#!/usr/bin/env bash
# E2E test helpers — execution engine and extended assertions
# Sources the base test-helpers.sh and adds fixture, transcript, and artifact assertions.

E2E_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_DIR="$(cd "$E2E_DIR/.." && pwd)"

# Source base helpers (run_claude, assert_contains, assert_not_contains, assert_count, assert_order)
source "$TESTS_DIR/test-helpers.sh"

# ─── REPORT FILE ──────────────────────────────────────────
E2E_REPORT_DIR="${E2E_REPORT_DIR:-$E2E_DIR/reports/$(date +%Y-%m-%d-%H%M%S)}"
E2E_REPORT_FILE="${E2E_REPORT_FILE:-$E2E_REPORT_DIR/scenario-results.jsonl}"

# ─── GRANULAR ASSERTION COUNTERS ─────────────────────────
# Reset before each assertion layer; individual assertion functions increment these.
_ASSERTION_PASS=0
_ASSERTION_FAIL=0
_ASSERTION_SKIP=0

_reset_assertion_counters() {
    _ASSERTION_PASS=0
    _ASSERTION_FAIL=0
    _ASSERTION_SKIP=0
}

# ─── SCAFFOLD ─────────────────────────────────────────────

# Compose a project from a base + overlays into a target directory
# Usage: scaffold_project "/tmp/xyz" "node-project" "with-constitution" "with-approved-spec"
scaffold_project() {
    local target="$1"
    shift
    bash "$E2E_DIR/fixtures/scaffold.sh" "$target" "$@"
}

# ─── SESSION TRANSCRIPT DISCOVERY ─────────────────────────

# Find the most recent JSONL session transcript for a working directory
# Usage: find_latest_session_transcript "/tmp/project-dir"
find_latest_session_transcript() {
    local project_dir="$1"
    # Use eval echo ~ to resolve home even when $HOME is empty
    local real_home
    real_home=$(eval echo ~)
    local claude_projects="$real_home/.claude/projects"

    if [ ! -d "$claude_projects" ]; then
        return
    fi

    # Match by temp dir basename with Claude's escaping applied (/, _, . → -)
    local dir_basename
    dir_basename=$(basename "$project_dir" | sed 's/[._]/-/g')

    local session_dir
    session_dir=$(find "$claude_projects" -maxdepth 1 -type d -name "*${dir_basename}*" 2>/dev/null | head -1)

    if [ -n "$session_dir" ]; then
        # Exclude subagent transcripts, get most recent main session
        find "$session_dir" -name "*.jsonl" -not -path "*/subagents/*" -type f -mmin -60 2>/dev/null | sort -r | head -1
    fi
}

# ─── FILE SYSTEM ASSERTIONS ──────────────────────────────

assert_file_exists() {
    local file_path="$1"
    local test_name="${2:-file exists: $(basename "$file_path")}"
    if [ -f "$file_path" ]; then
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected file to exist: $file_path"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

assert_file_not_exists() {
    local file_path="$1"
    local test_name="${2:-file not exists: $(basename "$file_path")}"
    if [ ! -f "$file_path" ]; then
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected file NOT to exist: $file_path"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

assert_file_contains() {
    local file_path="$1"
    local pattern="$2"
    local test_name="${3:-file contains: $pattern}"
    if [ ! -f "$file_path" ]; then
        echo "  [FAIL] $test_name (file not found: $file_path)"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
    if grep -q "$pattern" "$file_path"; then
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected file $file_path to contain: $pattern"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# Assert no files matching a glob exist (useful for gate scenarios)
# Usage: assert_no_files_matching "/tmp/project/src" "*.js" "No JS files created"
assert_no_files_matching() {
    local search_dir="$1"
    local pattern="$2"
    local test_name="${3:-no files matching: $pattern}"
    if [ ! -d "$search_dir" ]; then
        echo "  [PASS] $test_name (directory does not exist)"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    fi
    local count
    count=$(find "$search_dir" -name "$pattern" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -eq 0 ]; then
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Found $count file(s) matching '$pattern' in $search_dir"
        find "$search_dir" -name "$pattern" -type f 2>/dev/null | head -5 | sed 's/^/    /'
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# Assert at least one file matching a glob exists
# Usage: assert_files_matching "/tmp/project/src" "*.js" "JS files created"
assert_files_matching() {
    local search_dir="$1"
    local pattern="$2"
    local test_name="${3:-files matching: $pattern}"
    if [ ! -d "$search_dir" ]; then
        echo "  [FAIL] $test_name (directory does not exist: $search_dir)"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
    local count
    count=$(find "$search_dir" -name "$pattern" -type f 2>/dev/null | wc -l | tr -d ' ')
    if [ "$count" -gt 0 ]; then
        echo "  [PASS] $test_name (found $count file(s))"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  No files matching '$pattern' found in $search_dir"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# ─── MARKDOWN STRUCTURE ASSERTIONS ────────────────────────

# Check metadata table field value: | Field | Value |
assert_md_field() {
    local file_path="$1"
    local field_name="$2"
    local expected_value="$3"
    local test_name="${4:-metadata $field_name = $expected_value}"
    if [ ! -f "$file_path" ]; then
        echo "  [FAIL] $test_name (file not found)"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
    if grep -qE "^\|[[:space:]]*${field_name}[[:space:]]*\|.*${expected_value}" "$file_path"; then
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected | $field_name | ... $expected_value ... | in $(basename "$file_path")"
        local actual
        actual=$(grep -E "^\|[[:space:]]*${field_name}[[:space:]]*\|" "$file_path" | head -1)
        echo "  Actual: ${actual:-<field not found>}"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# Check that a markdown section heading exists
assert_md_section() {
    local file_path="$1"
    local section="$2"
    local test_name="${3:-section exists: $section}"
    if [ ! -f "$file_path" ]; then
        echo "  [FAIL] $test_name (file not found)"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
    if grep -qE "^#{1,4}[[:space:]]+${section}" "$file_path"; then
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected section heading '$section' in $(basename "$file_path")"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# Check that a markdown section heading does NOT exist (for omitted conditional sections)
assert_md_no_section() {
    local file_path="$1"
    local section="$2"
    local test_name="${3:-section omitted: $section}"
    if [ ! -f "$file_path" ]; then
        echo "  [PASS] $test_name (file doesn't exist, section trivially absent)"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    fi
    if grep -qE "^#{1,4}[[:space:]]+${section}" "$file_path"; then
        echo "  [FAIL] $test_name"
        echo "  Section '$section' should be omitted in $(basename "$file_path")"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    else
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    fi
}

# Check for Given/When/Then BDD format in acceptance criteria
assert_ac_format() {
    local file_path="$1"
    local test_name="${2:-acceptance criteria use Given/When/Then}"
    if [ ! -f "$file_path" ]; then
        echo "  [FAIL] $test_name (file not found)"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
    local ac_count
    ac_count=$(grep -ciE "given.*when.*then" "$file_path" || echo "0")
    if [ "$ac_count" -ge 1 ]; then
        echo "  [PASS] $test_name (found $ac_count BDD criteria)"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  No Given/When/Then criteria found"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# Check for unresolved template placeholders
assert_no_placeholders() {
    local file_path="$1"
    local test_name="${2:-no template placeholders}"
    if [ ! -f "$file_path" ]; then
        echo "  [FAIL] $test_name (file not found)"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
    if grep -qE '\[.*describe.*\]|\[.*here.*\]|\[.*TODO.*\]|XXX' "$file_path"; then
        echo "  [FAIL] $test_name"
        echo "  Found unresolved placeholders in $(basename "$file_path"):"
        grep -nE '\[.*describe.*\]|\[.*here.*\]|\[.*TODO.*\]|XXX' "$file_path" | sed 's/^/    /'
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    else
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    fi
}

# ─── TRANSCRIPT ASSERTIONS ───────────────────────────────
# Exit code convention: 0=PASS, 1=FAIL, 2=SKIP (transcript unavailable)

# Check that a tool was called in the session transcript
assert_tool_called() {
    local transcript_file="$1"
    local tool_name="$2"
    local test_name="${3:-tool called: $tool_name}"
    if [ -z "$transcript_file" ] || [ ! -f "$transcript_file" ]; then
        echo "  [SKIP] $test_name (no transcript)"
        _ASSERTION_SKIP=$((_ASSERTION_SKIP + 1))
        return 2
    fi
    if grep -q "\"name\":\"$tool_name\"" "$transcript_file"; then
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Tool '$tool_name' was not called"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# Check that a tool was NOT called
assert_no_tool_calls() {
    local transcript_file="$1"
    local tool_name="$2"
    local test_name="${3:-tool not called: $tool_name}"
    if [ -z "$transcript_file" ] || [ ! -f "$transcript_file" ]; then
        echo "  [SKIP] $test_name (no transcript)"
        _ASSERTION_SKIP=$((_ASSERTION_SKIP + 1))
        return 2
    fi
    if grep -q "\"name\":\"$tool_name\"" "$transcript_file"; then
        local count
        count=$(grep -c "\"name\":\"$tool_name\"" "$transcript_file" || echo "0")
        echo "  [FAIL] $test_name"
        echo "  Tool '$tool_name' was called $count time(s) but should not have been"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    else
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    fi
}

# Check tool call ordering in transcript
assert_tool_order() {
    local transcript_file="$1"
    local tool_a="$2"
    local tool_b="$3"
    local test_name="${4:-$tool_a before $tool_b}"
    if [ -z "$transcript_file" ] || [ ! -f "$transcript_file" ]; then
        echo "  [SKIP] $test_name (no transcript)"
        _ASSERTION_SKIP=$((_ASSERTION_SKIP + 1))
        return 2
    fi
    local line_a line_b
    line_a=$(grep -n "\"name\":\"$tool_a\"" "$transcript_file" | head -1 | cut -d: -f1)
    line_b=$(grep -n "\"name\":\"$tool_b\"" "$transcript_file" | head -1 | cut -d: -f1)
    if [ -z "$line_a" ] || [ -z "$line_b" ]; then
        echo "  [FAIL] $test_name (one or both tools not found)"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
    if [ "$line_a" -lt "$line_b" ]; then
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name ($tool_a at line $line_a, $tool_b at line $line_b)"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# Check that Skill tool was invoked with a specific skill name
assert_skill_invoked() {
    local transcript_file="$1"
    local skill_name="$2"
    local test_name="${3:-skill invoked: $skill_name}"
    if [ -z "$transcript_file" ] || [ ! -f "$transcript_file" ]; then
        echo "  [SKIP] $test_name (no transcript)"
        _ASSERTION_SKIP=$((_ASSERTION_SKIP + 1))
        return 2
    fi
    if grep "\"name\":\"Skill\"" "$transcript_file" | grep -q "\"$skill_name\""; then
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name"
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# Check no tools were invoked before Skill tool (premature action detection)
assert_no_premature_action() {
    local transcript_file="$1"
    local test_name="${2:-no premature action before Skill invocation}"
    if [ -z "$transcript_file" ] || [ ! -f "$transcript_file" ]; then
        echo "  [SKIP] $test_name (no transcript)"
        _ASSERTION_SKIP=$((_ASSERTION_SKIP + 1))
        return 2
    fi
    local first_skill_line
    first_skill_line=$(grep -n '"name":"Skill"' "$transcript_file" | head -1 | cut -d: -f1)
    if [ -z "$first_skill_line" ]; then
        echo "  [SKIP] $test_name (no Skill invocation found)"
        _ASSERTION_SKIP=$((_ASSERTION_SKIP + 1))
        return 2
    fi
    local premature
    premature=$(head -n "$first_skill_line" "$transcript_file" | \
        grep '"type":"tool_use"' | \
        grep -v '"name":"Skill"' | \
        grep -v '"name":"TodoWrite"' || true)
    if [ -n "$premature" ]; then
        echo "  [FAIL] $test_name"
        echo "  Tools invoked before Skill:"
        echo "$premature" | head -3 | sed 's/^/    /'
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    else
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    fi
}

# ─── FUZZY / LLM-TOLERANT ASSERTIONS ─────────────────────

# Assert output matches ANY of several patterns (OR logic)
# Usage: assert_any_of "$output" "pattern1" "pattern2" "pattern3" "test name"
# Last argument is the test name, rest are patterns
assert_any_of() {
    local output="$1"
    shift
    local test_name="${!#}"  # last argument
    local count=$#
    local i=0

    for arg in "$@"; do
        i=$((i + 1))
        [ "$i" -eq "$count" ] && break  # skip last (test name)
        if echo "$output" | grep -qi "$arg"; then
            echo "  [PASS] $test_name (matched: $arg)"
            _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
            return 0
        fi
    done

    echo "  [FAIL] $test_name"
    echo "  None of the expected patterns matched"
    _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
    return 1
}

# Assert output matches ALL of several patterns (AND logic)
# Usage: assert_all_of "$output" "pattern1" "pattern2" "test name"
assert_all_of() {
    local output="$1"
    shift
    local test_name="${!#}"
    local count=$#
    local i=0
    local missing=()

    for arg in "$@"; do
        i=$((i + 1))
        [ "$i" -eq "$count" ] && break
        if ! echo "$output" | grep -qi "$arg"; then
            missing+=("$arg")
        fi
    done

    if [ ${#missing[@]} -eq 0 ]; then
        echo "  [PASS] $test_name"
        _ASSERTION_PASS=$((_ASSERTION_PASS + 1))
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Missing patterns:"
        for p in "${missing[@]}"; do
            echo "    - $p"
        done
        _ASSERTION_FAIL=$((_ASSERTION_FAIL + 1))
        return 1
    fi
}

# ─── RESULT REPORTING ─────────────────────────────────────

emit_result() {
    local name="$1"
    local duration="$2"
    local pass_count="$3"
    local fail_count="$4"
    local skip_count="$5"
    local assertion_pass="$6"
    local assertion_fail="$7"
    local assertion_skip="$8"
    shift 8
    local layers=("$@")

    local status="PASS"
    if [ "$fail_count" -gt 0 ]; then
        status="FAIL"
    elif [ "$skip_count" -gt 0 ]; then
        status="PASS_WITH_SKIPS"
    fi

    echo ""
    echo "  [$status] $name (${duration}s)"
    for layer in "${layers[@]}"; do
        echo "    $layer"
    done
    echo "    assertions: ${assertion_pass} passed, ${assertion_fail} failed, ${assertion_skip} skipped"

    # Append to JSONL report if report dir exists
    if [ -n "${E2E_REPORT_FILE:-}" ]; then
        mkdir -p "$(dirname "$E2E_REPORT_FILE")"
        local layers_json=""
        for layer in "${layers[@]}"; do
            layers_json="${layers_json}\"${layer}\","
        done
        layers_json="[${layers_json%,}]"
        local timestamp
        timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
        echo "{\"scenario\":\"$name\",\"tier\":\"${scenario_tier:-}\",\"status\":\"$status\",\"duration\":$duration,\"pass\":$pass_count,\"fail\":$fail_count,\"skip\":$skip_count,\"assertions\":{\"pass\":$assertion_pass,\"fail\":$assertion_fail,\"skip\":$assertion_skip},\"layers\":$layers_json,\"timestamp\":\"$timestamp\"}" >> "$E2E_REPORT_FILE"
    fi
}

# ─── SCENARIO EXECUTION ENGINE ────────────────────────────

run_scenario() {
    local start_time
    start_time=$(date +%s)

    echo ""
    echo "[$scenario_name] Starting scenario..."

    # 1. Create isolated project directory
    local project_dir
    project_dir=$(mktemp -d)
    trap "rm -rf '$project_dir'" EXIT

    # 2. Setup fixture
    echo "[$scenario_name] Setting up fixture..."
    setup_fixture "$project_dir"

    # 3. Build prompt
    local prompt
    prompt=$(build_prompt)

    # 4. Invoke Claude
    echo "[$scenario_name] Invoking Claude (timeout: ${scenario_timeout:-120}s)..."
    local output_file="$project_dir/.e2e-output.txt"
    local claude_exit=0

    if _timeout_cmd "${scenario_timeout:-120}" env -u CLAUDECODE bash -c \
        "cd '$project_dir' && claude -p \"\$1\" --plugin-dir \"$PLUGIN_DIR\" --dangerously-skip-permissions" \
        -- "$prompt" \
        > "$output_file" 2>&1; then
        claude_exit=0
    else
        claude_exit=$?
    fi

    local output
    output=$(cat "$output_file")

    # 5. Find session transcript
    local transcript_file=""
    transcript_file=$(find_latest_session_transcript "$project_dir")

    # 6. Save artifacts for debugging
    if [ -n "${E2E_REPORT_DIR:-}" ]; then
        local artifact_dir="$E2E_REPORT_DIR/artifacts/$(echo "$scenario_name" | tr '/' '-')"
        mkdir -p "$artifact_dir"
        cp "$output_file" "$artifact_dir/claude-output.txt" 2>/dev/null || true
        [ -n "$transcript_file" ] && cp "$transcript_file" "$artifact_dir/transcript.jsonl" 2>/dev/null || true
        # Copy any created artifacts
        find "$project_dir" -name "*.md" -newer "$output_file" -exec cp {} "$artifact_dir/" \; 2>/dev/null || true
    fi

    # 7. Run assertion layers (with short-circuit support)
    local total_pass=0
    local total_fail=0
    local total_skip=0
    local total_assertion_pass=0
    local total_assertion_fail=0
    local total_assertion_skip=0
    local layer_results=()
    local short_circuited=false

    # Layer 1: Artifacts
    if type -t assert_artifacts &>/dev/null; then
        echo "[$scenario_name] Checking artifacts..."
        _reset_assertion_counters
        local layer_exit=0
        assert_artifacts "$project_dir" || layer_exit=$?
        total_assertion_pass=$((_ASSERTION_PASS + total_assertion_pass))
        total_assertion_fail=$((_ASSERTION_FAIL + total_assertion_fail))
        total_assertion_skip=$((_ASSERTION_SKIP + total_assertion_skip))
        if [ $layer_exit -eq 0 ]; then
            layer_results+=("artifacts:PASS")
            total_pass=$((total_pass + 1))
        elif [ $layer_exit -eq 2 ]; then
            layer_results+=("artifacts:SKIP")
            total_skip=$((total_skip + 1))
        else
            layer_results+=("artifacts:FAIL")
            total_fail=$((total_fail + 1))
            if [ "${scenario_short_circuit:-false}" = true ]; then
                short_circuited=true
            fi
        fi
    fi

    # Layer 2: Behavior
    if type -t assert_behavior &>/dev/null; then
        if [ "$short_circuited" = true ]; then
            echo "[$scenario_name] Skipping behavior (short-circuit)..."
            layer_results+=("behavior:SKIP(short-circuit)")
            total_skip=$((total_skip + 1))
        else
            echo "[$scenario_name] Checking behavior..."
            _reset_assertion_counters
            local layer_exit=0
            assert_behavior "$output" || layer_exit=$?
            total_assertion_pass=$((_ASSERTION_PASS + total_assertion_pass))
            total_assertion_fail=$((_ASSERTION_FAIL + total_assertion_fail))
            total_assertion_skip=$((_ASSERTION_SKIP + total_assertion_skip))
            if [ $layer_exit -eq 0 ]; then
                layer_results+=("behavior:PASS")
                total_pass=$((total_pass + 1))
            elif [ $layer_exit -eq 2 ]; then
                layer_results+=("behavior:SKIP")
                total_skip=$((total_skip + 1))
            else
                layer_results+=("behavior:FAIL")
                total_fail=$((total_fail + 1))
                if [ "${scenario_short_circuit:-false}" = true ]; then
                    short_circuited=true
                fi
            fi
        fi
    fi

    # Layer 3: Transcript (optional)
    if type -t assert_transcript &>/dev/null; then
        if [ "$short_circuited" = true ]; then
            echo "[$scenario_name] Skipping transcript (short-circuit)..."
            layer_results+=("transcript:SKIP(short-circuit)")
            total_skip=$((total_skip + 1))
        else
            echo "[$scenario_name] Checking transcript..."
            _reset_assertion_counters
            local layer_exit=0
            assert_transcript "$transcript_file" || layer_exit=$?
            total_assertion_pass=$((_ASSERTION_PASS + total_assertion_pass))
            total_assertion_fail=$((_ASSERTION_FAIL + total_assertion_fail))
            total_assertion_skip=$((_ASSERTION_SKIP + total_assertion_skip))
            if [ $layer_exit -eq 0 ]; then
                layer_results+=("transcript:PASS")
                total_pass=$((total_pass + 1))
            elif [ $layer_exit -eq 2 ]; then
                layer_results+=("transcript:SKIP")
                total_skip=$((total_skip + 1))
            else
                layer_results+=("transcript:FAIL")
                total_fail=$((total_fail + 1))
            fi
        fi
    fi

    # 8. Report
    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))

    emit_result "$scenario_name" "$duration" "$total_pass" "$total_fail" "$total_skip" \
        "$total_assertion_pass" "$total_assertion_fail" "$total_assertion_skip" \
        "${layer_results[@]}"

    if [ "$total_fail" -gt 0 ]; then
        return 1
    fi
    return 0
}

# Export everything for subshells
export E2E_DIR TESTS_DIR PLUGIN_DIR
export E2E_REPORT_DIR E2E_REPORT_FILE
export -f scaffold_project find_latest_session_transcript
export -f _reset_assertion_counters
export -f assert_file_exists assert_file_not_exists assert_file_contains
export -f assert_no_files_matching assert_files_matching
export -f assert_md_field assert_md_section assert_md_no_section assert_ac_format assert_no_placeholders
export -f assert_tool_called assert_no_tool_calls assert_tool_order assert_skill_invoked assert_no_premature_action
export -f assert_any_of assert_all_of
export -f emit_result run_scenario
