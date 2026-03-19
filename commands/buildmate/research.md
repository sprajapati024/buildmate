---
name: buildmate:research
description: Quick research on a specific topic. Spawns Researcher agent for focused investigation.
tools: Read, Write
argument-hint: "<topic>"
---

# /buildmate:research - Quick Research

Spawn the Researcher agent for focused topic investigation.

## Usage

```
/buildmate:research "PostgreSQL vs MySQL for this use case"
/buildmate:research "Best Python libraries for PDF generation"
/buildmate:research "Redis caching strategies"
```

## When to Use

- Need to evaluate specific technology
- Comparing options for a decision
- Understanding best practices
- Before committing to a library/approach

## What Happens

1. Spawns `buildmate-researcher` agent
2. Researcher investigates topic
3. Writes findings to RESEARCH.md (or APPENDIX.md)
4. Reports summary with recommendation

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

<step name="parse_topic">
Extract research topic from user input.
</step>

<step name="spawn_researcher">
Spawn `buildmate:researcher` with task:

```
Research topic: "[topic]"

Deliverables:
1. Investigate options
2. Compare pros/cons
3. Provide recommendation
4. Write findings to RESEARCH.md
```
</step>

<step name="report_result">
```
🔍 Research Complete

Topic: [topic]
Summary: [brief recommendation]

Full analysis: RESEARCH.md
```
</step>

## Example

```
/buildmate:research "Should we use SQLAlchemy or raw SQL?"

Spawning Researcher...

🔍 Research Complete: ORM vs Raw SQL

Summary:
- SQLAlchemy: Better for complex models, migrations
- Raw SQL: Better for performance-critical queries
- Recommendation: SQLAlchemy for 90%, raw SQL for hot paths

See full analysis: RESEARCH.md#orm-vs-raw-sql
```

## Output

Creates or appends to:
- RESEARCH.md - Main research document
- Includes pros/cons, tradeoffs, recommendation

## vs Full Project Research

During `/buildmate:init`, Researcher does **broad** tech stack evaluation.

`/buildmate:research` does **focused** deep-dive on one specific topic.

Use this for targeted questions after the project is underway.
