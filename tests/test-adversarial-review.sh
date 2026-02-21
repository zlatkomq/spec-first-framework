#!/usr/bin/env bash
# Test: adversarial-review skill
# Verifies key gates: find 10+ issues, 4-part structure, don't fix content
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: adversarial-review skill ==="
echo ""

# Test 1: Find at least 10 issues
echo "Test 1: Find at least 10 issues..."

output=$(run_claude "How many issues does the adversarial-review skill require finding? What if you find fewer?" 30)

if assert_contains "$output" "10.*issue\|ten.*issue\|at least.*10\|minimum.*10" "Requires at least 10 issues"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: 4-part structure (What/Where/Why/How)
echo "Test 2: Issue structure..."

output=$(run_claude "For each issue in the adversarial-review skill, what parts or sections must be provided?" 30)

if assert_contains "$output" "[Ww]hat" "Includes What"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "[Ww]here" "Includes Where"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "[Ww]hy" "Includes Why"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "[Hh]ow\|[Ff]ix" "Includes How/Fix"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: Don't fix content
echo "Test 3: Don't fix content..."

output=$(run_claude "In the adversarial-review skill, should the AI fix the problems it finds or only report them?" 30)

if assert_contains "$output" "[Dd]o [Nn][Oo][Tt] fix\|not.*fix\|only.*report\|report.*issue\|don't.*fix" "Does not fix content, only reports"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All adversarial-review skill tests passed ==="
