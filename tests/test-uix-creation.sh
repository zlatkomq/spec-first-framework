#!/usr/bin/env bash
# Test: uix-creation skill (v1.2.0 cached Figma snapshot model)
# Verifies key gates: DESIGN must be APPROVED, fetch-once cache policy,
# /uix-refresh as sole re-fetch path, svg_ex_ auto-export rule,
# no fidelity loop (step-04 / step-05 never call MCP)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: uix-creation skill ==="
echo ""

# Test 1: DESIGN.md must be APPROVED before UIX-SPEC.md can be created
echo "Test 1: DESIGN must be APPROVED gate..."

output=$(run_claude "Using the uix-creation skill, what happens if I ask you to create a UIX-SPEC.md when DESIGN.md status is still DRAFT?" 30)

if assert_contains "$output" "STOP\|stop\|cannot\|APPROVED\|not.*proceed\|approved" "Stops if DESIGN not approved"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 2: Cache policy — fetch once, file on disk = never re-fetch
echo "Test 2: Cache policy (fetch once, never re-fetch)..."

output=$(run_claude "In the uix-creation skill's Figma cache policy, what is the rule when an artifact file already exists on disk under specs/XXX/figma/? Should the agent call the figma-to-code MCP again?" 30)

if assert_contains "$output" "[Nn]ever\|do not\|DO NOT\|never re-fetch\|read.*disk\|from disk\|cached" "Reads from disk, does not re-fetch"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "FAILURE\|failure condition\|REVIEW\|reported" "Re-fetch of cached artifact is a failure condition"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 3: /uix-refresh is the only sanctioned path to re-fetch
echo "Test 3: /uix-refresh is the only re-fetch path..."

output=$(run_claude "In the uix-creation skill, what is the ONLY command or path that may re-fetch a cached Figma artifact after the initial step-02b fetch? Is there any automatic re-fetch?" 30)

if assert_contains "$output" "/uix-refresh\|uix-refresh\|Force refresh" "Names /uix-refresh as the only re-fetch path"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "[Nn]o automatic\|never automatic\|no.*loop\|no fidelity loop\|no re-loop" "No automatic re-fetch / no fidelity loop"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 4: svg_ex_ node convention — automatic SVG export, read from disk if cached
echo "Test 4: svg_ex_ node auto-export rule..."

output=$(run_claude "In the uix-creation skill, what is the rule for Figma nodes whose name starts with svg_ex_? How must they be exported and where must the resulting file live? Can the agent inline the SVG markup instead?" 30)

if assert_contains "$output" "svg_ex_\|export_figma_assets\|\\.svg" "References svg_ex_ / svg export"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "figma/assets\|assets/" "Saved under figma/assets/"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "[Nn]ot inline\|MUST NOT inline\|never inline\|do not inline\|no.*inline\|relative path" "Must not inline SVG markup; reference by relative path"; then
    : # pass
else
    exit 1
fi

echo ""

# Test 5: No fidelity loop — step-04 / step-05 never call MCP
echo "Test 5: No fidelity loop (step-04 and step-05 never call MCP)..."

output=$(run_claude "In the uix-creation skill, are step-04 implementation and step-05 review allowed to call the figma-to-code MCP server? What about a 'compare and re-fetch' fidelity loop?" 30)

if assert_contains "$output" "[Nn]ever\|MUST NOT\|do not\|DO NOT\|not allowed\|forbidden" "Step-04 / step-05 must not call MCP"; then
    : # pass
else
    exit 1
fi

if assert_contains "$output" "no fidelity loop\|no.*loop\|no compare\|no re-fetch\|no automatic" "No fidelity loop / no compare-and-re-fetch"; then
    : # pass
else
    exit 1
fi

echo ""

echo "=== All uix-creation skill tests passed ==="
