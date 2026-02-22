#!/usr/bin/env bash
# Compose a test project from a base + overlays
# Usage: scaffold.sh <target-dir> <base> [overlay1] [overlay2] ...
# Example: scaffold.sh /tmp/xyz node-project with-constitution with-approved-spec
set -euo pipefail

FIXTURES_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:?Usage: $0 <target-dir> <base> [overlay1] [overlay2] ...}"
shift
BASE="${1:?Must specify a base (e.g., node-project)}"
shift

# Copy base
mkdir -p "$TARGET"
cp -r "$FIXTURES_DIR/bases/$BASE/"* "$TARGET/" 2>/dev/null || true
# Include dotfiles (.claude, etc.)
cp -r "$FIXTURES_DIR/bases/$BASE/".[!.]* "$TARGET/" 2>/dev/null || true

# Apply overlays in order
for overlay in "$@"; do
    if [ -d "$FIXTURES_DIR/overlays/$overlay" ]; then
        cp -r "$FIXTURES_DIR/overlays/$overlay/"* "$TARGET/" 2>/dev/null || true
        cp -r "$FIXTURES_DIR/overlays/$overlay/".[!.]* "$TARGET/" 2>/dev/null || true
    else
        echo "WARNING: overlay '$overlay' not found at $FIXTURES_DIR/overlays/$overlay" >&2
    fi
done

# Initialize git repo
cd "$TARGET"
git init --quiet
git config user.email "e2e-test@test.com"
git config user.name "E2E Test"
git add -A
git commit -m "Fixture: $BASE + $*" --quiet
