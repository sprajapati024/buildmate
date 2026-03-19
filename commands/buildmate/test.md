---
name: buildmate:test
description: Run tests via the Tester agent. Checks code quality, coverage, and reports results.
tools: Read, Write, Bash
---

# /buildmate:test - Run Tests

Spawn the Tester agent to run the test suite.

## Usage

```
/buildmate:test
/buildmate:test unit
/buildmate:test integration
/buildmate:test coverage
```

## What Happens

1. Spawns `buildmate-tester` agent
2. Tester discovers test files
3. Runs appropriate test suite
4. Reports pass/fail count
5. Shows coverage percentage
6. Quality gate check

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

<step name="discover_tests">
```bash
# Find test files
find . -name "*test*.py" -o -name "*.test.js" -o -name "*.spec.ts" 2>/dev/null | head -20

# Detect test framework
ls package.json 2>/dev/null && cat package.json | grep -E "jest|mocha|vitest"
ls requirements.txt 2>/dev/null && cat requirements.txt | grep -E "pytest|unittest"
```
</step>

<step name="spawn_tester">
Spawn `buildmate:tester` with task:

```
Run test suite: [unit/integration/coverage]
- Discover all tests
- Run appropriate runner
- Report pass/fail
- Check coverage
- Quality gate
```
</step>

<step name="report_result">
```
✅ Test Results

Tests: [total]
Passed: [count] ✅
Failed: [count] ❌
Coverage: [percentage]%
Quality Gate: [PASS/FAIL]
```
</step>

## Example

```
/buildmate:test

Spawning Tester...

✅ Test Results

Suite: Full Suite
Tests: 42 total
  - Passed: 42 ✅
  - Failed: 0 ✅
  - Skipped: 2

Coverage: 89%
  - src/services/: 94%
  - src/api/: 87%
  - src/models/: 91%

Quality Gate: ✅ PASSED

No action needed. Code is solid!
```

## If Tests Fail

```
🛑 Test Results - FAILURES

Tests: 42 total
  - Passed: 38
  - Failed: 4 🛑

Failures:
1. test_auth_missing_token
   Expected 401, got 500

Quality Gate: 🛑 FAILED

Action: Sending back to Coder for fixes
```

## Test Types

- **unit** - Fast tests for individual functions
- **integration** - Component interaction tests
- **coverage** - Full suite with coverage report
- *(default)* - Run all test types

## Continuous Testing

The Tester agent runs automatically after each Coder commit. Use `/buildmate:test` for on-demand testing or to check specific areas.
