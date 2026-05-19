#!/usr/bin/env bash
# Test: change-request skill
# Verifies key gates: APPROVED + classification, INVALIDATED/UNAFFECTED/REMOVED, no modify without approval
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: change-request skill ==="
echo ""

# Test 1: SPEC must be APPROVED + classification check
echo "Test 1: SPEC APPROVED gate and classification check..."

output=$(run_claude "What pre-conditions does the change-request skill check before proceeding with a change?" 30)

if assert_contains "$output" "APPROVED\|approved.*SPEC\|SPEC.*approved" "SPEC must be APPROVED"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "classification\|bug.*or\|[Cc]hange [Rr]equest.*or.*bug\|confirm.*type\|verify.*type" "Performs classification check"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Per-task INVALIDATED/UNAFFECTED/REMOVED classification
echo "Test 2: Task impact classification..."

output=$(run_claude "In the change-request skill, how are existing completed tasks classified when a change is approved?" 30)

if assert_contains "$output" "INVALIDATED\|UNAFFECTED\|REMOVED" "Uses the three classification categories"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: No artifact modification without approval
echo "Test 3: No modification without approval..."

output=$(run_claude "In the change-request skill, when are SPEC.md, DESIGN.md, or TASKS.md actually modified?" 30)

if assert_contains "$output" "approv\|after.*approv\|user.*confirm\|explicit.*approv" "Only after user approves"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All change-request skill tests passed ==="
