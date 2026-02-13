#!/bin/bash

# Jira MCP Server - Setup Verification Script
# This checks if everything is configured correctly

echo "🔍 Jira MCP Server - Setup Verification"
echo "========================================"
echo ""

ERRORS=0
WARNINGS=0

# Check 1: Node.js installed
echo -n "✓ Checking Node.js installation... "
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✅ Found: $NODE_VERSION"
else
    echo "❌ Node.js not found!"
    ERRORS=$((ERRORS + 1))
fi

# Check 2: npm installed
echo -n "✓ Checking npm installation... "
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "✅ Found: $NPM_VERSION"
else
    echo "❌ npm not found!"
    ERRORS=$((ERRORS + 1))
fi

# Check 3: node_modules exists
echo -n "✓ Checking dependencies... "
if [ -d "node_modules" ]; then
    echo "✅ Installed"
else
    echo "⚠️  Not installed. Run: npm install"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 4: Build exists
echo -n "✓ Checking build... "
if [ -f "build/index.js" ]; then
    echo "✅ Built"
else
    echo "⚠️  Not built. Run: npm run build"
    WARNINGS=$((WARNINGS + 1))
fi

# Check 5: .env file exists
echo -n "✓ Checking .env file... "
if [ -f ".env" ]; then
    echo "✅ Exists"
    
    # Check 6: Load and validate environment variables
    export $(cat .env | grep -v '^#' | grep -v '^$' | xargs 2>/dev/null)
    
    echo ""
    echo "  Environment Variables:"
    
    echo -n "    - JIRA_BASE_URL: "
    if [ -n "$JIRA_BASE_URL" ]; then
        echo "✅ Set ($JIRA_BASE_URL)"
    else
        echo "❌ Missing"
        ERRORS=$((ERRORS + 1))
    fi
    
    echo -n "    - JIRA_EMAIL: "
    if [ -n "$JIRA_EMAIL" ]; then
        echo "✅ Set ($JIRA_EMAIL)"
    else
        echo "❌ Missing"
        ERRORS=$((ERRORS + 1))
    fi
    
    echo -n "    - JIRA_API_TOKEN: "
    if [ -n "$JIRA_API_TOKEN" ]; then
        TOKEN_LEN=${#JIRA_API_TOKEN}
        echo "✅ Set (${TOKEN_LEN} chars)"
    else
        echo "❌ Missing"
        ERRORS=$((ERRORS + 1))
    fi
    
    echo -n "    - JIRA_PROJECT_KEY: "
    if [ -n "$JIRA_PROJECT_KEY" ]; then
        echo "✅ Set ($JIRA_PROJECT_KEY)"
    else
        echo "⚠️  Not set (optional)"
        WARNINGS=$((WARNINGS + 1))
    fi
    
else
    echo "❌ Missing!"
    echo "  → Run: cp .env.example .env"
    echo "  → Then edit .env with your credentials"
    ERRORS=$((ERRORS + 1))
fi

# Check 7: Test Jira API connection (if credentials exist)
if [ -n "$JIRA_BASE_URL" ] && [ -n "$JIRA_EMAIL" ] && [ -n "$JIRA_API_TOKEN" ]; then
    echo ""
    echo -n "✓ Testing Jira API connection... "
    
    # Try to get current user info
    RESPONSE=$(curl -s -w "\n%{http_code}" -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
        "$JIRA_BASE_URL/rest/api/3/myself" 2>/dev/null)
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    
    if [ "$HTTP_CODE" = "200" ]; then
        USER_INFO=$(echo "$RESPONSE" | head -n-1)
        DISPLAY_NAME=$(echo "$USER_INFO" | grep -o '"displayName":"[^"]*"' | cut -d'"' -f4 | head -1)
        echo "✅ Connected as: $DISPLAY_NAME"
    elif [ "$HTTP_CODE" = "401" ]; then
        echo "❌ Authentication failed (401)"
        echo "  → Check your email and API token"
        ERRORS=$((ERRORS + 1))
    elif [ "$HTTP_CODE" = "000" ]; then
        echo "⚠️  Cannot connect to Jira"
        echo "  → Check your JIRA_BASE_URL"
        echo "  → Are you behind a firewall/VPN?"
        WARNINGS=$((WARNINGS + 1))
    else
        echo "⚠️  HTTP $HTTP_CODE"
        WARNINGS=$((WARNINGS + 1))
    fi
fi

# Check 8: Cursor settings location
echo ""
echo -n "✓ Checking Cursor settings directory... "
CURSOR_SETTINGS_DIR="$HOME/Library/Application Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings"
if [ -d "$CURSOR_SETTINGS_DIR" ]; then
    echo "✅ Found"
    
    echo -n "    - cline_mcp_settings.json: "
    if [ -f "$CURSOR_SETTINGS_DIR/cline_mcp_settings.json" ]; then
        echo "✅ Exists"
        
        # Check if jira server is configured
        if grep -q '"jira"' "$CURSOR_SETTINGS_DIR/cline_mcp_settings.json" 2>/dev/null; then
            echo "      ✅ Jira server configured in Cursor"
        else
            echo "      ⚠️  Jira server not found in configuration"
            echo "      → Run: ./generate-config.sh"
            echo "      → Then add the configuration to Cursor settings"
            WARNINGS=$((WARNINGS + 1))
        fi
    else
        echo "⚠️  Not found"
        echo "      → You'll need to create this file"
        WARNINGS=$((WARNINGS + 1))
    fi
else
    echo "⚠️  Not found"
    echo "  → Cursor might not be installed or settings location different"
    WARNINGS=$((WARNINGS + 1))
fi

# Summary
echo ""
echo "========================================"
echo "Summary:"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "🎉 Perfect! Everything is set up correctly!"
    echo ""
    echo "Next steps:"
    echo "  1. Run: ./generate-config.sh"
    echo "  2. Copy the output to Cursor settings"
    echo "  3. Restart Cursor"
    echo "  4. Test: 'Create a test Jira ticket'"
elif [ $ERRORS -eq 0 ]; then
    echo "✅ Setup complete with $WARNINGS warning(s)"
    echo ""
    echo "You can proceed but check warnings above."
else
    echo "❌ Found $ERRORS error(s) and $WARNINGS warning(s)"
    echo ""
    echo "Please fix the errors above before proceeding."
    echo ""
    echo "Quick fixes:"
    echo "  - Missing dependencies: npm install"
    echo "  - Missing build: npm run build"
    echo "  - Missing .env: cp .env.example .env && nano .env"
fi

echo ""
echo "📚 Documentation:"
echo "  - START_HERE.md - Step-by-step setup guide"
echo "  - QUICKSTART.md - Quick reference"
echo "  - README.md - Full documentation"
echo ""

exit $ERRORS
