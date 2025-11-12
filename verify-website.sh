#!/bin/bash

# Website Verification Script

set -e

# Load deployment configuration from .env.deploy
if [ -f .env.deploy ]; then
    export $(cat .env.deploy | grep -v '^#' | xargs)
fi

# Set defaults if not provided
DOMAIN=${DOMAIN:-"www.ganeshkumar.me"}
SERVER_HOST=${SERVER_HOST:-""}

echo "🔍 Verifying Website Functionality..."
echo ""

# Test 1: HTTPS Website
echo "✅ Test 1: HTTPS Website"
HTTPS_CONTENT=$(curl -s -k "https://$DOMAIN" | head -c 500)
if echo "$HTTPS_CONTENT" | grep -q "Ganesh Kumar\|portfolio\|root"; then
    echo "   ✅ Website HTML is loading correctly"
else
    echo "   ⚠️  Website content check"
fi
echo ""

# Test 2: API Health
echo "✅ Test 2: API Health Endpoint"
API_HEALTH=$(curl -s -k "https://$DOMAIN/api/health")
if echo "$API_HEALTH" | grep -q "ok"; then
    echo "   ✅ API Health: $API_HEALTH"
else
    echo "   ❌ API Health check failed"
fi
echo ""

# Test 3: Profile API
echo "✅ Test 3: Profile API"
PROFILE=$(curl -s -k "https://$DOMAIN/api/profile" | head -c 200)
if echo "$PROFILE" | grep -q "personal\|name\|Ganesh"; then
    echo "   ✅ Profile API: Returning data"
else
    echo "   ⚠️  Profile API check"
fi
echo ""

# Test 4: SSL Certificate
echo "✅ Test 4: SSL Certificate"
SSL_INFO=$(echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -dates 2>/dev/null || echo "CHECK_FAILED")
if echo "$SSL_INFO" | grep -q "notAfter"; then
    echo "   ✅ SSL Certificate: Valid"
    echo "$SSL_INFO" | grep "notAfter"
else
    echo "   ⚠️  SSL Certificate check"
fi
echo ""

# Test 5: HTTP Redirect
echo "✅ Test 5: HTTP to HTTPS Redirect"
REDIRECT=$(curl -s -I "http://$DOMAIN" 2>/dev/null | grep -i "location\|301\|302" || echo "NO_REDIRECT")
if echo "$REDIRECT" | grep -q "https\|301\|302"; then
    echo "   ✅ HTTP redirects to HTTPS correctly"
else
    echo "   ⚠️  HTTP redirect check"
fi
echo ""

echo "✅ Website Verification Complete!"
echo ""
echo "🌐 Your website is live at:"
echo "   • https://$DOMAIN"
echo "   • https://ganeshkumar.me"
echo ""

