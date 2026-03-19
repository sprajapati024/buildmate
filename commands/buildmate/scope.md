---
name: buildmate:scope
description: View current scope boundaries and change history. Shows what's IN scope, OUT of scope, and recent changes.
tools: Read
---

# /buildmate:scope - View Scope Boundaries

Display current project scope: what's included, what's excluded, and change history.

## Usage

```
/buildmate:scope
```

## What Shows

From `.buildmate/soul.json` and PRD:
- Scope status (locked/unlocked)
- IN scope items
- OUT scope items
- Change history
- Who approved changes

## Steps

<step name="check_soul_json">
```bash
# Verify we're in a Buildmate project
if [ ! -f ".buildmate/soul.json" ]; then
  echo "NO_SOUL"
  exit 0
fi

# Read scope from soul.json
cat .buildmate/soul.json | jq '.scope' 2>/dev/null || echo "NO_SCOPE"

# Read scope section from PRD
cat PRD.md 2>/dev/null || cat .buildmate/PRD.md 2>/dev/null
```
</step>

<step name="spawn_pm_scope_review">
Spawn PM agent for scope review:

```
Task: buildmate-pm
Description: |
  User requested scope view via /buildmate:scope
  
  Your task:
  1. Read .buildmate/soul.json for current scope state
  2. Read PRD.md for scope boundaries
  3. Present formatted scope view to user:
     - Scope status (locked/unlocked)
     - IN scope items
     - OUT of scope items
     - Change history
     - Any pending scope changes
  4. If scope is unlocked, recommend locking it
  5. Report any scope violations detected
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

<step name="display_scope">
```
🎯 SCOPE BOUNDARIES

Status: [✅ Locked / 🔄 Unlocked]

═══════════════════════════════════════
✅ IN SCOPE
═══════════════════════════════════════
• [Item 1]
• [Item 2]
• [Item 3]

═══════════════════════════════════════
❌ OUT OF SCOPE
═══════════════════════════════════════
• [Item A] - Future version
• [Item B] - Not needed for MVP
• [Item C] - Separate project

═══════════════════════════════════════
📜 CHANGE HISTORY
═══════════════════════════════════════
[Date] - [Change description] - Approved by: [who]
[Date] - [Change description] - Approved by: [who]

═══════════════════════════════════════
⚠️  SCOPE CHANGE PROTOCOL
═══════════════════════════════════════
To change scope:
1. Request goes to PM
2. PM presents to user for approval
3. If approved: PRD updated, logged here
4. If rejected: Work redirected to current scope

Current blockers: [count] agents waiting for scope clarity
```
</step>

## Scope Lock Rules

Once scope is locked:
- ✅ Agents can work within boundaries
- 🚫 Scope changes require user approval
- 📝 PM logs all changes
- 🔄 Change history is permanent

## See Also

- `/buildmate:prd` - View full PRD
- `/buildmate:checkpoint` - Approval gate
