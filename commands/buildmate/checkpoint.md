---
name: buildmate:checkpoint
description: Create a manual approval gate. Pauses all agents until user reviews and approves progress.
tools: Read, Write
argument-hint: "[checkpoint-name]"
---

# /buildmate:checkpoint - Manual Approval Gate

Create a checkpoint that pauses all agents until you review and approve.

## Usage

```
/buildmate:checkpoint
/buildmate:checkpoint "name"

Examples:
/buildmate:checkpoint
/buildmate:checkpoint "pre-deploy"
/buildmate:checkpoint "phase-1-complete"
```

## What Happens

1. All active agents pause
2. Checkpoint created in soul.json
3. You review current state
4. Approve → Agents resume
5. Reject → Changes needed

## Steps

<step name="verify_project">
```bash
# Check for Buildmate project
if [ ! -f ".buildmate/soul.json" ]; then
  echo "NO_SOUL"
  exit 0
fi

# Read current state
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

<step name="spawn_pm_checkpoint">
Spawn PM agent to manage checkpoint:

```
Task: buildmate-pm
Description: |
  User requested checkpoint: "[checkpoint-name]"
  
  Your task:
  1. Read .buildmate/soul.json for current state
  2. Pause all active agents (set status to paused_checkpoint)
  3. Create checkpoint entry in soul.json:
     - active: true
     - name: "[checkpoint-name]"
     - created: timestamp
     - agents_paused: [list of active agents]
     - requires_approval: true
  4. Present checkpoint review UI to user showing:
     - Current phase
     - Active agents and their status
     - Recent changes/files modified
     - Approval options (Approve / Request Changes / View Details)
  5. Wait for user decision
  6. If approved: clear checkpoint, resume agents
  7. If changes requested: record feedback, keep checkpoint active
```
</step>

<step name="prompt_user">
```
🚧 CHECKPOINT: [name]

All agents are paused pending your review.

═══════════════════════════════════════
📊 Current State
═══════════════════════════════════════
Phase: [current phase]
Active agents: [count]
Files changed: [count]

═══════════════════════════════════════
📁 Recent Changes
═══════════════════════════════════════
• [File 1] - [change description]
• [File 2] - [change description]

═══════════════════════════════════════
❓ Review & Approve
═══════════════════════════════════════

Options:
[✅ Approve] - Agents resume
[📝 Request Changes] - Provide feedback
[👀 View Details] - See full diff

Your decision?
```
</step>

<step name="handle_response">
If Approve:
- Clear checkpoint from soul.json
- Set agents to `active`
- Report: "✅ Checkpoint approved. Agents resuming."

If Request Changes:
- Keep checkpoint active
- Record feedback
- Signal agents to address feedback
- Report: "📝 Changes requested. Agents addressing feedback."
</step>

## Use Cases

- **Pre-deploy**: Review before pushing to production
- **Phase complete**: Review milestone before next phase
- **Critical changes**: Any major architectural change
- **External review**: Wait for stakeholder approval

## See Also

- `/buildmate:pause` - Pause without checkpoint
- `/buildmate:resume` - Resume from pause
- `/buildmate:status` - See current state
