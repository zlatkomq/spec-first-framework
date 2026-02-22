#!/usr/bin/env bash
# Scenario: task-creation / happy-path
# Tests that task-creation produces a valid TASKS.md when DESIGN is APPROVED
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="task-creation/happy-path"
scenario_tier="T2"
scenario_timeout=180
scenario_tags="happy-path task-creation artifact-creation"

# ── FIXTURE ───────────────────────────────────────────────
setup_fixture() {
    local project_dir="$1"
    scaffold_project "$project_dir" "node-project" "with-constitution" "with-approved-spec" "with-approved-design"
}

# ── PROMPT ────────────────────────────────────────────────
build_prompt() {
    cat <<'PROMPT'
Create TASKS.md for specs/001-user-registration/ using the task-creation skill. The project uses Node.js with the built-in node:test framework.
PROMPT
}

# ── ASSERTIONS ────────────────────────────────────────────

# Layer 1: Artifacts — TASKS.md should be created with correct structure
assert_artifacts() {
    local project_dir="$1"
    local tasks="$project_dir/specs/001-user-registration/TASKS.md"

    assert_file_exists "$tasks" "TASKS.md was created"

    # Metadata checks
    assert_file_contains "$tasks" "001" "Contains spec ID 001"
    assert_md_field "$tasks" "Status" "DRAFT" "Status is DRAFT"

    # Required sections
    assert_md_section "$tasks" "Tasks" "Has Tasks section"
    assert_md_section "$tasks" "Definition of Done" "Has Definition of Done section"

    # Task structure
    assert_file_contains "$tasks" "T1:" "Has at least T1"
    assert_file_contains "$tasks" "T2:" "Has at least T2"
    assert_file_contains "$tasks" "T3:" "Has at least T3"

    # Produces/Consumes contracts
    assert_file_contains "$tasks" "Produces:" "Has Produces declarations"

    # No unresolved placeholders
    assert_no_placeholders "$tasks" "No template placeholders remain"
}

# Layer 2: Behavior — Claude's output should reference task creation
assert_behavior() {
    local output="$1"
    assert_any_of "$output" \
        "TASKS" \
        "tasks" \
        "task" \
        "breakdown" \
        "Claude mentions creating tasks"
}

# Layer 3: Transcript — should read DESIGN.md before writing TASKS.md
assert_transcript() {
    local transcript="$1"
    assert_tool_called "$transcript" "Read" "Read tool was used"
    assert_tool_called "$transcript" "Write" "Write tool was used"
}

# ── RUN ───────────────────────────────────────────────────
run_scenario
