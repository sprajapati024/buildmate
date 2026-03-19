---
name: buildmate:debug
description: Debug current issues in the codebase. Spawns Debugger agent to investigate problems.
tools: Read, Write, Bash
argument-hint: "[issue description]"
---

# /buildmate:debug - Debug Issues

Spawn the Debugger agent to investigate and fix problems.

## Usage

```
/buildmate:debug
/buildmate:debug "API returning 500 errors"
/buildmate:debug "Tests failing after last commit"
/buildmate:debug "Performance is slow"
```

## When to Use

- Something is broken and you don't know why
- Tests are failing
- Performance issues
- Unexpected behavior
- Error logs you don't understand

## What Happens

1. Spawns debugging agent (Coder + Tester combo)
2. Investigates issue:
   - Reads error logs
   - Checks recent changes
   - Reproduces problem
   - Identifies root cause
3. Proposes or implements fix
4. Runs tests to verify

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

<step name="gather_context">
```bash
# Check recent changes
git log --oneline -10 2>/dev/null || echo "NO_GIT"

# Check for error logs
find . -name "*.log" -type f 2>/dev/null | head -5

# Run tests to see failures
npm test 2>/dev/null || pytest 2>/dev/null || echo "NO_TESTS"
```
</step>

<step name="spawn_debugger">
Spawn `buildmate:coder` in debug mode:

Task: "Debug issue: [user description]"
- Investigate root cause
- Check error logs
- Review recent changes
- Propose or implement fix
- Run tests to verify
</step>

<step name="report_result">
```
🐛 Debug Complete

Issue: [description]
Root Cause: [explanation]
Fix: [what was done]
Tests: [result]
```
</step>

## Example

```
/buildmate:debug "Auth endpoints returning 401"

Spawning Debugger...

🐛 Debug Report

Issue: Auth endpoints return 401 for valid tokens

Root Cause:
- JWT secret key mismatch between auth and verify
- auth.py uses SECRET_KEY from env
- middleware.py uses hardcoded fallback

Fix:
- Updated middleware to read from same env var
- Added validation that SECRET_KEY is set

Commit: a1b2c3d
Tests: ✅ All auth tests passing
```

## Auto-Debug

If Coder encounters errors during implementation, debugging happens automatically. Use `/buildmate:debug` for issues that come up during manual testing or usage.

## Related

- `/buildmate:test` - Run tests to check for issues
- `/buildmate:review` - Code review (catches bugs early)
