#!/usr/bin/env bash
# Test: systematic-debugging skill
# Verifies key gates: no fix before Phase 1, instrument before analyze, one variable at a time
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: systematic-debugging skill ==="
echo ""

# Test 1: No fix before Phase 1
echo "Test 1: No fix before root cause investigation..."

output=$(run_claude "In the systematic-debugging skill, what must you complete before proposing any fix?" 30)

if assert_contains "$output" "Phase 1\|root.*cause\|investigation\|investigate.*first" "Must complete Phase 1 (investigation) first"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Instrument before analyze
echo "Test 2: Instrument before analyze in multi-component systems..."

output=$(run_claude "In the systematic-debugging skill, if a problem spans multiple system components, what should you do before analyzing which layer is broken?" 30)

if assert_contains "$output" "instrument\|diagnostic\|evidence\|gather.*data\|add.*log\|trace" "Must instrument first"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: One variable at a time
echo "Test 3: One variable at a time..."

output=$(run_claude "In systematic-debugging Phase 3, what constraint applies to hypothesis testing and making changes?" 30)

if assert_contains "$output" "one.*variable\|single.*change\|smallest.*possible\|minimal.*change\|one.*at.*a.*time" "One variable at a time"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All systematic-debugging skill tests passed ==="
