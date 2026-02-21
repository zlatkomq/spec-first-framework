# Spec-First Framework — Skill Tests

Automated tests for spec-first-framework skills using the Claude Code CLI.

## Overview

This test suite verifies **skill content**: Claude has access to the skills and states their key rules correctly when asked. Tests invoke Claude Code in headless mode (`claude -p`) with the spec-first-framework plugin and assert on the responses.

## Requirements

- Claude Code CLI installed and in PATH (`claude --version` should work)
- The spec-first-framework plugin directory accessible (auto-detected from `tests/..`)
- Python 3 for `analyze-token-usage.py` (optional)

## Running Tests

```bash
# Run all 15 skill tests (~15-20 min)
./run-skill-tests.sh

# Run with verbose output
./run-skill-tests.sh --verbose

# Run a specific skill test
./run-skill-tests.sh --test test-implementation.sh

# Set custom timeout (default: 300s per test)
./run-skill-tests.sh --timeout 120

# List all available tests
./run-skill-tests.sh --help
```

## Test Structure

### Infrastructure

| File | Purpose |
|------|---------|
| `test-helpers.sh` | Shared utilities: `run_claude`, `assert_contains`, `assert_not_contains`, `assert_count`, `assert_order` |
| `run-skill-tests.sh` | Test runner with argument parsing, timing, pass/fail tracking |
| `analyze-token-usage.py` | Parses JSONL session transcripts for per-subagent token breakdown |

### Skill Tests (15 files, 46 assertions)

**Spec Definition Workflow:**
- `test-constitution-creation.sh` — one-question-at-a-time, concrete versions, DRAFT status
- `test-spec-creation.sh` — user provides ID, BDD format ACs, no tech details
- `test-design-creation.sh` — SPEC must be APPROVED, omit irrelevant sections, ID match
- `test-task-creation.sh` — DESIGN must be APPROVED, atomic tasks, Produces/Consumes contracts

**Implementation Workflow:**
- `test-implementation.sh` — TASKS must be APPROVED, TDD iron law, HALT after 3 failures
- `test-subagent-driven-development.sh` — read TASKS once, no file reads by subagents, spec before quality review, IMPL-SUMMARY logging (4 assertions)

**Review Workflow:**
- `test-code-review.sh` — two-stage order, 30% file threshold = BLOCKED, expect 3+ issues
- `test-adversarial-review.sh` — 10+ issues, 4-part structure, don't fix content

**Bug Workflow:**
- `test-bugfixing.sh` — classification check, SPEC must exist, regression test mandatory
- `test-bug-implementation.sh` — BUG must be CONFIRMED, minimal change, test naming convention
- `test-bug-review.sh` — inspect actual code, missing test = CHANGES REQUESTED, minimal change

**Change Workflow:**
- `test-change-request.sh` — APPROVED gate + classification, INVALIDATED/UNAFFECTED/REMOVED, no modify without approval

**Utility Skills:**
- `test-systematic-debugging.sh` — no fix before Phase 1, instrument before analyze, one variable at a time
- `test-git-worktrees.sh` — directory priority, .gitignore safety check, no duplicate worktrees
- `test-finishing-development-branch.sh` — tests before options, exactly 4 options, post-merge test gate

## What These Tests Verify

Each test asks Claude about a specific skill's rules and asserts the response contains the expected key terms. This verifies:

1. The skill **loads correctly** via the plugin
2. Key **workflow rules are present** in the skill content
3. The skill's **unique hard gates** are stated correctly under questioning

## What These Tests Don't Cover

- **Skill triggering** (natural language → automatic skill detection) — requires the using-spec-first meta-skill (P9)
- **End-to-end integration** (full workflow execution with real code output) — planned for P14
- **Pressure/rationalization resistance** (does the agent follow rules under pressure) — requires manual testing with the methodology in `superpowers/skills/writing-skills/testing-skills-with-subagents.md`

## Adding New Tests

1. Create `test-<skill-name>.sh` following the pattern in existing test files
2. Source `test-helpers.sh` at the top
3. Use `run_claude` with a timeout of 30 seconds per assertion
4. Add the filename to the `tests()` array in `run-skill-tests.sh`
5. Make executable: `chmod +x test-<skill-name>.sh`

## Token Analysis

After any Claude Code session, analyze token usage:

```bash
python3 analyze-token-usage.py ~/.claude/projects/<project-dir>/<session-id>.jsonl
```

Find recent sessions:
```bash
find ~/.claude/projects -name "*.jsonl" -mmin -60 | sort -r | head -5
```
