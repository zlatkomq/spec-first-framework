#!/usr/bin/env bash
# Test: implementation skill
# Verifies key gates: TASKS must be APPROVED, TDD iron law, HALT after 3 failures
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: implementation skill ==="
echo ""

# Test 1: TASKS must be APPROVED gate
echo "Test 1: TASKS must be APPROVED..."

output=$(run_claude "What happens if I ask the implementation skill to start coding when TASKS.md status is still DRAFT?" 30)

if assert_contains "$output" "STOP\|stop\|cannot\|APPROVED\|not.*proceed" "Stops if tasks not approved"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: TDD iron law
echo "Test 2: TDD iron law — test first, delete code before test..."

output=$(run_claude "In the implementation skill, what is the iron law about test order? What happens if you write code before a test?" 30)

if assert_contains "$output" "test.*first\|TEST.*FIRST\|RED.*GREEN\|TDD\|failing.*test" "Test-first is the rule"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "[Dd]elete\|DELETE\|start over\|remove" "Must delete code written before test"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: HALT after 3 consecutive failures
echo "Test 3: HALT after 3 consecutive failures..."

output=$(run_claude "In the implementation skill, what happens after 3 consecutive failed attempts on the same problem?" 30)

if assert_contains "$output" "HALT\|halt\|stop\|systematic.*debug\|debugging" "Invokes systematic debugging or halts"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All implementation skill tests passed ==="
