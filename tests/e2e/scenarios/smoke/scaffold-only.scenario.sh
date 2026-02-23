#!/usr/bin/env bash
# Scenario: smoke / scaffold-only
# Zero API cost. Validates fixture composition produces expected file structure.
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="smoke/scaffold-only"
scenario_tier="T0"
scenario_timeout=30
scenario_tags="smoke infrastructure"

# Override run_scenario — no Claude invocation needed
run_smoke() {
    local start_time
    start_time=$(date +%s)

    echo ""
    echo "[$scenario_name] Starting scenario..."
    _reset_assertion_counters

    local total_pass=0
    local total_fail=0
    local fail=false

    # Test 1: Base + constitution + approved spec
    echo "[$scenario_name] Testing: node-project + with-constitution + with-approved-spec..."
    local dir1
    dir1=$(mktemp -d)
    scaffold_project "$dir1" "node-project" "with-constitution" "with-approved-spec"

    assert_file_exists "$dir1/package.json" "Base has package.json" || fail=true
    assert_file_exists "$dir1/CONSTITUTION.md" "Constitution overlay applied" || fail=true
    assert_md_field "$dir1/CONSTITUTION.md" "Status" "APPROVED" "Constitution is APPROVED" || fail=true
    assert_file_exists "$dir1/specs/001-user-registration/SPEC.md" "Spec overlay applied" || fail=true
    assert_md_field "$dir1/specs/001-user-registration/SPEC.md" "Status" "APPROVED" "Spec is APPROVED" || fail=true
    assert_file_exists "$dir1/.git/HEAD" "Git repo initialized" || fail=true
    rm -rf "$dir1"

    # Test 2: Base + draft spec
    echo "[$scenario_name] Testing: node-project + with-constitution + with-draft-spec..."
    local dir2
    dir2=$(mktemp -d)
    scaffold_project "$dir2" "node-project" "with-constitution" "with-draft-spec"

    assert_md_field "$dir2/specs/001-user-registration/SPEC.md" "Status" "DRAFT" "Draft spec has DRAFT status" || fail=true
    rm -rf "$dir2"

    # Test 3: Design overlays
    echo "[$scenario_name] Testing: design overlays..."
    local dir3
    dir3=$(mktemp -d)
    scaffold_project "$dir3" "node-project" "with-constitution" "with-approved-spec" "with-approved-design"

    assert_file_exists "$dir3/specs/001-user-registration/DESIGN.md" "Design overlay applied" || fail=true
    assert_md_field "$dir3/specs/001-user-registration/DESIGN.md" "Status" "APPROVED" "Design is APPROVED" || fail=true
    rm -rf "$dir3"

    # Test 4: Tasks overlay
    echo "[$scenario_name] Testing: tasks overlay..."
    local dir4
    dir4=$(mktemp -d)
    scaffold_project "$dir4" "node-project" "with-constitution" "with-approved-spec" "with-approved-design" "with-approved-tasks"

    assert_file_exists "$dir4/specs/001-user-registration/TASKS.md" "Tasks overlay applied" || fail=true
    assert_md_field "$dir4/specs/001-user-registration/TASKS.md" "Status" "APPROVED" "Tasks is APPROVED" || fail=true
    rm -rf "$dir4"

    # Test 5: Implementation overlay (tests pass)
    echo "[$scenario_name] Testing: implementation overlay (npm test)..."
    local dir5
    dir5=$(mktemp -d)
    scaffold_project "$dir5" "node-project" "with-constitution" "with-approved-spec" "with-approved-design" "with-approved-tasks" "with-implementation"

    assert_file_exists "$dir5/src/services/registration-service.js" "Implementation source exists" || fail=true
    assert_file_exists "$dir5/test/unit/registration-service.test.js" "Implementation tests exist" || fail=true
    assert_file_exists "$dir5/specs/001-user-registration/IMPLEMENTATION-SUMMARY.md" "Implementation summary exists" || fail=true

    # Verify tests actually pass
    if (cd "$dir5" && node --test 2>&1 | grep -q "^# fail 0\|ℹ fail 0"); then
        echo "  [PASS] Implementation tests pass"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
    else
        echo "  [FAIL] Implementation tests do not pass"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        fail=true
    fi
    rm -rf "$dir5"

    # Test 6: Bug overlay
    echo "[$scenario_name] Testing: bug overlay..."
    local dir6
    dir6=$(mktemp -d)
    scaffold_project "$dir6" "node-project" "with-confirmed-bug"

    assert_file_exists "$dir6/bugs/BUG-001-email-validation/BUG.md" "Bug overlay applied" || fail=true
    assert_md_field "$dir6/bugs/BUG-001-email-validation/BUG.md" "Status" "CONFIRMED" "Bug is CONFIRMED" || fail=true
    rm -rf "$dir6"

    # Report
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))

    local layers=()
    if [ "$fail" = true ]; then
        layers+=("scaffold:FAIL")
        emit_result "$scenario_name" "$duration" 0 1 0 \
            "$_ASSERTION_PASS" "$_ASSERTION_FAIL" "$_ASSERTION_SKIP" \
            "${layers[@]}"
        return 1
    else
        layers+=("scaffold:PASS")
        emit_result "$scenario_name" "$duration" 1 0 0 \
            "$_ASSERTION_PASS" "$_ASSERTION_FAIL" "$_ASSERTION_SKIP" \
            "${layers[@]}"
        return 0
    fi
}

run_smoke
