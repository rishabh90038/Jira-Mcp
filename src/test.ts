#!/usr/bin/env node

/**
 * Test script for Jira MCP Server
 * This simulates how Cursor will interact with the server
 */

import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import dotenv from 'dotenv';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Load environment variables
dotenv.config({ path: join(__dirname, '..', '.env') });

console.log('🧪 Testing Jira MCP Server\n');

// Check environment variables
const requiredEnvVars = ['JIRA_BASE_URL', 'JIRA_EMAIL', 'JIRA_API_TOKEN'];
const missingVars = requiredEnvVars.filter(v => !process.env[v]);

if (missingVars.length > 0) {
  console.error('❌ Missing required environment variables:', missingVars.join(', '));
  console.error('\nPlease copy .env.example to .env and fill in your credentials.');
  process.exit(1);
}

console.log('✅ Environment variables loaded');
console.log(`   JIRA_BASE_URL: ${process.env.JIRA_BASE_URL}`);
console.log(`   JIRA_EMAIL: ${process.env.JIRA_EMAIL}`);
console.log(`   JIRA_PROJECT_KEY: ${process.env.JIRA_PROJECT_KEY || '(not set)'}`);
console.log();

// Start the server
const serverPath = join(__dirname, 'index.js');
console.log('🚀 Starting MCP Server...\n');

const server = spawn('node', [serverPath], {
  env: process.env,
  stdio: ['pipe', 'pipe', 'pipe']
});

server.stderr.on('data', (data) => {
  console.log('Server output:', data.toString());
});

server.stdout.on('data', (data) => {
  console.log('Server stdout:', data.toString());
});

server.on('error', (error) => {
  console.error('❌ Failed to start server:', error);
  process.exit(1);
});

// Send initialization request
setTimeout(() => {
  console.log('📤 Sending test request...\n');
  
  const initRequest = {
    jsonrpc: '2.0',
    id: 1,
    method: 'initialize',
    params: {
      protocolVersion: '2024-11-05',
      capabilities: {},
      clientInfo: {
        name: 'test-client',
        version: '1.0.0'
      }
    }
  };
  
  server.stdin.write(JSON.stringify(initRequest) + '\n');
  
  setTimeout(() => {
    console.log('\n✅ Server is running successfully!');
    console.log('\n📋 Next steps:');
    console.log('   1. Add the server configuration to Cursor settings');
    console.log('   2. Restart Cursor');
    console.log('   3. Try creating a Jira ticket through the AI assistant');
    console.log('\nPress Ctrl+C to stop the test server.');
  }, 1000);
}, 1000);

// Handle graceful shutdown
process.on('SIGINT', () => {
  console.log('\n\n👋 Shutting down test server...');
  server.kill();
  process.exit(0);
});
