#!/usr/bin/env bash
# Test: design-creation skill
# Verifies key gates: SPEC must be APPROVED, omit irrelevant sections, ID match
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: design-creation skill ==="
echo ""

# Test 1: SPEC must be APPROVED hard gate
echo "Test 1: SPEC must be APPROVED..."

output=$(run_claude "I want to create a DESIGN.md but my SPEC.md is still in DRAFT status. What does the design-creation skill say I should do?" 30)

if assert_contains "$output" "STOP\|stop\|cannot\|must.*[Aa]pproved\|not.*proceed\|APPROVED" "Stops if spec not approved"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Omit irrelevant sections (not N/A)
echo "Test 2: Omit irrelevant sections..."

output=$(run_claude "In the design-creation skill, if a feature has no database changes, what should I write in the Data Model section?" 30)

if assert_contains "$output" "omit\|skip\|do not include\|leave.*out\|not.*include\|remove.*section" "Omits irrelevant sections entirely"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: ID must match SPEC
echo "Test 3: ID must match SPEC exactly..."

output=$(run_claude "In the design-creation skill, what rules apply to the ID and Name metadata fields?" 30)

if assert_contains "$output" "match.*SPEC\|SPEC.*match\|same.*ID\|exact\|identical" "ID must match SPEC exactly"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All design-creation skill tests passed ==="
