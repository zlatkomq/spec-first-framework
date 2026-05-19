#!/usr/bin/env bash
# Test: bug-implementation skill
# Verifies key gates: BUG must be CONFIRMED, minimal change, test naming convention
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: bug-implementation skill ==="
echo ""

# Test 1: BUG must be CONFIRMED gate
echo "Test 1: BUG must be CONFIRMED..."

output=$(run_claude "Can I start implementing a bugfix using the bug-implementation skill when BUG.md status is still DRAFT?" 30)

if assert_contains "$output" "STOP\|stop\|cannot\|CONFIRMED\|not.*proceed\|must.*CONFIRMED" "Stops if bug not CONFIRMED"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Minimal change principle
echo "Test 2: Minimal change principle..."

output=$(run_claude "In the bug-implementation skill, what is the scope of allowed changes? Can I improve adjacent code while fixing a bug?" 30)

if assert_contains "$output" "minimal.*change\|minimum.*change\|only.*what.*broken\|nothing.*more\|fix.*only" "Enforces minimal change principle"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: Regression test naming convention
echo "Test 3: Regression test naming convention..."

output=$(run_claude "What naming convention must the regression test follow in the bug-implementation skill?" 30)

if assert_contains "$output" "bug.*ID\|BUG.*[0-9]\|BUG-\|reference.*bug\|test_bug_\|bug.*number" "Test name must reference bug ID"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All bug-implementation skill tests passed ==="
