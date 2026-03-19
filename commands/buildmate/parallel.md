---
name: buildmate:parallel
description: Enable parallel agent mode. Allows multiple agents to work simultaneously with PM coordination.
tools: Read, Write
---

# /buildmate:parallel - Enable Parallel Mode

Allow multiple agents to work simultaneously with PM coordination and zone assignment.

## Usage

```
/buildmate:parallel
```

## When to Use

- Project has multiple independent components
- Want faster completion through parallel work
- PM can coordinate non-conflicting zones
- Researcher and Architect can work on different aspects

## What Happens

1. Read `.buildmate/soul.json`
2. Set `parallel_mode: true`
3. PM activates zone assignment logic
4. Agents can start in parallel where safe

## Safe Parallel Patterns

**Always Safe:**
- Multiple researchers (different topics)
- Architect + Documenter (different files)

**PM Coordinated:**
- Multiple coders (assigned different zones)
- Max 2 coders at once

**Sequential Only:**
- Researcher → Architect (design needs research)
- Architect → Coder (code needs design)

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

<step name="enable_parallel">
Update soul.json:
```json
{
  "settings": {
    "parallel_mode": true,
    "max_parallel_coders": 2,
    "coordination": "pm_managed"
  }
}
```
</step>

<step name="notify_pm">
Signal PM to activate zone assignment:
```
PM: Parallel mode enabled. Assigning zones to prevent conflicts.
```
</step>

<step name="confirm">
Report to user:
```
⚡ PARALLEL MODE ENABLED

Agents can now work in parallel where safe:
✅ Researchers: Unlimited parallel
✅ Architect + Documenter: Parallel OK
🔄 Coders: PM assigns zones (max 2)

Current coordination:
- PM monitors for conflicts
- Zones assigned automatically
- Sequential where dependencies exist

💡 To disable: /buildmate:sequential
```
</step>

## Zone Assignment Example

```
PM assigns:
- Coder A: src/auth/ + tests/auth/
- Coder B: src/api/ + tests/api/

Result: Both code simultaneously, no conflicts
```

## See Also

- `/buildmate:sequential` - Force sequential mode
- `/buildmate:status` - See parallel agent activity
- `/buildmate:huddle` - Message all agents
