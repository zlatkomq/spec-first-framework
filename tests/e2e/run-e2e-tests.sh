#!/usr/bin/env bash
# E2E test runner for spec-first-framework skills
# Discovers and runs *.scenario.sh files, reports results
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source shared utilities (_timeout_cmd)
source "$SCRIPT_DIR/../shared-utils.sh"

echo "========================================"
echo " Spec-First Framework E2E Test Suite"
echo "========================================"
echo ""
echo "Repository: $(cd "$SCRIPT_DIR/../.." && pwd)"
echo "Test time: $(date)"
echo "Claude version: $(claude --version 2>/dev/null || echo 'not found')"
echo ""

# Check Claude Code
if ! command -v claude &> /dev/null; then
    echo "ERROR: Claude Code CLI not found"
    exit 1
fi

# Parse arguments
VERBOSE=false
SPECIFIC_SCENARIO=""
FILTER_TAG=""
FILTER_TIERS=()
TIMEOUT=300
RETRIES=0
FAIL_FAST=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --scenario|-s)
            SPECIFIC_SCENARIO="$2"
            shift 2
            ;;
        --tag|-t)
            FILTER_TAG="$2"
            shift 2
            ;;
        --tier)
            FILTER_TIERS+=("$2")
            shift 2
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --retries)
            RETRIES="$2"
            shift 2
            ;;
        --fail-fast)
            FAIL_FAST=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --verbose, -v            Show verbose output"
            echo "  --scenario, -s NAME      Run only scenarios matching NAME"
            echo "  --tag, -t TAG            Run only scenarios with matching tag"
            echo "  --tier TIER              Run only scenarios with matching tier (T0/T1/T2/T3)"
            echo "                           Can be specified multiple times: --tier T0 --tier T1"
            echo "  --timeout SECONDS        Set timeout per scenario (default: 300)"
            echo "  --retries N              Retry failed scenarios up to N times (default: 0)"
            echo "  --fail-fast              Stop on first scenario failure"
            echo "  --help, -h               Show this help"
            echo ""
            echo "Tiers:"
            echo "  T0  Smoke tests (fast, zero/low API cost)"
            echo "  T1  Gate tests (verify skills refuse when preconditions not met)"
            echo "  T2  Happy path tests (verify correct artifact creation)"
            echo "  T3  Chain tests (full workflow pipeline)"
            echo ""
            echo "Examples:"
            echo "  $0 --tier T0                    # Quick smoke test"
            echo "  $0 --tier T0 --tier T1          # Smoke + gates"
            echo "  $0 --retries 1                  # Retry failures once"
            echo "  $0 --tier T1 --fail-fast        # Gates only, stop on first failure"
            echo ""
            echo "Scenarios are discovered from: $SCRIPT_DIR/scenarios/"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Set up report directory
export E2E_REPORT_DIR="$SCRIPT_DIR/reports/$(date +%Y-%m-%d-%H%M%S)"
export E2E_REPORT_FILE="$E2E_REPORT_DIR/scenario-results.jsonl"
mkdir -p "$E2E_REPORT_DIR"

# Discover scenarios
scenarios=()
while IFS= read -r -d '' scenario_file; do
    scenarios+=("$scenario_file")
done < <(find "$SCRIPT_DIR/scenarios" -name "*.scenario.sh" -type f -print0 | sort -z)

# Filter by scenario name
if [ -n "$SPECIFIC_SCENARIO" ]; then
    filtered=()
    for s in "${scenarios[@]}"; do
        if echo "$s" | grep -q "$SPECIFIC_SCENARIO"; then
            filtered+=("$s")
        fi
    done
    scenarios=("${filtered[@]}")
fi

# Filter by tag
if [ -n "$FILTER_TAG" ]; then
    filtered=()
    for s in "${scenarios[@]}"; do
        if head -15 "$s" | grep -q "scenario_tags=.*$FILTER_TAG"; then
            filtered+=("$s")
        fi
    done
    scenarios=("${filtered[@]}")
fi

# Filter by tier
if [ ${#FILTER_TIERS[@]} -gt 0 ]; then
    filtered=()
    for s in "${scenarios[@]}"; do
        for tier in "${FILTER_TIERS[@]}"; do
            if head -15 "$s" | grep -q "scenario_tier=\"$tier\""; then
                filtered+=("$s")
                break
            fi
        done
    done
    scenarios=("${filtered[@]}")
fi

if [ ${#scenarios[@]} -eq 0 ]; then
    echo "No scenarios found."
    exit 0
fi

echo "Found ${#scenarios[@]} scenario(s)"
if [ ${#FILTER_TIERS[@]} -gt 0 ]; then
    echo "Tier filter: ${FILTER_TIERS[*]}"
fi
if [ "$RETRIES" -gt 0 ]; then
    echo "Retries: $RETRIES"
fi
echo "Report: $E2E_REPORT_DIR"
echo ""

# Track results
passed=0
failed=0
flaky=0
suite_start=$(date +%s)

# Run each scenario
for scenario_file in "${scenarios[@]}"; do
    # Extract scenario name from file path
    rel_path="${scenario_file#$SCRIPT_DIR/scenarios/}"
    scenario_display="${rel_path%.scenario.sh}"

    echo "----------------------------------------"
    echo "Running: $scenario_display"
    echo "----------------------------------------"

    if [ ! -x "$scenario_file" ]; then
        chmod +x "$scenario_file"
    fi

    start_time=$(date +%s)

    # Retry loop
    attempt=0
    max_attempts=$((RETRIES + 1))
    scenario_passed=false
    scenario_output=""

    while [ $attempt -lt $max_attempts ] && [ "$scenario_passed" = false ]; do
        attempt=$((attempt + 1))
        if [ $attempt -gt 1 ]; then
            echo "  Retry $((attempt - 1))/$RETRIES..."
        fi

        if [ "$VERBOSE" = true ]; then
            if _timeout_cmd "$TIMEOUT" bash "$scenario_file"; then
                scenario_passed=true
            else
                exit_code=$?
                if [ $exit_code -eq 124 ]; then
                    echo "  [TIMEOUT] $scenario_display (after ${TIMEOUT}s)"
                fi
            fi
        else
            if scenario_output=$(_timeout_cmd "$TIMEOUT" bash "$scenario_file" 2>&1); then
                scenario_passed=true
            else
                exit_code=$?
                if [ $exit_code -eq 124 ]; then
                    scenario_output="[TIMEOUT] $scenario_display (after ${TIMEOUT}s)"
                fi
            fi
        fi
    done

    end_time=$(date +%s)
    duration=$((end_time - start_time))

    if [ "$scenario_passed" = true ]; then
        if [ $attempt -gt 1 ]; then
            echo "  [FLAKY_PASS] $scenario_display (passed on attempt $attempt, ${duration}s)"
            flaky=$((flaky + 1))
        else
            if [ "$VERBOSE" = false ]; then
                echo "$scenario_output" | grep -E '^\s*\[(PASS|PASS_WITH_SKIPS|FAIL)\]' | tail -1
            fi
        fi
        passed=$((passed + 1))
    else
        if [ "$VERBOSE" = false ]; then
            echo "$scenario_output" | grep -E '^\s*\[(PASS|PASS_WITH_SKIPS|FAIL)\]' | tail -1
            echo ""
            echo "  Output:"
            echo "$scenario_output" | sed 's/^/    /'
        fi
        failed=$((failed + 1))

        if [ "$FAIL_FAST" = true ]; then
            echo ""
            echo "  --fail-fast: Stopping after first failure"
            break
        fi
    fi

    echo ""
done

suite_end=$(date +%s)
suite_duration=$((suite_end - suite_start))

# Format duration as minutes:seconds
suite_mins=$((suite_duration / 60))
suite_secs=$((suite_duration % 60))

# Summary
echo "========================================"
echo " E2E Test Results Summary"
echo "========================================"
echo ""
echo "  Passed:  $passed"
if [ $flaky -gt 0 ]; then
    echo "  Flaky:   $flaky (passed on retry)"
fi
echo "  Failed:  $failed"
echo "  Total:   $((passed + failed))"
echo ""
echo "  Time:    ${suite_mins}m ${suite_secs}s"
echo "  Report:  $E2E_REPORT_DIR"
echo ""

if [ $failed -gt 0 ]; then
    echo "STATUS: FAILED"
    exit 1
else
    echo "STATUS: PASSED"
    exit 0
fi
