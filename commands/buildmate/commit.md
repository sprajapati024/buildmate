---
name: buildmate:commit
description: Smart commit with automatic documentation. Commits code + updates CHANGELOG + logs decisions.
tools: Read, Write, Bash
argument-hint: "[commit message]"
---

# /buildmate:commit - Smart Commit

Commit current work with automatic documentation updates.

## Usage

```
/buildmate:commit
/buildmate:commit "Add user authentication"
```

## When to Use

- Ready to commit current work
- Want consistent commit format
- Need to update docs simultaneously
- Following atomic commit practice

## What Happens

1. Checks git status
2. Stages relevant files
3. Runs tests (if any)
4. Updates CHANGELOG.md
5. Creates commit with:
   - Your message (or auto-generated)
   - Summary of changes
   - Test results
6. Logs any architectural decisions

## Steps

<step name="verify_project">
```bash
if [ ! -f ".buildmate/soul.json" ]; then
  echo "NO_SOUL"
  exit 0
fi
cat .buildmate/soul.json
```
</step>

<step name="handle_no_project">
If NO_SOUL detected:

```
❌ No Buildmate project found.

Start a project with: `/buildmate init "description"`
```

Stop execution.
</step>

<step name="check_git_status">
```bash
git status --short 2>/dev/null || echo "NO_GIT"
git diff --stat 2>/dev/null || echo "NO_CHANGES"
```
</step>

<step name="run_tests">
```bash
npm test 2>/dev/null || pytest 2>/dev/null || echo "NO_TESTS"
```
</step>

<step name="update_changelog">
Read CHANGELOG.md and add entry for current changes.
</step>

<step name="create_commit">
```bash
# Stage all changes
git add -A

# Commit with message (user-provided or auto-generated)
git commit -m "[buildmate] $COMMIT_MESSAGE"
```
</step>

<step name="report_result">
```
📝 Smart Commit Complete

Commit: [hash]
Message: [message]
Files changed: [count]
Tests: [result]
CHANGELOG.md: Updated
```
</step>

## Example

```
/buildmate:commit "Implement JWT authentication"

📝 Smart Commit

Changes:
- src/auth/jwt.py (new)
- src/api/routes/auth.py (modified)
- tests/unit/test_auth.py (new)

Tests: ✅ 15/15 passing

Commit: [buildmate] Implement JWT authentication

- Adds JWT token generation and validation
- Implements login/logout endpoints
- Includes comprehensive test suite
- Coverage: 94%

CHANGELOG.md updated
DECISIONS.md: Logged auth approach choice
```

## Without Message

If you don't provide a message:

```
/buildmate:commit

Documenter analyzes changes...
Suggested message: "Add stock price caching"

Accept? (Y/n): Y

Commit created with suggested message.
```

## Best Practice

Use `/buildmate:commit` instead of raw `git commit` to keep:
- CHANGELOG.md in sync
- DECISIONS.md updated
- Consistent commit format
- Test verification

## Related

- `/buildmate:test` - Verify before commit
- `/buildmate:review` - Review before commit
