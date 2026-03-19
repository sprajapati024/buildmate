---
name: buildmate:review
description: Code review via Documenter and Tester agents. Checks quality, patterns, and best practices.
tools: Read, Write, Bash
---

# /buildmate:review - Code Review

Review code quality, patterns, and best practices.

## Usage

```
/buildmate:review
/buildmate:review src/auth/
/buildmate:review --since-last-commit
```

## When to Use

- Before committing major changes
- Want feedback on implementation
- Checking for best practices
- Ensuring consistency
- Pre-PR review

## What Happens

1. Spawns Documenter + Tester agents
2. Reviews code for:
   - Code quality & patterns
   - Documentation completeness
   - Test coverage
   - Security issues
   - Performance concerns
3. Generates review report
4. Suggests improvements

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

<step name="identify_files">
```bash
# Get files to review
git diff --name-only HEAD~1 2>/dev/null || find . -type f \( -name "*.py" -o -name "*.js" -o -name "*.ts" \) 2>/dev/null | head -20
```
</step>

<step name="spawn_reviewers">
Spawn agents for review:
- `buildmate:test` - Check test coverage
- `buildmate:documenter` - Check documentation
</step>

<step name="generate_report">
Create REVIEW.md with:
- Files reviewed
- Issues found
- Suggestions
- Overall grade
</step>

<step name="report_result">
```
📋 Code Review Complete

Files reviewed: [count]
Issues: [count] ([severity breakdown])
Grade: [A/B/C/D]

See: REVIEW.md
```
</step>

## Example

```
/buildmate:review

📋 Code Review Report

Files reviewed: 12
Overall: ✅ Good

Strengths:
- Clean separation of concerns
- Good error handling
- Tests cover main paths

Suggestions:
⚠️ src/auth/jwt.py:42
   - Add input validation for token format
   
⚠️ src/api/routes/users.py:15
   - Missing docstring
   - Consider pagination for list endpoint
   
⚠️ tests/unit/test_auth.py
   - Add test for expired token case

Action items: 3 (all minor)
Recommended: Address before merge
```

## Output

Creates:
- REVIEW.md - Detailed review document
- Inline comments (if implemented)
- Ticket items for improvements

## vs /buildmate:test

- `/buildmate:test` - "Does it work?" (functional)
- `/buildmate:review` - "Is it good?" (quality)

Both should pass before major commits.
