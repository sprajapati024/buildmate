# Buildmate V2: System Architecture

**Date:** March 18, 2026  
**Version:** 2.0  
**Status:** Implementation Ready

---

## Executive Summary

Buildmate V2 is a multi-agent project development system that runs inside Claude Code. It introduces mandatory scope definition, parallel agent coordination via a Project Manager, and trust-based execution.

**Key Innovation:** No agent works until scope is crystal clear. The PM agent guards the PRD as a living document.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER LAYER                               │
│     (Voice, Telegram, Web UI, CLI - all interface to Claude)     │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                    ORCHESTRATOR AGENT                            │
│                                                                  │
│  • Parses user intent                                            │
│  • Runs mandatory interview (NO WORK WITHOUT SCOPE)              │
│  • Spawns PM first                                               │
│  • Monitors via /buildmate status                                │
│  • Intervenes on conflicts                                       │
└──────┬──────────────────────┬────────────────┬───────────────────┘
       │                      │                │
       ▼                      ▼                ▼
┌─────────────┐      ┌─────────────┐   ┌─────────────────┐
│    SOLO     │      │    TEAM     │   │   GLOBAL        │
│    MODE     │      │    MODE     │   │   MEMORY        │
│             │      │             │   │                 │
│ Single agent│      │ PM + Team   │   │ ~/.buildmate/   │
│ handles all │      │ Researcher  │   │                 │
│             │      │ Architect   │   │ • User profile  │
│ Fast, simple│      │ Coder       │   │ • Skill library │
│             │      │ Tester      │   │ • Patterns      │
│             │      │ Documenter  │   │ • Permissions   │
└─────────────┘      │             │   └─────────────────┘
                     │ Parallel    │            ▲
                     │ coordinated │            │ Sync
                     └──────┬──────┘            │ bidirectional
                            │                   │
              ┌─────────────┴─────────────┐     │
              ▼                           ▼     │
    ┌──────────────────┐      ┌──────────────────┐
    │   SHARED CANVAS  │      │  PROJECT LOCAL   │
    │   (Real-time)    │      │  (.buildmate/)   │
    │                  │      │                  │
    │ • soul.json      │◄────►│ • soul.json      │
    │ • PRD.md         │      │ • PRD.md         │
    │ • DECISIONS.md   │      │ • DECISIONS.md   │
    │ • Active agents  │      │ • Session logs   │
    └──────────────────┘      └──────────────────┘
```

---

## Core Principles

### 1. No Work Without Scope
**Rule:** Agents cannot start until:
- PRD exists and is approved
- Task is clearly defined in scope
- Dependencies are complete
- Write zone is assigned (for parallel)

### 2. PRD as Living Document
**Rule:** The PRD is not static. The PM updates it continuously as:
- Decisions are made
- Scope changes (with approval)
- New information discovered

### 3. Trust Mode Execution
**Rule:** 
- **Auto-approve:** Read/write in zone, tests, commits
- **Always ask:** Push, deploy, destructive ops, scope changes

### 4. Parallel Coordination
**Rule:** PM assigns zones, tracks dependencies, prevents conflicts

### 5. Global Learning
**Rule:** Patterns learned in one project become skills for future projects

---

## The Agent Team (6 Agents)

### 1. Orchestrator
**Role:** Entry point, scope clarification, team spawner

**When Active:** Always first, then monitors

**Key Behaviors:**
- Runs interview phase (mandatory)
- Spawns PM after scope confirmation
- Spawns team members
- Monitors via status checks
- Intervenes on escalation

**Tools:** All (spawns other agents via Task)

### 2. Project Manager (PM) - NEW in V2
**Role:** Governance, documentation, scope guardian

**When Active:** Throughout entire project

**Key Behaviors:**
- Creates and maintains PRD
- Logs all decisions
- Blocks agents with unclear scope
- Assigns zones for parallel coding
- Updates docs in real-time

**Cannot:** Write code, make technical decisions

**Tools:** Read, Write, Edit (docs only)

### 3. Researcher
**Role:** Evaluate options, find best practices

**When Active:** Phase 1 (after scope locked)

**Key Behaviors:**
- Research APIs, libraries, patterns
- Compare alternatives
- Write RESEARCH.md
- Hand off to Architect

**Cannot:** Write implementation code

**Tools:** Read, WebSearch, WebFetch, Write (research docs)

### 4. Architect
**Role:** Design system structure

**When Active:** Phase 2 (after research)

**Key Behaviors:**
- Design data models
- Plan API contracts
- Define folder structure
- Write ARCHITECTURE.md
- Get approval before Coder starts

**Cannot:** Write implementation (design only)

**Tools:** Read, Write, Edit (design docs)

### 5. Coder
**Role:** Implement features

**When Active:** Phase 3 (after architecture approved)

**Key Behaviors:**
- Write code per ARCHITECTURE.md
- Make atomic commits
- Run tests
- Ask on: push, destructive ops, scope deviation

**Trust Mode:** Can commit locally, cannot push/deploy

**Tools:** Read, Write, Edit, Bash (in assigned zone)

### 6. Tester
**Role:** Verify against PRD

**When Active:** After Coder completes

**Key Behaviors:**
- Test against PRD requirements
- Report gaps to PM
- Write TEST_REPORT.md
- Do not fix - report only

**Tools:** Read, Bash (tests), Write (reports)

### 7. Documenter
**Role:** Maintain documentation

**When Active:** Continuously

**Key Behaviors:**
- Watch all agent activity
- Update README, CHANGELOG, API docs
- Keep .env.example current

**Tools:** Read, Write, Edit (docs)

---

## Communication Patterns

### Pattern A: Sequential (Dependencies)
```
Researcher ──► Architect ──► Coder ──► Tester
     │             │           │          │
     └─────────────┴───────────┴──────────┘
                   │
                  PM (updates PRD between each)
```

**Use when:** Each phase depends on previous output

### Pattern B: Parallel (Independent)
```
Researcher ──┐
             ├─► PM coordinates
Architect ───┘
```

**Use when:** Tasks don't conflict (research different topics)

### Pattern C: Parallel Coding (Zone-based)
```
         ┌─► Coder A (src/auth/) ──┐
PM assigns│                         ├─► Integration
         └─► Coder B (src/api/) ───┘
```

**Use when:** Large codebase, PM assigns non-overlapping zones

---

## The Interview System (Phase 0)

### Step 1: Initial Prompt
```
What are we building? 
(Describe in plain English)
```

### Step 2: Follow-up Questions (Claude Question Tool)
- Who is this for?
- What problem does it solve?
- Tech preferences?
- Timeline?
- Complexity?

### Step 3: Clarifying Loop
Keep asking until scope is unambiguous

### Step 4: Scope Confirmation
```
📋 PROJECT SCOPE CONFIRMED

Name: [name]
Type: [type]
Purpose: [description]
Scope: [boundaries]

[Yes] [Modify] [Cancel]
```

**NO AGENTS SPAWN until Yes is selected.**

### Step 5: PRD Generation
PM creates initial PRD, user approves

### Step 6: Team Spawn
Orchestrator spawns team based on project type

---

## State Management

### Project-Level (.buildmate/soul.json)
```json
{
  "version": "2.0",
  "project": {
    "name": "trading-bot",
    "status": "active",
    "phase": "coding",
    "scope_locked": true,
    "started_at": "2026-03-18T14:00:00Z"
  },
  "pm": {
    "prd_version": "1.3",
    "last_updated": "2026-03-18T15:30:00Z",
    "open_questions": []
  },
  "agents": {
    "active": [
      {
        "name": "coder",
        "task": "Implement auth module",
        "status": "working",
        "zone": "src/auth/",
        "started": "2026-03-18T15:00:00Z"
      }
    ],
    "completed": [
      {
        "name": "researcher",
        "task": "Find APIs",
        "completed_at": "2026-03-18T14:00:00Z"
      }
    ]
  },
  "scope": {
    "locked": true,
    "boundaries": [
      "Paper trading only (no real money)",
      "Telegram notifications only",
      "Single user"
    ],
    "change_log": [
      {
        "date": "2026-03-18T14:30:00Z",
        "change": "Added caching",
        "approved_by": "user"
      }
    ]
  }
}
```

### Global-Level (~/.buildmate-global/)
```
buildmate-global/
├── user-profile.json       # Preferences learned
├── skill-library/          # Extracted skills
│   ├── python-cli/
│   │   ├── SKILL.md
│   │   └── patterns.json
│   └── trading-bot/
├── patterns.json           # Cross-project patterns
└── permissions.json        # Global tool permissions
```

---

## Trust Mode Permissions

### Auto-Approve (No Ask)
- Read any file
- Write/edit in assigned zone
- Run tests
- Git commit (local only)
- Research/search
- Write documentation

### Always Ask
- Git push
- Git force-push
- rm -rf or destructive bash
- Deploy to production
- API calls with real money
- Change PRD scope
- Add new dependencies
- Access outside project directory

### Configuration
```json
{
  "trust_mode": {
    "level": "high",
    "auto_approve": ["read", "write", "edit", "bash:test*"],
    "always_ask": ["git:push", "deploy:*", "financial:*"],
    "budget_limit": "$10/day"
  }
}
```

---

## Command Structure (25+ Commands)

### Tier 1: Project Lifecycle
- `/buildmate init` - Start with mandatory interview
- `/buildmate onboard` - Adopt existing codebase
- `/buildmate status` - Peek into agent activity
- `/buildmate resume` - Continue from saved state
- `/buildmate pause` - Freeze agents
- `/buildmate stop` - Kill agents

### Tier 2: Team Communication
- `/buildmate huddle` - Broadcast message
- `/buildmate focus` - Isolate to one agent
- `/buildmate parallel` - Enable parallel mode
- `/buildmate sequential` - Force sequential

### Tier 3: Context & Memory
- `/buildmate context` - Show project state
- `/buildmate why` - Explain decisions
- `/buildmate remember` - Teach Buildmate
- `/buildmate forget` - Remove from memory
- `/buildmate learn` - Extract skill

### Tier 4: Quick Actions
- `/buildmate research` - Research only
- `/buildmate plan` - Architect only
- `/buildmate review` - Code review
- `/buildmate test` - Run tests
- `/buildmate debug` - Debug mode
- `/buildmate commit` - Smart commit
- `/buildmate docs` - Update docs

### Tier 5: PM & Governance
- `/buildmate prd` - View PRD
- `/buildmate prd update` - Update PRD
- `/buildmate scope` - View boundaries
- `/buildmate checkpoint` - Approval gate

### Tier 6: Sync & Deploy
- `/buildmate sync` - Git sync
- `/buildmate deploy` - Deploy

---

## Edge Case Handling

### Agent Conflict
```
Researcher: "Use PostgreSQL"
Architect:  "Use SQLite"

PM detects conflict → Escalate to user
User picks one → PM logs decision → Unblock
```

### Infinite Loop
```
Coder fixes → Tester finds bug → Coder fixes → ...

PM detects (iteration count) → Escalate after 10 cycles
```

### Scope Creep
```
Coder: "I'll add caching"
PM: "Caching not in PRD. Block. Escalate to user."
```

### Stuck Agent
```
No update in 15 minutes
PM marks as stuck → Escalate → Respawn or ask user
```

---

## Comparison with Other Systems

| Feature | OpenClaw | OpenCode | Buildmate V2 |
|---------|----------|----------|--------------|
| Multi-agent | ✅ | ✅ | ✅ |
| Mandatory scope | ❌ | ❌ | ✅ |
| PM agent | ❌ | ❌ | ✅ |
| Parallel coord | ✅ | ✅ | ✅ |
| Trust mode | ❌ | ✅ | ✅ |
| Global learning | ❌ | ❌ | ✅ |
| 25+ commands | ❌ | ❌ | ✅ |
| Hard cut legacy | N/A | N/A | ✅ |

---

## Implementation Phases

### Phase 1: Foundation
- [ ] Remove GSD commands (hard cut)
- [ ] Create PM agent definition
- [ ] Update all agent prompts for scope rules
- [ ] Create 25+ command files

### Phase 2: Core Features
- [ ] Implement interview system
- [ ] Build trust mode system
- [ ] Create PM coordination logic
- [ ] Implement status command

### Phase 3: Advanced
- [ ] Parallel execution
- [ ] Zone assignment
- [ ] Global learning layer
- [ ] Skill extraction

---

## Success Criteria

Buildmate V2 succeeds when:

1. ✅ No agent works without clear scope
2. ✅ PRD is always up-to-date
3. ✅ User can peek anytime via `/buildmate status`
4. ✅ Scope creep is caught and escalated
5. ✅ Parallel agents don't conflict
6. ✅ Trust mode prevents accidents
7. ✅ Cross-project learning improves over time
8. ✅ All 25+ commands work reliably

---

**Document Status:** LOCKED  
**Changes Require:** Explicit approval
