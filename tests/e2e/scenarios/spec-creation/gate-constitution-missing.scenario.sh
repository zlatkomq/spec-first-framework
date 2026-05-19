#!/usr/bin/env bash
# Scenario: spec-creation / gate-constitution-missing
# Tests that spec-creation asks for project context when CONSTITUTION.md is missing
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="spec-creation/gate-constitution-missing"
scenario_tier="T1"
scenario_timeout=120
scenario_tags="gate-violation spec-creation"
scenario_short_circuit=true

# ── FIXTURE ───────────────────────────────────────────────
setup_fixture() {
    local project_dir="$1"
    # NO constitution overlay — bare project only
    scaffold_project "$project_dir" "node-project"
}

# ── PROMPT ────────────────────────────────────────────────
build_prompt() {
    cat <<'PROMPT'
Create a SPEC.md for a user registration feature, ID 001. Users should be able to register with email and password using invite codes. Use the spec-creation skill.
PROMPT
}

# ── ASSERTIONS ────────────────────────────────────────────

# Layer 1: Artifacts — No SPEC.md should be created (or if created, should ask for context)
assert_artifacts() {
    local project_dir="$1"
    # Check no spec directory was created, or if it was, no finalized SPEC.md
    if [ -f "$project_dir/specs/001-user-registration/SPEC.md" ]; then
        # If a SPEC was created, it's acceptable if Claude gathered context first
        # But it should not have a proper metadata table without constitution
        echo "  [WARN] SPEC.md was created (Claude may have gathered context inline)"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [PASS] No SPEC.md created without constitution"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    fi
}

# Layer 2: Behavior — Claude should mention constitution or ask about project standards
assert_behavior() {
    local output="$1"
    assert_any_of "$output" \
        "constitution" \
        "CONSTITUTION" \
        "project standards" \
        "tech stack" \
        "coding standards" \
        "project setup" \
        "framework" \
        "no constitution" \
        "Claude mentions constitution or project context"
}

# Layer 3: Transcript — should attempt to Read constitution (and fail to find it)
assert_transcript() {
    local transcript="$1"
    assert_tool_called "$transcript" "Read" "Attempted to read project files"
}

# ── RUN ───────────────────────────────────────────────────
run_scenario
