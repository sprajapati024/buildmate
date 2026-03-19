---
name: buildmate:pause
description: Pause all active Buildmate agents. They will stop working but maintain their state.
tools: Read, Write
---

# /buildmate:pause - Pause All Agents

Temporarily stop all active Buildmate agents.

## When to Use

- Need to review work before continuing
- Want to make manual changes without agent interference
- Running into API rate limits
- Need to think about direction

## What Happens

1. Reads `.buildmate/soul.json` to find active agents
2. Sets all agents to `status: "paused"`
3. Agents check their status and pause at next opportunity
4. State is preserved - work can resume later

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

<step name="pause_agents">
Update soul.json:
- Set all active agents to `status: "paused"`
- Set project status to `paused`
- Record pause timestamp
</step>

## Example

```
/buildmate:pause

Result:
⏸️ Agents Paused

Active agents before pause:
- Coder (implementing auth)
- Documenter (monitoring)

Status: PAUSED

Resume with: /buildmate:resume
```

## Resume Later

```
/buildmate:resume
```

Agents continue from where they left off.
