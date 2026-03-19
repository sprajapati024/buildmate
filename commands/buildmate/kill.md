---
name: buildmate:kill
description: Stop a specific Buildmate agent permanently. Useful when an agent is stuck or no longer needed.
tools: Read, Write
argument-hint: "<agent-name>"
---

# /buildmate:kill - Stop Specific Agent

Permanently stop a specific agent.

## Usage

```
/buildmate:kill <agent-name>

Examples:
/buildmate:kill coder
/buildmate:kill researcher
/buildmate:kill documenter
```

## When to Use

- Agent is stuck or unresponsive
- Agent's task is no longer needed
- Want to stop one agent but keep others running
- Agent is in an error loop

## What Happens

1. Finds agent in `.buildmate/soul.json`
2. Marks agent as `status: "killed"`
3. Agent stops at next check
4. Work from killed agent remains (not lost)

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

<step name="validate_agent">
Check if target agent exists in active agents list.

If not found:
```
❌ Agent not found: [name]

Active agents:
- [list active agents]

Use one of the above names, or check `/buildmate:status`
```
</step>

<step name="kill_agent">
Update soul.json:
- Move agent from `active` to `killed`
- Record kill timestamp and reason
- Preserve agent's completed work
</step>

## Example

```
/buildmate:status

Active agents:
- Coder ✅
- Documenter ✅
- Researcher 🔄 (stuck on external API)

/buildmate:kill researcher

Result:
🛑 Agent Killed: researcher

Researcher was stuck on external API call.
Work saved to RESEARCH.md (partial results)

Remaining active:
- Coder
- Documenter
```

## Warning

Killing an agent loses their **future** work but keeps what they already completed. To restart from scratch, use `/buildmate:init` with a fresh description.

## See Also

- `/buildmate:pause` - Pause all agents (can resume)
- `/buildmate:status` - See all agents
