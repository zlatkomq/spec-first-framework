#!/usr/bin/env bash
# Scenario: spec-creation / happy-path
# Tests that spec-creation produces a valid SPEC.md with BDD acceptance criteria
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="spec-creation/happy-path"
scenario_tier="T2"
scenario_timeout=180
scenario_tags="happy-path spec-creation artifact-creation"

# ── FIXTURE ───────────────────────────────────────────────
setup_fixture() {
    local project_dir="$1"
    scaffold_project "$project_dir" "node-project" "with-constitution"
}

# ── PROMPT ────────────────────────────────────────────────
build_prompt() {
    cat <<'PROMPT'
Create a SPEC.md for a password reset feature, ID 002, slug password-reset. Users should be able to request a password reset via email and set a new password using a time-limited token. Use the spec-creation skill. Place it at specs/002-password-reset/SPEC.md.
PROMPT
}

# ── ASSERTIONS ────────────────────────────────────────────

# Layer 1: Artifacts — SPEC.md should be created with correct structure
assert_artifacts() {
    local project_dir="$1"
    local spec="$project_dir/specs/002-password-reset/SPEC.md"

    assert_file_exists "$spec" "SPEC.md was created"

    # Metadata checks
    assert_file_contains "$spec" "002" "Contains spec ID 002"
    assert_md_field "$spec" "Status" "DRAFT" "Status is DRAFT"

    # Required sections
    assert_md_section "$spec" "Overview" "Has Overview section"
    assert_md_section "$spec" "Acceptance Criteria" "Has Acceptance Criteria section"
    assert_md_section "$spec" "Scope" "Has Scope section"

    # BDD format
    assert_ac_format "$spec" "Acceptance criteria use Given/When/Then"

    # No unresolved placeholders
    assert_no_placeholders "$spec" "No template placeholders remain"
}

# Layer 2: Behavior — Claude's output should reference spec creation
assert_behavior() {
    local output="$1"
    assert_any_of "$output" \
        "SPEC" \
        "spec" \
        "specification" \
        "password.*reset" \
        "Claude mentions creating the specification"
}

# Layer 3: Transcript — should read CONSTITUTION.md before writing SPEC.md
assert_transcript() {
    local transcript="$1"
    assert_tool_called "$transcript" "Read" "Read tool was used"
    assert_tool_called "$transcript" "Write" "Write tool was used"
}

# ── RUN ───────────────────────────────────────────────────
run_scenario
