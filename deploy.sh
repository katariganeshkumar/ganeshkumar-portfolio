#!/bin/bash

# Quick Deployment Script
# This script helps deploy the portfolio to the Ubuntu server

set -e

# Load deployment configuration from .env.deploy
if [ -f .env.deploy ]; then
    export $(cat .env.deploy | grep -v '^#' | xargs)
else
    echo "❌ Error: .env.deploy file not found!"
    echo "   Please copy .env.deploy.example to .env.deploy and fill in your credentials"
    exit 1
fi

# Set defaults if not provided
SERVER_HOST=${SERVER_HOST:-""}
SERVER_USER=${SERVER_USER:-"root"}
APP_DIR=${APP_DIR:-"/var/www/ganeshkumar-portfolio"}

echo "🚀 Portfolio Deployment Script"
echo "================================"
echo ""

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

# Build frontend
echo "📦 Building frontend..."
cd frontend
npm run build
cd ..

# Create deployment package
echo "📦 Creating deployment package..."
DEPLOY_DIR="/tmp/portfolio-deploy-$(date +%s)"
mkdir -p $DEPLOY_DIR

# Copy necessary files
cp -r backend $DEPLOY_DIR/
cp -r frontend/dist $DEPLOY_DIR/frontend-dist
cp package.json $DEPLOY_DIR/
cp .gitignore $DEPLOY_DIR/

echo "📤 Ready to deploy!"
echo ""
echo "Option 1: Manual deployment (recommended)"
echo "  1. SSH to server: ssh root@$SERVER_HOST"
echo "  2. Run: bash <(curl -s https://raw.githubusercontent.com/katariganeshkumar/ganeshkumar-portfolio/main/setup-server.sh)"
echo "  3. Clone repo: cd $APP_DIR && git clone https://github.com/katariganeshkumar/ganeshkumar-portfolio.git ."
echo "  4. Install & start: npm run install:all && npm run build:frontend && cd backend && pm2 start server.js --name portfolio"
echo ""
echo "Option 2: Automated deployment"
echo "  Run: bash deploy-ubuntu.sh"
echo ""
echo "Deployment package created at: $DEPLOY_DIR"
