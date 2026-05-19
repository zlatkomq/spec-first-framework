#!/usr/bin/env bash
# Scenario: design-creation / happy-path
# Tests that design-creation produces a valid DESIGN.md when SPEC is APPROVED
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="design-creation/happy-path"
scenario_tier="T2"
scenario_timeout=180
scenario_tags="happy-path design-creation artifact-creation"

# ── FIXTURE ───────────────────────────────────────────────
setup_fixture() {
    local project_dir="$1"
    scaffold_project "$project_dir" "node-project" "with-constitution" "with-approved-spec"
}

# ── PROMPT ────────────────────────────────────────────────
build_prompt() {
    cat <<'PROMPT'
Create the DESIGN.md for specs/001-user-registration/ using the design-creation skill. The project uses Node.js with the built-in node:test framework, as described in the constitution.
PROMPT
}

# ── ASSERTIONS ────────────────────────────────────────────

# Layer 1: Artifacts — DESIGN.md should be created with correct structure
assert_artifacts() {
    local project_dir="$1"
    local design="$project_dir/specs/001-user-registration/DESIGN.md"

    assert_file_exists "$design" "DESIGN.md was created"

    # Metadata checks
    # Claude may use "ID" or "Spec ID" — check for the value in any ID-like field
    assert_file_contains "$design" "001" "Contains spec ID 001"
    assert_md_field "$design" "Status" "DRAFT" "Status is DRAFT"

    # Required sections
    assert_md_section "$design" "Overview" "Has Overview section"
    assert_md_section "$design" "Architecture" "Has Architecture section"

    # No unresolved placeholders
    assert_no_placeholders "$design" "No template placeholders remain"
}

# Layer 2: Behavior — Claude's output should reference the skill and spec
assert_behavior() {
    local output="$1"
    assert_contains "$output" \
        "DESIGN\|design\|Design" \
        "Claude mentions creating the design"
}

# Layer 3: Transcript — should read SPEC.md before writing DESIGN.md
assert_transcript() {
    local transcript="$1"
    assert_tool_called "$transcript" "Read" "Read tool was used"
    assert_tool_called "$transcript" "Write" "Write tool was used"
}

# ── RUN ───────────────────────────────────────────────────
run_scenario
