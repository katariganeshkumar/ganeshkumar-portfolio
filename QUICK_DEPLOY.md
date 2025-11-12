# Quick Deployment Guide

## 🚀 Fastest Way to Deploy

### Step 1: Build Locally

```bash
# Build frontend
cd frontend && npm run build && cd ..
```

### Step 2: Setup Server (One-time)

SSH into your server:

```bash
ssh root@103.194.228.36
```

Run the setup script:

```bash
bash <(curl -s https://raw.githubusercontent.com/katariganeshkumar/ganeshkumar-portfolio/main/setup-server.sh)
```

### Step 3: Deploy Application

On the server:

```bash
# Clone repository
cd /var/www
git clone https://github.com/katariganeshkumar/ganeshkumar-portfolio.git ganeshkumar-portfolio
cd ganeshkumar-portfolio

# Install dependencies
npm run install:all

# Build frontend (if not already built)
npm run build:frontend

# Start backend with PM2
cd backend
pm2 start server.js --name portfolio
pm2 save
pm2 startup
```

### Step 4: Configure Nginx

```bash
# Create config file
cat > /etc/nginx/sites-available/ganeshkumar-portfolio <<'EOF'
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
EOF

# Enable site
ln -s /etc/nginx/sites-available/ganeshkumar-portfolio /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl reload nginx
```

### Step 5: Setup SSL

```bash
certbot --nginx -d www.ganeshkumar.me -d ganeshkumar.me
```

## ✅ Verify Deployment

```bash
# Check PM2
pm2 status

# Check API
curl http://localhost:5001/api/health

# Check website
curl http://localhost:5001
```

## 🔄 Update Application

```bash
cd /var/www/ganeshkumar-portfolio
git pull origin main
npm run install:all
npm run build:frontend
pm2 restart portfolio
```

---

**Server**: 103.194.228.36
**Domain**: www.ganeshkumar.me

