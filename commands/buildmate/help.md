---
name: buildmate:help
description: Show all available Buildmate commands and how to use them.
tools: Read
---

# /buildmate:help - Show Available Commands

## Buildmate Commands

### Core Commands
| Command | Description |
|---------|-------------|
| `/buildmate:init "description"` | Start a new project or phase |
| `/buildmate:onboard` | Map existing codebase to Buildmate |
| `/buildmate:status` | Check agent status and progress |
| `/buildmate:help` | Show this help message |

### Communication
| Command | Description |
|---------|-------------|
| `/buildmate:huddle "message"` | Broadcast to all active agents |
| `/buildmate:pause` | Pause all active agents |
| `/buildmate:resume` | Resume paused agents |
| `/buildmate:kill <agent>` | Stop a specific agent |

### Development
| Command | Description |
|---------|-------------|
| `/buildmate:plan` | Create plan for next phase |
| `/buildmate:research "topic"` | Quick research on a topic |
| `/buildmate:test` | Run tests and check coverage |
| `/buildmate:debug` | Debug current issues |
| `/buildmate:review` | Review code quality |
| `/buildmate:commit` | Commit with documentation |

### Legacy GSD Commands
Buildmate also includes all GSD commands (prefixed with `/gsd:`):
- `/gsd:new-project` - GSD project initialization
- `/gsd:execute-phase` - Execute planned phase
- `/gsd:debug` - Debug with GSD tools
- And 30+ more...

## Quick Start

**New Project:**
```
/buildmate:init "Build a trading bot that monitors stocks"
```

**Existing Project:**
```
/buildmate:onboard
/buildmate:init "Add authentication"
```

**Check Progress:**
```
/buildmate:status
```

**Broadcast Change:**
```
/buildmate:huddle "Switch from SQLite to PostgreSQL"
```

## Steps

<step name="detect_context">
```bash
# Check if in a Buildmate project
if [ -f ".buildmate/soul.json" ]; then
  echo "IN_PROJECT"
  cat .buildmate/soul.json | jq '.project.name' 2>/dev/null
else
  echo "NO_PROJECT"
fi
```
</step>

<step name="display_help">
If IN_PROJECT:
```
📚 Buildmate Help

Active Project: [name]
Phase: [current phase]

Available Commands:
[context-aware command list]

Quick Actions:
/buildmate:status - Check agent progress
/buildmate:context - View full project state
/buildmate:huddle "msg" - Message all agents
```

If NO_PROJECT:
```
📚 Buildmate Help

No active project. Start with:
/buildmate:init "Description of what to build"

Or onboard existing project:
/buildmate:onboard
```
</step>

<step name="show_examples">
Display common workflows based on detected context.
</step>

## Tips

- Use quotes around descriptions with spaces
- Check `/buildmate:status` often to see agent progress
- Agents work in parallel - you can do other things while they work
- All documentation is auto-generated in your project folder
