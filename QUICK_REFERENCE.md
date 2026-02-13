# Jira MCP - Quick Reference Card

## 🚀 Quick Commands

### Setup Commands
```bash
cd /Users/rishabh.kumar/jfl/jira-mcp

# Verify setup
./verify-setup.sh

# Generate Cursor config
./generate-config.sh

# Rebuild if needed
npm run build
```

## 💬 Natural Language Examples

### Create Tickets
```
Create a bug: Login fails on Safari browser
Create a story for implementing dark mode
Create a task: Refactor UserService with high priority
Create a bug ticket with labels: frontend, urgent
```

### Search Tickets
```
Search for all my open tickets
Find all high priority bugs
Show me tickets created this week
Search for tickets with label "frontend"
```

### Get Details
```
Get details of PROJ-123
Show me ticket PROJ-456
What's the status of PROJ-789
```

### Update Tickets
```
Update PROJ-123 to In Progress
Change PROJ-456 priority to High
Move PROJ-789 to Done
Update PROJ-123: change summary and move to In Progress
```

### Add Comments
```
Add comment to PROJ-123: Fixed in commit abc123
Comment on PROJ-456: Ready for review
```

## 🔧 Configuration Locations

### Project Directory
```
/Users/rishabh.kumar/jfl/jira-mcp/
```

### Cursor Settings
```
~/Library/Application Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json
```

### Environment File
```
/Users/rishabh.kumar/jfl/jira-mcp/.env
```

## 📋 Required Environment Variables

```env
JIRA_BASE_URL=https://your-domain.atlassian.net
JIRA_EMAIL=your-email@company.com
JIRA_API_TOKEN=your-api-token
JIRA_PROJECT_KEY=PROJ
```

## 🔍 JQL Search Examples

```
project = PROJ AND status = "In Progress"
assignee = currentUser() AND status != Done
created >= -7d ORDER BY priority DESC
status = Open AND priority = High
labels = frontend AND type = Bug
```

## 🛠️ Available Issue Types

- Story
- Bug
- Task
- Epic
- Subtask

## 📊 Available Priorities

- Highest
- High
- Medium
- Low
- Lowest

## 🐛 Troubleshooting Quick Fixes

### Server not working
```bash
cd /Users/rishabh.kumar/jfl/jira-mcp
./verify-setup.sh
npm run build
```

### Check credentials
```bash
cat /Users/rishabh.kumar/jfl/jira-mcp/.env
```

### Restart Cursor
```
⌘+Q (quit completely)
Then reopen Cursor
```

### Check logs
```
Cursor → Help → Toggle Developer Tools → Console
```

## 🔗 Useful Links

- **API Token**: https://id.atlassian.com/manage-profile/security/api-tokens
- **Jira API Docs**: https://developer.atlassian.com/cloud/jira/platform/rest/v3/
- **JQL Reference**: https://support.atlassian.com/jira-service-management-cloud/docs/use-advanced-search-with-jira-query-language-jql/

## 📖 Documentation Files

- `START_HERE.md` - Step-by-step setup
- `QUICKSTART.md` - 5-minute setup
- `README.md` - Complete documentation
- `SUMMARY.txt` - Visual overview

## ⚡ Tips

1. Use natural language - AI understands context
2. Create tickets while discussing code
3. Reference ticket keys (PROJ-123) directly
4. Combine multiple operations in one request
5. Use JQL for advanced searches

---

**Keep this card handy for quick reference!**
