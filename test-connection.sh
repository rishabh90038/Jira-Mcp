#!/bin/bash

# Quick Test Script for Jira API Connection
# This helps you verify your credentials work before setting up Cursor

echo "🧪 Testing Jira API Connection"
echo "=============================="
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "Please create .env with your credentials first."
    echo ""
    echo "Run: cp .env.example .env && nano .env"
    exit 1
fi

# Load environment variables
export $(cat .env | grep -v '^#' | grep -v '^$' | xargs 2>/dev/null)

# Validate required variables
if [ -z "$JIRA_BASE_URL" ] || [ -z "$JIRA_EMAIL" ] || [ -z "$JIRA_API_TOKEN" ]; then
    echo "❌ Missing credentials in .env file"
    echo ""
    echo "Required variables:"
    echo "  - JIRA_BASE_URL"
    echo "  - JIRA_EMAIL"
    echo "  - JIRA_API_TOKEN"
    exit 1
fi

echo "📋 Testing with:"
echo "   URL: $JIRA_BASE_URL"
echo "   Email: $JIRA_EMAIL"
echo "   Token: ${JIRA_API_TOKEN:0:10}..."
echo ""

# Test 1: Get current user
echo "Test 1: Authentication (Getting current user info)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

RESPONSE=$(curl -s -w "\n%{http_code}" \
    -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
    -H "Accept: application/json" \
    "$JIRA_BASE_URL/rest/api/3/myself" 2>/dev/null)

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | head -n-1)

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ Authentication successful!"
    DISPLAY_NAME=$(echo "$BODY" | grep -o '"displayName":"[^"]*"' | cut -d'"' -f4 | head -1)
    ACCOUNT_TYPE=$(echo "$BODY" | grep -o '"accountType":"[^"]*"' | cut -d'"' -f4 | head -1)
    echo "   User: $DISPLAY_NAME"
    echo "   Account Type: $ACCOUNT_TYPE"
else
    echo "❌ Authentication failed (HTTP $HTTP_CODE)"
    if [ "$HTTP_CODE" = "401" ]; then
        echo "   → Check your email and API token"
    elif [ "$HTTP_CODE" = "000" ]; then
        echo "   → Cannot connect to Jira"
        echo "   → Check JIRA_BASE_URL (remove trailing slash)"
        echo "   → Check your network/VPN"
    fi
    echo ""
    echo "Response:"
    echo "$BODY" | head -n 5
    exit 1
fi

echo ""

# Test 2: Check project access (if project key is set)
if [ -n "$JIRA_PROJECT_KEY" ]; then
    echo "Test 2: Project Access (Checking project: $JIRA_PROJECT_KEY)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    RESPONSE=$(curl -s -w "\n%{http_code}" \
        -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
        -H "Accept: application/json" \
        "$JIRA_BASE_URL/rest/api/3/project/$JIRA_PROJECT_KEY" 2>/dev/null)
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)
    
    if [ "$HTTP_CODE" = "200" ]; then
        echo "✅ Project access confirmed!"
        PROJECT_NAME=$(echo "$BODY" | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | head -1)
        PROJECT_TYPE=$(echo "$BODY" | grep -o '"projectTypeKey":"[^"]*"' | cut -d'"' -f4 | head -1)
        echo "   Name: $PROJECT_NAME"
        echo "   Type: $PROJECT_TYPE"
    elif [ "$HTTP_CODE" = "404" ]; then
        echo "⚠️  Project not found (HTTP $HTTP_CODE)"
        echo "   → Check JIRA_PROJECT_KEY in .env"
        echo "   → Current value: $JIRA_PROJECT_KEY"
    elif [ "$HTTP_CODE" = "403" ]; then
        echo "⚠️  No permission to access project (HTTP $HTTP_CODE)"
        echo "   → Verify you have access to project: $JIRA_PROJECT_KEY"
    else
        echo "⚠️  Cannot check project (HTTP $HTTP_CODE)"
    fi
    
    echo ""
fi

# Test 3: Get issue types
echo "Test 3: Available Issue Types"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -n "$JIRA_PROJECT_KEY" ]; then
    RESPONSE=$(curl -s -w "\n%{http_code}" \
        -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
        -H "Accept: application/json" \
        "$JIRA_BASE_URL/rest/api/3/project/$JIRA_PROJECT_KEY" 2>/dev/null)
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    BODY=$(echo "$RESPONSE" | head -n-1)
    
    if [ "$HTTP_CODE" = "200" ]; then
        echo "✅ Available issue types:"
        echo "$BODY" | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | grep -E "Story|Bug|Task|Epic|Subtask" | sort -u | while read TYPE; do
            echo "   - $TYPE"
        done
    else
        echo "⚠️  Could not fetch issue types"
    fi
else
    echo "⚠️  JIRA_PROJECT_KEY not set, skipping"
fi

echo ""
echo "=============================="
echo "✅ All tests completed!"
echo ""
echo "Your Jira credentials are working correctly."
echo ""
echo "Next steps:"
echo "  1. Run: ./generate-config.sh"
echo "  2. Add configuration to Cursor"
echo "  3. Restart Cursor"
echo "  4. Test: 'Create a test Jira ticket'"
echo ""
