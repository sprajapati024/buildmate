---
name: buildmate:onboard
description: Onboard an existing project to Buildmate. Discovers current codebase, creates soul.json, and generates missing documentation.
tools: Read, Write, Bash, Grep, Glob
---

# /buildmate-onboard - Onboard Existing Project

Use this when you have an existing project and want Buildmate to take over.

## When to Use

- Existing codebase, no Buildmate setup yet
- Want Buildmate to understand current state
- Ready to continue development with the agent team

## What It Does

1. **Discovers** current project structure
2. **Maps** existing code to understand architecture
3. **Creates** `.buildmate/soul.json` with current state
4. **Generates** missing documentation:
   - ARCHITECTURE.md (from code analysis)
   - RESEARCH.md (tech stack identification)
   - CHANGELOG.md (from git history)
   - DECISIONS.md (if detectable from commits)

## Steps

<step name="detect_existing">
Check what's in the project:

```bash
# Detect project type
ls -la 2>/dev/null || echo "NO_DIR"
git log --oneline -20 2>/dev/null || echo "NO_GIT"
find . -type f \( -name "*.py" -o -name "*.ts" -o -name "*.js" -o -name "*.go" \) 2>/dev/null | head -30
```

If NO_DIR:
```
❌ No project directory found.

Create a directory first:
mkdir my-project && cd my-project
```
Stop execution.

Identify:
- Programming language
- Framework (FastAPI, Express, etc.)
- Database (PostgreSQL, Mongo, etc.)
- Existing structure
- Git history
</step>

<step name="spawn_mapper">
Spawn: `buildmate-architect` (in mapping mode)

Task: "Map existing codebase structure. Analyze:
- Folder organization
- Key modules/services
- API routes (if any)
- Database models
- External integrations

Write findings to ARCHITECTURE.md. Mark as 'reverse-engineered from existing code'."
</step>

<step name="spawn_researcher">
Spawn: `buildmate-researcher` (in analysis mode)

Task: "Analyze existing tech stack. Look at:
- package.json, requirements.txt, Cargo.toml, etc.
- Import statements
- Dockerfile, docker-compose.yml
- CI/CD configs
- Any infra code

Write RESEARCH.md with identified stack and rationale (if detectable)."
</step>

<step name="spawn_documenter">
Spawn: `buildmate-documenter` (in catch-up mode)

Task: "Generate missing documentation:
- CHANGELOG.md from git commits (last 20)
- README.md if missing or outdated
- DECISIONS.md from commit messages (if they explain why)
- Any .env.example from code references

Mark all as 'generated from existing codebase'."
</step>

<step name="create_soul">
Create `.buildmate/soul.json`:

```json
{
  "version": "1.0.0",
  "project": {
    "name": "[detected from package.json or folder name]",
    "born": "[from first git commit]",
    "onboarded": "[today]",
    "intent": "[user provided or inferred from code]",
    "status": "existing-onboarded"
  },
  "onboarding": {
    "codebase_mapped": true,
    "architecture_documented": true,
    "tech_stack_identified": true,
    "docs_generated": true
  },
  "phases": {
    "current": "discovery",
    "completed": ["onboarding"],
    "next": "[user decides]"
  },
  "agents": {
    "completed": [
      {"name": "architect", "task": "Map existing codebase"},
      {"name": "researcher", "task": "Identify tech stack"},
      {"name": "documenter", "task": "Generate missing docs"}
    ]
  }
}
```
</step>

<step name="report">
Report to user:

```
🚀 Buildmate Onboarding Complete!

Project: [name]
Type: [Python/FastAPI/etc.]
Onboarded: [date]

📊 Discovered:
- [N] source files
- [N] test files
- [N] dependencies
- Git history: [N] commits

📁 Generated:
✅ .buildmate/soul.json - Project memory
✅ ARCHITECTURE.md - System design (reverse-engineered)
✅ RESEARCH.md - Tech stack analysis
✅ CHANGELOG.md - Recent changes (from git)

🎯 Current State:
Phase: Discovery
Status: Onboarded, ready to continue

Next Steps:
/buildmate "Add [new feature]" - Continue with agent team
/buildmate-status - Check current state
```
</step>

</steps>

## Example Flow

**User has existing project:**
```
my-trading-bot/
├── src/
│   ├── main.py
│   └── fetcher.py
├── requirements.txt
└── .git/
```

**User runs:** `/buildmate-onboard`

**Buildmate does:**
1. Detects Python project
2. Architect analyzes code → creates ARCHITECTURE.md
3. Researcher reads requirements.txt → creates RESEARCH.md
4. Documenter reads git log → creates CHANGELOG.md
5. Creates soul.json with "status": "existing-onboarded"

**Now ready for:** `/buildmate "Add alert notifications"`
</steps>
