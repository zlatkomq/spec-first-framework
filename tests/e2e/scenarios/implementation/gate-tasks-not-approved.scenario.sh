#!/usr/bin/env bash
# Scenario: implementation / gate-tasks-not-approved
# Tests that implementation STOPS when TASKS.md has Status: DRAFT
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="implementation/gate-tasks-not-approved"
scenario_tier="T1"
scenario_timeout=120
scenario_tags="gate-violation implementation"
scenario_short_circuit=true

# ── FIXTURE ───────────────────────────────────────────────
setup_fixture() {
    local project_dir="$1"
    scaffold_project "$project_dir" "node-project" "with-constitution" "with-approved-spec" "with-approved-design" "with-draft-tasks"
}

# ── PROMPT ────────────────────────────────────────────────
build_prompt() {
    cat <<'PROMPT'
Implement T1 from specs/001-user-registration/TASKS.md using the implementation skill.
PROMPT
}

# ── ASSERTIONS ────────────────────────────────────────────

# Layer 1: Artifacts — No source files should be created
assert_artifacts() {
    local project_dir="$1"
    assert_no_files_matching "$project_dir/src" "*.js" \
        "No source files created when TASKS is DRAFT"
}

# Layer 2: Behavior — Claude should refuse and mention tasks approval
assert_behavior() {
    local output="$1"
    assert_any_of "$output" \
        "STOP" \
        "not.*approved" \
        "cannot.*proceed" \
        "DRAFT" \
        "TASKS.*approved" \
        "tasks.*approved" \
        "must.*approved" \
        "needs.*approv" \
        "approval.*required" \
        "Claude refuses and mentions tasks approval requirement"
}

# Layer 3: Transcript — no Write tool calls should occur
assert_transcript() {
    local transcript="$1"
    assert_no_tool_calls "$transcript" "Write" \
        "No Write tool calls when gate blocks"
}

# ── RUN ───────────────────────────────────────────────────
run_scenario
