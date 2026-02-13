# 📚 Jira MCP Server - Documentation Index

Welcome to the Jira MCP Server! This index helps you find what you need quickly.

## 🚀 Getting Started

### New Users - Start Here!
1. **[START_HERE.md](START_HERE.md)** - Complete step-by-step setup guide
   - Detailed walkthrough for first-time setup
   - Screenshots and examples
   - Troubleshooting tips

2. **[QUICKSTART.md](QUICKSTART.md)** - Fast 5-minute setup
   - Quick setup for experienced users
   - Essential steps only
   - Get up and running fast

3. **[SUMMARY.txt](SUMMARY.txt)** - Visual overview
   - Beautiful formatted summary
   - Quick reference
   - At-a-glance information

## 📖 Documentation

### Complete Guides
- **[README.md](README.md)** - Full documentation
  - All features explained
  - API reference
  - Advanced usage examples

- **[SETUP_INSTRUCTIONS.md](SETUP_INSTRUCTIONS.md)** - Detailed setup
  - Comprehensive installation guide
  - Configuration options
  - Environment variables explained

### Quick References
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick reference card
  - Command examples
  - Configuration locations
  - Troubleshooting quick fixes
  - Keep this handy!

## 🛠️ Setup Scripts

### Essential Scripts
1. **[verify-setup.sh](verify-setup.sh)** - Verify your setup
   ```bash
   ./verify-setup.sh
   ```
   - Checks dependencies
   - Validates credentials
   - Tests Jira connection
   - Verifies Cursor settings

2. **[generate-config.sh](generate-config.sh)** - Generate Cursor config
   ```bash
   ./generate-config.sh
   ```
   - Creates Cursor configuration
   - Shows where to paste it
   - Saves to cursor-config.json

3. **[test-connection.sh](test-connection.sh)** - Test Jira API
   ```bash
   ./test-connection.sh
   ```
   - Tests authentication
   - Checks project access
   - Lists available issue types

4. **[setup.sh](setup.sh)** - Interactive setup
   ```bash
   ./setup.sh
   ```
   - Guided setup process
   - Interactive configuration

## 📁 Project Files

### Configuration
- **`.env.example`** - Template for credentials
  - Copy to `.env` and fill in
  - Contains all required variables
  - Well documented

- **`.env`** - Your credentials (create this!)
  - Not tracked in git
  - Contains your API token
  - Required for operation

- **`package.json`** - Node.js dependencies
  - Project metadata
  - Dependency versions
  - Build scripts

- **`tsconfig.json`** - TypeScript configuration
  - Compiler options
  - Build settings

### Source Code
- **`src/index.ts`** - Main MCP server
  - Server implementation
  - Tool handlers
  - API integration

- **`src/test.ts`** - Test utilities
  - Testing tools
  - Development helpers

### Build
- **`build/index.js`** - Compiled server (ready to use!)
  - Executable server
  - Ready for Cursor
  - Already built!

## 📋 Setup Checklist

Use this checklist to track your setup progress:

- [ ] 1. Read START_HERE.md or QUICKSTART.md
- [ ] 2. Get Jira API token from https://id.atlassian.com/manage-profile/security/api-tokens
- [ ] 3. Create .env file: `cp .env.example .env`
- [ ] 4. Fill in .env with your credentials
- [ ] 5. Run `./verify-setup.sh` to check setup
- [ ] 6. Run `./test-connection.sh` to test Jira API
- [ ] 7. Run `./generate-config.sh` to get Cursor config
- [ ] 8. Add configuration to Cursor settings
- [ ] 9. Restart Cursor completely (⌘+Q then reopen)
- [ ] 10. Test: "Create a test Jira ticket"

## 🎯 Common Tasks

### Setup Tasks
```bash
# Initial setup
cp .env.example .env
nano .env                    # Fill in credentials
./verify-setup.sh            # Check everything
./generate-config.sh         # Get Cursor config

# Testing
./test-connection.sh         # Test Jira API
npm run build                # Rebuild if needed
```

### Usage Examples
See [QUICK_REFERENCE.md](QUICK_REFERENCE.md) for:
- Creating tickets
- Searching issues
- Updating tickets
- Adding comments
- Natural language examples

## 🐛 Troubleshooting

### Quick Fixes
1. **Setup issues**: Run `./verify-setup.sh`
2. **Connection issues**: Run `./test-connection.sh`
3. **Cursor not seeing server**: Check configuration and restart Cursor
4. **Build issues**: Run `npm run build`

### Detailed Help
- [README.md#troubleshooting](README.md) - Comprehensive troubleshooting
- [START_HERE.md](START_HERE.md) - Common problems and solutions
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Quick fixes

## 🔗 External Resources

### Jira Resources
- **API Token Generator**: https://id.atlassian.com/manage-profile/security/api-tokens
- **Jira REST API Docs**: https://developer.atlassian.com/cloud/jira/platform/rest/v3/
- **JQL Reference**: https://support.atlassian.com/jira-service-management-cloud/docs/use-advanced-search-with-jira-query-language-jql/

### MCP Resources
- **MCP SDK**: https://github.com/modelcontextprotocol/sdk
- **MCP Specification**: https://modelcontextprotocol.io/

## 💡 Tips for Success

1. **Start with START_HERE.md** - It has everything you need
2. **Use verify-setup.sh** - Catches issues early
3. **Test connection first** - Before configuring Cursor
4. **Keep QUICK_REFERENCE.md handy** - For daily use
5. **Use natural language** - AI understands context

## 📞 Need Help?

1. Check [SUMMARY.txt](SUMMARY.txt) for quick overview
2. Review [START_HERE.md](START_HERE.md) for detailed steps
3. Run `./verify-setup.sh` to diagnose issues
4. Check Cursor Developer Console for errors
5. Verify .env file has correct credentials

## 🎊 You're Ready!

Everything is set up and ready to go. Follow START_HERE.md to configure your credentials and start using Jira with Cursor!

---

**Quick Start**: `cat START_HERE.md` or `cat SUMMARY.txt`

**Daily Use**: `cat QUICK_REFERENCE.md`

**Problems**: `./verify-setup.sh`
