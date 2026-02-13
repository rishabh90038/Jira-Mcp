# 🎯 Complete Jira-Cursor Integration Setup

Your Jira MCP server has been created successfully! Follow these steps to integrate it with Cursor.

## 📁 What's Been Created

```
/Users/rishabh.kumar/jfl/jira-mcp/
├── src/
│   └── index.ts          # Main MCP server code
├── build/
│   └── index.js          # Compiled JavaScript (ready to use)
├── .env.example          # Template for your credentials
├── package.json          # Node.js dependencies
├── README.md             # Full documentation
├── QUICKSTART.md         # Quick setup guide
└── setup.sh             # Automated setup script
```

## ⚡ Quick Setup (3 Steps)

### 1️⃣ Get Your Jira API Token

Visit: https://id.atlassian.com/manage-profile/security/api-tokens

- Click "Create API token"
- Name it "Cursor MCP"
- Copy the token

### 2️⃣ Configure Your Credentials

```bash
cd /Users/rishabh.kumar/jfl/jira-mcp
cp .env.example .env
nano .env  # or use your favorite editor
```

Fill in your details in `.env`:
```env
JIRA_BASE_URL=https://your-domain.atlassian.net
JIRA_EMAIL=your-email@company.com
JIRA_API_TOKEN=your-api-token-here
JIRA_PROJECT_KEY=PROJ
```

### 3️⃣ Add to Cursor

Open Cursor settings file:
```bash
nano ~/Library/Application\ Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json
```

Add this configuration (replace with YOUR actual values from .env):

```json
{
  "mcpServers": {
    "jira": {
      "command": "node",
      "args": [
        "/Users/rishabh.kumar/jfl/jira-mcp/build/index.js"
      ],
      "env": {
        "JIRA_BASE_URL": "https://your-domain.atlassian.net",
        "JIRA_EMAIL": "your-email@company.com",
        "JIRA_API_TOKEN": "your-api-token-here",
        "JIRA_PROJECT_KEY": "PROJ"
      }
    }
  }
}
```

**Important**: If the file doesn't exist or has existing content, merge carefully. The outer `mcpServers` object should contain all your MCP server configurations.

### 4️⃣ Restart Cursor

Completely quit and restart Cursor (⌘+Q on Mac, then reopen).

## 🎉 Test It!

Open Cursor and try these commands with the AI:

### Create a ticket:
```
Create a Jira ticket:
- Type: Task
- Summary: Test Cursor integration
- Description: Testing the new Jira MCP server
- Priority: Low
```

### Search tickets:
```
Search for all open issues in my project
```

### Get ticket details:
```
Get details of PROJ-123
```

## 🎨 Usage Examples

### Bug Reporting
```
I found a bug. Create a Jira bug ticket:
- Summary: User authentication fails on mobile devices
- Description: Users cannot log in on iOS Safari browsers. Error occurs after entering credentials.
- Priority: High
- Labels: mobile, authentication, ios
```

### Feature Requests
```
Create a story for implementing dark mode in the settings page
```

### Quick Tasks
```
Create a task: Add logging to payment service with priority High
```

### JQL Searches
```
Find all bugs assigned to me that are in progress
```

```
Search for issues created in the last 7 days with high priority
```

### Update Tickets
```
Update PROJ-456:
- Move to In Progress
- Change priority to High
- Add comment: Started working on this, ETA 2 days
```

## 🔍 Available Commands

Your AI assistant now has these Jira capabilities:

1. **create_jira_issue** - Create new tickets (Story, Bug, Task, Epic, Subtask)
2. **search_jira_issues** - Search using JQL queries
3. **get_jira_issue** - Get full details of a ticket
4. **update_jira_issue** - Update existing tickets
5. **add_comment_to_issue** - Add comments to tickets
6. **get_project_info** - Get project information

## 🐛 Troubleshooting

### Server Not Showing Up
```bash
# Verify the build exists
ls -la /Users/rishabh.kumar/jfl/jira-mcp/build/

# Rebuild if needed
cd /Users/rishabh.kumar/jfl/jira-mcp
npm run build
```

### Authentication Issues
- Double-check your API token
- Verify your email is correct
- Ensure no trailing slashes in JIRA_BASE_URL
- Check you have project permissions

### Can't Find Project
- Verify JIRA_PROJECT_KEY matches your project (case-sensitive)
- Or specify project_key in each command

### View Cursor Logs
- Open Cursor Developer Tools (Help → Toggle Developer Tools)
- Check Console for MCP-related errors

## 📚 Documentation

- **README.md** - Complete documentation with all features
- **QUICKSTART.md** - Fast setup guide
- **Jira REST API** - https://developer.atlassian.com/cloud/jira/platform/rest/v3/

## 🔐 Security Notes

- Never commit your `.env` file to git (it's in .gitignore)
- Your API token has the same permissions as your account
- Rotate tokens regularly for security
- Store credentials securely

## 🚀 Next Steps

1. ✅ Set up your `.env` file
2. ✅ Add to Cursor settings
3. ✅ Restart Cursor
4. ✅ Test with a simple ticket creation
5. 🎯 Start automating your Jira workflow!

## 💡 Pro Tips

- You can create tickets while discussing code with the AI
- Use natural language - the AI understands context
- Combine ticket creation with code analysis
- Set up project-specific defaults in .env

Example workflow:
```
[You're discussing a bug with AI]

You: "This function has a memory leak"
AI: [Explains the issue]
You: "Create a Jira bug for this with high priority"
AI: [Creates ticket with context from your conversation]
```

---

**Need Help?** Check README.md or QUICKSTART.md for more details!

Enjoy your automated Jira integration! 🎊
