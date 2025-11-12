# GitHub Repository Setup Guide

## Step 1: Create GitHub Repository

1. Go to [GitHub.com](https://github.com) and sign in
2. Click the **"+"** icon in the top right corner
3. Select **"New repository"**
4. Fill in the repository details:
   - **Repository name**: `ganeshkumar-portfolio` (or your preferred name)
   - **Description**: "Senior DevOps Engineer Portfolio Website - Modern WebGL-powered portfolio showcasing technical expertise"
   - **Visibility**: Choose Public or Private
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
5. Click **"Create repository"**

## Step 2: Connect Local Repository to GitHub

After creating the repository on GitHub, you'll see a page with setup instructions. Use these commands:

### Option A: If repository is empty (recommended)

```bash
# Add the remote repository (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/ganeshkumar-portfolio.git

# Rename main branch if needed
git branch -M main

# Push code to GitHub
git push -u origin main

# Push tags
git push origin v1.0
```

### Option B: Using SSH (if you have SSH keys set up)

```bash
git remote add origin git@github.com:YOUR_USERNAME/ganeshkumar-portfolio.git
git branch -M main
git push -u origin main
git push origin v1.0
```

## Step 3: Verify

1. Go to your repository on GitHub
2. You should see all your files
3. Check the "Releases" section - you should see v1.0 tag

## Step 4: Update README (Optional)

The README.md is already created. You can enhance it with:
- Repository description
- Live demo link (once deployed)
- Screenshots
- Badges

## Authentication Methods

### Method 1: Personal Access Token (Recommended)

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token with `repo` scope
3. Use token as password when pushing

### Method 2: SSH Keys

1. Generate SSH key: `ssh-keygen -t ed25519 -C "katariganeshkumar@gmail.com"`
2. Add to GitHub: Settings → SSH and GPG keys → New SSH key
3. Use SSH URL for remote

### Method 3: GitHub CLI

```bash
# Install GitHub CLI
brew install gh  # macOS
# or
sudo apt install gh  # Ubuntu

# Login
gh auth login

# Create repository and push
gh repo create ganeshkumar-portfolio --public --source=. --remote=origin --push
```

## Quick Commands Reference

```bash
# Check remote
git remote -v

# Push updates
git push origin main

# Create new tag
git tag -a v1.1 -m "Version 1.1"
git push origin v1.1

# View tags
git tag

# View commits
git log --oneline
```

## Troubleshooting

### If you get authentication errors:
- Use Personal Access Token instead of password
- Check SSH key setup
- Verify remote URL is correct

### If repository already exists:
```bash
git remote set-url origin https://github.com/YOUR_USERNAME/ganeshkumar-portfolio.git
```

### To update existing repository:
```bash
git add .
git commit -m "Update: Description of changes"
git push origin main
```

---

**Note**: Replace `YOUR_USERNAME` with your actual GitHub username throughout this guide.

