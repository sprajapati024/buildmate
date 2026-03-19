---
name: buildmate:prd
description: View the current PRD (Product Requirements Document). Shows the living project specification maintained by the PM.
tools: Read
argument-hint: "[update]"
---

# /buildmate:prd - View or Update PRD

Display the current Product Requirements Document (PRD) maintained by the PM.

## Usage

```
/buildmate:prd              # View full PRD
/buildmate:prd update       # Ask PM to update PRD
```

## What Shows

- Project overview
- Scope boundaries (IN scope / OUT scope)
- Requirements (functional & non-functional)
- Technical decisions
- Open questions
- Agent assignments

## Steps for View

<step name="verify_project">
```bash
# Check for Buildmate project
if [ ! -f ".buildmate/soul.json" ]; then
  echo "NO_SOUL"
  exit 0
fi

# Read PRD
cat PRD.md 2>/dev/null || cat .buildmate/PRD.md 2>/dev/null || echo "NO_PRD"
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

<step name="display_or_error">
If PRD exists:
- Display full PRD content

If no PRD:
```
❌ No PRD found.

This project hasn't been initialized with a PRD yet.

Start a project:
/buildmate init "Description of what to build"

The PM will create a PRD during the interview phase.
```
</step>

## Steps for Update

<step name="verify_project_update">
```bash
# Check for Buildmate project
if [ ! -f ".buildmate/soul.json" ]; then
  echo "NO_SOUL"
  exit 0
fi
cat .buildmate/soul.json
```
</step>

<step name="trigger_pm_update">
If user runs `/buildmate:prd update`:

Spawn PM agent with task:

```
Task: buildmate-pm
Description: |
  User requested PRD update via /buildmate:prd update
  
  Your task:
  1. Read current PRD.md
  2. Read soul.json for recent decisions
  3. Read DECISIONS.md for decision history
  4. Check for outdated sections
  5. Incorporate recent decisions
  6. Update open questions
  7. Sync with actual codebase structure
  8. Update PRD version and timestamp
  9. Present summary of changes to user
```
</step>

<step name="confirm_update">
```
📝 PRD UPDATE REQUESTED

PM is reviewing and updating the PRD:
- Checking for outdated sections
- Incorporating recent decisions
- Updating agent assignments
- Syncing with codebase

Updated PRD will be available shortly.
```
</step>

## PRD Format

```markdown
# PRD: [Project Name]
**Version**: 1.0
**Last Updated**: 2026-03-18 by PM
**Status**: ✅ Scope Locked

## 1. Overview
What we're building and why.

## 2. Scope

### IN Scope ✅
- Feature A
- Feature B

### OUT Scope ❌
- Feature X (future version)
- Feature Y (not needed)

## 3. Requirements

### 3.1 Functional
- REQ-1: System shall do X
- REQ-2: System shall do Y

### 3.2 Non-Functional
- Performance: Handle 100 requests/min
- Security: Paper trading only

## 4. Technical Decisions
- **API**: AlphaVantage (see DECISIONS.md:1)
- **Database**: SQLite (see DECISIONS.md:2)

## 5. Open Questions
- [ ] Auth method: JWT or OAuth?

## 6. Agent Assignments
- Researcher: ✅ Complete
- Architect: 🔄 Working on section 4
- Coder: ⏳ Waiting for Architect
```

## See Also

- `/buildmate:scope` - View scope boundaries
- `/buildmate:context` - Full project context
- `/buildmate:why` - Decision rationale
