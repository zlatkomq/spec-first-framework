#!/usr/bin/env bash
# Test: bug-review skill
# Verifies key gates: inspect actual code, missing test = CHANGES REQUESTED, minimal change
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: bug-review skill ==="
echo ""

# Test 1: Must inspect actual code
echo "Test 1: Must inspect actual source code..."

output=$(run_claude "In the bug-review skill, can I produce a REVIEW.md based only on reading the BUG.md document without looking at the code?" 30)

if assert_contains "$output" "[Nn]o\|[Dd]o [Nn][Oo][Tt]\|must.*inspect\|must.*verify\|actual.*code\|source.*code" "Must inspect actual source code"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Regression test missing = CHANGES REQUESTED
echo "Test 2: Missing regression test verdict..."

output=$(run_claude "What verdict does the bug-review skill set if the regression test is missing from the bugfix?" 30)

if assert_contains "$output" "CHANGES REQUESTED\|changes.*requested\|CHANGES_REQUESTED" "Sets CHANGES REQUESTED verdict"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: Minimal change verification
echo "Test 3: Minimal change verification..."

output=$(run_claude "What does the bug-review skill check for regarding the scope of changes in a bugfix?" 30)

if assert_contains "$output" "unrelated.*change\|unnecessary.*refactor\|feature.*addition\|minimal.*change\|scope\|only.*necessary" "Checks for scope violations"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All bug-review skill tests passed ==="
