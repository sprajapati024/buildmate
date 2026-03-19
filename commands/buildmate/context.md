---
name: buildmate:context
description: Show full current project state including PRD summary, active agents, recent decisions, and open questions.
tools: Read, Bash
---

# /buildmate:context - Show Project Context

Display comprehensive project state - PRD summary, agents, decisions, and what's happening now.

## Usage

```
/buildmate:context
```

## What Shows

1. Project overview from PRD
2. Current phase and scope status
3. Active agents and their tasks
4. Recent decisions from DECISIONS.md
5. Open questions blocking progress
6. File artifacts (RESEARCH.md, ARCHITECTURE.md, etc.)

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

<step name="read_project_state">
```bash
# Check for key files
ls -la PRD.md RESEARCH.md ARCHITECTURE.md DECISIONS.md 2>/dev/null
```
</step>

<step name="display_context">
If project exists:
```
📋 PROJECT CONTEXT

═══════════════════════════════════════
📄 PRD Summary
═══════════════════════════════════════
Name: [project name]
Purpose: [one-liner from PRD]
Phase: [current phase]
Scope: [✅ Locked / 🔄 In Progress]

═══════════════════════════════════════
🤖 Agent Status
═══════════════════════════════════════
Active:
┌─────────────┬────────────────────┬──────────┐
│ Agent       │ Task               │ Status   │
├─────────────┼────────────────────┼──────────┤
│ [name]      │ [task]             │ [status] │
└─────────────┴────────────────────┴──────────┘

═══════════════════════════════════════
📊 Artifacts
═══════════════════════════════════════
✅ PRD.md
🔄 RESEARCH.md (in progress)
⏳ ARCHITECTURE.md (waiting)
⏳ CHANGELOG.md (waiting)

═══════════════════════════════════════
💡 Recent Decisions
═══════════════════════════════════════
• [timestamp]: [decision summary]
• [timestamp]: [decision summary]

═══════════════════════════════════════
❓ Open Questions
═══════════════════════════════════════
• [question 1]
• [question 2]

═══════════════════════════════════════
🎯 Next Actions
═══════════════════════════════════════
1. [action 1]
2. [action 2]
```
</step>

## See Also

- `/buildmate:status` - Quick agent status
- `/buildmate:why` - Specific decision rationale
- `/buildmate:prd` - View full PRD
