# Buildmate

> **Make Claude Code safe to vibe with.**

---

## The Problem

Claude Code is powerful as hell. It can read your entire codebase, run terminal commands, write files, debug errors — basically pair program with you at the speed of light.

**But it's also kinda scary.**

You open it up and you're staring at a blank prompt with god-mode permissions. What do you even say? "Build me a thing"? Next thing you know, it's created 47 files, spun up Docker containers you didn't ask for, and committed "fix: final final fix" three times.

I learned this the hard way. I was using Claude Code at work to build Python projects — trading bots, automation scripts, internal tools. I'd describe what I wanted in a sentence, Claude would go off and build something... kind of related but not really what I meant. I'd spend 3 hours cleaning up scope creep, re-reading code I didn't ask for, and explaining "no, simpler than that."

**The chaos was real:**
- No structure to how projects started
- No guardrails on what got built  
- No way to course-correct without derailing everything
- No memory of decisions from one session to the next

I wanted to **vibe code** — describe what I need in plain English and have it just work — but I needed training wheels that didn't limit me.

## The Fix

**Buildmate is a project manager for Claude Code.**

Instead of talking directly to Claude, you talk to Buildmate. It interviews you for 2 minutes, locks the scope, then orchestrates a team of specialized agents to build exactly what you meant.

**The vibe:**
```
You: "Trading bot for Canadian stocks"
Buildmate: "Cool — paper or real money? What timeframe? Notifications?"
*5 minutes of clarifying questions later*
Buildmate: "Scope locked. Spawning team. Check status whenever."
```

No more blank page anxiety. No more "will it break my system" paranoia. No more decision fatigue.

You describe. Buildmate interviews. Scope locks. Team builds. You chill.

---

## What It Actually Is

Buildmate adds three layers on top of Claude Code:

### 1. Mandatory Interview
**Before any code gets written**, Buildmate asks clarifying questions. Who's using this? What's the real problem? Any tech preferences? Timeline?

Sounds annoying? It's 5 minutes that saves you 5 hours of "wait that's not what I meant."

### 2. Project Manager Agent
Once scope is locked, a PM agent watches everything. It maintains the PRD (Product Requirements Document), guards against scope creep, and makes sure the team isn't building random features you didn't ask for.

### 3. Trust Mode
Agents can write code, run tests, commit locally — but they **cannot** push to production, delete your repo, or run destructive commands without your approval.

You get speed without the fear.

---

## How It Works

### The Agent Team

Once your project starts, Buildmate spawns specialized agents:

| Agent | What They Do |
|-------|--------------|
| **Orchestrator** | Your main point of contact. Clarifies intent, routes requests. |
| **Project Manager** | Guards scope, maintains PRD, tracks decisions. |
| **Researcher** | Finds APIs, compares options, evaluates tech. |
| **Architect** | Designs system structure per the PRD. |
| **Coder** | Implements features. Can commit, cannot push/deploy. |
| **Tester** | Verifies against PRD requirements. |
| **Documenter** | Maintains docs, keeps everything in sync. |

### The Workflow

```
You ──► ORCHESTRATOR (interviews you, locks scope)
           │
           ├──► PROJECT MANAGER ──► Guards PRD, tracks decisions
           │
           ├──► RESEARCHER ──► "Found 3 APIs, here's comparison"
           │
           ├──► ARCHITECT ──► "Designed system per PRD"
           │
           ├──► CODER ──► "Implemented, tested, committed"
           │
           ├──► TESTER ──► "Verified against PRD requirements"
           │
           └──► DOCUMENTER ──► "Docs synced with code"
```

**You set the goal. The team asks questions. The PM locks scope. Then agents execute.**

---

## Quick Start

### Install

```bash
npx github:sprajapati024/buildmate --global --claude
```

Or clone and install manually:
```bash
git clone https://github.com/sprajapati024/buildmate.git
cd buildmate
node bin/install.js --global --claude
```

### Your First Project

```bash
# 1. Start a project (triggers interview)
/buildmate init "Trading bot for Canadian stocks"

# 2. Answer the interview questions (takes ~2 minutes)
# 3. Let the team work

# 4. Check progress anytime
/buildmate status

# 5. Course-correct if needed
/buildmate huddle "Use AlphaVantage API, free tier"
```

That's it. You're vibing.

---

## Common Workflows

### Starting From Scratch

```bash
/buildmate init "CLI tool that converts CSV to JSON"

# Interview will ask:
# - What problem does this solve?
# - Who will use it?
# - Any tech preferences?
# - Timeline?

# After scope lock:
/buildmate status        # See what agents are doing
/buildmate context       # View full project state
/buildmate prd          # View the Product Requirements Document
```

### Working On Existing Code

```bash
/buildmate onboard       # Adopt an existing codebase
/buildmate research "best auth libraries for this stack"
/buildmate plan "add user authentication"
```

### Daily Development

```bash
/buildmate status        # Quick health check
/buildmate huddle "switch to PostgreSQL instead of SQLite"
/buildmate focus coder   # Work directly with coder agent
/buildmate review        # Get code review
/buildmate checkpoint "before big refactor"  # Save point
```

---

## All Commands

### Project Lifecycle
| Command | What It Does |
|---------|--------------|
| `/buildmate init` | Start project with mandatory interview |
| `/buildmate onboard` | Adopt existing codebase |
| `/buildmate status` | Peek into agent activity |
| `/buildmate resume` | Continue from saved state |
| `/buildmate pause` | Freeze all agents |
| `/buildmate stop` | Kill all agents, save state |

### Team Communication
| Command | What It Does |
|---------|--------------|
| `/buildmate huddle "msg"` | Broadcast to all active agents |
| `/buildmate focus [agent]` | Isolate to one agent |
| `/buildmate parallel` | Enable parallel agent mode |
| `/buildmate sequential` | Force sequential mode |

### Context & Memory
| Command | What It Does |
|---------|-------------|
| `/buildmate context` | Show current project state |
| `/buildmate why [decision]` | Explain past decisions |
| `/buildmate remember "[fact]"` | Teach Buildmate |
| `/buildmate learn` | Extract skill from project |

### Quick Actions
| Command | What It Does |
|---------|-------------|
| `/buildmate research "[topic]"` | Spawn researcher only |
| `/buildmate plan "[feature]"` | Spawn architect only |
| `/buildmate review` | Code review |
| `/buildmate test` | Run tests |
| `/buildmate debug` | Debug mode |
| `/buildmate commit` | Smart commit |

### PM & Governance
| Command | What It Does |
|---------|-------------|
| `/buildmate prd` | View current PRD |
| `/buildmate prd update` | Trigger PM to update PRD |
| `/buildmate scope` | View scope boundaries |
| `/buildmate checkpoint` | Manual approval gate |

### Sync & Deploy
| Command | What It Does |
|---------|-------------|
| `/buildmate sync` | Git sync |
| `/buildmate deploy` | Deploy to VPS |

---

## Project Structure

Buildmate organizes projects like this:

```
my-project/
├── .buildmate/
│   ├── soul.json          # Project state & active agents
│   ├── decisions.json     # Why we chose X over Y
│   └── sessions/          # Agent conversation logs
├── PRD.md                 # Living document (PM maintains)
├── ARCHITECTURE.md        # System design
├── RESEARCH.md            # Tech evaluation
├── CHANGELOG.md           # Auto-updated
└── [your code]
```

Global memory lives in `~/.claude/buildmate-global/`:
```
buildmate-global/
├── user-profile.json      # Your preferences
├── skill-library/         # Learned skills from past projects
├── patterns.json          # What worked
└── permissions.json       # Global tool permissions
```

---

## Troubleshooting

### "Agents seem stuck"
```bash
/buildmate status          # See what's blocking
/buildmate focus coder     # Isolate to one agent
/buildmate huddle "status update?"  # Ping the team
```

### "Scope is creeping"
```bash
/buildmate scope           # View current boundaries
/buildmate prd            # Check the PRD
/buildmate checkpoint "before scope change"  # Save first
```

### "I want to make manual changes"
```bash
/buildmate pause          # Freeze all agents
# Make your changes
/buildmate resume         # Agents adapt to new state
```

### "Something broke"
```bash
/buildmate resume         # Resume from last checkpoint
# Or check sessions:
ls .buildmate/sessions/   # Review agent conversations
```

### "I don't like the direction"
```bash
/buildmate huddle "pivot: we're building an API not a CLI"
/buildmate prd update     # PM will update requirements
```

### "It's too chaotic"
```bash
/buildmate sequential     # Force sequential execution
# Or focus on one agent at a time:
/buildmate focus architect
```

---

## Configuration

### Trust Mode Levels

**Standard (default):**
- ✅ Read/write files in assigned zones
- ✅ Run tests
- ✅ Git commit (local)
- ✅ Research
- 🔒 Git push, deploy, destructive bash

**Strict:**
- 🔒 Everything requires approval

**Permissive:**
- ⚠️ Auto-approves more (use with caution)

Set in your project config or per-command.

### Execution Mode

**Sequential (default):** Agents work one after another. Clear, predictable, slower.

**Parallel:** Multiple agents work simultaneously where safe. Faster, requires more monitoring.

```bash
/buildmate parallel       # Enable parallel mode
/buildmate sequential     # Back to sequential
```

---

## Why This Approach

I built Buildmate after months of chaotic Claude Code sessions. The lessons:

1. **AI agents are dumb without context.** A 2-minute interview saves hours of rework.

2. **Someone needs to guard scope.** Without a PM, agents build cool stuff that's not what you asked for.

3. **Speed needs safety rails.** Trust mode lets you vibe without fear of production disasters.

4. **Projects need memory.** The PRD, decisions log, and checkpoints mean you can pause and resume without losing context.

---

## Contributing

This is a personal tool that solved my problem. If it helps you too, rad.

Issues and PRs welcome. The codebase is structured to make adding new agent types straightforward.

---

## License

MIT — use it, fork it, make it yours.

---

**Built because I wanted to vibe code without the chaos.**

*— S*
