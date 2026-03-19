---
name: buildmate:sequential
description: Force sequential agent mode. Agents work one at a time in dependency order.
tools: Read, Write
---

# /buildmate:sequential - Force Sequential Mode

Force agents to work one at a time, completing dependencies before next agent starts.

## Usage

```
/buildmate:sequential
```

## When to Use

- Complex dependencies between phases
- Want strict control over execution order
- Debugging parallel issues
- Small project where parallel is overkill
- Prefer clarity over speed

## Execution Order

```
Researcher ──► Architect ──► Coder ──► Tester
     │             │           │          │
     └─────────────┴───────────┴──────────┘
                   │
                  PM updates PRD between each
```

## What Happens

1. Read `.buildmate/soul.json`
2. Set `parallel_mode: false`
3. Queue agents in dependency order
4. Next agent starts only when previous completes

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

<step name="disable_parallel">
Update soul.json:
```json
{
  "settings": {
    "parallel_mode": false,
    "execution_order": "sequential"
  }
}
```
</step>

<step name="confirm">
Report to user:
```
📋 SEQUENTIAL MODE ENABLED

Agents will work one at a time:
1. Researcher completes → PM updates PRD
2. Architect completes → PM updates PRD  
3. Coder completes → PM updates PRD
4. Tester verifies

No parallel work. Maximum clarity.

⏱️ May be slower for large projects.
💡 To enable parallel: /buildmate:parallel
```
</step>

## See Also

- `/buildmate:parallel` - Enable parallel mode
- `/buildmate:status` - See agent queue
