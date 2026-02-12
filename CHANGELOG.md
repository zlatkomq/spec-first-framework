# Changelog

All notable changes to the Spec-First AI Development Framework will be documented in this file.

## [0.7.2] - Cap Review Fix-Loop (2026-02-12)

### Summary

Adds a maximum iteration cap (3 attempts) to the `[F] Fix automatically` cycle in step 5 (code review). Prevents an infinite fix-review loop when AI-generated fixes keep introducing new issues.

### Changes

#### Review fix-loop cap
- **workflow-state.template.md:** Added `fixAttempts`, `previousIssueCount`, and `fixLoopActive` fields to frontmatter and descriptions. These track auto-fix iterations and enable fresh-entry detection.
- **step-05-review.md:**
  - Section 2 now checks `fixLoopActive` flag to distinguish fresh entry (reset counters) from `[F]` re-review loop (preserve counters).
  - CHANGES REQUESTED menu conditionally shows `[F]` only when `fixAttempts < 3`. When capped, displays convergence-based recommendation: diverging issues recommend `[B] Back to Tasks`, converging issues recommend `[A] Create action items`.
  - `[F]` handler expanded to 7 steps: increments counter, records issue count, sets `fixLoopActive = true` before redirecting to section 2.
  - All `[B]` back-navigation handlers (4 explicit, 3 inherited via "same as above") now reset `fixAttempts`, `previousIssueCount`, and `fixLoopActive` to prevent stale state.
- **REVIEW.template.md:** Added `Attempt` column to Auto-Fix Tracking table for per-attempt audit trail.

#### Fix counter reset gaps
- **step-00-continue.md:** `[B] Back to step N` handler now resets `fixAttempts`, `previousIssueCount`, and `fixLoopActive` — prevents stale counters when resuming via `/flow` and navigating back.
- **step-05-review.md:** `[A] Create action items` handler now explicitly resets fix counters (step 1), consistent with all `[B]` handlers. Removes implicit dependency on section 2 fresh-entry detection.

---

## [0.7.1] - Pipeline Hardening (2026-02-09)

### Summary

Six targeted changes to close gaps in the task-creation, implementation, and code-review pipeline. Prevents AI test fabrication, adds interface contracts between tasks, mandates integration tests for multi-component specs, adds file inventory before review, makes CONSTITUTION compliance checks evidence-based, and enables cross-spec code reuse.

### Changes

#### Gap 4: Raw Test Output as Evidence (most critical)
- **implementation.mdc:** Per-task validation gate 2 now requires pasting raw terminal output (stdout/stderr) in the implementation summary. If terminal is unavailable, task status is `IMPLEMENTED-UNVERIFIED` with `[~]` marker instead of `[x]`.
- **task-creation.mdc:** Documented `[~]` marker convention (not started / complete / unverified).
- **TASKS.template.md:** Added task marker legend.
- **definition-of-done.md:** Added "No unverified tasks" check — blocks Continue if any `[~]` tasks remain.

#### Gap 1: Interface Contracts Between Tasks
- **task-creation.mdc:** New "Interface Contracts" section. Tasks that create public components must declare `Produces:` signatures (derived from DESIGN.md). Dependent tasks use `Consumes: T[N].ComponentName` (task-ID references, not duplicated signatures). Validation checks and adversarial self-validation item 6 (contract check) added.
- **TASKS.template.md:** Updated task format to show Produces/Consumes fields.

#### Gap 3: Mandatory Integration Tests
- **task-creation.mdc:** Integration test mandate is now mechanically checkable: if DESIGN.md lists >1 New component that interact, integration test task is mandatory. Added adversarial self-validation item 7 (integration coverage check).

#### Gap 5: File Inventory Before Review (Phase 0)
- **code-review.mdc:** New Phase 0 before Phase 1. Read and quote first 3 lines of each expected file to verify access. 30% threshold: if >30% of files not reviewable, verdict is BLOCKED.
- **REVIEW.template.md:** Added Phase 0 section with file inventory table and coverage metrics.

#### Gap 2: Evidence-Based CONSTITUTION Checks
- **code-review.mdc:** Step 6 split into Category A (mechanically verifiable — grep, show output) and Category B (requires judgment — show code, then explain). Neither allows bare assertions.

#### Gap 6: Multi-Spec Sequencing
- **task-creation.mdc:** Previous Spec Intelligence now loads key source files from previous spec's Dev Agent Record File List (not just REVIEW.md). Added adversarial self-validation item 8 (cross-spec reinvention check).

---

## [0.7.0] - BMAD Fusion (2026-02-09)

### Summary

**BMAD fusion** adds agency-ready metadata, a dedicated change-request workflow, classification checks (bug vs scope change), and stricter implementation and review gates. This release aligns the framework with agency needs: traceability (Jira/SOW), Amendment History, SPEC-CURRENT.md, Dev Agent Record, and clear review policies.

### What's New

#### New Commands (`.cursor/commands/`)
- **`/change`** — Handle scope changes. Takes a spec reference and optional Jira ref. Runs classification check, impact analysis, and generates a Change Proposal. After approval: updates SPEC/DESIGN/TASKS, adds Amendment History row to SPEC.md, regenerates SPEC-CURRENT.md.
- **`/adversarial`** — Review any content (spec, design, doc) with extreme skepticism. Finds at least 10 issues. Use before approving a gate or to sanity-check documents.

#### New Rules (`.cursor/rules/`)
- **`change-request.mdc`** — Step 0 classification check, impact analysis, Change Proposal generation, post-approval artifact updates and SPEC-CURRENT regeneration.
- **`adversarial-review.mdc`** — Adversarial review flow (≥10 issues).

#### New Templates (`.framework/templates/`)
- **`CHANGE-PROPOSAL.template.md`** — Structure for change proposals including Classification Verification.
- **`SPEC-CURRENT.template.md`** — Header and instructions for compiled spec (SPEC + bugs + CRs).

#### New Checklist (`.framework/checklists/`)
- **`definition-of-done.md`** — Implementation completion checklist (tests, documentation, quality, status) used by step 4 before allowing Continue to review.

#### Agency Metadata (Phase 1)
- **SPEC.template.md, DESIGN.template.md, TASKS.template.md:** Added Approved By, Approval Date, Jira Ticket. SPEC adds Bug History table and Amendment History table.
- **workflow-state.template.md:** Added `jiraTicket` and `sowRef` in frontmatter and body.

### Improvements

#### Bugfix & Classification
- **bugfixing.mdc:** When a Jira ref is present, Step 0 classification check compares ticket vs SPEC.md ACs. If no AC is violated, flags "may be CR" and suggests `/change`.
- **bug-review.mdc:** Post-approval checklist now includes: update BUG.md status/date, add Bug History row to SPEC.md, regenerate SPEC-CURRENT.md using SPEC-CURRENT.template.md.

#### TASKS (Phase 3)
- **task-creation.mdc:** Context gathering (previous spec intelligence, git history); adversarial self-validation (reinvention, vagueness, coverage, test coverage, dependency order). No duplication of CONSTITUTION/DESIGN into TASKS.
- **TASKS.template.md:** Previous Spec Learnings, References, Dev Agent Record (Agent Model Used, Implementation Log, Decisions Made, File List).
- **step-03-tasks.md:** New step 3.5 — present validation findings (auto-fixed vs remaining concerns) before approval gate.

#### Implementation (Phase 4)
- **implementation.mdc:** Test-accompaniment mandate; per-task validation gates (tests exist, pass, match spec, ACs satisfied, no regressions); review continuation (REVIEW.md + [AI-Review] tasks); Dev Agent Record updates after each task; "same task fails validation 3 times" → HALT and suggest back to TASKS/DESIGN.
- **step-04-implement.md:** Priority for [AI-Review] tasks; per-task validation and Dev Agent Record update; DoD checklist before "all tasks complete" menu; DoD must pass before [C] Continue.

#### Review (Phase 5)
- **code-review.mdc:** Dev Agent Record File List vs git diff cross-check. Issue-count policy: &lt;3 → re-examine/justify; 3–10 → CHANGES REQUESTED or APPROVED; &gt;10 → BLOCKED with "re-implement from TASKS" recommendation.
- **step-05-review.md:** CHANGES REQUESTED menu: [F] Fix automatically (fix code, update Dev Agent Record, Auto-Fix Tracking, re-run review) or [A] Create action items (inject [AI-Review] tasks into TASKS.md, add Action Items Created to REVIEW, go to step-04). BLOCKED menu has no [F]/[A].
- **REVIEW.template.md:** Dev Agent Record cross-reference table; Auto-Fix Tracking section; Action Items Created section.

### How to Use

- **Change request:** `/change 001` or `/change 001: PROJ-123`. Follow the Change Proposal; after approval, SPEC/DESIGN/TASKS and Amendment History are updated and SPEC-CURRENT.md is regenerated.
- **Adversarial review:** `/adversarial` with the document you want reviewed (e.g. spec, design). Use before gate approval or to find weaknesses.
- **Classification:** When creating a bug with a Jira ref, the framework will suggest `/change` if the ticket does not violate any AC.

See [README.md](README.md) § BMAD Fusion for an overview and [docs/COMMANDS-WORKFLOW-EXAMPLE.md](docs/COMMANDS-WORKFLOW-EXAMPLE.md) for command usage.

---

## [0.6.0] - 2026-02-05

### Summary

Added **Cursor slash commands** as the primary way to run the spec-first workflow. Commands wrap rules and templates so you can drive the full flow (feature and bugfix) with simple prompts like `/specify`, `/design`, `/implement`, etc.

### What's New

#### Cursor Commands (`.cursor/commands/`)
- `/constitute` — Create or update `.framework/CONSTITUTION.md`
- `/specify` — Create `specs/XXX-slug/SPEC.md`
- `/design` — Create `specs/XXX-slug/DESIGN.md`
- `/tasks` — Create `specs/XXX-slug/TASKS.md`
- `/implement` — Implement one task from TASKS.md
- `/review` — Generate `specs/XXX-slug/REVIEW.md`
- `/bug` — Create `bugs/BUG-XXX-slug/BUG.md`
- `/bugfix` — Implement one task from BUG.md
- `/bugreview` — Generate `bugs/BUG-XXX-slug/REVIEW.md`

#### Documentation
- `docs/COMMANDS-WORKFLOW-EXAMPLE.md` — Full command reference and workflow examples
- README Usage and Bugfix Usage sections rewritten to use commands
- README Quick Start and folder structure updated to include `.cursor/commands/`
- `FOLDER-STRUCTURE.md` updated with commands folder and link to commands doc

### Improvements

- High-level workflow overview in README is now command-based and stable (details live in rules and commands doc)
- Rules (`@rule.mdc`) remain available for custom or advanced usage

### How to Use Commands

Run any step via the slash command; the command invokes the right rule and context. Example:

```
/constitute Python 3.12, FastAPI, PostgreSQL, pytest 80% coverage
/specify 001-user-auth: login, logout, session handling
/design 001
/tasks 001
/implement T1 from 001
/review 001
```

See [docs/COMMANDS-WORKFLOW-EXAMPLE.md](docs/COMMANDS-WORKFLOW-EXAMPLE.md) for full examples and [README.md](README.md) for the workflow overview.

---

## [0.5.0] - 2026-01-28

### Summary

Added comprehensive **bugfixing workflow** support to the framework. This release extends the framework beyond greenfield development to include structured bug fixing and maintenance workflows.

### What's New

#### Bugfixing Workflow
- **3-step bugfix process**: BUG → Implementation → Review
- **2 quality gates** with human approval checkpoints
- **Full traceability** from bug report to fix, linked back to original SPEC.md
- **Regression testing** requirements built into the workflow

#### New Rules (`.cursor/rules/`)
- `bugfixing.mdc` — Create bug reports from issues
- `bug-implementation.mdc` — Implement bug fixes following standards
- `bug-review.mdc` — Review fixes against bug criteria and original spec

#### New Templates (`.framework/templates/`)
- `BUG.template.md` — Bug report structure with severity, steps to reproduce, and acceptance criteria
- `BUG-REVIEW.template.md` — Bug fix review structure

#### Workflow Diagrams
- `framework-bugfix-workflow.mermaid` — Visual bugfix workflow diagram
- `framework-workflow-final.mermaid` — Updated feature workflow (separated from bugfix)

#### Bug Status Lifecycle
- **DRAFT** → Tech Lead approval → **CONFIRMED** → Fix implemented → **FIXED**

### Improvements

- Separated feature and bugfix workflows into distinct diagrams for clarity
- Moved framework examples to `docs/examples/` for better organization
- Updated `.gitignore` to exclude `specs/` folder (testing only)
- Aligned all rules and templates for consistency

### How to Use Bugfixing

1. When a bug is found, reference the original `SPEC.md`
2. Create `BUG.md` using: `@bugfixing.mdc` + `@SPEC.md` + issue description
3. Tech Lead approves bug report (Gate 1)
4. Implement fix using: `@bug-implementation.mdc` + `@BUG.md` + `@DESIGN.md`
5. Review fix using: `@bug-review.mdc` + `@BUG.md` + `@SPEC.md`
6. Reviewer approves fix (Gate 2)
7. Update original `SPEC.md` Bug History section

See [README.md](README.md) and workflow diagrams for detailed instructions.

---

## [0.4.0] - 2026-01-23

### Summary

First public release of the Spec-First AI Development Framework. This version provides a complete workflow for **greenfield backend API development** using AI-assisted coding.

### What's Included

#### Workflow
- **5-step development process**: SPEC → DESIGN → TASKS → Implementation → Review
- **4 quality gates** with human approval checkpoints
- **Full traceability** from requirements to code

#### Rules (`.cursor/rules/`)
- `spec-creation.mdc` — Create specifications from requirements
- `design-creation.mdc` — Generate technical designs from approved specs
- `task-creation.mdc` — Break designs into atomic, implementable tasks
- `implementation.mdc` — Implement code following standards
- `code-review.mdc` — Review code against acceptance criteria
- `constitution-creation.mdc` — Define project-level standards

#### Templates (`.framework/templates/`)
- `SPEC.template.md` — Specification structure
- `DESIGN.template.md` — Technical design structure
- `TASKS.template.md` — Task breakdown structure
- `CONSTITUTION.template.md` — Project standards structure

#### Example
- Complete 001 User Registration example showing full workflow execution

#### Documentation
- `README.md` — Quick start guide
- `PHILOSOPHY.md` — Framework principles and approach
- `FOLDER-STRUCTURE.md` — Detailed folder and file descriptions
- `WORKFLOW-DEMO.md` — Live walkthrough of the workflow

### Scope & Limitations

**Current version is optimized for:**
- Greenfield projects (new codebases)
- Backend API development (services, APIs, database-backed applications)
- Cursor IDE (using `.mdc` rule files)

**Not yet supported:**
- Frontend/mobile development (planned)
- Brownfield/legacy codebases (planned)
- Other IDEs (Claude Code, Antigravity — planned)
- Enforcement tooling (CI checks, pre-commit hooks — planned)

### How to Adopt

1. Copy `.cursor/` and `.framework/` folders into your project
2. Create `CONSTITUTION.md` using: `@constitution-creation.mdc` + your project description
3. For each spec, follow the workflow: SPEC → DESIGN → TASKS → Implementation → Review

See [README.md](README.md) for detailed instructions.

---

## Planned for Future Releases

### 0.6.0 (Planned)
- Frontend/mobile templates and rules
- Component architecture support
- State management patterns

### 0.7.0 (Planned)
- Brownfield/legacy codebase support
- Codebase analysis rules
- Legacy assessment templates

### 1.0.0 (Planned)
- Production-ready across all domains
- Enforcement tooling
- Multi-IDE support
- Jira integration
