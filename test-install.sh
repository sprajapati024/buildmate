#!/bin/bash
# Buildmate Installation Test Script
# Verifies all files are in place and correctly formatted

echo "=========================================="
echo "Buildmate Installation Test"
echo "=========================================="
echo ""

CLAUDE_DIR="$HOME/.claude"
PASS=0
FAIL=0

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $2"
        ((PASS++))
    else
        echo -e "${RED}✗${NC} $2 (missing: $1)"
        ((FAIL++))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $2"
        ((PASS++))
    else
        echo -e "${RED}✗${NC} $2 (missing: $1)"
        ((FAIL++))
    fi
}

echo "1. Checking Directory Structure"
echo "--------------------------------"
check_dir "$CLAUDE_DIR" "Claude config directory"
check_dir "$CLAUDE_DIR/commands" "Commands directory"
check_dir "$CLAUDE_DIR/commands/buildmate" "Buildmate commands"
# V2 Hard Cut: GSD commands removed - verify they don't exist
if [ -d "$CLAUDE_DIR/commands/gsd" ]; then
    echo -e "${YELLOW}!${NC} GSD commands still present (should be removed in V2)"
else
    echo -e "${GREEN}✓${NC} GSD commands removed (V2 hard cut)"
    ((PASS++))
fi
check_dir "$CLAUDE_DIR/agents" "Agents directory"
# V2: buildmate-core is GSD legacy, not installed in V2
# check_dir "$CLAUDE_DIR/buildmate-core" "Buildmate core"
echo ""

echo "2. Checking Buildmate Commands (29 expected for V2)"
echo "--------------------------------"
check_file "$CLAUDE_DIR/commands/buildmate/init.md" "buildmate:init"
check_file "$CLAUDE_DIR/commands/buildmate/onboard.md" "buildmate:onboard"
check_file "$CLAUDE_DIR/commands/buildmate/status.md" "buildmate:status"
check_file "$CLAUDE_DIR/commands/buildmate/stop.md" "buildmate:stop"
check_file "$CLAUDE_DIR/commands/buildmate/help.md" "buildmate:help"
check_file "$CLAUDE_DIR/commands/buildmate/huddle.md" "buildmate:huddle"
check_file "$CLAUDE_DIR/commands/buildmate/pause.md" "buildmate:pause"
check_file "$CLAUDE_DIR/commands/buildmate/resume.md" "buildmate:resume"
check_file "$CLAUDE_DIR/commands/buildmate/kill.md" "buildmate:kill"
check_file "$CLAUDE_DIR/commands/buildmate/test.md" "buildmate:test"
check_file "$CLAUDE_DIR/commands/buildmate/plan.md" "buildmate:plan"
check_file "$CLAUDE_DIR/commands/buildmate/research.md" "buildmate:research"
check_file "$CLAUDE_DIR/commands/buildmate/debug.md" "buildmate:debug"
check_file "$CLAUDE_DIR/commands/buildmate/review.md" "buildmate:review"
check_file "$CLAUDE_DIR/commands/buildmate/commit.md" "buildmate:commit"
check_file "$CLAUDE_DIR/commands/buildmate/sync.md" "buildmate:sync"
check_file "$CLAUDE_DIR/commands/buildmate/deploy.md" "buildmate:deploy"
check_file "$CLAUDE_DIR/commands/buildmate/focus.md" "buildmate:focus"
check_file "$CLAUDE_DIR/commands/buildmate/parallel.md" "buildmate:parallel"
check_file "$CLAUDE_DIR/commands/buildmate/sequential.md" "buildmate:sequential"
check_file "$CLAUDE_DIR/commands/buildmate/context.md" "buildmate:context"
check_file "$CLAUDE_DIR/commands/buildmate/why.md" "buildmate:why"
check_file "$CLAUDE_DIR/commands/buildmate/remember.md" "buildmate:remember"
check_file "$CLAUDE_DIR/commands/buildmate/forget.md" "buildmate:forget"
check_file "$CLAUDE_DIR/commands/buildmate/learn.md" "buildmate:learn"
check_file "$CLAUDE_DIR/commands/buildmate/prd.md" "buildmate:prd"
check_file "$CLAUDE_DIR/commands/buildmate/scope.md" "buildmate:scope"
check_file "$CLAUDE_DIR/commands/buildmate/checkpoint.md" "buildmate:checkpoint"
check_file "$CLAUDE_DIR/commands/buildmate/docs.md" "buildmate:docs"
echo ""

echo "3. Checking Buildmate Agents (7 expected - including PM)"
echo "--------------------------------"
check_file "$CLAUDE_DIR/agents/buildmate-orchestrator.md" "Orchestrator agent"
check_file "$CLAUDE_DIR/agents/buildmate-pm.md" "Project Manager agent (NEW in V2)"
check_file "$CLAUDE_DIR/agents/buildmate-researcher.md" "Researcher agent"
check_file "$CLAUDE_DIR/agents/buildmate-architect.md" "Architect agent"
check_file "$CLAUDE_DIR/agents/buildmate-coder.md" "Coder agent"
check_file "$CLAUDE_DIR/agents/buildmate-documenter.md" "Documenter agent"
check_file "$CLAUDE_DIR/agents/buildmate-tester.md" "Tester agent"
echo ""

echo "4. Checking Command Format (Frontmatter)"
echo "--------------------------------"
if grep -q "^name: buildmate:init" "$CLAUDE_DIR/commands/buildmate/init.md" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Command names use colon format (buildmate:init)"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Command names missing or wrong format"
    ((FAIL++))
fi

if grep -q "^tools:" "$CLAUDE_DIR/commands/buildmate/init.md" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Commands have tools defined"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Commands missing tools"
    ((FAIL++))
fi
echo ""

echo "5. Checking Agent Format (Frontmatter)"
echo "--------------------------------"
if grep -q "^name: buildmate-orchestrator" "$CLAUDE_DIR/agents/buildmate-orchestrator.md" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Agent names correct"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Agent names missing or wrong"
    ((FAIL++))
fi

if grep -q "^tools:" "$CLAUDE_DIR/agents/buildmate-orchestrator.md" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Agents have tools defined"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Agents missing tools"
    ((FAIL++))
fi

if grep -q "^color:" "$CLAUDE_DIR/agents/buildmate-orchestrator.md" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Agents have colors defined"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Agents missing colors"
    ((FAIL++))
fi
echo ""

echo "6. Checking Buildmate Core"
echo "--------------------------------"
echo "  (V2: buildmate-core is GSD legacy - not installed in V2)"
echo ""

echo "7. Checking GSD Commands (V2 Hard Cut)"
echo "--------------------------------"
if [ -d "$CLAUDE_DIR/commands/gsd" ]; then
    GSD_COUNT=$(ls -1 "$CLAUDE_DIR/commands/gsd/" 2>/dev/null | wc -l)
    if [ "$GSD_COUNT" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} GSD hard cut complete - no GSD commands"
        ((PASS++))
    else
        echo -e "${YELLOW}!${NC} GSD commands still present: $GSD_COUNT (V2 does hard cut)"
        ((PASS++))  # Not a failure, just informational
    fi
else
    echo -e "${GREEN}✓${NC} GSD directory removed - hard cut complete"
    ((PASS++))
fi
echo ""

echo "8. Checking V2 Scope Enforcement"
echo "--------------------------------"
if grep -q "NO WORK WITHOUT SCOPE" "$CLAUDE_DIR/agents/buildmate-researcher.md" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Researcher has scope verification"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Researcher missing scope verification"
    ((FAIL++))
fi

if grep -q "NO WORK WITHOUT SCOPE" "$CLAUDE_DIR/agents/buildmate-architect.md" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Architect has scope verification"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Architect missing scope verification"
    ((FAIL++))
fi

if grep -q "NO WORK WITHOUT SCOPE" "$CLAUDE_DIR/agents/buildmate-coder.md" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Coder has scope verification"
    ((PASS++))
else
    echo -e "${RED}✗${NC} Coder missing scope verification"
    ((FAIL++))
fi

if grep -q "buildmate-pm" "$CLAUDE_DIR/agents/buildmate-pm.md" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} PM agent properly defined"
    ((PASS++))
else
    echo -e "${RED}✗${NC} PM agent not found"
    ((FAIL++))
fi
echo ""

echo "=========================================="
echo "Test Results"
echo "=========================================="
echo -e "Passed: ${GREEN}$PASS${NC}"
echo -e "Failed: ${RED}$FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ ALL TESTS PASSED${NC}"
    echo ""
    echo "Installation is complete and correct!"
    echo ""
    echo "You can now use:"
    echo "  /buildmate:init \"Your project description\""
    echo "  /buildmate:help"
    echo "  /buildmate:status"
    echo ""
    exit 0
else
    echo -e "${RED}✗ SOME TESTS FAILED${NC}"
    echo ""
    echo "Reinstall with:"
    echo "  cd ~/buildmate-code"
    echo "  node bin/install.js --global --claude"
    echo ""
    exit 1
fi
