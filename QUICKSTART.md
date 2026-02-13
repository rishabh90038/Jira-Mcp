# Quick Start Guide - Jira Integration with Cursor

## 🚀 Get Started in 5 Minutes

### Step 1: Get Your Jira API Token

1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Click **"Create API token"**
3. Give it a name (e.g., "Cursor MCP")
4. Copy the token (you won't see it again!)

### Step 2: Configure Your Credentials

1. Navigate to the jira-mcp directory:
   ```bash
   cd /Users/rishabh.kumar/jfl/jira-mcp
   ```

2. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

3. Edit the `.env` file with your credentials:
   ```bash
   nano .env
   # or
   code .env
   ```

4. Fill in your details:
   ```env
   JIRA_BASE_URL=https://your-domain.atlassian.net
   JIRA_EMAIL=your-email@company.com
   JIRA_API_TOKEN=your-api-token-from-step-1
   JIRA_PROJECT_KEY=PROJ
   ```

### Step 3: Add to Cursor Settings

#### Option A: Using Cursor UI (Recommended)

1. Open Cursor Settings (⌘ + ,)
2. Search for "MCP" or go to Extensions → MCP Servers
3. Add a new server with these details:
   - **Name**: jira
   - **Command**: node
   - **Args**: `/Users/rishabh.kumar/jfl/jira-mcp/build/index.js`
   - **Environment Variables**: (copy from your .env file)

#### Option B: Manual Configuration

Edit the file:
```bash
~/Library/Application\ Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json
```

Add this configuration (replace with your actual values):

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
        "JIRA_API_TOKEN": "your-api-token",
        "JIRA_PROJECT_KEY": "PROJ"
      }
    }
  }
}
```

### Step 4: Restart Cursor

**Important**: Completely quit and restart Cursor for the changes to take effect.

### Step 5: Test It!

Open Cursor and try these commands with the AI assistant:

```
Create a Jira ticket:
- Type: Task
- Summary: Test ticket from Cursor
- Description: Testing the Jira MCP integration
```

Or:

```
Search for all open issues in project PROJ
```

## 🎯 Common Use Cases

### Creating Bugs from Code

When you find a bug while coding:

```
Create a bug ticket:
- Summary: Login form validation not working
- Description: The email validation allows invalid email formats
- Priority: High
- Labels: frontend, validation
```

### Quick Task Creation

```
Create a task: "Add unit tests for UserService"
```

### Search Your Issues

```
Show me all my open tickets
```

```
Find all bugs with high priority
```

### Update Tickets

```
Update PROJ-123 to In Progress and add comment "Starting work on this"
```

## 🔧 Troubleshooting

### "Server not found"
- Make sure you've restarted Cursor completely
- Check that the path in settings is correct
- Verify the build folder exists: `ls /Users/rishabh.kumar/jfl/jira-mcp/build/`

### "Authentication failed"
- Verify your API token is correct
- Check your email matches your Jira account
- Ensure JIRA_BASE_URL has no trailing slash

### "Project not found"
- Verify your project key is correct (e.g., PROJ, not proj)
- Check you have permission to create issues in that project
- Try specifying the project key explicitly in your command

## 📚 More Examples

See the [README.md](README.md) for comprehensive documentation and advanced usage examples.

## 🆘 Need Help?

1. Check the README.md for detailed documentation
2. Verify all environment variables are set correctly
3. Look at Cursor's developer console for error messages
4. Test your Jira credentials with: https://your-domain.atlassian.net/rest/api/3/myself
