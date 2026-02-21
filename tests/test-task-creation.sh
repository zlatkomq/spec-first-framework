#!/usr/bin/env bash
# Test: task-creation skill
# Verifies key gates: DESIGN must be APPROVED, atomic tasks, Produces/Consumes
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: task-creation skill ==="
echo ""

# Test 1: DESIGN must be APPROVED gate
echo "Test 1: DESIGN must be APPROVED..."

output=$(run_claude "The DESIGN.md exists but the Tech Lead hasn't approved it yet. Can I use the task-creation skill now?" 30)

if assert_contains "$output" "STOP\|stop\|not.*approved\|must.*APPROVED\|cannot.*proceed" "Stops if design not approved"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Atomic tasks with DESIGN references
echo "Test 2: Atomic tasks with DESIGN references..."

output=$(run_claude "What makes a task valid in the task-creation skill? What must every task reference?" 30)

if assert_contains "$output" "atomic\|single.*prompt\|small\|focused" "Tasks must be atomic"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "DESIGN\|design.*reference\|DESIGN:" "Must reference DESIGN.md section"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: Produces/Consumes contracts
echo "Test 3: Produces/Consumes interface contracts..."

output=$(run_claude "In the task-creation skill, what are Produces and Consumes declarations and when are they required?" 30)

if assert_contains "$output" "Produces\|Consumes" "Mentions Produces/Consumes"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "interface\|contract\|depend\|public.*interface\|task.*ID\|signature" "Explains dependency contracts"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All task-creation skill tests passed ==="
