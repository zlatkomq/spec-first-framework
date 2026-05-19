#!/usr/bin/env bash
# Test: spec-creation skill
# Verifies key gates: user provides ID, BDD format ACs, no technical details
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: spec-creation skill ==="
echo ""

# Test 1: User must provide ID
echo "Test 1: User must provide ID..."

output=$(run_claude "In the spec-creation skill, if the user doesn't provide a spec ID, what should happen?" 30)

if assert_contains "$output" "ask\|ASK\|request.*ID\|provide.*ID\|prompt.*ID" "Asks user for ID before proceeding"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: BDD acceptance criteria format
echo "Test 2: BDD acceptance criteria format..."

output=$(run_claude "What format must acceptance criteria use in the spec-creation skill?" 30)

if assert_contains "$output" "Given.*[Ww]hen.*[Tt]hen\|Given\|When\|Then" "Uses Given/When/Then BDD format"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: No technical implementation details
echo "Test 3: No technical details in spec..."

output=$(run_claude "In spec-creation, can the SPEC.md include database schema details or API endpoint definitions?" 30)

if assert_contains "$output" "[Nn]o\|not.*include\|not.*technical\|behavior.*only\|belong.*design\|DESIGN" "Rejects technical details in spec"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All spec-creation skill tests passed ==="
