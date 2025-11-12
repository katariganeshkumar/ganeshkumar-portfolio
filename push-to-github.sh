#!/bin/bash

# Script to push portfolio code to GitHub
# Usage: bash push-to-github.sh YOUR_GITHUB_USERNAME REPO_NAME

set -e

GITHUB_USERNAME=${1:-"YOUR_USERNAME"}
REPO_NAME=${2:-"ganeshkumar-portfolio"}

echo "🚀 Setting up GitHub repository..."
echo ""

# Check if remote already exists
if git remote get-url origin &>/dev/null; then
    echo "⚠️  Remote 'origin' already exists"
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote set-url origin "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
    else
        echo "Keeping existing remote"
    fi
else
    echo "📦 Adding remote repository..."
    git remote add origin "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
fi

# Ensure we're on main branch
git branch -M main

echo ""
echo "📋 Repository Status:"
git remote -v
echo ""
git status
echo ""

read -p "Ready to push to GitHub? Make sure you've created the repository on GitHub first! (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Cancelled. Create the repository on GitHub first, then run this script again."
    exit 1
fi

echo ""
echo "⬆️  Pushing code to GitHub..."
git push -u origin main

echo ""
echo "🏷️  Pushing tags..."
git push origin v1.0

echo ""
echo "✅ Successfully pushed to GitHub!"
echo ""
echo "📍 Repository URL: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
echo "🏷️  Version 1.0 tag pushed successfully"
echo ""
echo "Next steps:"
echo "1. Visit your repository on GitHub"
echo "2. Go to Settings → Pages to enable GitHub Pages (optional)"
echo "3. Check the Releases section to see v1.0 tag"

