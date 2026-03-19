---
name: buildmate:status
description: Check the status of all Buildmate agents and project progress.
tools: Read, Bash
---

# /buildmate-status - Check Agent Status

Read the `.buildmate/soul.json` and report current agent status to the user.

## Steps

<step name="read_soul">
```bash
cat .buildmate/soul.json 2>/dev/null || echo "NO_SOUL"
```
</step>

<step name="report_status">
If soul.json exists:

Parse and display:
```
📊 Buildmate Project Status

Project: [name from soul]
Born: [date]
Current Phase: [phase]

🤖 Active Agents:
[For each agent in agents.active]
- 🔄 [name]: [task] (started [time])

✅ Completed:
[For each agent in agents.completed]
- [name]: [task] → [result]

📁 Artifacts:
- RESEARCH.md [✅/❌]
- ARCHITECTURE.md [✅/❌]
- [other files]

💡 Next: /buildmate-huddle "your message" to broadcast
```

If no soul.json:
```
❌ No Buildmate project found.

Start one with: /buildmate "description of what to build"
```
</step>

</steps>
