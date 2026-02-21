#!/usr/bin/env bash
# Test runner for spec-first-framework skills
# Tests skills by invoking Claude Code CLI and verifying behavior
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================"
echo " Spec-First Framework Skills Test Suite"
echo "========================================"
echo ""
echo "Repository: $(cd .. && pwd)"
echo "Test time: $(date)"
echo "Claude version: $(claude --version 2>/dev/null || echo 'not found')"
echo ""

# Check if Claude Code is available
if ! command -v claude &> /dev/null; then
    echo "ERROR: Claude Code CLI not found"
    echo "Install Claude Code first: https://code.claude.com"
    exit 1
fi

# Parse command line arguments
VERBOSE=false
SPECIFIC_TEST=""
TIMEOUT=300  # Default 5 minute timeout per test

while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --test|-t)
            SPECIFIC_TEST="$2"
            shift 2
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --verbose, -v        Show verbose output"
            echo "  --test, -t NAME      Run only the specified test"
            echo "  --timeout SECONDS    Set timeout per test (default: 300)"
            echo "  --help, -h           Show this help"
            echo ""
            echo "Skill Tests (15 total):"
            echo ""
            echo "  Spec Definition:"
            echo "    test-constitution-creation.sh"
            echo "    test-spec-creation.sh"
            echo "    test-design-creation.sh"
            echo "    test-task-creation.sh"
            echo ""
            echo "  Implementation:"
            echo "    test-implementation.sh"
            echo "    test-subagent-driven-development.sh"
            echo ""
            echo "  Review:"
            echo "    test-code-review.sh"
            echo "    test-adversarial-review.sh"
            echo ""
            echo "  Bug Workflow:"
            echo "    test-bugfixing.sh"
            echo "    test-bug-implementation.sh"
            echo "    test-bug-review.sh"
            echo ""
            echo "  Change Workflow:"
            echo "    test-change-request.sh"
            echo ""
            echo "  Utility Skills:"
            echo "    test-systematic-debugging.sh"
            echo "    test-git-worktrees.sh"
            echo "    test-finishing-development-branch.sh"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# List of skill tests to run
tests=(
    # Spec Definition Workflow
    "test-constitution-creation.sh"
    "test-spec-creation.sh"
    "test-design-creation.sh"
    "test-task-creation.sh"
    # Implementation Workflow
    "test-implementation.sh"
    "test-subagent-driven-development.sh"
    # Review Workflow
    "test-code-review.sh"
    "test-adversarial-review.sh"
    # Bug Workflow
    "test-bugfixing.sh"
    "test-bug-implementation.sh"
    "test-bug-review.sh"
    # Change Workflow
    "test-change-request.sh"
    # Utility Skills
    "test-systematic-debugging.sh"
    "test-git-worktrees.sh"
    "test-finishing-development-branch.sh"
)

# Filter to specific test if requested
if [ -n "$SPECIFIC_TEST" ]; then
    tests=("$SPECIFIC_TEST")
fi

# Portable timeout: use GNU timeout, gtimeout (macOS brew), or fallback
_timeout_cmd() {
    if command -v timeout &> /dev/null; then
        timeout "$@"
    elif command -v gtimeout &> /dev/null; then
        gtimeout "$@"
    else
        shift  # drop the timeout value
        "$@"
    fi
}

# Track results
passed=0
failed=0
skipped=0

# Run each test
for test in "${tests[@]}"; do
    echo "----------------------------------------"
    echo "Running: $test"
    echo "----------------------------------------"

    test_path="$SCRIPT_DIR/$test"

    if [ ! -f "$test_path" ]; then
        echo "  [SKIP] Test file not found: $test"
        skipped=$((skipped + 1))
        continue
    fi

    if [ ! -x "$test_path" ]; then
        echo "  Making $test executable..."
        chmod +x "$test_path"
    fi

    start_time=$(date +%s)

    if [ "$VERBOSE" = true ]; then
        if _timeout_cmd "$TIMEOUT" bash "$test_path"; then
            end_time=$(date +%s)
            duration=$((end_time - start_time))
            echo ""
            echo "  [PASS] $test (${duration}s)"
            passed=$((passed + 1))
        else
            exit_code=$?
            end_time=$(date +%s)
            duration=$((end_time - start_time))
            echo ""
            if [ $exit_code -eq 124 ]; then
                echo "  [FAIL] $test (timeout after ${TIMEOUT}s)"
            else
                echo "  [FAIL] $test (${duration}s)"
            fi
            failed=$((failed + 1))
        fi
    else
        # Capture output for non-verbose mode
        if output=$(_timeout_cmd "$TIMEOUT" bash "$test_path" 2>&1); then
            end_time=$(date +%s)
            duration=$((end_time - start_time))
            echo "  [PASS] (${duration}s)"
            passed=$((passed + 1))
        else
            exit_code=$?
            end_time=$(date +%s)
            duration=$((end_time - start_time))
            if [ $exit_code -eq 124 ]; then
                echo "  [FAIL] (timeout after ${TIMEOUT}s)"
            else
                echo "  [FAIL] (${duration}s)"
            fi
            echo ""
            echo "  Output:"
            echo "$output" | sed 's/^/    /'
            failed=$((failed + 1))
        fi
    fi

    echo ""
done

# Print summary
echo "========================================"
echo " Test Results Summary"
echo "========================================"
echo ""
echo "  Passed:  $passed"
echo "  Failed:  $failed"
echo "  Skipped: $skipped"
echo ""

if [ $failed -gt 0 ]; then
    echo "STATUS: FAILED"
    exit 1
else
    echo "STATUS: PASSED"
    exit 0
fi
