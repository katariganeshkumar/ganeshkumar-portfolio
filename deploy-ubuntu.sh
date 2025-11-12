#!/bin/bash

# Ubuntu Server Deployment Script
# This script deploys the portfolio website to a fresh Ubuntu server

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
APP_DIR=${APP_DIR:-"/var/www/ganeshkumar-portfolio"}
APP_USER=${APP_USER:-"www-data"}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting deployment to Ubuntu server...${NC}"

# Check if sshpass is installed (for password-based SSH)
if ! command -v sshpass &> /dev/null; then
    echo -e "${YELLOW}Installing sshpass...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install hudochenkov/sshpass/sshpass
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install -y sshpass
    fi
fi

# Function to run commands on remote server
run_remote() {
    sshpass -p "$SERVER_PASS" ssh -o StrictHostKeyChecking=no "$SERVER_USER@$SERVER_HOST" "$1"
}

# Function to copy files to remote server
copy_to_remote() {
    sshpass -p "$SERVER_PASS" scp -o StrictHostKeyChecking=no -r "$1" "$SERVER_USER@$SERVER_HOST:$2"
}

echo -e "${GREEN}Step 1: Installing dependencies on server...${NC}"
run_remote "apt-get update && apt-get install -y curl git nginx"

echo -e "${GREEN}Step 2: Installing Node.js 20.x...${NC}"
run_remote "curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -y nodejs"

echo -e "${GREEN}Step 3: Installing PM2...${NC}"
run_remote "npm install -g pm2"

echo -e "${GREEN}Step 4: Creating application directory...${NC}"
run_remote "mkdir -p $APP_DIR && chown -R $SERVER_USER:$SERVER_USER $APP_DIR"

echo -e "${GREEN}Step 5: Building frontend locally...${NC}"
cd frontend
npm run build
cd ..

echo -e "${GREEN}Step 6: Copying files to server...${NC}"
# Create a temporary directory structure
mkdir -p /tmp/deploy
cp -r backend /tmp/deploy/
cp -r frontend/dist /tmp/deploy/frontend-dist
cp package.json /tmp/deploy/
cp .gitignore /tmp/deploy/

# Copy to server
copy_to_remote "/tmp/deploy/*" "$APP_DIR/"

# Cleanup
rm -rf /tmp/deploy

echo -e "${GREEN}Step 7: Installing backend dependencies on server...${NC}"
run_remote "cd $APP_DIR/backend && npm install --production"

echo -e "${GREEN}Step 8: Setting up PM2...${NC}"
run_remote "cd $APP_DIR/backend && pm2 start server.js --name portfolio --update-env"
run_remote "pm2 save"
run_remote "pm2 startup systemd -u $SERVER_USER --hp /root | bash"

echo -e "${GREEN}Step 9: Configuring Nginx...${NC}"
# Create nginx config
cat > /tmp/nginx-config <<EOF
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

copy_to_remote "/tmp/nginx-config" "/etc/nginx/sites-available/ganeshkumar-portfolio"
run_remote "ln -sf /etc/nginx/sites-available/ganeshkumar-portfolio /etc/nginx/sites-enabled/"
run_remote "rm -f /etc/nginx/sites-enabled/default"
run_remote "nginx -t && systemctl reload nginx"

# Cleanup temp file
rm -f /tmp/nginx-config

echo -e "${GREEN}Step 10: Configuring firewall...${NC}"
run_remote "ufw allow 22/tcp && ufw allow 80/tcp && ufw allow 443/tcp && ufw --force enable"

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Point your domain DNS to: $SERVER_HOST"
echo "2. Set up SSL with Let's Encrypt:"
echo "   ssh $SERVER_USER@$SERVER_HOST"
echo "   apt-get install certbot python3-certbot-nginx"
echo "   certbot --nginx -d $DOMAIN -d ganeshkumar.me"
echo ""
echo -e "${GREEN}Your website should be accessible at: http://$SERVER_HOST${NC}"

