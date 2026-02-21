#!/usr/bin/env bash
# Test: constitution-creation skill
# Verifies key gates: one-question-at-a-time, concrete versions, DRAFT status
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: constitution-creation skill ==="
echo ""

# Test 1: One-question-at-a-time gate
echo "Test 1: One-question-at-a-time clarification style..."

output=$(run_claude "What does the constitution-creation skill say about how to ask clarifying questions? How many questions at once?" 30)

if assert_contains "$output" "one.*question\|ONE.*question\|single.*question\|one.*at.*a.*time" "Asks one question at a time"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Concrete versions required
echo "Test 2: Concrete version requirement..."

output=$(run_claude "In the constitution-creation skill, what happens if the tech stack says 'Python latest' instead of a specific version number?" 30)

if assert_contains "$output" "ask\|concrete\|specific.*version\|version.*number\|not.*latest" "Requires concrete version numbers"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: DRAFT status
echo "Test 3: DRAFT status on output..."

output=$(run_claude "What status does the constitution-creation skill set on the output document? Who approves it?" 30)

if assert_contains "$output" "DRAFT" "Output starts as DRAFT"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "Tech Lead\|tech lead\|human\|approve" "Tech Lead approves"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All constitution-creation skill tests passed ==="
