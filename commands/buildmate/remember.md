---
name: buildmate:remember
description: Teach Buildmate a fact or preference to remember across sessions. Saves to global memory.
tools: Read, Write
argument-hint: "[fact to remember]"
---

# /buildmate:remember - Teach Buildmate

Save a fact or preference to Buildmate's global memory for future projects.

## Usage

```
/buildmate:remember "[fact]"

Examples:
/buildmate:remember "I prefer PostgreSQL over MySQL"
/buildmate:remember "Always use TypeScript for new projects"
/buildmate:remember "My VPS is at 192.168.1.100"
/buildmate:remember "Prefer open source over paid APIs"
```

## Where Stored

`~/.buildmate-global/user-profile.json`

## Categories

Facts are auto-categorized:
- **tech_prefs**: Technology preferences (React > Vue, etc.)
- **workflows**: How you like to work (test-first, etc.)
- **infra**: Infrastructure details (VPS, domains, etc.)
- **constraints**: Hard constraints (FOSS only, etc.)
- **general**: Everything else

## Steps

<step name="ensure_global_dir">
```bash
mkdir -p ~/.buildmate-global
```
</step>

<step name="read_existing">
```bash
cat ~/.buildmate-global/user-profile.json 2>/dev/null || echo "{}"
```
</step>

<step name="categorize_and_store">
Parse the fact and determine category:

Keywords → Category:
- "prefer", "like", "love", "hate" → tech_prefs
- "always", "never", "workflow" → workflows  
- "VPS", "server", "IP", "domain" → infra
- "only", "must", "constraint" → constraints
- else → general

Update user-profile.json:
```json
{
  "facts": [
    {
      "id": "uuid",
      "text": "[fact text]",
      "category": "[category]",
      "added": "2026-03-18T15:30:00Z",
      "source": "manual"
    }
  ]
}
```
</step>

<step name="confirm">
```
🧠 REMEMBERED

"[fact text]"

Category: [category]
ID: [uuid]

This will be available in future projects.
```
</step>

## View All Memories

```
cat ~/.buildmate-global/user-profile.json
```

## See Also

- `/buildmate:forget` - Remove a memory
- `/buildmate:learn` - Extract skill from project
