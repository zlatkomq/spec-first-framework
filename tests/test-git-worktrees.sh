#!/usr/bin/env bash
# Test: git-worktrees skill
# Verifies key gates: directory priority, .gitignore safety check, no duplicate worktrees
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: git-worktrees skill ==="
echo ""

# Test 1: Directory priority order
echo "Test 1: Directory selection priority..."

output=$(run_claude "In the git-worktrees skill, if both .worktrees/ and worktrees/ directories exist, which takes precedence?" 30)

if assert_contains "$output" "\.worktrees\|dot.*worktrees\|hidden" ".worktrees/ takes precedence"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: .gitignore safety check
echo "Test 2: .gitignore safety gate..."

output=$(run_claude "In the git-worktrees skill, before creating a project-local worktree directory, what must be verified first?" 30)

if assert_contains "$output" "\.gitignore\|git.*ignore\|ignored" "Must verify .gitignore coverage"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: No duplicate worktrees
echo "Test 3: No duplicate worktrees..."

output=$(run_claude "In the git-worktrees skill, what happens if a worktree already exists for the target branch?" 30)

if assert_contains "$output" "already.*exist\|exist.*worktree\|skip.*creat\|cd.*into\|use.*existing\|not.*duplicate" "Detects existing worktree and skips creation"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All git-worktrees skill tests passed ==="
