#!/bin/bash

# Generate Cursor MCP Configuration
# This script creates the exact configuration you need to paste into Cursor settings

echo "🔧 Jira MCP Configuration Generator"
echo "===================================="
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found!"
    echo ""
    echo "Please create .env file first:"
    echo "  1. cp .env.example .env"
    echo "  2. Edit .env with your Jira credentials"
    echo ""
    exit 1
fi

# Load environment variables
export $(cat .env | grep -v '^#' | grep -v '^$' | xargs)

# Validate required variables
MISSING=""
[ -z "$JIRA_BASE_URL" ] && MISSING="${MISSING}JIRA_BASE_URL "
[ -z "$JIRA_EMAIL" ] && MISSING="${MISSING}JIRA_EMAIL "
[ -z "$JIRA_API_TOKEN" ] && MISSING="${MISSING}JIRA_API_TOKEN "

if [ -n "$MISSING" ]; then
    echo "❌ Missing required variables in .env: $MISSING"
    echo ""
    echo "Please edit .env and add these values."
    exit 1
fi

# Get absolute path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BUILD_PATH="$SCRIPT_DIR/build/index.js"

# Check if build exists
if [ ! -f "$BUILD_PATH" ]; then
    echo "⚠️  Build not found. Running build..."
    npm run build
    if [ $? -ne 0 ]; then
        echo "❌ Build failed. Please fix errors and try again."
        exit 1
    fi
fi

echo "✅ Configuration ready!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 COPY THIS CONFIGURATION TO CURSOR"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Location:"
echo "~/Library/Application Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json"
echo ""
echo "Configuration:"
echo ""

# Generate the JSON configuration
cat << EOF
{
  "mcpServers": {
    "jira": {
      "command": "node",
      "args": [
        "$BUILD_PATH"
      ],
      "env": {
        "JIRA_BASE_URL": "$JIRA_BASE_URL",
        "JIRA_EMAIL": "$JIRA_EMAIL",
        "JIRA_API_TOKEN": "$JIRA_API_TOKEN",
        "JIRA_PROJECT_KEY": "${JIRA_PROJECT_KEY:-PROJ}"
      }
    }
  }
}
EOF

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 INSTRUCTIONS:"
echo ""
echo "1. Copy the JSON above (from { to })"
echo ""
echo "2. Open Cursor settings file:"
echo "   nano ~/Library/Application\ Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json"
echo ""
echo "3. Paste the configuration"
echo "   - If the file is empty, paste as-is"
echo "   - If it has content, merge the 'jira' entry into existing 'mcpServers'"
echo ""
echo "4. Save and close the file"
echo ""
echo "5. Restart Cursor completely (⌘+Q then reopen)"
echo ""
echo "6. Test by asking: 'Create a test Jira ticket'"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 TIP: This script also saved the config to 'cursor-config.json'"
echo "    You can view it anytime: cat cursor-config.json"
echo ""

# Save to file for easy reference
cat > cursor-config.json << EOF
{
  "mcpServers": {
    "jira": {
      "command": "node",
      "args": [
        "$BUILD_PATH"
      ],
      "env": {
        "JIRA_BASE_URL": "$JIRA_BASE_URL",
        "JIRA_EMAIL": "$JIRA_EMAIL",
        "JIRA_API_TOKEN": "$JIRA_API_TOKEN",
        "JIRA_PROJECT_KEY": "${JIRA_PROJECT_KEY:-PROJ}"
      }
    }
  }
}
EOF

echo "✅ Done! Follow the instructions above to complete setup."
