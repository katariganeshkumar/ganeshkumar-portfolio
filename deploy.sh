#!/bin/bash

# Deployment script for Ubuntu server
# Run with: bash deploy.sh

echo "🚀 Starting deployment..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Node.js not found. Installing...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    echo -e "${YELLOW}PM2 not found. Installing...${NC}"
    sudo npm install -g pm2
fi

# Install dependencies
echo -e "${GREEN}Installing dependencies...${NC}"
npm run install:all

# Build project
echo -e "${GREEN}Building project...${NC}"
npm run build

# Copy image to public folder
if [ -f "generated-image.png" ]; then
    echo -e "${GREEN}Copying image to public folder...${NC}"
    cp generated-image.png frontend/public/
fi

# Start/restart PM2 process
echo -e "${GREEN}Starting server with PM2...${NC}"
cd backend
pm2 delete portfolio 2>/dev/null || true
pm2 start server.js --name portfolio
pm2 save

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${YELLOW}Check status with: pm2 status${NC}"
echo -e "${YELLOW}View logs with: pm2 logs portfolio${NC}"

