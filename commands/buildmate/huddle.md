---
name: buildmate:huddle
description: Broadcast a message to all active Buildmate agents.
tools: Read, Write
---

# /buildmate-huddle - Broadcast to All Agents

Send a message to all currently active Buildmate agents.

## Format

```
/buildmate-huddle "Your message here"
/buildmate-huddle Change of plans - use PostgreSQL instead of SQLite
```

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

<step name="parse_message">
Extract the message from the command.
</step>

<step name="broadcast">
Add message to soul.json:

```json
{
  "broadcasts": [
    {
      "from": "user",
      "message": "[extracted message]",
      "timestamp": "[now]",
      "read_by": []
    }
  ]
}
```
</step>

<step name="confirm">
Report to user:
```
📢 Broadcast sent to [N] active agents:

"[message]"

Agents will pick this up on their next cycle.
```
</step>

</steps>

## How Agents Receive It

Active agents (Researcher, Coder, etc.) check soul.json periodically.
When they see a new broadcast, they:
1. Read the message
2. Adjust their work if needed
3. Mark as "read" in soul.json
4. Report back to Orchestrator
