#!/usr/bin/env bash
# Test: code-review skill
# Verifies key gates: two-stage order, 30% threshold = BLOCKED, expect 3+ issues
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: code-review skill ==="
echo ""

# Test 1: Two-stage order (spec compliance before code quality)
echo "Test 1: Two-stage review order..."

output=$(run_claude "In the code-review skill, what are the two review stages and which must come first? Is this a hard gate?" 30)

if assert_order "$output" "[Ss]pec.*[Cc]ompliance\|Stage 1\|Phase 2" "[Cc]ode.*[Qq]uality\|Stage 2\|Phase 3" "Spec compliance before code quality"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: 30% file threshold = BLOCKED
echo "Test 2: 30% file threshold..."

output=$(run_claude "In the code-review skill, what happens if more than 30% of expected files cannot be reviewed?" 30)

if assert_contains "$output" "30%\|30 percent\|BLOCKED\|blocked" "30% threshold triggers BLOCKED verdict"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: Expect at least 3 issues
echo "Test 3: Expect at least 3 issues..."

output=$(run_claude "In the code-review skill, what is the minimum number of issues a reviewer should expect to find?" 30)

if assert_contains "$output" "3.*issue\|three.*issue\|at least.*3\|minimum.*3\|expect.*3" "Must find at least 3 issues"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All code-review skill tests passed ==="
