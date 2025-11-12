# Deployment Guide

Complete guide for deploying the portfolio website to your Ubuntu cloud server.

## Prerequisites

- Ubuntu server (2 cores, 4GB RAM)
- Domain name: www.ganeshkumar.me
- SSH access to server
- Root or sudo access

## Step 1: Server Setup

### 1.1 Update System
```bash
sudo apt update && sudo apt upgrade -y
```

### 1.2 Install Node.js 18+
```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version  # Verify installation
```

### 1.3 Install Nginx
```bash
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 1.4 Install PM2 (Process Manager)
```bash
sudo npm install -g pm2
```

## Step 2: Deploy Application

### 2.1 Clone Repository
```bash
cd /var/www
sudo git clone <your-repo-url> portfolio
sudo chown -R $USER:$USER portfolio
cd portfolio
```

### 2.2 Install Dependencies
```bash
npm run install:all
```

### 2.3 Copy Image
```bash
cp generated-image.png frontend/public/
```

### 2.4 Update Profile Data
Edit `backend/data/profile.json` with your information:
```bash
nano backend/data/profile.json
```

### 2.5 Build Application
```bash
npm run build
```

## Step 3: Configure Nginx

### 3.1 Create Nginx Configuration
```bash
sudo nano /etc/nginx/sites-available/ganeshkumar.me
```

Paste the configuration from `nginx.conf` file, then:
```bash
sudo ln -s /etc/nginx/sites-available/ganeshkumar.me /etc/nginx/sites-enabled/
sudo nginx -t  # Test configuration
sudo systemctl reload nginx
```

### 3.2 Configure Firewall
```bash
sudo ufw allow 'Nginx Full'
sudo ufw allow ssh
sudo ufw enable
```

## Step 4: SSL Certificate (Let's Encrypt)

### 4.1 Install Certbot
```bash
sudo apt install certbot python3-certbot-nginx -y
```

### 4.2 Obtain SSL Certificate
```bash
sudo certbot --nginx -d www.ganeshkumar.me -d ganeshkumar.me
```

Follow the prompts. Certbot will automatically configure Nginx.

### 4.3 Auto-renewal
Certbot sets up auto-renewal automatically. Test with:
```bash
sudo certbot renew --dry-run
```

## Step 5: Start Application

### 5.1 Start with PM2
```bash
cd backend
pm2 start server.js --name portfolio
pm2 save
pm2 startup  # Follow instructions to enable startup on boot
```

### 5.2 Verify Status
```bash
pm2 status
pm2 logs portfolio
```

## Step 6: Domain Configuration

### 6.1 DNS Records
Ensure your domain has these DNS records:
- A record: `www.ganeshkumar.me` → Your server IP
- A record: `ganeshkumar.me` → Your server IP

### 6.2 Verify DNS
```bash
dig www.ganeshkumar.me
nslookup www.ganeshkumar.me
```

## Step 7: Monitoring & Maintenance

### 7.1 PM2 Commands
```bash
pm2 status          # Check status
pm2 logs portfolio  # View logs
pm2 restart portfolio  # Restart
pm2 stop portfolio     # Stop
pm2 delete portfolio   # Remove
```

### 7.2 Nginx Logs
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### 7.3 Update Application
```bash
cd /var/www/portfolio
git pull
npm run install:all
npm run build
pm2 restart portfolio
```

## Troubleshooting

### Port Already in Use
```bash
sudo lsof -i :5000
sudo kill -9 <PID>
```

### Nginx 502 Bad Gateway
- Check if Node.js app is running: `pm2 status`
- Check backend logs: `pm2 logs portfolio`
- Verify port 5000 is accessible

### SSL Certificate Issues
```bash
sudo certbot certificates
sudo certbot renew
```

### Permission Issues
```bash
sudo chown -R $USER:$USER /var/www/portfolio
```

## Performance Optimization

### Enable Gzip Compression
Already configured in nginx.conf

### Enable Caching
Static assets are cached for 1 year

### Monitor Resources
```bash
htop
pm2 monit
```

## Security Checklist

- [ ] Firewall configured (UFW)
- [ ] SSL certificate installed
- [ ] Nginx security headers enabled
- [ ] PM2 running as non-root user
- [ ] Regular system updates
- [ ] Strong SSH keys configured
- [ ] Fail2ban installed (optional)

## Backup Strategy

### Backup Application
```bash
tar -czf portfolio-backup-$(date +%Y%m%d).tar.gz /var/www/portfolio
```

### Backup Database (if added later)
```bash
# Add database backup commands here
```

## Support

For issues or questions:
- Check PM2 logs: `pm2 logs portfolio`
- Check Nginx logs: `/var/log/nginx/error.log`
- Review application logs in backend directory

