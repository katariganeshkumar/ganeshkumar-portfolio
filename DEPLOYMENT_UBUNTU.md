# Ubuntu Server Deployment Guide

Complete guide for deploying the portfolio website to a fresh Ubuntu server.

## Server Information

- **Host**: [Configure in .env.deploy]
- **User**: root
- **Domain**: www.ganeshkumar.me

**Note**: Server credentials are stored in `.env.deploy` (gitignored). Copy `.env.deploy.example` to `.env.deploy` and fill in your server details.

## Prerequisites

- SSH access to the server
- Domain DNS pointing to server IP (103.194.228.36)
- Git repository access

## Step 1: Initial Server Setup

### Option A: Automated Setup (Recommended)

SSH into your server and run:

```bash
# Load your server IP from .env.deploy
source .env.deploy
ssh $SERVER_USER@$SERVER_HOST
```

Then run the setup script:

```bash
bash <(curl -s https://raw.githubusercontent.com/katariganeshkumar/ganeshkumar-portfolio/main/setup-server.sh)
```

### Option B: Manual Setup

```bash
# Update system
apt-get update && apt-get upgrade -y

# Install essential packages
apt-get install -y curl git wget build-essential nginx

# Install Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Install PM2
npm install -g pm2

# Install Certbot for SSL
apt-get install -y certbot python3-certbot-nginx

# Configure firewall
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable
```

## Step 2: Clone Repository

```bash
# Create application directory
mkdir -p /var/www/ganeshkumar-portfolio
cd /var/www/ganeshkumar-portfolio

# Clone repository
git clone https://github.com/katariganeshkumar/ganeshkumar-portfolio.git .

# Or if you prefer to use SSH:
# git clone git@github.com:katariganeshkumar/ganeshkumar-portfolio.git .
```

## Step 3: Install Dependencies

```bash
# Install all dependencies
npm run install:all

# Or install separately:
cd frontend && npm install && cd ..
cd backend && npm install && cd ..
```

## Step 4: Build Frontend

```bash
npm run build:frontend
```

This creates the `frontend/dist` directory with production-ready files.

## Step 5: Configure Backend

Verify the backend configuration:

```bash
cd backend
# Check server.js uses port 5001
grep PORT server.js
```

The server should be configured to use port 5001 (to avoid macOS AirPlay conflicts).

## Step 6: Start Application with PM2

```bash
cd /var/www/ganeshkumar-portfolio/backend

# Start the application
pm2 start server.js --name portfolio

# Save PM2 configuration
pm2 save

# Setup PM2 to start on boot
pm2 startup systemd -u root --hp /root
# Follow the instructions it outputs
```

Verify it's running:

```bash
pm2 status
pm2 logs portfolio
```

## Step 7: Configure Nginx

Create Nginx configuration:

```bash
nano /etc/nginx/sites-available/ganeshkumar-portfolio
```

Add the following configuration:

```nginx
server {
    listen 80;
    server_name www.ganeshkumar.me ganeshkumar.me;

    location / {
        proxy_pass http://localhost:5001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable the site:

```bash
# Remove default site
rm -f /etc/nginx/sites-enabled/default

# Enable our site
ln -s /etc/nginx/sites-available/ganeshkumar-portfolio /etc/nginx/sites-enabled/

# Test configuration
nginx -t

# Reload Nginx
systemctl reload nginx
```

## Step 8: Set Up SSL with Let's Encrypt

```bash
# Obtain SSL certificate
certbot --nginx -d www.ganeshkumar.me -d ganeshkumar.me

# Follow the prompts:
# - Enter your email
# - Agree to terms
# - Choose to redirect HTTP to HTTPS

# Test auto-renewal
certbot renew --dry-run
```

## Step 9: Verify Deployment

1. **Check PM2 status:**
   ```bash
   pm2 status
   pm2 logs portfolio
   ```

2. **Check Nginx status:**
   ```bash
   systemctl status nginx
   ```

3. **Test API endpoint:**
   ```bash
   curl http://localhost:5001/api/health
   ```

4. **Test website:**
   - Visit: http://www.ganeshkumar.me
   - Visit: https://www.ganeshkumar.me (after SSL setup)

## Step 10: Update Application

When you need to update the application:

```bash
cd /var/www/ganeshkumar-portfolio

# Pull latest changes
git pull origin main

# Install any new dependencies
npm run install:all

# Rebuild frontend
npm run build:frontend

# Restart application
pm2 restart portfolio

# Check logs
pm2 logs portfolio
```

## Troubleshooting

### Application Not Starting

```bash
# Check PM2 logs
pm2 logs portfolio

# Check if port is in use
lsof -i :5001

# Restart PM2
pm2 restart portfolio
```

### Nginx 502 Bad Gateway

```bash
# Check if Node.js app is running
pm2 status

# Check backend logs
pm2 logs portfolio

# Verify port 5001 is accessible
curl http://localhost:5001/api/health

# Check Nginx error logs
tail -f /var/log/nginx/error.log
```

### SSL Certificate Issues

```bash
# Check certificate status
certbot certificates

# Renew certificate manually
certbot renew

# Check Nginx SSL configuration
nginx -t
```

### Firewall Issues

```bash
# Check firewall status
ufw status

# Allow required ports
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 22/tcp
```

## Monitoring

### PM2 Monitoring

```bash
# View real-time monitoring
pm2 monit

# View logs
pm2 logs portfolio

# View process info
pm2 show portfolio
```

### System Resources

```bash
# Check disk usage
df -h

# Check memory usage
free -h

# Check CPU usage
top
```

## Security Best Practices

1. **Change SSH port** (optional but recommended)
2. **Set up SSH key authentication** instead of password
3. **Configure fail2ban** for SSH protection
4. **Keep system updated**: `apt-get update && apt-get upgrade`
5. **Regular backups** of application and database
6. **Monitor logs** regularly

## Backup Script

Create a backup script:

```bash
#!/bin/bash
BACKUP_DIR="/root/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/portfolio-$DATE.tar.gz /var/www/ganeshkumar-portfolio
```

## Maintenance Commands

```bash
# View application logs
pm2 logs portfolio --lines 100

# Restart application
pm2 restart portfolio

# Stop application
pm2 stop portfolio

# Start application
pm2 start portfolio

# Reload Nginx
systemctl reload nginx

# Check Nginx status
systemctl status nginx
```

## Quick Reference

| Service | Command | Status Check |
|---------|---------|--------------|
| PM2 | `pm2 start/restart/stop portfolio` | `pm2 status` |
| Nginx | `systemctl reload nginx` | `systemctl status nginx` |
| Node.js | `node --version` | `pm2 logs portfolio` |
| SSL | `certbot renew` | `certbot certificates` |

## Support

If you encounter issues:

1. Check PM2 logs: `pm2 logs portfolio`
2. Check Nginx logs: `tail -f /var/log/nginx/error.log`
3. Verify port 5001 is accessible: `curl http://localhost:5001/api/health`
4. Check system resources: `htop` or `free -h`

---

**Deployment Date**: $(date)
**Server IP**: [Configure in .env.deploy]
**Domain**: www.ganeshkumar.me

