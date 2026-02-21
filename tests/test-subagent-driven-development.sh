#!/usr/bin/env bash
# Test: subagent-driven-development skill
# Verifies key gates: read TASKS once, no file reads by subagents,
# spec before quality review, IMPLEMENTATION-SUMMARY logging
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: subagent-driven-development skill ==="
echo ""

# Test 1: Read TASKS.md once, upfront
echo "Test 1: Read TASKS.md once..."

output=$(run_claude "In the subagent-driven-development skill, how many times should the controller read the TASKS.md file? When?" 30)

if assert_contains "$output" "once\|one time\|single" "Reads TASKS.md once"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "upfront\|beginning\|start\|before.*dispatch\|Step 1\|first" "Reads at the beginning"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Don't make subagents read files
echo "Test 2: Subagents don't read files themselves..."

output=$(run_claude "Should the subagent-driven-development controller tell implementer subagents to read TASKS.md themselves? Why or why not?" 30)

if assert_contains "$output" "[Nn]o\|not.*make\|do not\|don't\|never.*read" "Does not make subagents read files"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "provide.*directly\|full.*text\|paste\|include.*prompt\|embed\|inline" "Provides text directly instead"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: Spec compliance before code quality (two-stage order)
echo "Test 3: Spec compliance before code quality..."

output=$(run_claude "In the subagent-driven-development skill, which review happens first: spec compliance or code quality? Is this a hard rule?" 30)

if assert_order "$output" "spec.*compliance\|Spec.*[Cc]ompliance\|spec.*review" "code.*quality\|[Cc]ode.*[Qq]uality\|quality.*review" "Spec compliance before code quality"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 4: IMPLEMENTATION-SUMMARY.md logging
echo "Test 4: IMPLEMENTATION-SUMMARY.md logging..."

output=$(run_claude "What must the controller log to IMPLEMENTATION-SUMMARY.md in the subagent-driven-development skill? When does this happen?" 30)

if assert_contains "$output" "IMPLEMENTATION-SUMMARY\|implementation.*summary" "Logs to IMPLEMENTATION-SUMMARY"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "review\|gate\|result\|anchor\|per.*task\|after.*task" "Logs review results per task"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All subagent-driven-development skill tests passed ==="
