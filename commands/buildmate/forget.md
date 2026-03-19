---
name: buildmate:forget
description: Remove a fact from Buildmate's memory. Undoes /buildmate:remember.
tools: Read, Write
argument-hint: "<fact-id-or-keyword>"
---

# /buildmate:forget - Remove from Memory

Delete a previously saved fact from Buildmate's global memory.

## Usage

```
/buildmate:forget <fact-id>
/buildmate:forget <keyword>

Examples:
/buildmate:forget "postgres"
/buildmate:forget "uuid-1234"
/buildmate:forget "VPS"
```

## Steps

<step name="read_profile">
```bash
cat ~/.buildmate-global/user-profile.json 2>/dev/null || echo "NO_PROFILE"
```
</step>

<step name="find_and_remove">
Search for fact by:
1. Exact ID match
2. Keyword in text (partial match)

If found → Remove from facts array
If multiple matches → Show list, ask which one
</step>

<step name="confirm">
If found and removed:
```
🗑️ FORGOTTEN

"[fact text]"

This preference is no longer saved.
```

If not found:
```
❌ No memory found matching: [keyword]

View all memories:
cat ~/.buildmate-global/user-profile.json | jq '.facts'
```

If multiple matches:
```
Multiple matches found:
1. "I prefer PostgreSQL" (ID: abc-123)
2. "PostgreSQL is great" (ID: def-456)

Use fact ID for precision:
/buildmate:forget abc-123
```
</step>

## See Also

- `/buildmate:remember` - Save a memory
- `/buildmate:learn` - Extract skill from project
