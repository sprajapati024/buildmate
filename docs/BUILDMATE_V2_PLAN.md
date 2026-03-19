# Buildmate V2: System Architecture Plan

**Status:** LOCKED SCOPE  
**Date:** March 18, 2026  
**Version:** 2.0  

---

## Philosophy

> "Agents are DUMB without context. They MUST ask questions until they understand. NO WORK happens until scope is crystal clear."

---

## 1. Command Structure (Full Featured - 25+ commands)

### Tier 1: Project Lifecycle
| Command | Description |
|---------|-------------|
| `/buildmate` or `/buildmate init` | Start with mandatory interview phase |
| `/buildmate onboard` | Adopt existing codebase with discovery phase |
| `/buildmate status` | Peek into agent activity |
| `/buildmate resume` | Continue from saved state |
| `/buildmate pause` | Freeze all agents |
| `/buildmate stop` | Kill all agents, save state |

### Tier 2: Team Communication
| Command | Description |
|---------|-------------|
| `/buildmate huddle "msg"` | Broadcast to active agents |
| `/buildmate focus [agent]` | Isolate to one agent |
| `/buildmate parallel` | Enable parallel agent mode |
| `/buildmate sequential` | Force sequential mode |

### Tier 3: Context & Memory
| Command | Description |
|---------|-------------|
| `/buildmate context` | Show current project state |
| `/buildmate why [decision]` | Explain past decisions |
| `/buildmate remember "[fact]"` | Teach Buildmate |
| `/buildmate forget "[fact]"` | Remove from memory |
| `/buildmate learn` | Extract skill from current project |

### Tier 4: Quick Actions
| Command | Description |
|---------|-------------|
| `/buildmate research "[topic]"` | Spawn researcher only |
| `/buildmate plan "[feature]"` | Spawn architect only |
| `/buildmate review` | Code review |
| `/buildmate test` | Run tests |
| `/buildmate debug` | Debug mode |
| `/buildmate commit` | Smart commit |
| `/buildmate docs` | Update documentation |

### Tier 5: PM & Governance
| Command | Description |
|---------|-------------|
| `/buildmate prd` | View current PRD |
| `/buildmate prd update` | Trigger PM to update PRD |
| `/buildmate scope` | View current scope boundaries |
| `/buildmate checkpoint` | Manual approval gate |

### Tier 6: Sync & Deploy
| Command | Description |
|---------|-------------|
| `/buildmate sync` | Git sync |
| `/buildmate deploy` | Deploy to VPS |

---

## 2. The Interview System (NO WORK WITHOUT SCOPE)

### Phase 0: Context Gathering (MANDATORY)

**Step 1: Initial Prompt**
```
What are we building? 
(Describe in plain English - don't worry about technical details)
```

**Step 2: Orchestrator asks follow-ups using Claude's question tool**
- Who is this for?
- What's the main problem it solves?
- Any tech preferences?
- Timeline?
- Complexity level?

**Step 3: Clarifying questions until scope is clear**

**Step 4: Scope Confirmation**
- Show summary
- Get explicit "Yes"
- NO AGENTS SPAWN until confirmed

**Step 5: PRD Generation**
- PM creates initial PRD.md
- User reviews and approves

**Step 6: Only THEN spawn team**

---

## 3. The Agent Team (5 + PM)

### AGENT 1: Project Manager (PM) - NEW!
**Role:** Governance, documentation, scope enforcement

**Responsibilities:**
- Maintain PRD.md as living document
- Track all decisions in DECISIONS.md
- Monitor scope: "Are we building what's in the PRD?"
- BLOCK other agents if scope unclear
- Update PRD when decisions are made

**Cannot:**
- Write code
- Make technical decisions
- Change scope without user approval

### AGENT 2: Researcher
**Rule #1:** Cannot start until PM confirms scope is clear
**Rule #2:** If scope ambiguous, MUST ask questions, not guess
**Rule #3:** Only research - no code, no decisions

### AGENT 3: Architect
**Rule #1:** Cannot design until Researcher completes AND PM confirms scope
**Rule #2:** Design MUST fit within PRD scope
**Rule #3:** If PRD conflicts with best practices, escalate to PM

### AGENT 4: Coder
**Rule #1:** Cannot code until PRD and ARCHITECTURE.md are approved
**Rule #2:** Implement EXACTLY what's in ARCHITECTURE.md
**Rule #3:** If issues found, escalate - don't improvise

**Trust Mode Permissions:**
- CAN commit without asking
- CANNOT: git push, rm -rf, destructive ops (always ask)

### AGENT 5: Tester
**Role:** Test what Coder built against PRD requirements
- Report gaps
- Don't fix - report to PM

### AGENT 6: Documenter
**Role:** Keep docs in sync with code
- README.md
- CHANGELOG.md
- API docs
- .env.example

---

## 4. Parallel Execution (Without Overstepping)

### Safe Parallel Patterns

**Pattern A: Research + Analysis (Safe)**
- Both read PRD, write to different files
- No conflict

**Pattern B: Multiple Coders (Needs coordination)**
- PM assigns different files/folders
- PM ensures no overlap

**Pattern C: Sequential (Dependencies)**
- Researcher → Architect → Coder
- PM updates PRD between each

### PM Coordination
```json
{
  "active_agents": [
    {"name": "researcher", "task": "Find APIs", "status": "working"},
    {"name": "architect", "task": "Design DB", "status": "blocked", "reason": "Waiting for researcher"}
  ],
  "parallel_mode": true,
  "coordination_rules": [
    "Researchers can work in parallel",
    "Architects need research complete",
    "Coders need architecture approved",
    "Max 2 coders at once, PM assigns zones"
  ]
}
```

---

## 5. The Soul System (State Management)

### Project-Level (.buildmate/soul.json)
```json
{
  "version": "2.0",
  "project": {
    "name": "trading-bot",
    "status": "active",
    "phase": "coding",
    "scope_locked": true
  },
  "pm": {
    "prd_version": "1.3",
    "last_updated": "2026-03-18T15:30:00Z",
    "open_questions": []
  },
  "agents": {
    "active": [...],
    "completed": [...]
  },
  "scope": {
    "locked": true,
    "boundaries": [...],
    "change_log": [...]
  }
}
```

### Global-Level (~/.claude/buildmate-global/)
```
buildmate-global/
├── user-profile.json       # Your preferences
├── skill-library/          # Learned skills
├── patterns.json           # What worked
└── permissions.json        # Global tool permissions
```

---

## 6. No-Work-Without-Scope Enforcement

### Agent Startup Checklist (Auto-run)

Before ANY agent does work, they MUST verify:

- [ ] Does PRD.md exist?
- [ ] Is PRD approved by user?
- [ ] Is my task defined in scope?
- [ ] Are dependencies complete?
- [ ] Do I have write permissions for my zone?

**ALL CHECKS PASSED → Proceed with work**

---

## 7. Summarized View + Peek

### What User Normally Sees
```
/buildmate init "Trading bot"

Buildmate: Starting Project Initialization
[Interview phase... 5 questions]

Scope confirmed. Spawning team...

[PM] Created PRD.md
[Researcher] Finding APIs...
[Architect] Waiting for research...

Type '/buildmate status' to peek details.
```

### What /buildmate status Shows
- Project phase
- Active agents table
- Recent activity
- Blockers
- Next action required

---

## 8. Trust Mode Implementation

### Auto-Approve (No Ask)
- Read files
- Write/edit files in their zone
- Run tests
- Git commit (local)
- Research/search

### Always Ask
- Git push
- Git force-push
- rm -rf, destructive bash
- Deploy to production
- API calls with real money
- Changing PRD scope
- Adding new dependencies

---

## 9. Skill Creation (Hybrid Mode)

### After Project Completes
1. PM analyzes project for novel patterns
2. Suggests to user: "Create skill 'X'? [Yes / No / Modify]"
3. If yes: Extracts patterns, creates skill
4. Next project: "Found skill 'X', use it?"

---

## 10. GSD Hard Cut

### Delete All GSD Commands
```bash
rm -rf ~/.claude/commands/gsd/
rm -rf ~/.claude/agents/gsd-*.md
```

### Migration Guide
| Old (GSD) | New (Buildmate) |
|-----------|-----------------|
| `/gsd:new-project` | `/buildmate init` |
| `/gsd:research-phase` | `/buildmate research` |
| `/gsd:execute-phase` | `/buildmate resume` |
| `/gsd:health` | `/buildmate status` |

---

## Architecture Comparison

| Feature | OpenClaw | OpenCode | Buildmate V2 |
|---------|----------|----------|--------------|
| Cross-project learning | ❌ | ❌ | ✅ |
| Self-evolving skills | ❌ | ❌ | ✅ |
| PM Agent | ❌ | ❌ | ✅ |
| Mandatory scope lock | ❌ | ❌ | ✅ |
| Parallel coordination | ✅ | ✅ | ✅ |
| Trust mode | ❌ | ✅ | ✅ |
| 25+ commands | ❌ | ❌ | ✅ |

---

## Next Steps

1. ✅ LOCK SCOPE (this document)
2. 🔄 Create V2 command files
3. 🔄 Create 6 agent definitions
4. 🔄 Update README for V2
5. 🔄 Remove GSD commands
6. 🔄 Test all commands
7. 🔄 Commit and push

---

**This document is LOCKED. Any changes require explicit approval.**
