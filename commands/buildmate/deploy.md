---
name: buildmate:deploy
description: Deploy project to production. Triggers deployment workflow with safety checks and approval gates.
tools: Read, Write, Bash
argument-hint: "[environment]"
---

# /buildmate:deploy - Deploy to Production

Deploy the project to production or staging environment.

## Usage

```
/buildmate:deploy
/buildmate:deploy staging
/buildmate:deploy production
```

## Safety Checks

Before deploying:
1. ✅ All tests pass
2. ✅ PRD scope is met
3. ✅ User approval (always asked)
4. ✅ Git status clean (or commit first)

## Steps

<step name="verify_project">
```bash
# Check for Buildmate project
if [ ! -f ".buildmate/soul.json" ]; then
  echo "NO_SOUL"
  exit 0
fi

# Check tests
npm test 2>/dev/null || pytest 2>/dev/null || echo "NO_TESTS"

# Check git status
git status --short

# Check PRD alignment
cat PRD.md 2>/dev/null | grep -E "^(## [0-9]|###)" | head -20

# Get recent commits
git log --oneline -5 2>/dev/null || echo "NO_GIT"
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

<step name="spawn_pm_deploy_review">
Spawn PM agent to manage deployment approval:

```
Task: buildmate-pm
Description: |
  User requested deployment to [environment]
  
  Your task:
  1. Read soul.json - verify scope is locked
  2. Verify all tests pass (check test results)
  3. Review git status (must be clean)
  4. Check PRD - verify scope is met
  5. If ANY check fails: BLOCK deployment and explain why
  6. If all checks pass: Present deployment approval request to user
```
</step>

<step name="pre_deploy_checks">
PM verifies:
1. ✅ All tests pass (or user acknowledges skipping)
2. ✅ Git status clean (or commit required first)
3. ✅ Scope locked in soul.json
4. ✅ PRD requirements met for this phase

If any check fails:
- BLOCK deployment
- Report: "❌ Deployment blocked: [reason]"
- Require fixes before proceeding
</step>

<step name="multi_step_approval">
**STEP 1: Show What Will Be Deployed**

```
🚀 DEPLOYMENT REQUESTED - STEP 1/3

═══════════════════════════════════════
📊 DEPLOYMENT SUMMARY
═══════════════════════════════════════
Environment: [production/staging]
Project: [from soul.json]
Current version: [git commit hash]

═══════════════════════════════════════
✅ Pre-Deploy Verification
═══════════════════════════════════════
Tests: [PASS / FAIL / SKIP]
Git status: [clean / dirty - commits required]
Scope locked: [YES / NO]
PRD status: [requirements met / incomplete]

═══════════════════════════════════════
📦 Changes to Deploy (last 5 commits)
═══════════════════════════════════════
[git log --oneline -5]

═══════════════════════════════════════
📁 Files Modified
═══════════════════════════════════════
[git diff --name-only HEAD~5..HEAD]

═══════════════════════════════════════
⚠️  PRODUCTION IMPACT
═══════════════════════════════════════
This will deploy to LIVE production.
This action CANNOT be easily undone.
Users WILL see these changes immediately.

═══════════════════════════════════════
❓ Proceed to Step 2?
═══════════════════════════════════════
[Review Complete → Proceed] / [Cancel Deployment]
```
</step>

<step name="rollback_plan">
**STEP 2: Rollback Plan**

```
🚀 DEPLOYMENT REQUESTED - STEP 2/3

═══════════════════════════════════════
🔄 ROLLBACK PLAN
═══════════════════════════════════════

If deployment fails, you can rollback:

**Quick Rollback:**
```bash
git revert HEAD
git push
[redeploy command]
```

**Full Rollback:**
```bash
git checkout [previous-commit]
[redeploy command]
```

**Database Rollback (if applicable):**
- Check for migration compatibility
- Have database backup before deploying
- Test rollback procedure in staging first

═══════════════════════════════════════
❓ Ready for Final Confirmation?
═══════════════════════════════════════
[I Understand the Risks → Proceed] / [Cancel]
```
</step>

<step name="final_approval">
**STEP 3: Final Confirmation**

```
🚀 DEPLOYMENT REQUESTED - STEP 3/3 - FINAL CONFIRMATION

═══════════════════════════════════════
⚠️  TYPE TO CONFIRM
═══════════════════════════════════════

To prevent accidental deployment, type exactly:

👉  Yes, deploy to production  👈

(Or type "cancel" to abort)

═══════════════════════════════════════
🛡️  Final Checklist
═══════════════════════════════════════
□ I have reviewed the changes
□ Tests pass (or I accept the risk)
□ I understand rollback procedures
□ I am authorized to deploy

═══════════════════════════════════════
Deployment will begin immediately after confirmation.
═══════════════════════════════════════
```

If user types EXACT phrase "Yes, deploy to production":
- Proceed to execute_deploy

If user types anything else:
- Cancel deployment
- Report: "❌ Deployment cancelled. Confirmation phrase did not match."
</step>

<step name="execute_deploy">
If approved:

1. Run final tests
2. Build if needed (`npm run build`, etc.)
3. Deploy using configured method:
   - VPS: `ssh user@host "cd /app && git pull && restart"`
   - Docker: `docker-compose up -d`
   - Serverless: `serverless deploy`
   - Static: `rsync` or similar
4. Verify deployment
5. Report result
</step>

<step name="report_result">
```
✅ DEPLOYMENT COMPLETE

Environment: [production]
Time: [timestamp]
Version: [git commit]

Verify: [deployment URL]
```

Or on failure:
```
❌ DEPLOYMENT FAILED

Error: [error message]

Rollback: [instructions]
```
</step>

## Configuration

Deployment method detected from:
- `package.json` scripts
- `docker-compose.yml` presence
- `.buildmate/soul.json` deploy config
- Common patterns (Makefile, etc.)

## See Also

- `/buildmate:sync` - Git sync
- `/buildmate:test` - Run tests
- `/buildmate:checkpoint` - Approval gate
