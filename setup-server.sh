#!/bin/bash

# Server Setup Script - Run this ON the Ubuntu server
# Run: bash setup-server.sh

set -e

echo "🚀 Setting up Ubuntu server for portfolio deployment..."

# Update system
echo "📦 Updating system packages..."
apt-get update
apt-get upgrade -y

# Install essential packages
echo "📦 Installing essential packages..."
apt-get install -y curl git wget build-essential

# Install Node.js 20.x
echo "📦 Installing Node.js 20.x..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Verify Node.js installation
node_version=$(node --version)
npm_version=$(npm --version)
echo "✅ Node.js: $node_version"
echo "✅ npm: $npm_version"

# Install PM2 globally
echo "📦 Installing PM2..."
npm install -g pm2

# Install Nginx
echo "📦 Installing Nginx..."
apt-get install -y nginx

# Configure firewall
echo "🔥 Configuring firewall..."
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

# Create application directory
APP_DIR="/var/www/ganeshkumar-portfolio"
echo "📁 Creating application directory: $APP_DIR"
mkdir -p $APP_DIR
chown -R $USER:$USER $APP_DIR

# Install Certbot for SSL
echo "📦 Installing Certbot..."
apt-get install -y certbot python3-certbot-nginx

echo "✅ Server setup complete!"
echo ""
echo "Next steps:"
echo "1. Clone your repository:"
echo "   cd $APP_DIR"
echo "   git clone https://github.com/katariganeshkumar/ganeshkumar-portfolio.git ."
echo ""
echo "2. Install dependencies:"
echo "   npm run install:all"
echo ""
echo "3. Build frontend:"
echo "   npm run build:frontend"
echo ""
echo "4. Start application with PM2:"
echo "   cd backend"
echo "   pm2 start server.js --name portfolio"
echo "   pm2 save"
echo "   pm2 startup"
echo ""
echo "5. Configure Nginx (see DEPLOYMENT.md)"
echo ""
echo "6. Set up SSL:"
echo "   certbot --nginx -d www.ganeshkumar.me -d ganeshkumar.me"

