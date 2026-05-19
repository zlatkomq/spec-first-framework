#!/usr/bin/env bash
# Scenario: design-creation / gate-spec-not-approved
# Tests that design-creation STOPS when SPEC.md has Status: DRAFT
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="design-creation/gate-spec-not-approved"
scenario_tier="T1"
scenario_timeout=120
scenario_tags="gate-violation design-creation"
scenario_short_circuit=true

# ── FIXTURE ───────────────────────────────────────────────
setup_fixture() {
    local project_dir="$1"
    scaffold_project "$project_dir" "node-project" "with-constitution" "with-draft-spec"
}

# ── PROMPT ────────────────────────────────────────────────
build_prompt() {
    cat <<'PROMPT'
I have a SPEC.md at specs/001-user-registration/SPEC.md. Please create the DESIGN.md for it using the design-creation skill.
PROMPT
}

# ── ASSERTIONS ────────────────────────────────────────────

# Layer 1: Artifacts — DESIGN.md should NOT be created
assert_artifacts() {
    local project_dir="$1"
    assert_file_not_exists "$project_dir/specs/001-user-registration/DESIGN.md" \
        "DESIGN.md should NOT be created when SPEC is DRAFT"
}

# Layer 2: Behavior — Claude should refuse and mention approval
assert_behavior() {
    local output="$1"
    assert_any_of "$output" \
        "STOP" \
        "not.*approved" \
        "cannot.*proceed" \
        "DRAFT" \
        "not yet approved" \
        "must be.*APPROVED" \
        "must.*approved" \
        "needs.*approv" \
        "status.*draft" \
        "approve.*first" \
        "approval.*required" \
        "Claude refuses and mentions approval requirement"
}

# Layer 3: Transcript — no Write tool calls should occur
assert_transcript() {
    local transcript="$1"
    assert_no_tool_calls "$transcript" "Write" \
        "No Write tool calls when gate blocks"
}

# ── RUN ───────────────────────────────────────────────────
run_scenario
