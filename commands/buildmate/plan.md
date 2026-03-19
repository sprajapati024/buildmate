---
name: buildmate:plan
description: Create a detailed plan for the next development phase. Spawns Architect to design upcoming work.
tools: Read, Write
argument-hint: "[phase description]"
---

# /buildmate:plan - Plan Next Phase

Spawn the Architect agent to plan the next development phase.

## Usage

```
/buildmate:plan
/buildmate:plan "Add user dashboard with portfolio view"
```

## When to Use

- Before starting a major new phase
- Want to understand scope before coding
- Breaking down a large feature
- Changing direction and need new architecture

## What Happens

1. Architect reads current state (soul.json, ARCHITECTURE.md)
2. Designs plan for specified phase
3. Updates or creates PLAN.md
4. Updates soul.json with phase info

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

<step name="spawn_architect">
Spawn: `buildmate:architect`

Task: "Create detailed plan for phase based on soul.json and ARCHITECTURE.md"
</step>

## Example

```
/buildmate:plan "Add user authentication system"

Spawning Architect...

📐 Plan Created: Phase 2 - Authentication

Components:
- JWT token generation
- Login/logout endpoints
- Password hashing (bcrypt)
- Session management
- Auth middleware

Files to create:
- src/auth/jwt.py
- src/api/routes/auth.py
- src/middleware/auth.py
- tests/unit/test_auth.py

Dependencies:
- PyJWT library
- bcrypt library

Estimated: 3-4 hours

Ready for: /buildmate:init "Implement authentication"
```

## Output

Creates/updates:
- PLAN.md - Detailed phase plan
- ARCHITECTURE.md - Updated with new components
- soul.json - Phase tracking

## vs /buildmate:init

- `/buildmate:plan` - **Design only**, creates plan document
- `/buildmate:init` - **Design + implement**, spawns full team

Use `plan` when you want to review before building. Use `init` to go straight to implementation.
