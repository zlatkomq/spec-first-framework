#!/usr/bin/env bash
# Scenario: chain / full-workflow
# Full Constitution → Spec → Design → Tasks → Implement → Review pipeline
# Invokes Claude 6 times sequentially with programmatic approvals between steps.
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/e2e-helpers.sh"

# ── METADATA ──────────────────────────────────────────────
scenario_name="chain/full-workflow"
scenario_tier="T3"
scenario_timeout=900
scenario_tags="chain full-workflow integration"

# ── HELPERS ──────────────────────────────────────────────

# Invoke Claude in a project directory with a prompt
invoke_claude() {
    local project_dir="$1"
    local prompt="$2"
    local step_timeout="${3:-180}"
    local output_file="$project_dir/.e2e-step-output.txt"

    if _timeout_cmd "$step_timeout" env -u CLAUDECODE bash -c \
        "cd '$project_dir' && claude -p \"\$1\" --plugin-dir \"$PLUGIN_DIR\" --dangerously-skip-permissions" \
        -- "$prompt" \
        > "$output_file" 2>&1; then
        cat "$output_file"
        return 0
    else
        local exit_code=$?
        cat "$output_file" >&2
        return $exit_code
    fi
}

# Approve an artifact by changing Status from DRAFT to APPROVED
approve_artifact() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
        sed -i.bak 's/| DRAFT |/| APPROVED |/g; s/|[[:space:]]*DRAFT[[:space:]]*|/| APPROVED |/g' "$file_path"
        rm -f "${file_path}.bak"
        echo "  [INFO] Approved: $(basename "$file_path")"
    else
        echo "  [WARN] Cannot approve — file not found: $file_path"
        return 1
    fi
}

# ── CUSTOM RUN ───────────────────────────────────────────

run_chain() {
    local start_time
    start_time=$(date +%s)

    echo ""
    echo "[$scenario_name] Starting full workflow chain..."

    # 1. Create isolated project directory
    local project_dir
    project_dir=$(mktemp -d)
    trap "rm -rf '$project_dir'" EXIT

    # Setup bare project with constitution
    echo "[$scenario_name] Setting up bare project..."
    scaffold_project "$project_dir" "node-project" "with-constitution"
    # Approve constitution (it comes as APPROVED in the fixture)

    _reset_assertion_counters
    local total_pass=0
    local total_fail=0
    local total_skip=0
    local layer_results=()
    local chain_failed=false

    # ── STEP 1: Create Spec ──────────────────────────────
    echo ""
    echo "[$scenario_name] STEP 1: Create Spec..."
    local spec_output
    spec_output=$(invoke_claude "$project_dir" \
        "Create a SPEC.md for user registration, ID 001, slug user-registration. Users should register with email, password, and invite code. Place it at specs/001-user-registration/SPEC.md. Use the spec-creation skill." \
        180) || true

    local spec_file="$project_dir/specs/001-user-registration/SPEC.md"
    if assert_file_exists "$spec_file" "Step 1: SPEC.md created"; then
        # Content/structure validation
        assert_md_field "$spec_file" "Status" "DRAFT" "Step 1: Status is DRAFT" || true
        assert_md_field "$spec_file" "ID" "001" "Step 1: ID is 001" || true
        assert_md_section "$spec_file" "Acceptance Criteria" "Step 1: Has Acceptance Criteria section" || true
        assert_md_section "$spec_file" "User Stories" "Step 1: Has User Stories section" || true
        assert_md_section "$spec_file" "Scope" "Step 1: Has Scope section" || true
        assert_ac_format "$spec_file" "Step 1: ACs use Given/When/Then format" || true
        assert_no_placeholders "$spec_file" "Step 1: No template placeholders" || true
    else
        chain_failed=true
    fi

    if [ "$chain_failed" = true ]; then
        local end_time; end_time=$(date +%s)
        layer_results+=("chain:FAIL(step-1-spec)")
        emit_result "$scenario_name" "$((end_time - start_time))" 0 1 0 \
            "$_ASSERTION_PASS" "$_ASSERTION_FAIL" "$_ASSERTION_SKIP" \
            "${layer_results[@]}"
        return 1
    fi

    # Approve spec
    approve_artifact "$spec_file"

    # ── STEP 2: Create Design ────────────────────────────
    echo ""
    echo "[$scenario_name] STEP 2: Create Design..."
    local design_output
    design_output=$(invoke_claude "$project_dir" \
        "Create DESIGN.md for specs/001-user-registration/ using the design-creation skill. The project uses Node.js with node:test." \
        180) || true

    local design_file="$project_dir/specs/001-user-registration/DESIGN.md"
    if assert_file_exists "$design_file" "Step 2: DESIGN.md created"; then
        # Content/structure validation
        assert_md_field "$design_file" "Status" "DRAFT" "Step 2: Status is DRAFT" || true
        assert_md_section "$design_file" "Architecture" "Step 2: Has Architecture section" || true
        assert_md_section "$design_file" "Overview" "Step 2: Has Overview section" || true
        assert_no_placeholders "$design_file" "Step 2: No template placeholders" || true
    else
        chain_failed=true
    fi

    if [ "$chain_failed" = true ]; then
        local end_time; end_time=$(date +%s)
        layer_results+=("chain:FAIL(step-2-design)")
        emit_result "$scenario_name" "$((end_time - start_time))" 0 1 0 \
            "$_ASSERTION_PASS" "$_ASSERTION_FAIL" "$_ASSERTION_SKIP" \
            "${layer_results[@]}"
        return 1
    fi

    # Approve design
    approve_artifact "$design_file"

    # ── STEP 3: Create Tasks ─────────────────────────────
    echo ""
    echo "[$scenario_name] STEP 3: Create Tasks..."
    local tasks_output
    tasks_output=$(invoke_claude "$project_dir" \
        "Create TASKS.md for specs/001-user-registration/ using the task-creation skill." \
        180) || true

    local tasks_file="$project_dir/specs/001-user-registration/TASKS.md"
    if assert_file_exists "$tasks_file" "Step 3: TASKS.md created"; then
        # Content/structure validation
        assert_md_field "$tasks_file" "Status" "DRAFT" "Step 3: Status is DRAFT" || true
        assert_file_contains "$tasks_file" "T1:" "Step 3: Has task T1" || true
        assert_file_contains "$tasks_file" "T2:" "Step 3: Has task T2 (more than one task)" || true
        assert_md_section "$tasks_file" "Definition of Done" "Step 3: Has Definition of Done section" || true
        assert_md_section "$tasks_file" "Testing" "Step 3: Has Testing section" || true
        assert_no_placeholders "$tasks_file" "Step 3: No template placeholders" || true
    else
        chain_failed=true
    fi

    if [ "$chain_failed" = true ]; then
        local end_time; end_time=$(date +%s)
        layer_results+=("chain:FAIL(step-3-tasks)")
        emit_result "$scenario_name" "$((end_time - start_time))" 0 1 0 \
            "$_ASSERTION_PASS" "$_ASSERTION_FAIL" "$_ASSERTION_SKIP" \
            "${layer_results[@]}"
        return 1
    fi

    # Approve tasks
    approve_artifact "$tasks_file"

    # ── STEP 4: Implement T1 ─────────────────────────────
    echo ""
    echo "[$scenario_name] STEP 4: Implement T1..."
    local impl_output
    impl_output=$(invoke_claude "$project_dir" \
        "Implement T1 from specs/001-user-registration/TASKS.md using the implementation skill. Follow TDD. Skip workspace isolation." \
        300) || true

    # Check that source files were created
    local src_count
    src_count=$(find "$project_dir/src" -name "*.js" -type f 2>/dev/null | wc -l | tr -d ' ')
    local test_count
    test_count=$(find "$project_dir/test" -name "*.js" -type f 2>/dev/null | wc -l | tr -d ' ')

    if [ "$src_count" -gt 0 ]; then
        echo "  [PASS] Step 4: Source files created ($src_count files)"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
    else
        echo "  [FAIL] Step 4: No source files created"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        chain_failed=true
    fi

    if [ "$test_count" -gt 0 ]; then
        echo "  [PASS] Step 4: Test files created ($test_count files)"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
    else
        echo "  [FAIL] Step 4: No test files created"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        chain_failed=true
    fi

    if [ "$chain_failed" = true ]; then
        local end_time; end_time=$(date +%s)
        layer_results+=("chain:FAIL(step-4-implement)")
        emit_result "$scenario_name" "$((end_time - start_time))" 0 1 0 \
            "$_ASSERTION_PASS" "$_ASSERTION_FAIL" "$_ASSERTION_SKIP" \
            "${layer_results[@]}"
        return 1
    fi

    # ── STEP 5: Code Review ──────────────────────────────
    echo ""
    echo "[$scenario_name] STEP 5: Code Review..."
    local review_output
    review_output=$(invoke_claude "$project_dir" \
        "Perform a code review for specs/001-user-registration/ using the code-review skill. Produce REVIEW.md." \
        300) || true

    local review_file="$project_dir/specs/001-user-registration/REVIEW.md"
    if assert_file_exists "$review_file" "Step 5: REVIEW.md created"; then
        # Content/structure validation
        assert_file_contains "$review_file" "APPROVED\|CHANGES REQUESTED\|BLOCKED" "Step 5: Has verdict" || true
        assert_md_section "$review_file" "Phase 0" "Step 5: Has Phase 0 (File Inventory)" || true
        assert_md_section "$review_file" "Phase 1" "Step 5: Has Phase 1 (Reality Check)" || true
        assert_md_section "$review_file" "Phase 2" "Step 5: Has Phase 2 (Spec Verification)" || true
        assert_md_section "$review_file" "Issues Found" "Step 5: Has Issues Found section" || true
    else
        chain_failed=true
    fi

    # ── SAVE ARTIFACTS ───────────────────────────────────
    if [ -n "${E2E_REPORT_DIR:-}" ]; then
        local artifact_dir="$E2E_REPORT_DIR/artifacts/$(echo "$scenario_name" | tr '/' '-')"
        mkdir -p "$artifact_dir"
        # Save all created markdown files
        find "$project_dir/specs" -name "*.md" -exec cp {} "$artifact_dir/" \; 2>/dev/null || true
        # Save source tree listing
        (cd "$project_dir" && find src test -type f 2>/dev/null) > "$artifact_dir/file-tree.txt" 2>/dev/null || true
    fi

    # ── REPORT ───────────────────────────────────────────
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))

    if [ "$chain_failed" = true ]; then
        layer_results+=("chain:FAIL")
        emit_result "$scenario_name" "$duration" 0 1 0 \
            "$_ASSERTION_PASS" "$_ASSERTION_FAIL" "$_ASSERTION_SKIP" \
            "${layer_results[@]}"
        return 1
    else
        layer_results+=("chain:PASS")
        emit_result "$scenario_name" "$duration" 1 0 "$total_skip" \
            "$_ASSERTION_PASS" "$_ASSERTION_FAIL" "$_ASSERTION_SKIP" \
            "${layer_results[@]}"
        return 0
    fi
}

run_chain
