# BMAD Fusion — Change Request Summary

This document summarizes all changes introduced in the **BMAD fusion** release (v0.7.0). Use it to understand what was added or changed and where to find the relevant files.

---

## 1. Agency Metadata

**Purpose:** Traceability for billing, audit, and Jira/SOW linking.

| Location | Change |
|----------|--------|
| `SPEC.template.md` | Approved By, Approval Date, Jira Ticket; **Bug History** table; **Amendment History** table |
| `DESIGN.template.md` | Approved By, Approval Date, Jira Ticket |
| `TASKS.template.md` | Approved By, Approval Date, Jira Ticket |
| `workflow-state.template.md` | `jiraTicket` and `sowRef` in frontmatter and body |

---

## 2. Change Request Workflow

**Purpose:** Handle scope changes (new requirements, client requests) with impact analysis and Amendment History.

| Item | Path |
|------|------|
| Command | `.cursor/commands/change.md` — `/change {spec}` or `/change {spec}: {Jira ref}` |
| Rule | `.cursor/rules/change-request.mdc` — Step 0 classification, impact analysis, Change Proposal, post-approval updates |
| Template | `.framework/templates/CHANGE-PROPOSAL.template.md` — Structure for change proposals including Classification Verification |

**Post-approval:** Update SPEC/DESIGN/TASKS, add Amendment History row to SPEC.md (CR ID, Date, Description, Approved By), regenerate SPEC-CURRENT.md.

---

## 3. Adversarial Review

**Purpose:** Sanity-check any document (spec, design, doc) before approving a gate; find at least 10 issues.

| Item | Path |
|------|------|
| Command | `.cursor/commands/adversarial.md` — `/adversarial` |
| Rule | `.cursor/rules/adversarial-review.mdc` |

---

## 4. Classification Check (Bug vs CR)

**Purpose:** Avoid misclassifying scope changes as bugs (or vice versa).

| Location | Change |
|----------|--------|
| `bugfixing.mdc` | When Jira ref present: compare ticket vs SPEC.md ACs. If no AC violated → flag "may be CR" and suggest `/change`. |

---

## 5. SPEC-CURRENT.md

**Purpose:** Single compiled view of current specification (frozen SPEC + applied bug fixes + applied amendments).

| Item | Path |
|------|------|
| Template | `.framework/templates/SPEC-CURRENT.template.md` — Header and instructions for compiled spec |
| Regeneration | Triggered in `bug-review.mdc` (post bug approval) and `change-request.mdc` (post CR approval) |

---

## 6. TASKS Enhancement

**Purpose:** Richer context, validation before gate, and Dev Agent Record for audit.

| Location | Change |
|----------|--------|
| `task-creation.mdc` | Context: previous spec intelligence, git history. Adversarial self-validation (reinvention, vagueness, coverage, test coverage, dependency order). No duplication of CONSTITUTION/DESIGN into TASKS. |
| `TASKS.template.md` | Previous Spec Learnings, References, **Dev Agent Record** (Agent Model Used, Implementation Log, Decisions Made, File List) |
| `step-03-tasks.md` | **Step 3.5:** Present validation findings (auto-fixed vs remaining concerns) before approval gate |

---

## 7. Implementation Enhancement

**Purpose:** Tests alongside code, per-task validation, review continuation, and DoD checklist.

| Location | Change |
|----------|--------|
| `implementation.mdc` | Test-accompaniment mandate; per-task validation gates; review continuation (REVIEW.md + [AI-Review] tasks); Dev Agent Record updates after each task; "same task fails 3 times" → HALT, suggest back to TASKS/DESIGN |
| `step-04-implement.md` | Priority for [AI-Review] tasks; per-task validation and Dev Agent Record update; **DoD checklist** before "all tasks complete"; DoD must pass before [C] Continue |
| New checklist | `.framework/checklists/definition-of-done.md` — Implementation completion, testing, documentation, quality, final status |

---

## 8. Review Enhancement

**Purpose:** Clear issue-count policy, [F] Fix / [A] Action Items, BLOCKED handling, and REVIEW template updates.

| Location | Change |
|----------|--------|
| `code-review.mdc` | Dev Agent Record File List vs git diff cross-check. **Issue policy:** &lt;3 → re-examine; 3–10 → CHANGES REQUESTED or APPROVED; &gt;10 → BLOCKED with "re-implement from TASKS" |
| `step-05-review.md` | CHANGES REQUESTED: **[F] Fix automatically** (fix code, update Dev Agent Record, Auto-Fix Tracking, re-run review) or **[A] Create action items** (inject [AI-Review] tasks into TASKS.md, Action Items Created, go to step-04). BLOCKED: separate menu, no [F]/[A]. |
| `REVIEW.template.md` | Dev Agent Record cross-reference table; **Auto-Fix Tracking** section; **Action Items Created** section |

---

## 9. Pipeline Hardening (v0.7.1)

Six targeted changes to prevent the most common AI failure modes in the pipeline.

| Gap | What Changed | File(s) |
|-----|-------------|---------|
| **Raw test output** | Implementation summary requires pasting raw terminal stdout/stderr. No terminal = `IMPLEMENTED-UNVERIFIED` `[~]` status. DoD blocks on unverified tasks. | `implementation.mdc`, `task-creation.mdc`, `TASKS.template.md`, `definition-of-done.md` |
| **Interface contracts** | Tasks declare `Produces:` (signatures) and `Consumes: T[N].ComponentName` (task-ID refs, no drift). Adversarial validation catches missing contracts. | `task-creation.mdc`, `TASKS.template.md` |
| **Integration tests** | Mandatory if DESIGN.md has >1 New component that interact. Mechanically checkable from component table. | `task-creation.mdc` |
| **File inventory (Phase 0)** | Review reads and quotes first 3 lines of every expected file before Phase 1. >30% not reviewable = BLOCKED. | `code-review.mdc`, `REVIEW.template.md` |
| **Evidence-based checks** | CONSTITUTION compliance split into Category A (grep, show output) and Category B (show code, then explain). No bare assertions. | `code-review.mdc` |
| **Multi-spec sequencing** | Task creation loads previous spec's source files (from Dev Agent Record File List) to prevent reinvention. Cross-spec reinvention check in adversarial validation. | `task-creation.mdc` |

---

## Quick Reference

- **New commands:** `/change`, `/adversarial`
- **New rules:** `change-request.mdc`, `adversarial-review.mdc`
- **New templates:** `CHANGE-PROPOSAL.template.md`, `SPEC-CURRENT.template.md`
- **New checklist:** `definition-of-done.md`
- **Updated:** SPEC/DESIGN/TASKS/REVIEW/workflow-state templates; bugfixing, bug-review, task-creation, implementation, code-review rules; step-03, step-04, step-05

For version history, see [CHANGELOG.md](../CHANGELOG.md). For usage overview, see [README.md](../README.md) § BMAD Fusion.
