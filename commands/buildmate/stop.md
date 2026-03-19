---
name: buildmate:stop
description: Stop all Buildmate agents and save current state. Graceful shutdown of the entire team.
tools: Read, Write
---

# /buildmate:stop - Stop All Agents

Gracefully stop all Buildmate agents and save current state.

## Usage

```
/buildmate:stop
```

## Difference from Kill

| Command | Action |
|---------|--------|
| `/buildmate:stop` | Stop ALL agents, save state, graceful |
| `/buildmate:kill <agent>` | Stop ONE specific agent |

## What Happens

1. Signal all active agents to stop
2. Save current progress
3. Mark agents as `stopped` in soul.json
4. Preserve state for `/buildmate:resume`

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

<step name="stop_all">
Update soul.json:
```json
{
  "project": {
    "status": "stopped"
  },
  "agents": {
    "active": [],
    "stopped": [
      {"name": "researcher", "saved_state": "..."},
      {"name": "coder", "saved_state": "..."}
    ]
  }
}
```
</step>

<step name="confirm">
```
🛑 ALL AGENTS STOPPED

Active agents have been gracefully stopped:
✅ Progress saved
✅ State preserved
✅ Can resume with /buildmate:resume

Stopped agents:
• [Agent 1] - [last task]
• [Agent 2] - [last task]

To resume later:
/buildmate:resume
```
</step>

## Resume Later

```
/buildmate:resume
```

Restores all agents to their previous state.

## See Also

- `/buildmate:kill` - Stop specific agent
- `/buildmate:pause` - Pause (not stop) all agents
- `/buildmate:resume` - Resume from stop/pause
