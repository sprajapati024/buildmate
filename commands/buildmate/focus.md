---
name: buildmate:focus
description: Focus mode - isolate to one agent for detailed interaction. Pause all other agents temporarily.
tools: Read, Write
argument-hint: "<agent-name>"
---

# /buildmate:focus - Focus on One Agent

Temporarily pause all agents except one, allowing detailed interaction with that specific agent.

## Usage

```
/buildmate:focus <agent-name>
/buildmate:focus coder
/buildmate:focus architect
```

## When to Use

- Need to give detailed instructions to one agent
- Want to debug a specific agent's work
- Prevent other agents from interrupting
- Deep dive on a specific component

## What Happens

1. Read `.buildmate/soul.json`
2. Mark all agents except target as `status: "paused_focus"`
3. Mark target agent as `status: "focused"`
4. Record previous state for restoration

## Steps

<step name="read_soul">
```bash
cat .buildmate/soul.json 2>/dev/null || echo "NO_SOUL"
```
</step>

<step name="validate_agent">
Check if target agent exists in active agents list.

If not found:
```
❌ Agent not found: [name]

Active agents:
- researcher
- coder

Use one of the above names.
```
</step>

<step name="enter_focus_mode">
Update soul.json:
- Set `focus_mode: true`
- Set `focused_agent: "[name]"`
- Save `previous_states` for all other agents
- Mark other agents as `paused_focus`
- Mark target as `focused`
</step>

<step name="confirm_focus">
Report to user:
```
🔍 FOCUS MODE ACTIVATED

Focusing on: [agent-name]
Task: [agent's current task]

⏸️ Paused agents:
- [agent1]
- [agent2]

📝 While focused:
- Only [agent-name] will respond
- Other agents are frozen
- Their state is preserved

💡 Exit focus: /buildmate:huddle "resume all"
   or: /buildmate:resume
```
</step>

## Exit Focus Mode

To resume all agents:
```
/buildmate:resume
```

Or broadcast to all:
```
/buildmate:huddle "everyone resume"
```

## See Also

- `/buildmate:huddle` - Broadcast to all agents
- `/buildmate:pause` - Pause all agents
- `/buildmate:resume` - Resume all agents
