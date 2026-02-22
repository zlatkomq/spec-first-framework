#!/usr/bin/env bash
# Scenario: code-review / happy-path
# Tests that code-review produces a valid REVIEW.md for a completed implementation
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="code-review/happy-path"
scenario_tier="T2"
scenario_timeout=300
scenario_tags="happy-path code-review artifact-creation"

# ── FIXTURE ───────────────────────────────────────────────
setup_fixture() {
    local project_dir="$1"
    scaffold_project "$project_dir" "node-project" "with-constitution" "with-approved-spec" "with-approved-design" "with-approved-tasks" "with-implementation"
}

# ── PROMPT ────────────────────────────────────────────────
build_prompt() {
    cat <<'PROMPT'
Perform a code review for specs/001-user-registration/ using the code-review skill. The implementation is complete with all tests passing. Produce REVIEW.md at specs/001-user-registration/REVIEW.md.
PROMPT
}

# ── ASSERTIONS ────────────────────────────────────────────

# Layer 1: Artifacts — REVIEW.md should be created with correct structure
assert_artifacts() {
    local project_dir="$1"
    local review="$project_dir/specs/001-user-registration/REVIEW.md"

    assert_file_exists "$review" "REVIEW.md was created"

    # Should have a verdict
    assert_any_of "$(cat "$review" 2>/dev/null)" \
        "APPROVED" \
        "CHANGES REQUESTED" \
        "BLOCKED" \
        "Review has a verdict"
}

# Layer 2: Behavior — Claude should mention the review process
assert_behavior() {
    local output="$1"
    assert_any_of "$output" \
        "review" \
        "REVIEW" \
        "verdict" \
        "APPROVED" \
        "CHANGES" \
        "BLOCKED" \
        "phase" \
        "Claude mentions review process"
}

# Layer 3: Transcript — should read source files and run tests
assert_transcript() {
    local transcript="$1"
    assert_tool_called "$transcript" "Read" "Read tool was used to review code"
    assert_tool_called "$transcript" "Bash" "Bash tool was used (test execution)"
}

# ── RUN ───────────────────────────────────────────────────
run_scenario
