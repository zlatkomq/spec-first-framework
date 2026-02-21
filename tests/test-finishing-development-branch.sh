#!/usr/bin/env bash
# Test: finishing-development-branch skill
# Verifies key gates: tests before options, exactly 4 options, post-merge test gate
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: finishing-development-branch skill ==="
echo ""

# Test 1: Tests must pass before options
echo "Test 1: Tests must pass before presenting options..."

output=$(run_claude "In the finishing-development-branch skill, what must happen before the user is presented with completion options?" 30)

if assert_contains "$output" "test.*pass\|pass.*test\|test.*suite\|run.*test\|verify.*test" "Tests must pass first"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Exactly 4 options
echo "Test 2: Exactly 4 completion options..."

output=$(run_claude "What are the completion options presented by the finishing-development-branch skill? List all of them." 30)

if assert_contains "$output" "[Mm]erge.*local" "Option: Merge locally"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "[Pp]ull [Rr]equest\|PR\|[Pp]ush.*PR" "Option: Push and create PR"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "[Kk]eep.*branch\|[Kk]eep.*as" "Option: Keep branch as-is"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "[Dd]iscard" "Option: Discard"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: Post-merge test gate
echo "Test 3: Post-merge test verification..."

output=$(run_claude "In the finishing-development-branch skill, after merging locally, what must happen before deleting the feature branch?" 30)

if assert_contains "$output" "test.*pass\|verify.*test\|run.*test.*merge\|merged.*result\|test.*again" "Tests must pass on merged result"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All finishing-development-branch skill tests passed ==="
