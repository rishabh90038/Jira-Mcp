#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from '@modelcontextprotocol/sdk/types.js';
import axios, { AxiosInstance } from 'axios';
import https from 'https';
import dotenv from 'dotenv';

dotenv.config();

// Jira configuration from environment variables
const JIRA_BASE_URL = process.env.JIRA_BASE_URL; // e.g., https://your-domain.atlassian.net
const JIRA_EMAIL = process.env.JIRA_EMAIL;
const JIRA_API_TOKEN = process.env.JIRA_API_TOKEN;
const JIRA_PROJECT_KEY = process.env.JIRA_PROJECT_KEY; // e.g., PROJ

if (!JIRA_BASE_URL || !JIRA_EMAIL || !JIRA_API_TOKEN) {
  console.error('Error: Missing required Jira configuration.');
  console.error('Please set JIRA_BASE_URL, JIRA_EMAIL, and JIRA_API_TOKEN in your .env file');
  process.exit(1);
}

// Create axios instance for Jira API with SSL configuration
const jiraClient: AxiosInstance = axios.create({
  baseURL: `${JIRA_BASE_URL}/rest/api/3`,
  auth: {
    username: JIRA_EMAIL,
    password: JIRA_API_TOKEN,
  },
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
  httpsAgent: new https.Agent({
    rejectUnauthorized: false, // Allow self-signed certificates (for corporate networks)
  }),
});

// Define available tools
const TOOLS: Tool[] = [
  {
    name: 'create_jira_issue',
    description: 'Create a new Jira issue (story, bug, task, etc.)',
    inputSchema: {
      type: 'object',
      properties: {
        project_key: {
          type: 'string',
          description: 'The Jira project key (e.g., PROJ). If not provided, uses default from JIRA_PROJECT_KEY environment variable.',
        },
        issue_type: {
          type: 'string',
          description: 'The type of issue to create (Story, Bug, Task, Epic, etc.)',
          enum: ['Story', 'Bug', 'Task', 'Epic', 'Subtask'],
          default: 'Task',
        },
        summary: {
          type: 'string',
          description: 'Brief summary/title of the issue',
        },
        description: {
          type: 'string',
          description: 'Detailed description of the issue (supports Atlassian Document Format)',
        },
        priority: {
          type: 'string',
          description: 'Priority of the issue',
          enum: ['Highest', 'High', 'Medium', 'Low', 'Lowest'],
          default: 'Medium',
        },
        labels: {
          type: 'array',
          items: {
            type: 'string',
          },
          description: 'Array of labels to add to the issue',
        },
        assignee: {
          type: 'string',
          description: 'Account ID of the assignee (optional)',
        },
      },
      required: ['summary', 'issue_type'],
    },
  },
  {
    name: 'search_jira_issues',
    description: 'Search for Jira issues using JQL (Jira Query Language)',
    inputSchema: {
      type: 'object',
      properties: {
        jql: {
          type: 'string',
          description: 'JQL query string (e.g., "project = PROJ AND status = Open")',
        },
        max_results: {
          type: 'number',
          description: 'Maximum number of results to return (default: 50)',
          default: 50,
        },
      },
      required: ['jql'],
    },
  },
  {
    name: 'get_jira_issue',
    description: 'Get details of a specific Jira issue by its key',
    inputSchema: {
      type: 'object',
      properties: {
        issue_key: {
          type: 'string',
          description: 'The issue key (e.g., PROJ-123)',
        },
      },
      required: ['issue_key'],
    },
  },
  {
    name: 'update_jira_issue',
    description: 'Update an existing Jira issue',
    inputSchema: {
      type: 'object',
      properties: {
        issue_key: {
          type: 'string',
          description: 'The issue key to update (e.g., PROJ-123)',
        },
        summary: {
          type: 'string',
          description: 'New summary/title',
        },
        description: {
          type: 'string',
          description: 'New description',
        },
        status: {
          type: 'string',
          description: 'New status (To Do, In Progress, Done, etc.)',
        },
        priority: {
          type: 'string',
          description: 'New priority',
          enum: ['Highest', 'High', 'Medium', 'Low', 'Lowest'],
        },
        assignee: {
          type: 'string',
          description: 'Account ID of the new assignee',
        },
      },
      required: ['issue_key'],
    },
  },
  {
    name: 'add_comment_to_issue',
    description: 'Add a comment to a Jira issue',
    inputSchema: {
      type: 'object',
      properties: {
        issue_key: {
          type: 'string',
          description: 'The issue key (e.g., PROJ-123)',
        },
        comment: {
          type: 'string',
          description: 'The comment text to add',
        },
      },
      required: ['issue_key', 'comment'],
    },
  },
  {
    name: 'get_project_info',
    description: 'Get information about a Jira project',
    inputSchema: {
      type: 'object',
      properties: {
        project_key: {
          type: 'string',
          description: 'The project key (e.g., PROJ)',
        },
      },
      required: ['project_key'],
    },
  },
];

// Helper function to convert description to Atlassian Document Format
function convertToADF(text: string): any {
  return {
    version: 1,
    type: 'doc',
    content: [
      {
        type: 'paragraph',
        content: [
          {
            type: 'text',
            text: text,
          },
        ],
      },
    ],
  };
}

// Tool handlers
async function handleCreateIssue(args: any): Promise<any> {
  const projectKey = args.project_key || JIRA_PROJECT_KEY;
  
  if (!projectKey) {
    throw new Error('Project key is required. Set JIRA_PROJECT_KEY environment variable or provide project_key parameter.');
  }

  const issueData: any = {
    fields: {
      project: {
        key: projectKey,
      },
      summary: args.summary,
      description: convertToADF(args.description || ''),
      issuetype: {
        name: args.issue_type || 'Task',
      },
    },
  };

  if (args.priority) {
    issueData.fields.priority = { name: args.priority };
  }

  if (args.labels && args.labels.length > 0) {
    issueData.fields.labels = args.labels;
  }

  if (args.assignee) {
    issueData.fields.assignee = { accountId: args.assignee };
  }

  const response = await jiraClient.post('/issue', issueData);
  
  return {
    success: true,
    issue_key: response.data.key,
    issue_id: response.data.id,
    url: `${JIRA_BASE_URL}/browse/${response.data.key}`,
    message: `Successfully created issue ${response.data.key}`,
  };
}

async function handleSearchIssues(args: any): Promise<any> {
  const response = await jiraClient.get('/search', {
    params: {
      jql: args.jql,
      maxResults: args.max_results || 50,
      fields: ['summary', 'status', 'assignee', 'priority', 'created', 'updated'],
    },
  });

  return {
    total: response.data.total,
    issues: response.data.issues.map((issue: any) => ({
      key: issue.key,
      summary: issue.fields.summary,
      status: issue.fields.status.name,
      priority: issue.fields.priority?.name,
      assignee: issue.fields.assignee?.displayName,
      created: issue.fields.created,
      updated: issue.fields.updated,
      url: `${JIRA_BASE_URL}/browse/${issue.key}`,
    })),
  };
}

async function handleGetIssue(args: any): Promise<any> {
  const response = await jiraClient.get(`/issue/${args.issue_key}`);
  const issue = response.data;

  return {
    key: issue.key,
    summary: issue.fields.summary,
    description: issue.fields.description,
    status: issue.fields.status.name,
    priority: issue.fields.priority?.name,
    assignee: issue.fields.assignee?.displayName,
    reporter: issue.fields.reporter?.displayName,
    created: issue.fields.created,
    updated: issue.fields.updated,
    labels: issue.fields.labels,
    url: `${JIRA_BASE_URL}/browse/${issue.key}`,
  };
}

async function handleUpdateIssue(args: any): Promise<any> {
  const updateData: any = { fields: {} };

  if (args.summary) {
    updateData.fields.summary = args.summary;
  }

  if (args.description) {
    updateData.fields.description = convertToADF(args.description);
  }

  if (args.priority) {
    updateData.fields.priority = { name: args.priority };
  }

  if (args.assignee) {
    updateData.fields.assignee = { accountId: args.assignee };
  }

  await jiraClient.put(`/issue/${args.issue_key}`, updateData);

  // Handle status transition separately if provided
  if (args.status) {
    const transitionsResponse = await jiraClient.get(`/issue/${args.issue_key}/transitions`);
    const transition = transitionsResponse.data.transitions.find(
      (t: any) => t.to.name.toLowerCase() === args.status.toLowerCase()
    );

    if (transition) {
      await jiraClient.post(`/issue/${args.issue_key}/transitions`, {
        transition: {
          id: transition.id,
        },
      });
    }
  }

  return {
    success: true,
    message: `Successfully updated issue ${args.issue_key}`,
    url: `${JIRA_BASE_URL}/browse/${args.issue_key}`,
  };
}

async function handleAddComment(args: any): Promise<any> {
  const commentData = {
    body: convertToADF(args.comment),
  };

  const response = await jiraClient.post(`/issue/${args.issue_key}/comment`, commentData);

  return {
    success: true,
    comment_id: response.data.id,
    message: `Successfully added comment to ${args.issue_key}`,
    url: `${JIRA_BASE_URL}/browse/${args.issue_key}`,
  };
}

async function handleGetProjectInfo(args: any): Promise<any> {
  const response = await jiraClient.get(`/project/${args.project_key}`);
  const project = response.data;

  return {
    key: project.key,
    name: project.name,
    description: project.description,
    lead: project.lead?.displayName,
    projectTypeKey: project.projectTypeKey,
    url: project.self,
  };
}

// Create and configure the server
const server = new Server(
  {
    name: 'jira-mcp-server',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Register tool handlers
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return { tools: TOOLS };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  try {
    const { name, arguments: args } = request.params;

    switch (name) {
      case 'create_jira_issue':
        return { content: [{ type: 'text', text: JSON.stringify(await handleCreateIssue(args), null, 2) }] };
      
      case 'search_jira_issues':
        return { content: [{ type: 'text', text: JSON.stringify(await handleSearchIssues(args), null, 2) }] };
      
      case 'get_jira_issue':
        return { content: [{ type: 'text', text: JSON.stringify(await handleGetIssue(args), null, 2) }] };
      
      case 'update_jira_issue':
        return { content: [{ type: 'text', text: JSON.stringify(await handleUpdateIssue(args), null, 2) }] };
      
      case 'add_comment_to_issue':
        return { content: [{ type: 'text', text: JSON.stringify(await handleAddComment(args), null, 2) }] };
      
      case 'get_project_info':
        return { content: [{ type: 'text', text: JSON.stringify(await handleGetProjectInfo(args), null, 2) }] };
      
      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error: any) {
    const errorMessage = error.response?.data?.errorMessages?.join(', ') || error.message;
    return {
      content: [{ type: 'text', text: `Error: ${errorMessage}` }],
      isError: true,
    };
  }
});

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Jira MCP Server running on stdio');
}

main().catch((error) => {
  console.error('Server error:', error);
  process.exit(1);
});
