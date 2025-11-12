# Publish to GitHub - Step by Step Guide

Your code is ready to be published! Choose the method that works best for you.

## ✅ Current Status

- ✅ Git repository initialized
- ✅ All code committed
- ✅ Tagged as v1.0
- ⏳ Ready to push to GitHub

## Method 1: Using GitHub CLI (Easiest - Recommended)

### Step 1: Install GitHub CLI

**macOS:**
```bash
brew install gh
```

**Ubuntu/Linux:**
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

### Step 2: Login to GitHub

```bash
gh auth login
```

Follow the prompts:
- Choose GitHub.com
- Choose HTTPS
- Authenticate via browser or token

### Step 3: Create Repository and Push

**Option A: Use the automated script**
```bash
bash create-github-repo.sh
```

**Option B: Manual CLI commands**
```bash
# Create repository and push in one command
gh repo create ganeshkumar-portfolio --public --source=. --remote=origin --push --description "Senior DevOps Engineer Portfolio Website"

# Push the v1.0 tag
git push origin v1.0
```

## Method 2: Manual Setup (No CLI Required)

### Step 1: Create Repository on GitHub

1. Go to **https://github.com/new**
2. Fill in:
   - **Repository name**: `ganeshkumar-portfolio`
   - **Description**: "Senior DevOps Engineer Portfolio Website - Modern WebGL-powered portfolio"
   - **Visibility**: Public or Private
   - **⚠️ IMPORTANT**: Do NOT check "Add a README file"
   - **⚠️ IMPORTANT**: Do NOT add .gitignore or license
3. Click **"Create repository"**

### Step 2: Connect and Push

After creating the repository, GitHub will show you commands. Use these:

```bash
# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/ganeshkumar-portfolio.git

# Rename branch to main (if needed)
git branch -M main

# Push code
git push -u origin main

# Push version tag
git push origin v1.0
```

### Step 3: Authentication

When pushing, you'll be prompted for credentials:

**Username**: Your GitHub username  
**Password**: Use a **Personal Access Token** (not your GitHub password)

**To create a Personal Access Token:**
1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Give it a name: "Portfolio Push"
4. Select scope: `repo` (full control of private repositories)
5. Click "Generate token"
6. Copy the token (you won't see it again!)
7. Use this token as your password when pushing

## Method 3: Using the Helper Script

If you've already created the repository on GitHub:

```bash
bash push-to-github.sh YOUR_GITHUB_USERNAME ganeshkumar-portfolio
```

Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username.

## Verify Success

After pushing, verify:

1. **Visit your repository**: `https://github.com/YOUR_USERNAME/ganeshkumar-portfolio`
2. **Check files**: All your code should be visible
3. **Check releases**: Go to "Releases" → You should see v1.0 tag
4. **Check Actions**: Go to "Actions" → CI workflow should run

## Quick Commands Reference

```bash
# Check repository status
git status

# View commits
git log --oneline

# View tags
git tag -l

# Check remote
git remote -v

# Push updates (after initial push)
git push origin main

# Create new tag
git tag -a v1.1 -m "Version 1.1"
git push origin v1.1
```

## Troubleshooting

### Authentication Failed
- Use Personal Access Token instead of password
- Make sure token has `repo` scope
- Check if 2FA is enabled (requires token)

### Repository Already Exists
```bash
git remote set-url origin https://github.com/YOUR_USERNAME/ganeshkumar-portfolio.git
git push -u origin main
```

### Permission Denied
- Check your GitHub username is correct
- Verify repository name matches
- Ensure you have write access to the repository

### Tag Not Showing
```bash
# Push all tags
git push origin --tags

# Or push specific tag
git push origin v1.0
```

## Next Steps After Publishing

1. ✅ Add repository description
2. ✅ Add topics: `portfolio`, `react`, `threejs`, `devops`, `webgl`, `nodejs`
3. ✅ Enable GitHub Pages (optional)
4. ✅ Add to your GitHub profile
5. ✅ Share the repository link

## Repository Settings to Configure

After publishing, configure:

- **Description**: "Senior DevOps Engineer Portfolio Website"
- **Topics**: portfolio, react, threejs, devops, webgl
- **Website**: https://www.ganeshkumar.me (once deployed)
- **Visibility**: Public (recommended for portfolio)

---

**Need Help?** Check the error message and refer to the troubleshooting section above.

