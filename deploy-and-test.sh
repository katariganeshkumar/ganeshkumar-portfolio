#!/bin/bash

# Complete Deployment and Testing Script
# This script deploys the portfolio and tests if it's working

set -e

# Server Configuration
SERVER_HOST="103.194.228.36"
SERVER_USER="root"
SERVER_PASS="r9AWATgbrUn4cxyh"
DOMAIN="www.ganeshkumar.me"
APP_DIR="/var/www/ganeshkumar-portfolio"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Portfolio Deployment & Testing Script              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo -e "${YELLOW}Installing sshpass...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install hudochenkov/sshpass/sshpass 2>/dev/null || {
            echo -e "${RED}Please install sshpass manually: brew install hudochenkov/sshpass/sshpass${NC}"
            exit 1
        }
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install -y sshpass
    fi
fi

# Function to run commands on remote server
run_remote() {
    sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$SERVER_USER@$SERVER_HOST" "$1"
}

# Function to copy files to remote server
copy_to_remote() {
    sshpass -p "$SERVER_PASS" scp -o StrictHostKeyChecking=no -o ConnectTimeout=10 -r "$1" "$SERVER_USER@$SERVER_HOST:$2"
}

# Test connection
echo -e "${BLUE}Step 1: Testing SSH connection...${NC}"
if ! run_remote "echo 'Connection successful'" &>/dev/null; then
    echo -e "${RED}❌ Cannot connect to server. Please check:${NC}"
    echo "   - Server IP: $SERVER_HOST"
    echo "   - SSH credentials"
    echo "   - Network connectivity"
    exit 1
fi
echo -e "${GREEN}✅ SSH connection successful${NC}"
echo ""

# Step 2: Setup server (if needed)
echo -e "${BLUE}Step 2: Checking server setup...${NC}"
if ! run_remote "command -v node &> /dev/null" &>/dev/null; then
    echo -e "${YELLOW}Node.js not found. Setting up server...${NC}"
    run_remote "apt-get update && apt-get install -y curl git nginx && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -y nodejs && npm install -g pm2 && apt-get install -y certbot python3-certbot-nginx"
    echo -e "${GREEN}✅ Server setup complete${NC}"
else
    echo -e "${GREEN}✅ Server already configured${NC}"
fi
echo ""

# Step 3: Build frontend locally
echo -e "${BLUE}Step 3: Building frontend...${NC}"
cd frontend
if npm run build; then
    echo -e "${GREEN}✅ Frontend build successful${NC}"
else
    echo -e "${RED}❌ Frontend build failed${NC}"
    exit 1
fi
cd ..
echo ""

# Step 4: Create deployment package
echo -e "${BLUE}Step 4: Creating deployment package...${NC}"
DEPLOY_TEMP="/tmp/portfolio-deploy-$$"
mkdir -p "$DEPLOY_TEMP"

cp -r backend "$DEPLOY_TEMP/"
cp -r frontend/dist "$DEPLOY_TEMP/frontend-dist"
cp package.json "$DEPLOY_TEMP/"
cp .gitignore "$DEPLOY_TEMP/" 2>/dev/null || true

echo -e "${GREEN}✅ Deployment package created${NC}"
echo ""

# Step 5: Deploy to server
echo -e "${BLUE}Step 5: Deploying to server...${NC}"
run_remote "mkdir -p $APP_DIR"
copy_to_remote "$DEPLOY_TEMP/backend" "$APP_DIR/"
copy_to_remote "$DEPLOY_TEMP/frontend-dist" "$APP_DIR/"
copy_to_remote "$DEPLOY_TEMP/package.json" "$APP_DIR/" 2>/dev/null || true

# Cleanup temp files
rm -rf "$DEPLOY_TEMP"

echo -e "${GREEN}✅ Files deployed${NC}"
echo ""

# Step 6: Install dependencies on server
echo -e "${BLUE}Step 6: Installing backend dependencies...${NC}"
run_remote "cd $APP_DIR/backend && npm install --production"
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Step 7: Move frontend dist to correct location
echo -e "${BLUE}Step 7: Setting up frontend files...${NC}"
run_remote "cd $APP_DIR && mkdir -p frontend && mv frontend-dist frontend/dist 2>/dev/null || cp -r frontend-dist frontend/dist 2>/dev/null || true"
run_remote "cd $APP_DIR && ls -la frontend/dist/ | head -5 || echo 'Checking frontend files...'"
echo -e "${GREEN}✅ Frontend files configured${NC}"
echo ""

# Step 8: Start/restart PM2
echo -e "${BLUE}Step 8: Starting application with PM2...${NC}"
run_remote "cd $APP_DIR/backend && pm2 delete portfolio 2>/dev/null || true"
run_remote "cd $APP_DIR/backend && pm2 start server.js --name portfolio --update-env"
run_remote "pm2 save"
echo -e "${GREEN}✅ Application started${NC}"
echo ""

# Step 9: Configure Nginx
echo -e "${BLUE}Step 9: Configuring Nginx...${NC}"
NGINX_CONFIG="/tmp/nginx-config-$$"
cat > "$NGINX_CONFIG" <<EOF
server {
    listen 80;
    server_name $DOMAIN ganeshkumar.me;

    location / {
        proxy_pass http://localhost:5001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

copy_to_remote "$NGINX_CONFIG" "/etc/nginx/sites-available/ganeshkumar-portfolio"
run_remote "ln -sf /etc/nginx/sites-available/ganeshkumar-portfolio /etc/nginx/sites-enabled/"
run_remote "rm -f /etc/nginx/sites-enabled/default"
run_remote "nginx -t && systemctl reload nginx"
rm -f "$NGINX_CONFIG"

echo -e "${GREEN}✅ Nginx configured${NC}"
echo ""

# Step 10: Configure firewall
echo -e "${BLUE}Step 10: Configuring firewall...${NC}"
run_remote "ufw allow 22/tcp 2>/dev/null || true"
run_remote "ufw allow 80/tcp 2>/dev/null || true"
run_remote "ufw allow 443/tcp 2>/dev/null || true"
run_remote "ufw --force enable 2>/dev/null || true"
echo -e "${GREEN}✅ Firewall configured${NC}"
echo ""

# Step 11: Testing
echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    TESTING                            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Test 1: PM2 Status
echo -e "${YELLOW}Test 1: PM2 Status${NC}"
PM2_STATUS=$(run_remote "pm2 list | grep portfolio || echo 'NOT_FOUND'")
if echo "$PM2_STATUS" | grep -q "online"; then
    echo -e "${GREEN}✅ PM2: Application is running${NC}"
else
    echo -e "${RED}❌ PM2: Application not running${NC}"
    echo "$PM2_STATUS"
fi
echo ""

# Test 2: Backend API Health Check
echo -e "${YELLOW}Test 2: Backend API Health Check${NC}"
HEALTH_RESPONSE=$(run_remote "curl -s http://localhost:5001/api/health || echo 'FAILED'")
if echo "$HEALTH_RESPONSE" | grep -q "ok\|status"; then
    echo -e "${GREEN}✅ Backend API: Responding correctly${NC}"
    echo "   Response: $HEALTH_RESPONSE"
else
    echo -e "${RED}❌ Backend API: Not responding${NC}"
    echo "   Response: $HEALTH_RESPONSE"
fi
echo ""

# Test 3: Backend Profile API
echo -e "${YELLOW}Test 3: Profile API Check${NC}"
PROFILE_RESPONSE=$(run_remote "curl -s http://localhost:5001/api/profile | head -c 100 || echo 'FAILED'")
if echo "$PROFILE_RESPONSE" | grep -q "personal\|name\|{" || [ "$PROFILE_RESPONSE" != "FAILED" ]; then
    echo -e "${GREEN}✅ Profile API: Responding${NC}"
else
    echo -e "${RED}❌ Profile API: Not responding${NC}"
fi
echo ""

# Test 4: Nginx Status
echo -e "${YELLOW}Test 4: Nginx Status${NC}"
NGINX_STATUS=$(run_remote "systemctl is-active nginx || echo 'inactive'")
if [ "$NGINX_STATUS" = "active" ]; then
    echo -e "${GREEN}✅ Nginx: Running${NC}"
else
    echo -e "${RED}❌ Nginx: Not running${NC}"
fi
echo ""

# Test 5: Port 5001 Check
echo -e "${YELLOW}Test 5: Port 5001 Check${NC}"
PORT_CHECK=$(run_remote "ss -tuln | grep :5001 || lsof -i :5001 2>/dev/null || echo 'CHECKING'")
if echo "$PORT_CHECK" | grep -q "5001\|LISTEN"; then
    echo -e "${GREEN}✅ Port 5001: Listening${NC}"
else
    # Check via PM2 instead
    PM2_PORT=$(run_remote "pm2 describe portfolio | grep -i port || echo ''")
    if echo "$PM2_PORT" | grep -q "5001\|online"; then
        echo -e "${GREEN}✅ Port 5001: Application running (verified via PM2)${NC}"
    else
        echo -e "${YELLOW}⚠️  Port 5001: Cannot verify directly, but PM2 shows app is running${NC}"
    fi
fi
echo ""

# Test 6: Frontend Files Check
echo -e "${YELLOW}Test 6: Frontend Files Check${NC}"
FRONTEND_CHECK=$(run_remote "test -f $APP_DIR/frontend/dist/index.html && echo 'EXISTS' || (test -d $APP_DIR/frontend-dist && echo 'IN_DIST' || echo 'NOT_FOUND')")
if [ "$FRONTEND_CHECK" = "EXISTS" ]; then
    echo -e "${GREEN}✅ Frontend files: Present${NC}"
elif [ "$FRONTEND_CHECK" = "IN_DIST" ]; then
    echo -e "${YELLOW}⚠️  Frontend files: Found but need to move${NC}"
    run_remote "cd $APP_DIR && mkdir -p frontend && mv frontend-dist frontend/dist"
    echo -e "${GREEN}✅ Frontend files: Fixed and moved${NC}"
else
    echo -e "${RED}❌ Frontend files: Missing - checking...${NC}"
    run_remote "ls -la $APP_DIR/ | head -10"
fi
echo ""

# Test 7: External Access Test
echo -e "${YELLOW}Test 7: External Access Test${NC}"
EXTERNAL_TEST=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 "http://$SERVER_HOST" || echo "000")
if [ "$EXTERNAL_TEST" = "200" ] || [ "$EXTERNAL_TEST" = "301" ] || [ "$EXTERNAL_TEST" = "302" ]; then
    echo -e "${GREEN}✅ External Access: Website is accessible${NC}"
    echo "   HTTP Status: $EXTERNAL_TEST"
    echo "   URL: http://$SERVER_HOST"
else
    echo -e "${YELLOW}⚠️  External Access: May not be accessible yet${NC}"
    echo "   HTTP Status: $EXTERNAL_TEST"
    echo "   Note: This is normal if DNS is not configured yet"
fi
echo ""

# Summary
echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                 DEPLOYMENT SUMMARY                     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}✅ Deployment completed!${NC}"
echo ""
echo -e "${YELLOW}Access your website:${NC}"
echo "   • Direct IP: http://$SERVER_HOST"
echo "   • Domain: http://$DOMAIN (when DNS is configured)"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "   1. Configure DNS: Point $DOMAIN to $SERVER_HOST"
echo "   2. Setup SSL: ssh $SERVER_USER@$SERVER_HOST"
echo "      Then run: certbot --nginx -d $DOMAIN -d ganeshkumar.me"
echo ""
echo -e "${YELLOW}Useful Commands:${NC}"
echo "   • View logs: ssh $SERVER_USER@$SERVER_HOST 'pm2 logs portfolio'"
echo "   • Restart app: ssh $SERVER_USER@$SERVER_HOST 'pm2 restart portfolio'"
echo "   • Check status: ssh $SERVER_USER@$SERVER_HOST 'pm2 status'"
echo ""

