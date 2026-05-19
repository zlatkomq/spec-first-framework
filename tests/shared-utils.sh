#!/usr/bin/env bash
# Shared utilities used by both skill tests and e2e tests

# Portable timeout: use GNU timeout, gtimeout (macOS brew), or fallback to no timeout
_timeout_cmd() {
    if command -v timeout &> /dev/null; then
        timeout "$@"
    elif command -v gtimeout &> /dev/null; then
        gtimeout "$@"
    else
        # No timeout available — skip the timeout arg, run directly
        shift  # drop the timeout value
        "$@"
    fi
}

export -f _timeout_cmd
