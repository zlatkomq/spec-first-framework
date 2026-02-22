#!/usr/bin/env bash
# Scenario: smoke / infrastructure
# Trivial Claude prompt to validate CLI is reachable and report generation works.
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="smoke/infrastructure"
scenario_tier="T0"
scenario_timeout=60
scenario_tags="smoke infrastructure claude-reachable"

# ── FIXTURE ───────────────────────────────────────────────
setup_fixture() {
    local project_dir="$1"
    scaffold_project "$project_dir" "node-project" "with-constitution" "with-approved-spec"
}

# ── PROMPT ────────────────────────────────────────────────
build_prompt() {
    cat <<'PROMPT'
What is 2 + 2? Answer with just the number.
PROMPT
}

# ── ASSERTIONS ────────────────────────────────────────────

# Layer 1: Artifacts — scaffold produced expected files (no new files created)
assert_artifacts() {
    local project_dir="$1"
    assert_file_exists "$project_dir/package.json" "Base fixture intact"
    assert_file_exists "$project_dir/.framework/CONSTITUTION.md" "Constitution present"
    assert_file_exists "$project_dir/specs/001-user-registration/SPEC.md" "Spec present"
}

# Layer 2: Behavior — Claude responded (not empty, not error)
assert_behavior() {
    local output="$1"
    if [ -n "$output" ] && ! echo "$output" | grep -qi "error.*claude\|command not found\|ECONNREFUSED"; then
        echo "  [PASS] Claude responded successfully"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] Claude did not respond or returned error"
        echo "  Output: ${output:0:200}"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# ── RUN ───────────────────────────────────────────────────
run_scenario
