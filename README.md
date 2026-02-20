# Spec-First AI Development Framework

A structured methodology for AI-assisted software development. Ensures traceability, quality gates, and consistent outputs across projects.

## Installation

### Install the CLI

```bash
sudo curl -fsSL https://raw.githubusercontent.com/zlatkomq/spec-first-framework/main/spec-first.sh -o /usr/local/bin/spec-first && sudo chmod +x /usr/local/bin/spec-first
```

### Initialize a project

```bash
cd your-project
spec-first init
```

### Update to latest framework

```bash
spec-first update
```

### Switch to a different branch

```bash
spec-first update --branch <branch-name>
```

### CLI Commands

| Command | Description |
|---------|-------------|
| `spec-first init` | Install framework into current project |
| `spec-first update` | Pull latest rules/templates (preserves specs, bugs, constitution) |
| `spec-first update --branch <name>` | Switch to a different framework branch |
| `spec-first version` | Show installed framework version |

## Quick Start

1. Install the framework with `spec-first init` (or manually copy `.cursor/` and `.framework/` folders into your project)
2. Create `CONSTITUTION.md` using: `/constitute` + your project description
3. For each spec, follow the workflow: SPEC → DESIGN → TASKS → Implementation → Review

**Commands** (in `.cursor/commands/`): `/constitute`, `/specify`, `/design`, `/tasks`, `/implement`, `/review`, `/flow`, `/bug`, `/bugfix`, `/bugreview`, `/change`, `/adversarial` — see [Commands & Workflow Example](docs/COMMANDS-WORKFLOW-EXAMPLE.md).

**Guided workflow (recommended):** Use **`/flow 001-slug: requirements`** to run the full feature workflow step by step (BMAD-style: state + step files + menus). Resume anytime with **`/flow 001`**. Go back with **[B]**, continue with **[C]**. See [Workflow return and continue](docs/WORKFLOW-RETURN-AND-CONTINUE.md).

## Workflow

### Feature Workflow

```
STEP 0: CONSTITUTION.md (once per project)
         ↓
STEP 1: SPEC.md → Gate 1 (PO approves)
         ↓
STEP 2: DESIGN.md → Gate 2 (Tech Lead approves)
         ↓
STEP 3: TASKS.md → Gate 3 (Tech Lead approves)
         ↓
STEP 4: Implementation (all tasks)
         ↓
STEP 5: Code Review → Gate 4 (Reviewer approves) → Done
```

### Bugfix Workflow

```
BUG REPORTED + Original SPEC.md reference
         ↓
STEP 1: BUG.md → Gate 1 (Tech Lead confirms)
         ↓
STEP 2: Implementation (fix + regression test)
         ↓
STEP 3: Bug Review → Gate 2 (Reviewer approves)
         ↓
Update original SPEC.md Bug History → Done
```

### Change Request Workflow

```
SCOPE CHANGE IDENTIFIED
         ↓
/change 001: [Jira ticket or description]
         ↓
Classification check (bug vs CR)
         ↓
Impact analysis → Change Proposal document
         ↓
User approves → Update SPEC/DESIGN/TASKS, Amendment History, SPEC-CURRENT.md
```

## BMAD Fusion (Agency & Quality Enhancements)

This framework includes **BMAD fusion** enhancements: agency-ready metadata, change requests, classification checks, and stricter implementation/review gates.

### Agency Metadata

All spec artifacts support traceability fields for billing and audit:

- **Gate metadata:** Approved By, Approval Date, Jira Ticket on SPEC, DESIGN, and TASKS
- **Workflow state:** `jiraTicket` and `sowRef` in `.workflow-state.md` for Jira/SOW linking
- **Bug History** and **Amendment History** in SPEC.md — updated automatically when bugs are fixed or change requests are implemented

### New Commands

| Command | Purpose |
|---------|---------|
| `/change {spec}` | Handle scope changes. Produces a Change Proposal with impact analysis. On approval, updates artifacts and regenerates SPEC-CURRENT.md. |
| `/adversarial` | Review any content (spec, design, doc) with extreme skepticism. Finds at least 10 issues. Use before approving a gate or to sanity-check a document. |

### Classification Check

When `/bug` or `/change` is run with a Jira ticket (or ticket description), the framework compares the ticket against SPEC.md acceptance criteria and flags misclassification:

- **Bug reported but no AC violated** → "This may be a Change Request. Consider `/change`."
- **CR requested but it fixes an AC violation** → "This may be a Bug. Consider `/bug`."

Reduces billing disputes and keeps bug vs scope-change work clearly separated.

### SPEC-CURRENT.md

After a bug is fixed or a change request is implemented, the framework can regenerate **SPEC-CURRENT.md**: a compiled view of the current specification (frozen SPEC + all applied bug fixes + all applied amendments). Use it as the single "current state" reference without editing SPEC.md by hand.

### Implementation & Review Enhancements

- **Test-accompaniment:** Every implementation task must produce tests alongside code; per-task validation gates (tests exist, pass, ACs satisfied) before marking complete.
- **Implementation summary:** After implementing all tasks, an IMPLEMENTATION-SUMMARY.md is written to the spec folder with files changed, key decisions, patterns established, and test results.
- **Review continuation:** If code review finds issues, you can choose **[F] Fix automatically** (AI fixes and re-reviews) or **[B] Back to Implement** (return to step 4 with review findings as context).
- **Issue count policy:** Review verdicts: &lt;3 issues (re-examine/justify), 3–10 (CHANGES REQUESTED), &gt;10 (BLOCKED — recommend re-implementing from TASKS rather than patching).
- **Verification gate:** Step 4 runs a pre-flight verification checklist (see `.framework/checklists/verification-checklist.md`) after implementation before allowing Continue to review.

See [CHANGELOG.md](CHANGELOG.md) for the full list of changes in this release.

## Folder Structure

```
your-project/
├── skills/                            # Cross-platform AI skills (SKILL.md open standard)
│   ├── spec-creation/SKILL.md         #   Cursor 2.4+, Claude Code, OpenCode, Codex, Gemini CLI
│   ├── design-creation/SKILL.md
│   ├── task-creation/SKILL.md
│   ├── implementation/SKILL.md
│   ├── code-review/SKILL.md
│   ├── constitution-creation/SKILL.md
│   ├── adversarial-review/SKILL.md
│   ├── bugfixing/SKILL.md
│   ├── bug-implementation/SKILL.md
│   ├── bug-review/SKILL.md
│   └── change-request/SKILL.md
├── .cursor-plugin/plugin.json         # Cursor adapter
├── .claude-plugin/plugin.json         # Claude Code adapter
├── .opencode/                         # OpenCode plugin (see .opencode/INSTALL.md for setup)
├── .cursor/
│   └── commands/                      # Cursor slash commands: /specify, /design, /tasks, etc.
├── .framework/
│   ├── steps/                         # BMAD-style step files for /flow
│   │   ├── step-00-continue.md        #   Resume logic
│   │   ├── step-01-spec.md            #   Create SPEC.md
│   │   ├── step-02-design.md          #   Create DESIGN.md
│   │   ├── step-03-tasks.md           #   Create TASKS.md
│   │   ├── step-04-implement.md       #   Implement tasks
│   │   └── step-05-review.md          #   Code review
│   ├── templates/
│   │   ├── SPEC.template.md
│   │   ├── DESIGN.template.md
│   │   ├── TASKS.template.md
│   │   ├── REVIEW.template.md
│   │   ├── BUG.template.md
│   │   ├── BUG-REVIEW.template.md
│   │   ├── CONSTITUTION.template.md
│   │   ├── workflow-state.template.md
│   │   ├── CHANGE-PROPOSAL.template.md   # For /change
│   │   └── SPEC-CURRENT.template.md      # Compiled spec view
│   ├── checklists/
│   │   └── verification-checklist.md     # Step 4 verification gate
│   └── CONSTITUTION.md          ← You create this
├── specs/
│   └── XXX-description/
│       ├── .workflow-state.md          ← Created by /flow (tracks progress)
│       ├── SPEC.md
│       ├── DESIGN.md
│       ├── TASKS.md
│       ├── IMPLEMENTATION-SUMMARY.md   ← Written after implementation (step 4)
│       └── REVIEW.md
├── bugs/
│   └── BUG-XXX-description/
│       ├── BUG.md
│       └── REVIEW.md
└── src/
```

## Usage

All steps can be run via the slash commands below. See [Commands & Workflow Example](docs/COMMANDS-WORKFLOW-EXAMPLE.md) for details.

### Step 0: Project Setup (once)

```
/constitute Python 3.12, FastAPI, PostgreSQL, pytest 80% coverage, REST API
```

### Step 1: Create Specification

```
/specify 001-user-authentication: [paste requirements from PO/client]
```

### Step 2: Create Technical Design

```
/design 001
```

### Step 3: Create Task Breakdown

```
/tasks 001
```

### Step 4: Implement

```
/implement 001
```

### Step 5: Review

```
/review 001
```

---

## Bugfix Usage

### Step 1: Create Bug Report

```
/bug 001-user-registration: Email validation passes for "user@domain" (missing TLD). Steps: Enter "test@domain", click register, succeeds but shouldn't.
```

### Step 2: Implement Fix

```
/bugfix T1 from BUG-001
```

### Step 3: Review Fix

```
/bugreview BUG-001
```

After approval, update the original SPEC.md Bug History table.

---

## When to Use Each Workflow

| Situation | Workflow |
|-----------|----------|
| New feature or enhancement | Feature workflow (SPEC.md) |
| Code violates existing acceptance criteria | Bugfix workflow (BUG.md) |
| Scope change, new requirement, or client request | Change request: `/change {spec}` |
| Acceptance criteria was missing or wrong | Feature workflow (narrow spec) |
| Refactoring without behavior change | Feature workflow (Type: Refactor) |
| Performance optimization | Feature workflow (Type: Performance) |
| Database/system migration | Feature workflow (Type: Migration) |
| Trivial fix you made yourself (typo, config, one-liner) | Quick fix convention (no workflow) |
| Sanity-check a spec/design/doc before approving | `/adversarial` (finds 10+ issues) |

Note: Dedicated workflows for Refactor, Performance, and Migration may be added in future versions.

### Quick Fixes (No Workflow Needed)

For obvious fixes you make yourself (typos, config tweaks, one-liners):

1. Fix it
2. Commit with prefix: `quickfix(FEAT-XXX): description`
3. Optionally update SPEC.md Bug History table

No commands, no AI, no ceremony. The git log is your traceability. Find all quick fixes for a spec with `git log --grep="quickfix(FEAT-001)"`.

Use `/bug` instead if the fix needs investigation, touches many files, or carries risk.

## Documentation

- [FOLDER-STRUCTURE.md](FOLDER-STRUCTURE.md) — Detailed folder and file descriptions
- [Commands & Workflow Example](docs/COMMANDS-WORKFLOW-EXAMPLE.md) — Using slash commands (`/specify`, `/design`, etc.)
- [Workflow return and continue](docs/WORKFLOW-RETURN-AND-CONTINUE.md) — Resume or go back a step, then continue (`/flow 001`)
- [BMAD Fusion — Change Request Summary](docs/BMAD-FUSION-CHANGES.md) — Full list of BMAD fusion changes (templates, rules, steps)
- [framework-workflow-final.mermaid](framework-workflow-final.mermaid) — Visual workflow diagram
- [framework-legacy-analysis.mermaid](framework-legacy-analysis.mermaid) — Brownfield analysis flow (coming soon)

## Status

**Greenfield workflow:** ✅ Complete
**Bugfix workflow:** ✅ Complete
**Brownfield workflow:** 🚧 In progress
