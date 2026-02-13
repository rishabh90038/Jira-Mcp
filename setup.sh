#!/bin/bash

# Jira MCP Server Setup Script

echo "🚀 Jira MCP Server Setup"
echo "========================"
echo ""

# Check if .env exists
if [ -f ".env" ]; then
    echo "✅ .env file already exists"
else
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your Jira credentials"
    echo ""
    echo "You need:"
    echo "  1. JIRA_BASE_URL (e.g., https://your-domain.atlassian.net)"
    echo "  2. JIRA_EMAIL (your Jira account email)"
    echo "  3. JIRA_API_TOKEN (generate at: https://id.atlassian.com/manage-profile/security/api-tokens)"
    echo "  4. JIRA_PROJECT_KEY (e.g., PROJ)"
    echo ""
    read -p "Press Enter after you've edited .env with your credentials..."
fi

# Build the project
echo ""
echo "🔨 Building project..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
else
    echo "❌ Build failed. Please check for errors."
    exit 1
fi

# Get the absolute path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BUILD_PATH="$SCRIPT_DIR/build/index.js"

# Load .env variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Add this to your Cursor MCP settings:"
echo "   Location: ~/Library/Application Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json"
echo ""
echo "   Or use Cursor UI: Settings → MCP Servers"
echo ""
echo "2. Add this configuration:"
echo ""
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
        "JIRA_PROJECT_KEY": "$JIRA_PROJECT_KEY"
      }
    }
  }
}
EOF

echo ""
echo "3. Restart Cursor completely"
echo ""
echo "4. Test by asking Cursor AI: 'Create a test Jira ticket'"
echo ""
echo "📖 See README.md for more usage examples"
