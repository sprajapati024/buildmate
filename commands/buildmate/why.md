---
name: buildmate:why
description: Explain why a specific decision was made. Queries DECISIONS.md for rationale.
tools: Read, Grep
argument-hint: "<decision-keyword>"
---

# /buildmate:why - Explain a Decision

Show the rationale behind a specific decision from DECISIONS.md.

## Usage

```
/buildmate:why <keyword>

Examples:
/buildmate:why postgres
/buildmate:why stripe
/buildmate:why react
/buildmate:why "api choice"
```

## What Shows

From DECISIONS.md:
- Context: Why did we need this decision?
- Options: What alternatives were considered?
- Decision: What was chosen?
- Rationale: Why this choice?
- Decision Maker: Who made the call?
- Linked PRD Section

## Steps

<step name="search_decisions">
```bash
# Search DECISIONS.md for keyword
grep -i -A 10 -B 2 "$KEYWORD" .buildmate/DECISIONS.md 2>/dev/null || echo "NOT_FOUND"
```
</step>

<step name="display_rationale">
If found:
```
💡 DECISION RATIONALE

Decision: [Decision title]
Date: [timestamp]

─────────────────────────────────
📍 Context
─────────────────────────────────
[Why we needed this decision]

─────────────────────────────────
🔍 Options Considered
─────────────────────────────────
• Option A: [description]
• Option B: [description]
• Option C: [description]

─────────────────────────────────
✅ Decision Made
─────────────────────────────────
[What was chosen]

─────────────────────────────────
🧠 Rationale
─────────────────────────────────
[Why this choice over alternatives]

─────────────────────────────────
👤 Decision Maker
─────────────────────────────────
[user or agent name]

─────────────────────────────────
📎 Linked PRD Section
─────────────────────────────────
[Section reference]
```

If not found:
```
❌ No decision found matching: [keyword]

Try searching for:
• Technology names (postgres, react, stripe)
• Feature names (auth, api, caching)
• Or view all: cat .buildmate/DECISIONS.md
```
</step>

## See Also

- `/buildmate:context` - Full project context
- `/buildmate:prd` - View PRD
