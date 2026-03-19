---
name: buildmate:resume
description: Resume all paused Buildmate agents. They continue from where they left off.
tools: Read, Write
---

# /buildmate:resume - Resume All Agents

Continue work with all paused Buildmate agents.

## When to Use

- After `/buildmate:pause` when you're ready to continue
- Agents were paused for review and you're satisfied
- Ready to proceed after making manual changes

## What Happens

1. Reads `.buildmate/soul.json` to find paused agents
2. Sets all agents to `status: "active"`
3. Agents resume their tasks

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

<step name="resume_agents">
Update soul.json:
- Set all paused agents to `status: "active"`
- Set project status to `active`
- Clear any checkpoint state
</step>

## Example

```
/buildmate:resume

Result:
▶️ Agents Resumed

Now active:
- Coder (continuing auth implementation)
- Documenter (monitoring changes)

Check status: /buildmate:status
```

## Related Commands

- `/buildmate:pause` - Pause agents
- `/buildmate:status` - Check current status
- `/buildmate:kill <agent>` - Stop specific agent permanently
