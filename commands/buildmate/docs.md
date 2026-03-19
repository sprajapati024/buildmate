---
name: buildmate:docs
description: Trigger the Documenter agent to update all project documentation (README, CHANGELOG, API docs, .env.example).
tools: Read, Write
---

# /buildmate:docs - Update Documentation

Trigger the Documenter agent to review and update all project documentation.

## Usage

```
/buildmate:docs
```

## What Gets Updated

- **README.md** - Project overview, setup instructions
- **CHANGELOG.md** - Recent changes, version history
- **API.md** - API documentation (if applicable)
- **.env.example** - Environment variable template
- **ARCHITECTURE.md** - Sync with code changes

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

<step name="spawn_documenter">
Spawn documenter agent:

```
Task: buildmate-documenter
Description: |
  Update all project documentation to match current codebase:
  
  1. Review README.md - update setup, features, examples
  2. Review CHANGELOG.md - add recent changes
  3. Review ARCHITECTURE.md - sync with actual code
  4. Update .env.example - match current env vars
  5. Create/update API.md if project has APIs
  
  Check for:
  - Outdated installation steps
  - Missing features
  - Incorrect examples
  - New environment variables
  
  Report what was updated.
```
</step>

<step name="confirm">
```
📝 DOCUMENTATION UPDATE TRIGGERED

Documenter agent is reviewing and updating:
⏳ README.md
⏳ CHANGELOG.md
⏳ ARCHITECTURE.md
⏳ .env.example
⏳ API docs (if applicable)

Updates will be committed automatically.

Check status: /buildmate:status
```
</step>

## Auto-Documentation

Documenter runs continuously in the background during normal operations. This command forces an immediate sync.

## See Also

- `/buildmate:status` - Check documenter progress
- `/buildmate:commit` - Smart commit changes
