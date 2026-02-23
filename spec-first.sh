#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# spec-first — Install and update the Spec-First AI Development Framework
# ============================================================================

VERSION="0.6.0"
DEFAULT_REPO="https://github.com/zlatkomq/spec-first-framework.git"
DEFAULT_BRANCH="main"
VERSION_FILE=".framework/.spec-first-version"

# Colors (disabled if not a terminal)
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  CYAN='\033[0;36m'
  BOLD='\033[1m'
  NC='\033[0m'
else
  RED='' GREEN='' YELLOW='' CYAN='' BOLD='' NC=''
fi

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

info()  { echo -e "${CYAN}→${NC} $1"; }
ok()    { echo -e "${GREEN}✓${NC} $1"; }
warn()  { echo -e "${YELLOW}⚠${NC} $1"; }
err()   { echo -e "${RED}✗${NC} $1" >&2; }
fatal() { err "$1"; exit 1; }

usage() {
  cat <<EOF
${BOLD}spec-first${NC} — Spec-First AI Development Framework CLI

${BOLD}Usage:${NC}
  spec-first init     [--branch <branch>] [--repo <url>]   Install framework into current project
  spec-first update   [--branch <branch>] [--repo <url>]   Update framework files (preserves project data)
  spec-first version                                        Show installed framework version
  spec-first help                                           Show this help

${BOLD}Options:${NC}
  --branch <branch>   Git branch or tag to use (default: ${DEFAULT_BRANCH})
  --repo <url>        Git repository URL (default: ${DEFAULT_REPO})

${BOLD}Examples:${NC}
  spec-first init                          # Install from main branch
  spec-first init --branch develop         # Install from develop branch
  spec-first update                        # Update from same branch used during init
  spec-first update --branch v0.8.0        # Update and switch to a different branch
EOF
}

check_git() {
  command -v git >/dev/null 2>&1 || fatal "git is required but not installed."
}

# Clone repo into temp dir (shallow, specific branch)
clone_repo() {
  local repo="$1"
  local branch="$2"

  CLONE_DIR=$(mktemp -d)
  info "Fetching framework from ${BOLD}${branch}${NC} ..."

  if ! git clone --depth 1 --branch "$branch" "$repo" "$CLONE_DIR" 2>/dev/null; then
    rm -rf "$CLONE_DIR"
    fatal "Failed to clone ${repo} (branch: ${branch}). Check the URL and branch name."
  fi
}


# ---------------------------------------------------------------------------
# File copy logic
# ---------------------------------------------------------------------------

# Directories to copy (relative to repo root)
COPY_DIRS=(
  ".cursor/commands"
  ".cursor/rules"
  ".framework/templates"
  ".framework/steps"
  ".framework/checklists"
)

# Individual files to copy (relative to repo root)
COPY_FILES=(
  "README.md"
  "PHILOSOPHY.md"
  "FOLDER-STRUCTURE.md"
  "CHANGELOG.md"
)

# Scaffold directories to create with .gitkeep
SCAFFOLD_DIRS=(
  "specs"
  "bugs"
  "docs/legacy-analysis"
)

copy_framework_files() {
  local src="$1"
  local dest="$2"
  local copied=0

  # Copy directories
  for dir in "${COPY_DIRS[@]}"; do
    if [ -d "${src}/${dir}" ]; then
      mkdir -p "${dest}/${dir}"
      cp -r "${src}/${dir}/." "${dest}/${dir}/"
      copied=$((copied + 1))
    else
      warn "Expected directory not found in source: ${dir}"
    fi
  done

  # Copy individual files
  for file in "${COPY_FILES[@]}"; do
    if [ -f "${src}/${file}" ]; then
      cp "${src}/${file}" "${dest}/${file}"
      copied=$((copied + 1))
    else
      warn "Expected file not found in source: ${file}"
    fi
  done

  echo "$copied"
}

create_scaffold() {
  local dest="$1"

  for dir in "${SCAFFOLD_DIRS[@]}"; do
    if [ ! -d "${dest}/${dir}" ]; then
      mkdir -p "${dest}/${dir}"
      touch "${dest}/${dir}/.gitkeep"
      ok "Created ${dir}/"
    fi
  done
}

write_version_file() {
  local dest="$1"
  local branch="$2"
  local commit="$3"

  mkdir -p "$(dirname "${dest}/${VERSION_FILE}")"
  cat > "${dest}/${VERSION_FILE}" <<EOF
branch=${branch}
commit=${commit}
date=$(date -u +%Y-%m-%dT%H:%M:%SZ)
cli_version=${VERSION}
EOF
}

read_version_file() {
  local file="$1"
  if [ -f "$file" ]; then
    # shellcheck disable=SC1090
    source "$file"
  fi
}

# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

cmd_init() {
  local repo="$DEFAULT_REPO"
  local branch="$DEFAULT_BRANCH"

  # Parse flags
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --branch) branch="$2"; shift 2 ;;
      --repo)   repo="$2";   shift 2 ;;
      *)        fatal "Unknown option: $1" ;;
    esac
  done

  # Guard: already initialized
  if [ -d ".framework/templates" ] && [ -d ".cursor/rules" ]; then
    warn "Framework already installed in this project."
    info "Use ${BOLD}spec-first update${NC} to pull the latest version."
    exit 0
  fi

  check_git

  echo ""
  echo -e "${BOLD}Spec-First Framework — Init${NC}"
  echo ""

  # Clone
  # local tmpdir
  # tmpdir=$(clone_repo "$repo" "$branch")
  clone_repo "$repo" "$branch"
  local tmpdir="$CLONE_DIR"

  # Get commit hash
  local commit
  commit=$(git -C "$tmpdir" rev-parse --short HEAD)

  # Copy framework files
  info "Installing framework files..."
  local count
  count=$(copy_framework_files "$tmpdir" ".")

  # Create scaffold directories
  create_scaffold "."

  # Write version file
  write_version_file "." "$branch" "$commit"
  ok "Version recorded: ${branch}@${commit}"

  # Clean up
  rm -rf "$tmpdir"

  # Summary
  echo ""
  echo -e "${GREEN}${BOLD}Framework installed successfully.${NC}"
  echo ""
  echo "  Installed from: ${branch}@${commit}"
  echo "  Framework files: .cursor/ and .framework/"
  echo "  Project folders: specs/, bugs/, docs/legacy-analysis/"
  echo ""
  echo -e "  ${BOLD}Next step:${NC} Open Cursor and run ${CYAN}/constitute${NC} to set up project standards."
  echo ""
}

cmd_update() {
  local repo="$DEFAULT_REPO"
  local branch=""

  # Parse flags
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --branch) branch="$2"; shift 2 ;;
      --repo)   repo="$2";   shift 2 ;;
      *)        fatal "Unknown option: $1" ;;
    esac
  done

  # Guard: not initialized
  if [ ! -d ".framework" ]; then
    fatal "Framework not found. Run ${BOLD}spec-first init${NC} first."
  fi

  # Read existing version to get branch if not overridden
  if [ -z "$branch" ] && [ -f "$VERSION_FILE" ]; then
    local saved_branch=""
    saved_branch=$(grep '^branch=' "$VERSION_FILE" 2>/dev/null | cut -d= -f2)
    branch="${saved_branch:-$DEFAULT_BRANCH}"
  fi
  branch="${branch:-$DEFAULT_BRANCH}"

  check_git

  echo ""
  echo -e "${BOLD}Spec-First Framework — Update${NC}"
  echo ""

  # Show current version
  if [ -f "$VERSION_FILE" ]; then
    local current_commit
    current_commit=$(grep '^commit=' "$VERSION_FILE" 2>/dev/null | cut -d= -f2)
    local current_branch
    current_branch=$(grep '^branch=' "$VERSION_FILE" 2>/dev/null | cut -d= -f2)
    info "Current: ${current_branch}@${current_commit}"
  fi

  # Clone
  # local tmpdir
  # tmpdir=$(clone_repo "$repo" "$branch")
  clone_repo "$repo" "$branch"
  local tmpdir="$CLONE_DIR"

  # Get commit hash
  local commit
  commit=$(git -C "$tmpdir" rev-parse --short HEAD)

  # Check if already up to date
  if [ -f "$VERSION_FILE" ]; then
    local current_commit
    current_commit=$(grep '^commit=' "$VERSION_FILE" 2>/dev/null | cut -d= -f2)
    if [ "$commit" = "$current_commit" ]; then
      rm -rf "$tmpdir"
      ok "Already up to date (${branch}@${commit})."
      exit 0
    fi
  fi

  # Overwrite framework-owned files only
  info "Updating framework files..."

  local count
  count=$(copy_framework_files "$tmpdir" ".")

  # Ensure scaffold dirs exist (in case new ones were added)
  create_scaffold "."

  # Update version file
  write_version_file "." "$branch" "$commit"
  ok "Version updated: ${branch}@${commit}"

  # Clean up
  rm -rf "$tmpdir"

  # Summary
  echo ""
  echo -e "${GREEN}${BOLD}Framework updated successfully.${NC}"
  echo ""
  echo "  Updated to: ${branch}@${commit}"
  echo ""
  echo -e "  ${YELLOW}Preserved:${NC} CONSTITUTION.md, specs/*, bugs/*"
  echo ""
}

cmd_version() {
  echo -e "${BOLD}spec-first${NC} CLI v${VERSION}"

  if [ -f "$VERSION_FILE" ]; then
    local fw_branch fw_commit fw_date
    fw_branch=$(grep '^branch=' "$VERSION_FILE" 2>/dev/null | cut -d= -f2)
    fw_commit=$(grep '^commit=' "$VERSION_FILE" 2>/dev/null | cut -d= -f2)
    fw_date=$(grep '^date=' "$VERSION_FILE" 2>/dev/null | cut -d= -f2)
    echo "  Framework: ${fw_branch}@${fw_commit} (${fw_date})"
  else
    echo "  Framework: not installed (run spec-first init)"
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
  if [ $# -eq 0 ]; then
    usage
    exit 0
  fi

  local cmd="$1"
  shift

  case "$cmd" in
    init)    cmd_init "$@" ;;
    update)  cmd_update "$@" ;;
    version) cmd_version ;;
    help)    usage ;;
    -h)      usage ;;
    --help)  usage ;;
    *)       err "Unknown command: ${cmd}"; echo ""; usage; exit 1 ;;
  esac
}

main "$@"
