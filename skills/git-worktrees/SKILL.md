# Git Worktrees

## Description

Use when starting feature work that needs isolation from the current workspace, or before executing an implementation plan.
Not for branch cleanup after work is complete — use the finishing-a-development-branch skill for that.

## Instructions

You are setting up an isolated git worktree for feature work. Follow these rules strictly.

**Announce at start:** "I'm using the git-worktrees skill to set up an isolated workspace."

### Directory Selection

Follow this priority order. Do NOT skip steps or assume a location.

#### 1. Check Existing Directories

```bash
ls -d .worktrees 2>/dev/null     # Preferred (hidden)
ls -d worktrees 2>/dev/null      # Alternative
```

If found, use that directory. If both exist, `.worktrees` wins.

#### 2. Check CLAUDE.md

```bash
grep -i "worktree.*director" CLAUDE.md 2>/dev/null
```

If a preference is specified, use it without asking.

#### 3. Ask User

If no directory exists and no CLAUDE.md preference:

```
No worktree directory found. Where should I create worktrees?

1. .worktrees/ (project-local, hidden)
2. Custom path

Which do you prefer?
```

### Safety Verification

**HARD GATE — do NOT proceed without passing this check.**

For project-local directories (`.worktrees` or `worktrees`), verify the directory is git-ignored before creating the worktree:

```bash
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**If NOT ignored:**
1. Add the directory to `.gitignore`
2. Commit the `.gitignore` change
3. Then proceed with worktree creation

**Why critical:** Prevents accidentally committing worktree contents to the repository.

For directories outside the project root, no `.gitignore` verification is needed.

### Worktree Detection

Before creating a new worktree, check if one already exists for this branch:

```bash
git worktree list | grep "$BRANCH_NAME"
```

**If a worktree already exists for this branch:** `cd` into it and skip to Step 4 (Verify Clean Baseline). Do NOT create a duplicate worktree.

Also check if you are already inside a worktree:

```bash
# If these differ, you're in a worktree
git rev-parse --show-toplevel
git rev-parse --git-common-dir
```

**If already inside a worktree:** Skip worktree creation entirely. Proceed with implementation.

### Worktree Creation

#### 1. Record Base Branch

The current branch at invocation time is the base branch. All worktrees branch from it.

```bash
BASE_BRANCH=$(git branch --show-current)
```

This is mandatory. If on `dev`, the worktree branches from `dev`. If on `main`, from `main`. No guessing, no asking.

#### 2. Create Worktree

```bash
git worktree add "$WORKTREE_DIR/$BRANCH_NAME" -b "$BRANCH_NAME" "$BASE_BRANCH"
cd "$WORKTREE_DIR/$BRANCH_NAME"
```

The explicit `$BASE_BRANCH` start point ensures the worktree is based on the correct branch regardless of HEAD state.

#### 3. Run Project Setup (Auto-Detect)

Detect the project type from manifest files and run the appropriate setup:

```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

If no recognized manifest file is found, skip dependency installation.

#### 4. Verify Clean Baseline

Ask the user:

```
Run baseline tests to verify the worktree starts clean? [Y/n]
```

**If user accepts:** Run the project's test suite.

```bash
# Use the project-appropriate test command
npm test / cargo test / pytest / go test ./...
```

- **If tests pass:** Record the test count and proceed.
- **If tests fail:** Report the failures and let the user choose:

```
Baseline tests failed (<N> failures). The base branch has pre-existing issues.

1. Investigate and fix before proceeding
2. Proceed anyway (failures will be recorded as pre-existing)
```

  - **Option 1:** Investigate failures. Do not start implementation until baseline is green.
  - **Option 2:** Proceed with implementation. Record the failing tests in `.workflow-state.md` as pre-existing so they are not counted as regressions during implementation.

**If user skips:** Proceed without baseline verification. Note "skipped" in the report and `.workflow-state.md`.

#### 5. Log to Workflow State

If `.workflow-state.md` exists in the spec directory, append worktree information:

```markdown
## Worktree

- **Branch:** <branch-name>
- **Path:** <full-worktree-path>
- **Base branch:** <base-branch>
- **Baseline tests:** <N> passing, <M> failures (pre-existing: [test names] | none) | skipped
- **Created:** <timestamp>
```

If `.workflow-state.md` does not exist, skip this step.

#### 6. Report

```
Worktree ready at <full-path>
Branch: <branch-name> (based on <base-branch>)
Tests passing (<N> tests, 0 failures)
Ready to implement <feature-name>
```

### Quick Reference

| Situation | Action |
|-----------|--------|
| Already inside a worktree | Skip creation, proceed with implementation |
| Worktree exists for target branch | `cd` into it, run baseline tests, skip creation |
| `.worktrees/` exists | Use it (verify ignored) |
| `worktrees/` exists | Use it (verify ignored) |
| Both exist | Use `.worktrees/` |
| Neither exists | Check CLAUDE.md, then ask user |
| Directory not ignored | Add to `.gitignore`, commit, then proceed |
| User accepts baseline tests, pass | Record count, proceed |
| User accepts baseline tests, fail | Report failures, user chooses: fix first or proceed (record as pre-existing) |
| User skips baseline tests | Proceed; note "skipped" in report and `.workflow-state.md` |
| No manifest file found | Skip dependency install |

### Common Mistakes

#### Skipping ignore verification

- **Problem:** Worktree contents get tracked, pollute git status
- **Fix:** Always run `git check-ignore` before creating project-local worktrees

#### Assuming directory location

- **Problem:** Creates inconsistency, violates project conventions
- **Fix:** Follow priority order: existing directory > CLAUDE.md > ask user

#### Proceeding with failing baseline tests

- **Problem:** Cannot distinguish new bugs from pre-existing issues
- **Fix:** STOP and report. Never proceed with a broken baseline.

#### Hardcoding setup commands

- **Problem:** Breaks on projects using different tools
- **Fix:** Auto-detect from manifest files (package.json, Cargo.toml, etc.)

### Red Flags

**Never:**
- Create a worktree without verifying it's git-ignored (project-local)
- Skip baseline test verification without asking the user
- Proceed with failing baseline tests without informing the user and recording pre-existing failures
- Assume directory location when ambiguous
- Skip the CLAUDE.md check

**Always:**
- Follow directory priority: existing > CLAUDE.md > ask
- Verify directory is ignored for project-local worktrees
- Auto-detect and run project setup
- Ask user before running baseline tests
- Log worktree info to `.workflow-state.md` when it exists

### Integration

**Pairs with:**
- **finishing-a-development-branch** — use after work is complete for cleanup, merge, or PR creation

**Called by:**
- **implementation** — before starting implementation on a feature branch

## Verification

Before proceeding to implementation, confirm:

- [ ] Worktree directory follows priority selection (existing > CLAUDE.md > user choice)
- [ ] Project-local worktree directory is git-ignored (verified via `git check-ignore`)
- [ ] Worktree created on correct branch
- [ ] Dependencies installed (auto-detected from manifest files)
- [ ] Baseline tests: ran and passed, OR ran and user chose to proceed with pre-existing failures recorded, OR user skipped
- [ ] Worktree info logged to `.workflow-state.md` (if it exists)
