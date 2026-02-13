# Jira MCP Server

A Model Context Protocol (MCP) server that integrates Jira with Cursor AI, allowing you to create and manage Jira tickets directly from your AI assistant.

## Features

- ✅ Create Jira issues (Stories, Bugs, Tasks, Epics, Subtasks)
- ✅ Search issues using JQL (Jira Query Language)
- ✅ Get issue details
- ✅ Update existing issues
- ✅ Add comments to issues
- ✅ Get project information

## Prerequisites

- Node.js 18 or higher
- A Jira Cloud account
- Jira API token ([Generate one here](https://id.atlassian.com/manage-profile/security/api-tokens))

## Setup

### 1. Install Dependencies

```bash
npm install
```

### 2. Configure Environment Variables

Copy the example environment file and fill in your Jira credentials:

```bash
cp .env.example .env
```

Edit `.env` with your Jira details:

```env
JIRA_BASE_URL=https://your-domain.atlassian.net
JIRA_EMAIL=your-email@example.com
JIRA_API_TOKEN=your-api-token-here
JIRA_PROJECT_KEY=PROJ
```

**How to get your API token:**
1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Click "Create API token"
3. Give it a name (e.g., "Cursor MCP")
4. Copy the token and paste it in your `.env` file

### 3. Build the Project

```bash
npm run build
```

### 4. Configure Cursor

Add this configuration to your Cursor settings. On macOS, edit:

```
~/Library/Application Support/Cursor/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json
```

Or through Cursor settings UI (Cursor Settings > MCP Servers), add:

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
        "JIRA_EMAIL": "your-email@example.com",
        "JIRA_API_TOKEN": "your-api-token-here",
        "JIRA_PROJECT_KEY": "PROJ"
      }
    }
  }
}
```

### 5. Restart Cursor

After adding the configuration, restart Cursor completely for the changes to take effect.

## Usage Examples

Once configured, you can interact with Jira directly through Cursor's AI assistant:

### Create a Ticket

```
Create a Jira ticket:
- Type: Bug
- Summary: Login page not responsive on mobile
- Description: The login page UI breaks on mobile devices below 768px width
- Priority: High
- Labels: frontend, mobile, ui
```

### Search for Issues

```
Search for all open bugs in the current sprint
```

```
Find all issues assigned to me that are in progress
```

### Get Issue Details

```
Get details of ticket PROJ-123
```

### Update an Issue

```
Update PROJ-123:
- Change priority to High
- Update description to include reproduction steps
- Move to In Progress
```

### Add Comments

```
Add a comment to PROJ-123: "Fixed in commit abc123, ready for review"
```

## Available Tools

### create_jira_issue
Create a new Jira issue with customizable fields.

**Parameters:**
- `project_key` (optional): Project key (uses default if not provided)
- `issue_type` (required): Story, Bug, Task, Epic, or Subtask
- `summary` (required): Brief title
- `description` (optional): Detailed description
- `priority` (optional): Highest, High, Medium, Low, Lowest
- `labels` (optional): Array of labels
- `assignee` (optional): Account ID of assignee

### search_jira_issues
Search for issues using JQL.

**Parameters:**
- `jql` (required): JQL query string
- `max_results` (optional): Maximum results to return (default: 50)

**Example JQL queries:**
- `project = PROJ AND status = "In Progress"`
- `assignee = currentUser() AND status != Done`
- `created >= -7d ORDER BY priority DESC`

### get_jira_issue
Get detailed information about a specific issue.

**Parameters:**
- `issue_key` (required): The issue key (e.g., PROJ-123)

### update_jira_issue
Update an existing issue.

**Parameters:**
- `issue_key` (required): The issue key
- `summary` (optional): New summary
- `description` (optional): New description
- `status` (optional): New status
- `priority` (optional): New priority
- `assignee` (optional): New assignee account ID

### add_comment_to_issue
Add a comment to an issue.

**Parameters:**
- `issue_key` (required): The issue key
- `comment` (required): Comment text

### get_project_info
Get information about a project.

**Parameters:**
- `project_key` (required): The project key

## Troubleshooting

### Server not appearing in Cursor

1. Check that the path in the configuration is correct
2. Verify environment variables are set correctly
3. Run `npm run build` to ensure the code is compiled
4. Check Cursor's MCP logs for errors
5. Restart Cursor completely

### Authentication Errors

1. Verify your API token is valid
2. Check that your email matches your Jira account
3. Ensure your Jira base URL is correct (no trailing slash)
4. Make sure you have permission to create issues in the project

### "Project key is required" Error

Either set `JIRA_PROJECT_KEY` in your environment variables or provide `project_key` when creating issues.

## Development

### Watch Mode

For development with auto-rebuild:

```bash
npm run watch
```

### Testing

You can test the server directly:

```bash
npm run dev
```

## License

MIT
