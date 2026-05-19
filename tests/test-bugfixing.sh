#!/usr/bin/env bash
# Test: bugfixing skill
# Verifies key gates: classification check, SPEC must exist, regression test mandatory
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: bugfixing skill ==="
echo ""

# Test 1: Classification check (bug vs Change Request)
echo "Test 1: Classification check..."

output=$(run_claude "A Jira ticket was filed but it asks for new behavior not covered by any acceptance criterion in the spec. What does the bugfixing skill say to do?" 30)

if assert_contains "$output" "[Cc]hange [Rr]equest\|CR\|not.*bug\|may not.*be.*bug" "Flags as potential Change Request"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: SPEC must exist and be APPROVED
echo "Test 2: SPEC must exist..."

output=$(run_claude "Can I use the bugfixing skill to create a BUG.md for something not covered by any existing spec?" 30)

if assert_contains "$output" "[Dd]o [Nn][Oo][Tt]\|not.*without.*spec\|spec.*must.*exist\|need.*spec\|require.*spec\|APPROVED" "Requires existing approved spec"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: Regression test mandatory
echo "Test 3: Regression test is mandatory..."

output=$(run_claude "Is a regression test optional or mandatory in the bugfixing workflow?" 30)

if assert_contains "$output" "mandatory\|required\|must\|always.*required\|not.*optional" "Regression test is mandatory"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All bugfixing skill tests passed ==="
