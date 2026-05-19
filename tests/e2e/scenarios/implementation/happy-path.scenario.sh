#!/usr/bin/env bash
# Scenario: implementation / happy-path
# Tests that implementation produces code and tests for a single task
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="implementation/happy-path"
scenario_tier="T2"
scenario_timeout=300
scenario_tags="happy-path implementation artifact-creation"

# ── FIXTURE ───────────────────────────────────────────────
setup_fixture() {
    local project_dir="$1"
    scaffold_project "$project_dir" "node-project" "with-constitution" "with-approved-spec" "with-approved-design" "with-approved-tasks"
}

# ── PROMPT ────────────────────────────────────────────────
build_prompt() {
    cat <<'PROMPT'
Implement T1 (Create PasswordUtils module) from specs/001-user-registration/TASKS.md using the implementation skill. Follow TDD: write the test first, then implement. Skip workspace isolation (no git worktree needed, we are already in an isolated directory).
PROMPT
}

# ── ASSERTIONS ────────────────────────────────────────────

# Layer 1: Artifacts — source and test files should be created
assert_artifacts() {
    local project_dir="$1"

    # At least one JS file should exist under src/
    assert_files_matching "$project_dir/src" "*.js" "Source files created under src/"

    # At least one test file should exist under test/
    assert_files_matching "$project_dir/test" "*.js" "Test files created under test/"
}

# Layer 2: Behavior — Claude should mention implementation progress
assert_behavior() {
    local output="$1"
    assert_any_of "$output" \
        "implement" \
        "creat" \
        "password" \
        "PasswordUtils" \
        "test" \
        "TDD" \
        "Claude mentions implementation activity"
}

# Layer 3: Transcript — should use Write and Bash (for running tests)
assert_transcript() {
    local transcript="$1"
    assert_tool_called "$transcript" "Write" "Write tool was used to create files"
    assert_tool_called "$transcript" "Bash" "Bash tool was used (test execution)"
}

# ── RUN ───────────────────────────────────────────────────
run_scenario
