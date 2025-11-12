#!/bin/bash

# Fix Nginx Configuration Script
# This script fixes the Nginx configuration to properly serve the website

set -e

# Load deployment configuration from .env.deploy
if [ -f .env.deploy ]; then
    export $(cat .env.deploy | grep -v '^#' | xargs)
else
    echo "❌ Error: .env.deploy file not found!"
    exit 1
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Fixing Nginx Configuration                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to run commands on remote server
run_remote() {
    sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$SERVER_USER@$SERVER_HOST" "$1"
}

# Create proper Nginx configuration
echo -e "${BLUE}Step 1: Creating proper Nginx configuration...${NC}"

NGINX_CONFIG=$(cat <<EOF
# HTTP server - redirect to HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name www.ganeshkumar.me ganeshkumar.me;

    # Redirect all HTTP to HTTPS
    return 301 https://\$server_name\$request_uri;
}

# HTTPS server
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name www.ganeshkumar.me ganeshkumar.me;

    # SSL certificates
    ssl_certificate /etc/letsencrypt/live/www.ganeshkumar.me/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/www.ganeshkumar.me/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Security headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json application/xml;

    # Increase buffer sizes for large requests
    client_max_body_size 10M;
    proxy_buffering off;
    proxy_request_buffering off;

    # Proxy to Node.js backend
    location / {
        proxy_pass http://localhost:5001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }

    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        proxy_pass http://localhost:5001;
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }
}
EOF
)

# Write config to temp file
echo "$NGINX_CONFIG" > /tmp/nginx-fix-config

# Copy to server
echo -e "${BLUE}Step 2: Uploading configuration to server...${NC}"
sshpass -p "$SERVER_PASS" scp -o StrictHostKeyChecking=no /tmp/nginx-fix-config "$SERVER_USER@$SERVER_HOST:/tmp/nginx-fix-config"

# Backup existing config
echo -e "${BLUE}Step 3: Backing up existing configuration...${NC}"
run_remote "cp /etc/nginx/sites-available/ganeshkumar-portfolio /etc/nginx/sites-available/ganeshkumar-portfolio.backup.$(date +%Y%m%d_%H%M%S)"

# Install new config
echo -e "${BLUE}Step 4: Installing new configuration...${NC}"
run_remote "mv /tmp/nginx-fix-config /etc/nginx/sites-available/ganeshkumar-portfolio"

# Test configuration
echo -e "${BLUE}Step 5: Testing Nginx configuration...${NC}"
if run_remote "nginx -t"; then
    echo -e "${GREEN}✅ Nginx configuration is valid${NC}"
else
    echo -e "${RED}❌ Nginx configuration test failed${NC}"
    exit 1
fi

# Reload Nginx
echo -e "${BLUE}Step 6: Reloading Nginx...${NC}"
run_remote "systemctl reload nginx"
echo -e "${GREEN}✅ Nginx reloaded${NC}"

# Cleanup
rm -f /tmp/nginx-fix-config

echo ""
echo -e "${GREEN}✅ Nginx configuration fixed!${NC}"
echo ""
echo -e "${YELLOW}Testing website...${NC}"

# Test the website
sleep 2
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "http://$DOMAIN" 2>/dev/null || echo "000")
HTTPS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 -k "https://$DOMAIN" 2>/dev/null || echo "000")

echo ""
echo -e "${BLUE}Test Results:${NC}"
echo "  HTTP (should redirect): $HTTP_STATUS"
echo "  HTTPS: $HTTPS_STATUS"

if [ "$HTTPS_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ Website is accessible via HTTPS!${NC}"
else
    echo -e "${YELLOW}⚠️  HTTPS status: $HTTPS_STATUS${NC}"
fi

echo ""
echo -e "${GREEN}✅ Configuration update complete!${NC}"

