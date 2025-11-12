#!/bin/bash

# Complete GitHub Publishing Script
# This script will guide you through publishing your portfolio to GitHub

set -e

echo "🚀 GitHub Publishing Assistant"
echo "=============================="
echo ""

# Check GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI not found. Installing..."
    if command -v brew &> /dev/null; then
        brew install gh
    else
        echo "Please install GitHub CLI manually: https://cli.github.com/"
        exit 1
    fi
fi

echo "✅ GitHub CLI installed"
echo ""

# Check authentication
if gh auth status &>/dev/null 2>&1; then
    echo "✅ Already authenticated with GitHub"
    USERNAME=$(gh api user --jq .login)
    echo "   Logged in as: $USERNAME"
    echo ""
else
    echo "🔐 GitHub Authentication Required"
    echo ""
    echo "You need to login to GitHub. Choose authentication method:"
    echo "  1. Browser (easiest)"
    echo "  2. Token"
    echo ""
    read -p "Choose method (1 or 2, default: 1): " AUTH_METHOD
    AUTH_METHOD=${AUTH_METHOD:-1}
    
    if [ "$AUTH_METHOD" = "1" ]; then
        echo ""
        echo "Opening browser for authentication..."
        gh auth login --web
    else
        echo ""
        echo "Go to: https://github.com/settings/tokens"
        echo "Create a token with 'repo' scope"
        read -p "Paste your token here: " TOKEN
        echo "$TOKEN" | gh auth login --with-token
    fi
    
    USERNAME=$(gh api user --jq .login)
    echo ""
    echo "✅ Authenticated as: $USERNAME"
    echo ""
fi

# Get repository details
read -p "Repository name (default: ganeshkumar-portfolio): " REPO_NAME
REPO_NAME=${REPO_NAME:-ganeshkumar-portfolio}

read -p "Make repository public? (y/n, default: y): " IS_PUBLIC
IS_PUBLIC=${IS_PUBLIC:-y}

if [[ $IS_PUBLIC =~ ^[Yy]$ ]]; then
    VISIBILITY="--public"
    echo "✅ Repository will be public"
else
    VISIBILITY="--private"
    echo "✅ Repository will be private"
fi

echo ""
echo "📦 Creating repository: $REPO_NAME"
echo ""

# Create repository
gh repo create "$REPO_NAME" $VISIBILITY \
    --source=. \
    --remote=origin \
    --push \
    --description "Senior DevOps Engineer Portfolio Website - Modern WebGL-powered portfolio showcasing technical expertise"

echo ""
echo "🏷️  Pushing version tag v1.0..."
git push origin v1.0

echo ""
echo "✅ SUCCESS! Repository created and code pushed!"
echo ""
echo "📍 Repository URL: https://github.com/$USERNAME/$REPO_NAME"
echo "🏷️  Version 1.0: https://github.com/$USERNAME/$REPO_NAME/releases/tag/v1.0"
echo ""
echo "Next steps:"
echo "  1. Visit your repository on GitHub"
echo "  2. Add topics: portfolio, react, threejs, devops, webgl"
echo "  3. Update repository description if needed"
echo "  4. Check Actions tab for CI/CD status"
echo ""

