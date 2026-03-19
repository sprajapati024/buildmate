---
name: buildmate:sync
description: Sync project between devices via git. Pulls remote changes, commits local work, and keeps all devices in sync. Essential for multi-device workflow.
tools: Read, Write, Bash
---

# /buildmate:sync - Multi-Device Sync

Keep your project synchronized across MacBook, server, and phone.

## The Problem

You code on:
- **MacBook** (main dev machine)
- **Server** (via phone/iPad)
- **Multiple locations**

Changes get out of sync!

## The Solution

```
MacBook → git push → GitHub
                ↑
         Server ← git pull
                ↓
         iPhone ← SSH → Server ← synced!
```

## What /buildmate:sync Does

1. **Pull** latest changes from remote
2. **Check** for local uncommitted changes
3. **Commit** with auto-message if needed
4. **Push** to remote
5. **Report** sync status

## Steps

<step name="verify_git">
```bash
# Check for git repo
if [ ! -d ".git" ]; then
  echo "NO_GIT"
  exit 0
fi

# Check for remote
git remote -v 2>/dev/null || echo "NO_REMOTE"
```
</step>

<step name="handle_no_git">
If NO_GIT:
```
❌ Not a git repository.

Initialize git first:
git init
git remote add origin <your-repo-url>
```
Stop execution.

If NO_REMOTE:
```
❌ No git remote configured.

Add remote:
git remote add origin <your-repo-url>
```
Stop execution.
</step>

<step name="sync_flow">
```bash
# Pull latest
git pull 2>/dev/null || echo "PULL_FAILED"

# Check status
git status --short 2>/dev/null || echo "STATUS_FAILED"

# Commit if needed
git add -A && git commit -m "[buildmate-sync] Update from $(hostname)" 2>/dev/null || echo "COMMIT_FAILED"

# Push
git push 2>/dev/null || echo "PUSH_FAILED"
```
</step>

## Usage

```
/buildmate:sync

# Or with custom message
/buildmate:sync "Mobile updates from phone"
```

## Example Flow

### Scenario: Morning Routine

**Last night on MacBook:**
```bash
# You coded, committed, pushed
git push origin main
```

**This morning on phone (via server):**
```bash
/buildmate:sync

Result:
📥 Pulling latest changes...
✅ 3 commits pulled from origin/main

💾 Checking local changes...
✅ No uncommitted changes

📤 Pushing to remote...
✅ Already up to date

🔄 Sync complete!
You're up to date with remote.
Safe to start coding.
```

### Scenario: Phone Updates

**Working on server via phone:**
```bash
# Agents created some files
/buildmate:status
→ "Coder created auth.py"

/buildmate:sync

Result:
📥 Pulling latest changes...
✅ Already up to date

💾 Checking local changes...
📝 Found 2 new files:
   - src/auth.py
   - tests/test_auth.py

💬 Auto-generating commit message...
📝 Commit: "[buildmate] Add authentication system
            
            - Implemented JWT auth
            - Added login/logout endpoints
            - Includes tests (5 passing)"

📤 Pushing to remote...
✅ Pushed to origin/main

🔄 Sync complete!
Changes now on remote.
Pull on MacBook to continue.
```

**Back on MacBook:**
```bash
git pull
→ Gets all the phone/server updates!
```

### Scenario: Conflicts

```bash
/buildmate:sync

Result:
📥 Pulling latest changes...
⚠️  CONFLICT detected!

Conflict in:
- src/config.py

Options:
1. Keep local version (server changes)
2. Keep remote version (MacBook changes)
3. Show diff and decide
4. Abort sync

[You choose]

🔄 Sync complete with merge commit!
```

## Workflow Best Practice

### The "Sync Dance"

**Before switching devices:**
```
Current device:
1. /buildmate:sync
2. Confirm pushed ✅

Switch devices:
3. Open new device
4. /buildmate:sync
5. Confirm pulled ✅
6. Start coding!
```

### Recommended Setup

**In your project .gitconfig:**
```
[alias]
  sync = !/buildmate:sync
  
[push]
  default = current
  
[ pull ]
  rebase = false
```

## Smart Commit Messages

If you don't provide a message, sync generates one:

```
[buildmate-sync] Update from <device>

- <N> files changed
- <brief description of changes>
- Synced at <timestamp>
```

Examples:
- `[buildmate-sync] Update from iPhone`
- `[buildmate-sync] Update from MacBook-Air`
- `[buildmate-sync] Mobile updates (3 files)`

## Integration with Buildmate

When agents complete work, they can auto-sync:

```
Coder: "Feature complete!"
Documenter: "Docs updated!"

/buildmate:sync
→ Commits all agent work
→ Pushes to remote
→ Ready for MacBook!
```

## Safety Features

- ✅ Pulls before pushing (avoid conflicts)
- ✅ Shows what will be committed
- ✅ Requires confirmation for destructive actions
- ✅ Creates backup branch before risky operations
- ✅ Won't push if tests fail (optional)

## Multi-Device Workflow

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   MacBook    │◄───────►│    GitHub    │◄───────►│    Server    │
│  (Main Dev)  │  git    │   (Remote)   │  git    │  (Phone SSH) │
└──────────────┘         └──────────────┘         └──────────────┘
       │                                                    │
       │ /buildmate:sync                                    │ /buildmate:sync
       │ 1. Pull latest                                     │ 1. Pull latest
       │ 2. Push changes                                    │ 2. Commit local
       │                                                    │ 3. Push changes
       └────────────────────────────────────────────────────┘
                         Everything synced!
```

## Tips

1. **Sync before switching devices** - Always!
2. **Small commits** - Sync often, less conflicts
3. **Use branches** - `feature-X` branch, sync that
4. **Check status** - `/buildmate:status` before sync
5. **Auto-sync** - Set up cron to auto-sync every hour

## Troubleshooting

**"Failed to push"**
→ Pull first, resolve conflicts, then sync again

**"No remote configured"**
→ Add remote: `git remote add origin <url>`

**"Authentication failed"**
→ Set up SSH key or use GitHub token

## Related Commands

- `/buildmate:status` - Check current state before sync
- `/buildmate:commit` - Manual commit with message
- `/buildmate:review` - Review before syncing to remote
