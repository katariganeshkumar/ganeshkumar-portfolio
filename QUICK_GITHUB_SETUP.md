# Quick GitHub Setup - 5 Minutes

## ✅ Local Repository Ready!

Your code is already:
- ✅ Initialized with Git
- ✅ Committed with initial commit
- ✅ Tagged as **v1.0**

## 🚀 Push to GitHub (Choose One Method)

### Method 1: Using GitHub CLI (Easiest)

```bash
# Install GitHub CLI (if not installed)
brew install gh  # macOS
# or visit: https://cli.github.com/

# Login to GitHub
gh auth login

# Create repository and push (all in one command!)
gh repo create ganeshkumar-portfolio --public --source=. --remote=origin --push

# Push the v1.0 tag
git push origin v1.0
```

### Method 2: Manual Setup (Step by Step)

**Step 1:** Create repository on GitHub
1. Go to https://github.com/new
2. Repository name: `ganeshkumar-portfolio`
3. Description: "Senior DevOps Engineer Portfolio Website"
4. Choose Public or Private
5. **DO NOT** check "Initialize with README"
6. Click "Create repository"

**Step 2:** Connect and push
```bash
# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/ganeshkumar-portfolio.git

# Push code
git push -u origin main

# Push version tag
git push origin v1.0
```

### Method 3: Using the Push Script

```bash
# Run the helper script
bash push-to-github.sh YOUR_GITHUB_USERNAME ganeshkumar-portfolio

# Follow the prompts
```

## 🔐 Authentication

When pushing, you'll need to authenticate:

**Option A: Personal Access Token (Recommended)**
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token with `repo` scope
3. Use token as password when pushing

**Option B: SSH Key**
1. Generate: `ssh-keygen -t ed25519 -C "katariganeshkumar@gmail.com"`
2. Add to GitHub: Settings → SSH and GPG keys
3. Use SSH URL: `git@github.com:USERNAME/REPO.git`

## ✅ Verify

After pushing:
1. Visit: `https://github.com/YOUR_USERNAME/ganeshkumar-portfolio`
2. Check files are uploaded
3. Go to "Releases" → See v1.0 tag
4. Check "Actions" tab → CI workflow should run

## 📝 Next Steps

- [ ] Add repository description
- [ ] Add topics/tags: `portfolio`, `react`, `threejs`, `devops`, `webgl`
- [ ] Enable GitHub Pages (optional)
- [ ] Add repository to your GitHub profile

---

**Current Status:**
- ✅ Git initialized
- ✅ Code committed
- ✅ Tagged v1.0
- ⏳ Ready to push to GitHub

