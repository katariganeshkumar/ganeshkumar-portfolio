#!/bin/bash

# SSL/HTTPS Setup Script
# This script sets up SSL certificate using Let's Encrypt

set -e

# Load deployment configuration from .env.deploy
if [ -f .env.deploy ]; then
    export $(cat .env.deploy | grep -v '^#' | xargs)
else
    echo "❌ Error: .env.deploy file not found!"
    echo "   Please copy .env.deploy.example to .env.deploy and fill in your credentials"
    exit 1
fi

# Validate required variables
if [ -z "$SERVER_HOST" ] || [ -z "$SERVER_USER" ] || [ -z "$SERVER_PASS" ]; then
    echo "❌ Error: Missing required configuration in .env.deploy"
    exit 1
fi

# Set defaults if not provided
DOMAIN=${DOMAIN:-"www.ganeshkumar.me"}
DOMAIN_ALT=${DOMAIN_ALT:-"ganeshkumar.me"}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          SSL/HTTPS Setup & Verification Script        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo -e "${YELLOW}Installing sshpass...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install hudochenkov/sshpass/sshpass 2>/dev/null || true
    fi
fi

# Function to run commands on remote server
run_remote() {
    sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$SERVER_USER@$SERVER_HOST" "$1"
}

# Test connection
echo -e "${BLUE}Step 1: Testing SSH connection...${NC}"
if ! run_remote "echo 'Connection successful'" &>/dev/null; then
    echo -e "${RED}❌ Cannot connect to server${NC}"
    exit 1
fi
echo -e "${GREEN}✅ SSH connection successful${NC}"
echo ""

# Check if certbot is installed
echo -e "${BLUE}Step 2: Checking Certbot installation...${NC}"
if ! run_remote "command -v certbot &> /dev/null" &>/dev/null; then
    echo -e "${YELLOW}Installing Certbot...${NC}"
    run_remote "apt-get update && apt-get install -y certbot python3-certbot-nginx"
    echo -e "${GREEN}✅ Certbot installed${NC}"
else
    echo -e "${GREEN}✅ Certbot already installed${NC}"
fi
echo ""

# Check DNS resolution
echo -e "${BLUE}Step 3: Checking DNS resolution...${NC}"
DNS_CHECK=$(run_remote "nslookup $DOMAIN 2>/dev/null | grep -A 2 'Name:' || echo 'DNS_CHECK_FAILED'")
if echo "$DNS_CHECK" | grep -q "$SERVER_HOST\|103.194.228.36"; then
    echo -e "${GREEN}✅ DNS is pointing to server IP${NC}"
elif echo "$DNS_CHECK" | grep -q "DNS_CHECK_FAILED"; then
    echo -e "${YELLOW}⚠️  Cannot verify DNS. Continuing anyway...${NC}"
else
    echo -e "${YELLOW}⚠️  DNS may not be configured correctly${NC}"
    echo "   Expected: $DOMAIN → $SERVER_HOST"
    echo "   Continuing with SSL setup anyway..."
fi
echo ""

# Obtain SSL certificate
echo -e "${BLUE}Step 4: Obtaining SSL certificate...${NC}"
echo -e "${YELLOW}This may take a few moments...${NC}"

# Run certbot in non-interactive mode
SSL_RESULT=$(run_remote "certbot --nginx -d $DOMAIN -d $DOMAIN_ALT --non-interactive --agree-tos --email katariganeshkumar@gmail.com --redirect 2>&1" || echo "SSL_FAILED")

if echo "$SSL_RESULT" | grep -q "Congratulations\|Successfully\|Certificate installed"; then
    echo -e "${GREEN}✅ SSL certificate installed successfully${NC}"
elif echo "$SSL_RESULT" | grep -q "SSL_FAILED\|Error\|Failed"; then
    echo -e "${RED}❌ SSL certificate installation failed${NC}"
    echo "   This might be because:"
    echo "   1. DNS is not configured yet"
    echo "   2. Domain is not pointing to server IP"
    echo "   3. Port 80 is not accessible"
    echo ""
    echo "   Checking certificate status..."
    CERT_STATUS=$(run_remote "certbot certificates 2>&1 | head -20")
    echo "$CERT_STATUS"
    echo ""
    echo -e "${YELLOW}Note: You can manually run certbot later when DNS is configured${NC}"
else
    echo -e "${YELLOW}⚠️  SSL setup completed with warnings${NC}"
    echo "$SSL_RESULT" | tail -10
fi
echo ""

# Reload Nginx
echo -e "${BLUE}Step 5: Reloading Nginx...${NC}"
run_remote "nginx -t && systemctl reload nginx"
echo -e "${GREEN}✅ Nginx reloaded${NC}"
echo ""

# Testing
echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    TESTING                             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Test 1: HTTP (should redirect to HTTPS)
echo -e "${YELLOW}Test 1: HTTP Access (Port 80)${NC}"
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "http://$SERVER_HOST" || echo "000")
if [ "$HTTP_STATUS" = "200" ] || [ "$HTTP_STATUS" = "301" ] || [ "$HTTP_STATUS" = "302" ]; then
    echo -e "${GREEN}✅ HTTP: Accessible (Status: $HTTP_STATUS)${NC}"
else
    echo -e "${YELLOW}⚠️  HTTP: Status $HTTP_STATUS${NC}"
fi
echo ""

# Test 2: HTTPS
echo -e "${YELLOW}Test 2: HTTPS Access (Port 443)${NC}"
HTTPS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 -k "https://$SERVER_HOST" 2>/dev/null || echo "000")
if [ "$HTTPS_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ HTTPS: Accessible (Status: $HTTPS_STATUS)${NC}"
elif [ "$HTTPS_STATUS" = "000" ]; then
    echo -e "${YELLOW}⚠️  HTTPS: Not accessible yet (may need DNS configuration)${NC}"
else
    echo -e "${YELLOW}⚠️  HTTPS: Status $HTTPS_STATUS${NC}"
fi
echo ""

# Test 3: Certificate check
echo -e "${YELLOW}Test 3: SSL Certificate Check${NC}"
CERT_CHECK=$(run_remote "certbot certificates 2>/dev/null | grep -A 5 '$DOMAIN' || echo 'NO_CERT'")
if echo "$CERT_CHECK" | grep -q "Certificate Name\|Valid"; then
    echo -e "${GREEN}✅ Certificate: Found${NC}"
    echo "$CERT_CHECK" | head -10
else
    echo -e "${YELLOW}⚠️  Certificate: Not found or not yet configured${NC}"
fi
echo ""

# Test 4: Domain access
echo -e "${YELLOW}Test 4: Domain Access Test${NC}"
DOMAIN_HTTP=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "http://$DOMAIN" 2>/dev/null || echo "000")
DOMAIN_HTTPS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 -k "https://$DOMAIN" 2>/dev/null || echo "000")

if [ "$DOMAIN_HTTP" != "000" ] || [ "$DOMAIN_HTTPS" != "000" ]; then
    echo -e "${GREEN}✅ Domain: Accessible${NC}"
    echo "   HTTP: $DOMAIN_HTTP"
    echo "   HTTPS: $DOMAIN_HTTPS"
else
    echo -e "${YELLOW}⚠️  Domain: Not accessible (DNS may not be configured)${NC}"
fi
echo ""

# Test 5: API endpoints
echo -e "${YELLOW}Test 5: API Endpoints${NC}"
API_HTTP=$(curl -s "http://$SERVER_HOST/api/health" 2>/dev/null | head -c 50 || echo "FAILED")
API_HTTPS=$(curl -s -k "https://$SERVER_HOST/api/health" 2>/dev/null | head -c 50 || echo "FAILED")

if echo "$API_HTTP" | grep -q "ok\|status"; then
    echo -e "${GREEN}✅ API (HTTP): Working${NC}"
else
    echo -e "${YELLOW}⚠️  API (HTTP): $API_HTTP${NC}"
fi

if echo "$API_HTTPS" | grep -q "ok\|status"; then
    echo -e "${GREEN}✅ API (HTTPS): Working${NC}"
else
    echo -e "${YELLOW}⚠️  API (HTTPS): $API_HTTPS${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                 SSL SETUP SUMMARY                     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✅ SSL setup completed!${NC}"
echo ""
echo -e "${YELLOW}Access your website:${NC}"
echo "   • HTTP:  http://$SERVER_HOST"
echo "   • HTTPS: https://$SERVER_HOST"
echo "   • Domain HTTP:  http://$DOMAIN"
echo "   • Domain HTTPS: https://$DOMAIN"
echo ""
echo -e "${YELLOW}Important Notes:${NC}"
echo "   1. If DNS is not configured, SSL certificate may not be issued"
echo "   2. Once DNS is configured, run:"
echo "      ssh $SERVER_USER@$SERVER_HOST"
echo "      certbot --nginx -d $DOMAIN -d $DOMAIN_ALT"
echo "   3. Certificate auto-renewal is configured automatically"
echo ""
echo -e "${YELLOW}Verify SSL Certificate:${NC}"
echo "   ssh $SERVER_USER@$SERVER_HOST 'certbot certificates'"
echo ""

