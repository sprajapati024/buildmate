---
name: buildmate:update
description: Update Buildmate to the latest version. Checks for updates and reinstalls from GitHub or npm.
tools: Read, Write, Bash
---

# /buildmate:update - Update Buildmate

Check for and install the latest version of Buildmate.

## Usage

```
/buildmate:update
/buildmate:update --check    # Check for updates without installing
```

## What Happens

1. **Checks current version** - Reads local package.json
2. **Fetches latest version** - Checks GitHub releases or npm registry
3. **Compares versions** - Shows what's new if update available
4. **Installs update** - Re-runs installer with latest code
5. **Verifies installation** - Confirms commands and agents are present

## Steps

<step name="check_current_version">
```bash
# Read current version from package.json
cat ~/.claude/buildmate-core/package.json 2>/dev/null | jq -r '.version' || echo "UNKNOWN"
```
</step>

<step name="fetch_latest_version">
```bash
# Check latest from npm
npm view buildmate-ai version 2>/dev/null || echo "NOT_PUBLISHED"

# Or check GitHub latest release
curl -s https://api.github.com/repos/sprajapati024/buildmate/releases/latest 2>/dev/null | jq -r '.tag_name' || echo "GITHUB_CHECK_FAILED"
```
</step>

<step name="compare_versions">
Compare installed vs latest:

If already latest:
```
✅ Buildmate is up to date

Current: v1.25.1
Latest: v1.25.1

No update needed.
```

If update available:
```
🔄 Update Available

Current: v1.25.1
Latest: v1.26.0

Changes in v1.26.0:
- New feature X
- Bug fix Y
- Performance improvement Z

Install update? [Yes/No]
```
</step>

<step name="install_update">
If user approves:

```bash
# Method 1: npm update (if installed via npm)
npm update -g buildmate-ai 2>/dev/null || echo "NPM_UPDATE_FAILED"

# Method 2: Re-install from GitHub (fallback)
npx github:sprajapati024/buildmate --global --claude 2>/dev/null || echo "GITHUB_INSTALL_FAILED"
```
</step>

<step name="verify_installation">
```bash
# Check version after update
cat ~/.claude/buildmate-core/package.json 2>/dev/null | jq -r '.version'

# Verify commands exist
ls ~/.claude/commands/buildmate/ 2>/dev/null | wc -l

# Verify agents exist
ls ~/.claude/agents/buildmate-*.md 2>/dev/null | wc -l
```
</step>

<step name="report_result">
If success:
```
✅ Buildmate Updated Successfully

Old version: v1.25.1
New version: v1.26.0

Commands: 29 ✅
Agents: 7 ✅

Restart Claude Code to use the latest version.
```

If failed:
```
❌ Update Failed

Error: [error message]

Try manual update:
npm install -g buildmate-ai@latest

Or:
npx github:sprajapati024/buildmate --global --claude
```
</step>

## Manual Update (Alternative)

If the command fails, update manually:

```bash
# Via npm (once published)
npm update -g buildmate-ai

# Via GitHub (current method)
npx github:sprajapati024/buildmate --global --claude

# Or re-clone and install
git clone https://github.com/sprajapati024/buildmate.git
cd buildmate
node bin/install.js --global --claude
```

## Auto-Check on Startup

Future versions may check for updates automatically:
- Check once per day
- Notify if update available
- One-command install

## See Also

- `/buildmate:status` - Check current Buildmate status
- `/buildmate:version` - Show current version only
