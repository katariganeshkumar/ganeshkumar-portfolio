#!/bin/bash

# Script to create GitHub repository and push code
# Usage: bash create-github-repo.sh

set -e

echo "🚀 GitHub Repository Setup"
echo "=========================="
echo ""

# Check if GitHub CLI is installed
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI found"
    
    # Check if user is logged in
    if gh auth status &>/dev/null; then
        echo "✅ GitHub CLI authenticated"
        
        read -p "Enter repository name (default: ganeshkumar-portfolio): " REPO_NAME
        REPO_NAME=${REPO_NAME:-ganeshkumar-portfolio}
        
        read -p "Make repository public? (y/n, default: y): " IS_PUBLIC
        IS_PUBLIC=${IS_PUBLIC:-y}
        
        if [[ $IS_PUBLIC =~ ^[Yy]$ ]]; then
            VISIBILITY="--public"
        else
            VISIBILITY="--private"
        fi
        
        echo ""
        echo "📦 Creating repository: $REPO_NAME"
        
        # Create repository and push
        gh repo create "$REPO_NAME" $VISIBILITY --source=. --remote=origin --push --description "Senior DevOps Engineer Portfolio Website - Modern WebGL-powered portfolio showcasing technical expertise"
        
        echo ""
        echo "🏷️  Pushing version tag..."
        git push origin v1.0
        
        echo ""
        echo "✅ Successfully created and pushed to GitHub!"
        echo "📍 Repository: https://github.com/$(gh api user --jq .login)/$REPO_NAME"
        
    else
        echo "⚠️  Not logged in to GitHub CLI"
        echo ""
        echo "Please login first:"
        echo "  gh auth login"
        echo ""
        echo "Then run this script again."
        exit 1
    fi
    
else
    echo "⚠️  GitHub CLI not installed"
    echo ""
    echo "Please choose one of these options:"
    echo ""
    echo "Option 1: Install GitHub CLI (Recommended)"
    echo "  macOS: brew install gh"
    echo "  Then: gh auth login"
    echo "  Then run this script again"
    echo ""
    echo "Option 2: Manual Setup"
    echo "  1. Go to https://github.com/new"
    echo "  2. Create repository: ganeshkumar-portfolio"
    echo "  3. DO NOT initialize with README"
    echo "  4. Then run: bash push-to-github.sh YOUR_USERNAME ganeshkumar-portfolio"
    echo ""
    exit 1
fi

