#!/usr/bin/env bash
# Scenario: bugfixing / happy-path
# Tests that bugfixing skill produces a valid BUG.md
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="bugfixing/happy-path"
scenario_tier="T2"
scenario_timeout=180
scenario_tags="happy-path bugfixing artifact-creation"

# ── FIXTURE ───────────────────────────────────────────────
setup_fixture() {
    local project_dir="$1"
    scaffold_project "$project_dir" "node-project" "with-constitution" "with-approved-spec" "with-approved-design" "with-approved-tasks" "with-implementation"
}

# ── PROMPT ────────────────────────────────────────────────
build_prompt() {
    cat <<'PROMPT'
Create a BUG.md for a bug in specs/001-user-registration/ where email validation accepts emails without an @ symbol. The RegistrationService.register() method does not validate email format — users can register with strings like "notanemail". The expected behavior per the spec's acceptance criteria is that invalid inputs are rejected. Use the bugfixing skill.
PROMPT
}

# ── ASSERTIONS ────────────────────────────────────────────

# Layer 1: Artifacts — BUG.md should be created
assert_artifacts() {
    local project_dir="$1"

    # Bug file should exist somewhere under bugs/
    local bug_files
    bug_files=$(find "$project_dir/bugs" -name "BUG.md" -type f 2>/dev/null | head -1)

    if [ -n "$bug_files" ]; then
        echo "  [PASS] BUG.md was created"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))

        # Check for key sections
        assert_md_field "$bug_files" "Status" "DRAFT" "Bug status is DRAFT"
        assert_md_section "$bug_files" "Reproduction\|Steps\|Reproduce" "Has reproduction section"
    else
        echo "  [FAIL] No BUG.md found under bugs/"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# Layer 2: Behavior — Claude should mention bug classification
assert_behavior() {
    local output="$1"
    assert_any_of "$output" \
        "bug" \
        "BUG" \
        "email" \
        "validation" \
        "Claude mentions bug report"
}

# Layer 3: Transcript — should read SPEC.md
assert_transcript() {
    local transcript="$1"
    assert_tool_called "$transcript" "Read" "Read tool was used to check spec"
    assert_tool_called "$transcript" "Write" "Write tool was used to create BUG.md"
}

# ── RUN ───────────────────────────────────────────────────
run_scenario
