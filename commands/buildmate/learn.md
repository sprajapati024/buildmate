---
name: buildmate:learn
description: Extract a reusable skill from the current project. Creates a skill package for future use.
tools: Read, Write, Glob
---

# /buildmate:learn - Extract Skill from Project

Analyze the current project and create a reusable skill for future projects.

## Usage

```
/buildmate:learn
/buildmate:learn "[skill-name]"

Examples:
/buildmate:learn "fastapi-auth"
/buildmate:learn "trading-bot-pattern"
```

## What Happens

1. PM analyzes project structure and patterns
2. Identifies novel, reusable patterns
3. Creates skill package in `~/.buildmate-global/skill-library/`
4. Future projects can use: "Apply skill: [name]"

## Skill Package Contents

```
~/.buildmate-global/skill-library/[skill-name]/
├── SKILL.md          # Skill definition + usage
├── patterns.json     # Reusable patterns
├── templates/        # Code templates
└── examples/         # Example implementations
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

<step name="analyze_project">
```bash
# Read project structure
ls -la
cat .buildmate/soul.json
cat PRD.md 2>/dev/null | head -50

# Identify patterns
glob "**/*.py" "**/*.js" "**/*.ts" 2>/dev/null | head -20
```
</step>

<step name="suggest_skill">
Report to user:
```
🎓 SKILL EXTRACTION

PM analyzed your project and suggests:

Proposed Skill: "[auto-generated-name]"
Category: [python-cli / web-api / etc.]

Patterns detected:
• [Pattern 1 - e.g., "Typer CLI structure"]
• [Pattern 2 - e.g., "YAML config loading"]
• [Pattern 3 - e.g., "Test structure"]

What this skill includes:
- Folder structure template
- Common dependencies
- Code patterns
- Testing approach

Create this skill? [Yes / No / Rename]
```
</step>

<step name="create_skill">
If user approves:

1. Create directory: `~/.buildmate-global/skill-library/[name]/`
2. Write SKILL.md with:
   - What this skill provides
   - When to use it
   - How to apply it
3. Copy key patterns to templates/
4. Save metadata to patterns.json
</step>

<step name="confirm">
```
✅ SKILL CREATED

Name: [skill-name]
Location: ~/.buildmate-global/skill-library/[name]/

Future projects can use:
/buildmate init "Create project" --skill [name]

Or PM will suggest:
"Found skill '[name]' - use it for this project?"
```
</step>

## Skill Format

### SKILL.md
```markdown
# Skill: [name]

## What It Provides
[Brief description]

## When to Use
- [Condition 1]
- [Condition 2]

## Patterns Included
1. [Pattern name]: [description]
2. [Pattern name]: [description]

## How to Apply
[Instructions]
```

## See Also

- `/buildmate:remember` - Save a preference
- `/buildmate:forget` - Remove a memory
