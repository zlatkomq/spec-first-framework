#!/usr/bin/env bash
# Scenario: task-creation / gate-design-not-approved
# Tests that task-creation STOPS when DESIGN.md has Status: DRAFT
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="task-creation/gate-design-not-approved"
scenario_tier="T1"
scenario_timeout=120
scenario_tags="gate-violation task-creation"
scenario_short_circuit=true

# ── FIXTURE ───────────────────────────────────────────────
setup_fixture() {
    local project_dir="$1"
    scaffold_project "$project_dir" "node-project" "with-constitution" "with-approved-spec" "with-draft-design"
}

# ── PROMPT ────────────────────────────────────────────────
build_prompt() {
    cat <<'PROMPT'
Create TASKS.md for specs/001-user-registration/ using the task-creation skill.
PROMPT
}

# ── ASSERTIONS ────────────────────────────────────────────

# Layer 1: Artifacts — TASKS.md should NOT be created
assert_artifacts() {
    local project_dir="$1"
    assert_file_not_exists "$project_dir/specs/001-user-registration/TASKS.md" \
        "TASKS.md should NOT be created when DESIGN is DRAFT"
}

# Layer 2: Behavior — Claude should refuse and mention design approval
assert_behavior() {
    local output="$1"
    assert_any_of "$output" \
        "STOP" \
        "not.*approved" \
        "cannot.*proceed" \
        "DRAFT" \
        "DESIGN.*approved" \
        "design.*approved" \
        "must.*approved" \
        "needs.*approv" \
        "approval.*required" \
        "Claude refuses and mentions design approval requirement"
}

# Layer 3: Transcript — no Write tool calls should occur
assert_transcript() {
    local transcript="$1"
    assert_no_tool_calls "$transcript" "Write" \
        "No Write tool calls when gate blocks"
}

# ── RUN ───────────────────────────────────────────────────
run_scenario
