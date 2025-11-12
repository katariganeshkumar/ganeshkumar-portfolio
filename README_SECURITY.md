# Security & Configuration Guide

## 🔒 Sensitive Information

This project uses `.env.deploy` to store sensitive deployment credentials. This file is **gitignored** and will never be committed to the repository.

## 📋 Setup Instructions

### 1. Create Deployment Configuration

Copy the example file and fill in your credentials:

```bash
cp .env.deploy.example .env.deploy
```

### 2. Edit `.env.deploy`

Open `.env.deploy` and fill in your actual server details:

```bash
SERVER_HOST=your-server-ip-here
SERVER_USER=root
SERVER_PASS=your-server-password-here
DOMAIN=www.ganeshkumar.me
DOMAIN_ALT=ganeshkumar.me
APP_DIR=/var/www/ganeshkumar-portfolio
```

### 3. Verify `.env.deploy` is Gitignored

```bash
git status
# .env.deploy should NOT appear in the list
```

## 🚫 What's Gitignored

The following files are excluded from git:

- `.env.deploy` - Contains server IP, password, and credentials
- `*.env.deploy` - Any variant of deployment config
- `deployment.config` - Alternative config file
- `deploy.config` - Alternative config file
- `.env*` - All environment variable files

## ✅ Safe to Commit

These files are safe and contain no sensitive data:

- `.env.deploy.example` - Template file (no real credentials)
- All deployment scripts - Read from `.env.deploy` at runtime
- Documentation files - Use placeholders

## 🔐 Security Best Practices

1. **Never commit** `.env.deploy` to git
2. **Never share** `.env.deploy` publicly
3. **Use SSH keys** instead of passwords when possible
4. **Rotate credentials** regularly
5. **Review** `.gitignore` before committing

## 📝 Using Deployment Scripts

All deployment scripts automatically load configuration from `.env.deploy`:

```bash
# Scripts will automatically use .env.deploy
./deploy-and-test.sh
./setup-ssl.sh
./deploy-ubuntu.sh
```

If `.env.deploy` is missing, scripts will show an error and exit.

## 🔄 Updating Credentials

To update server credentials:

1. Edit `.env.deploy` (local file, not in git)
2. Run deployment scripts as usual
3. No need to commit anything

## ⚠️ Important Notes

- `.env.deploy` is **local only** - each developer needs their own copy
- Never add `.env.deploy` to git (it's already in `.gitignore`)
- If you accidentally commit sensitive data, rotate credentials immediately

