# Code Review

## Description

Use when generating a REVIEW.md document for a completed spec implementation (step 5 of the `/flow` workflow).
Not for standalone adversarial review of any document — use the adversarial-review skill for that. Not for bugfix review — use the bug-review skill.

## Instructions

You are generating a REVIEW.md document for a completed spec. Follow these rules strictly.

### Review Mindset

You are an ADVERSARIAL code reviewer. Your job is to find what is wrong or missing.

```
IRON LAW: Do NOT produce a review based solely on reading spec documents.
You MUST inspect actual source code. You MUST run tests.
A review without code inspection is not a review.
```

- CHALLENGE every claim: Are tasks marked complete actually implemented? Do tests actually test real behavior?
- ASSUME nothing: Verify every file, every function, every acceptance criterion against actual code.
- DISTRUST surface quality: AI-generated code is syntactically clean and well-commented by default. That means nothing. Clean syntax does not equal correct behavior.
- Expect to find at least 3 specific, actionable issues in every review. If you find fewer, re-examine before concluding the code is genuinely clean.

#### Rationalization Traps

These are common excuses AI reviewers use to shortcut the review. If you catch yourself thinking any of these, the corresponding reality applies.

| Excuse | Reality |
|--------|---------|
| "The code looks clean so it's probably correct" | Clean syntax is the AI default. Verify behavior, not formatting. |
| "I can't access the file so I'll assume it's fine" | Mark it NOT VERIFIED. Never assume. Unverified files count toward the 30% threshold. |
| "Only 2 issues found, that's enough" | Re-examine per the quality pressure checklist. Justify if truly fewer than 3. |
| "Tests exist so the code is tested" | Check what the tests actually assert. `result is not None` tests nothing. |
| "The implementation summary says it's done" | Summaries are claims, not evidence. Verify against actual code and git diff. |

### What You Must Inspect

Although you are producing `specs/XXX/REVIEW.md`, you must actively inspect:
- Source code in `src/` (or project's source directory per CONSTITUTION.md)
- Test files in `tests/` (or project's test directory per CONSTITUTION.md)
- Any configuration files changed
- The actual implementation, not just the spec documents

Do NOT produce a review based solely on reading SPEC.md, DESIGN.md, and TASKS.md. You must verify the code exists and matches.

### Required Inputs

Before reviewing, you must have access to:
- `specs/XXX/SPEC.md` for acceptance criteria
- `specs/XXX/DESIGN.md` for technical approach
- `specs/XXX/TASKS.md` for task list
- `../../.framework/CONSTITUTION.md` for coding standards
- The actual source code files implementing this feature

---

### Review Process

The review is organized into four phases (Phase 0 through Phase 3). Complete all phases in order.

---

#### PHASE 0: File Inventory

*Purpose: Verify access to every relevant file before any review begins. Do not review code you haven't read.*

Before starting the review:

1. **Build expected file list:** From TASKS.md (task descriptions) and IMPLEMENTATION-SUMMARY.md (files changed list, if exists), list every file that should exist.
2. **Verify existence and access:** For each file, confirm you can read it. If you cannot, flag it as NOT REVIEWABLE.
3. **Track coverage:** Report: "Verified access to N/M files." List any files NOT reviewable with the reason (missing, unreadable, etc.).
4. **30% threshold:** If more than 30% of expected files cannot be reviewed, verdict is BLOCKED — the spec is too large for reliable single-pass review, or files are missing. Recommend: split into smaller specs or review in sections.
5. **No unreviewed claims:** Do NOT make claims about code in files you haven't read. If a file is not reviewable, any checks that depend on it are marked "NOT VERIFIED — file not reviewed."

Report in the review:

| Metric | Count |
|--------|-------|
| Expected files (from TASKS.md) | [N] |
| Files verified accessible | [N] |
| Files not reviewable | [N] — [list paths] |

---

#### PHASE 1: Reality Check

*Purpose: Verify the work is actually done, clean, and testable before spending time on correctness.*

##### Step 1: Git Reality Check

Before reviewing code, verify what actually changed. Compare actual changed files (via git diff against the base branch) with TASKS.md expected changes. Check for uncommitted or unstaged changes. If git is not available, note "Git verification not available — manual file inspection only" in the review.

**Flag discrepancies as findings:**

| Discrepancy | Severity |
|-------------|----------|
| Files changed but not referenced in any task | MEDIUM — undocumented changes |
| Tasks claiming file changes but file not modified in git | CRITICAL — false claims |
| Files that should be created per TASKS.md but don't exist at all | CRITICAL — missing implementation |
| Uncommitted or unstaged changes | MEDIUM — incomplete work |
| Change size wildly inconsistent with task scope (e.g., "implement authentication" but only 12 lines changed) | MEDIUM — suspicious scope |

##### Step 2: Dead Code & Placeholder Scan

Scan for all prohibited patterns defined in the Prohibited Patterns section of `../implementation/SKILL.md` (TODO, FIXME, HACK, XXX, empty catch blocks, hardcoded stubs, debug prints, commented-out code, empty function bodies, not-implemented throws, unused imports). Adapt to the project's language per CONSTITUTION.md.

**Flag every instance found as a finding.** Placeholders and dead code are never acceptable in reviewed code.

##### Step 3: Test Execution

Execute the project's test suite per CONSTITUTION.md. Record: total tests, passed, failed, skipped, errors, and coverage percentage.

**Flag these as findings:**

| Result | Severity |
|--------|----------|
| Any test failure | CRITICAL — code is broken |
| Skipped tests without justification | MAJOR — hidden problems |
| Coverage below CONSTITUTION.md threshold | MAJOR — insufficient testing |
| Tests pass but coverage delta is negative (less coverage than before) | MEDIUM — regression in test quality |

If terminal access is NOT available, explicitly state in the review: "Test execution not performed — manual verification required. Reviewer should run tests before approving." Do NOT write "tests look good" without running them. Do NOT leave an ambiguous ⚠️.

---

#### PHASE 2: Spec Verification

*Purpose: Verify the implementation does what the spec says. This is the primary mission of the review.*

##### Step 4: Acceptance Criteria Validation

This is the most important step in the entire review. For EACH acceptance criterion in SPEC.md:

1. Read the criterion exactly as written
2. Trace it to the specific code path that implements it
3. Verify the behavior matches the criterion — not the spirit, the specifics
4. Check that at least one test covers this criterion

Do NOT accept "the code looks like it handles this." Verify: is there a code path that does exactly what the criterion says?

**Example of insufficient verification:**
- Criterion: "Given an expired token, when the user requests a resource, then the system returns 401"
- BAD: "Authentication middleware exists" ← does not verify expired token handling specifically
- GOOD: "auth_middleware.py (validate_token) checks token.exp against current time, raises UnauthorizedError which endpoint maps to 401" ← traces the specific path

Format:
```
| Criterion | Status | Evidence |
|-----------|--------|----------|
| Given X, when Y, then Z | PASS/FAIL | path/to/file.py (function_name) — [specific explanation] |
```

**Evidence format:** Use `path/to/file.py (function_name)` or `path/to/file.py (ClassName.method)`. Do not guess line numbers. Include a brief explanation of HOW the code satisfies the criterion, not just WHERE.

If a criterion has no corresponding test, flag it as MAJOR finding even if the code looks correct.

##### Step 5: Task Completion Check

Verify every task in TASKS.md is implemented:
- [ ] All implementation tasks (T1, T2, ...) have corresponding code files
- [ ] All testing tasks have corresponding test files with real tests
- [ ] No tasks were skipped
- [ ] Implementation matches what the task description says (not just that a file exists)

If tasks are missing or incomplete, set Verdict = BLOCKED.

---

#### PHASE 3: Quality Audit

*Purpose: Verify the code is built correctly according to project standards.*

##### Step 6: CONSTITUTION.md Compliance

Check code against project standards. Checks are split into two categories. Neither category allows bare assertions without evidence.

**Category A: Mechanically Verifiable**

Verify with evidence (show specific violations or confirm clean scan):

- **Naming conventions:** Check source files against CONSTITUTION.md naming rules. Show violations.
- **File/folder structure:** Compare actual file locations against CONSTITUTION.md structure. Flag misplaced files.
- **Import patterns:** Check for prohibited import patterns per CONSTITUTION.md. Show violations.
- **Prohibited patterns:** Already covered in Phase 1 dead code scan — reference those results here, do not re-scan.

**Category B: Requires Judgment**

For each check, show relevant code evidence and explain compliance or violation. Do not assert compliance without evidence.

- **Architectural patterns:** Verify classes/functions follow CONSTITUTION.md patterns (Repository, DI, etc.).
- **Error handling patterns:** Verify error handling matches CONSTITUTION.md error strategy.
- **Error responses:** Verify error response format matches CONSTITUTION.md.
- **Security checks:** Verify input validation, auth checks, and data handling.
- **Secrets/credentials:** Check for hardcoded strings, API keys, passwords.
- **Sensitive data in logs:** Check for user data in logging statements.

**Testing Quality**
- [ ] Unit tests exist for new code
- [ ] Tests assert real behavior, not trivial truths
- [ ] Tests cover error paths, not just happy paths
- [ ] Test assertions are specific (not just "no exception thrown" or "result is not null")
- [ ] No duplicate test logic with only descriptions changed
- [ ] Test coverage meets threshold from CONSTITUTION.md

**Testing red flags to catch:**
| Red Flag | What It Means |
|----------|---------------|
| Test only asserts `result is not None` or `expect(result).toBeDefined()` | Tests the mock, not the code |
| Test has no assertions at all | Placeholder test for coverage |
| Test description says "should handle errors" but only tests happy path | Misleading test |
| Multiple tests with identical structure, different descriptions | Copy-paste tests |
| Test mocks the thing it's supposed to be testing | Circular testing |
| All tests pass but none test edge cases from acceptance criteria | Incomplete coverage |

##### Step 7: DESIGN.md Alignment

Verify implementation matches technical design:
- [ ] Architecture followed as specified
- [ ] Data models match design (field names, types, relationships)
- [ ] APIs/interfaces match design (endpoints, request/response shapes, status codes)
- [ ] No unauthorized deviations from design
- [ ] Dependencies added are justified and listed in DESIGN.md

If deviations exist, they must be justified. Unjustified deviations = finding.

---

#### POST-PHASE: Implementation Summary Cross-Reference

Cross-reference IMPLEMENTATION-SUMMARY.md File List (from the spec folder) with git diff (if available):

| Discrepancy | Severity |
|-------------|----------|
| Files in git diff but NOT in IMPLEMENTATION-SUMMARY.md | MEDIUM — undocumented changes |
| Files in IMPLEMENTATION-SUMMARY.md but NOT in git diff | HIGH — false claims in summary |
| Uncommitted changes not documented anywhere | MEDIUM — incomplete tracking |

This catches cases where the AI agent claimed to change files it didn't, or changed files it didn't document.

#### POST-PHASE: Verdict Determination

After completing all phases, determine the verdict using severity as the primary signal and count as secondary quality pressure.

**Step 1: Check for hard blockers (verdict = BLOCKED regardless of count)**
- More than 30% of files not reviewable (from Phase 0)
- Tasks missing or incomplete (from Phase 2, Step 5)
- Tests fail when executed (from Phase 1, Step 3)

If any hard blocker applies, verdict is **BLOCKED**. Still complete the full review document.

**Step 2: Classify issues by severity**

Count Critical, Major, and Minor issues from all phases.

**Step 3: Apply severity-based verdict**

| Condition | Verdict |
|-----------|---------|
| No Critical or Major issues, and total issues <= 10 | **APPROVED** |
| No Critical or Major issues, but total issues > 10 (all Minor) | **CHANGES REQUESTED** — volume of minor issues suggests systemic style/quality gaps worth addressing |
| Any Critical or Major issues, and (critical_count >= 3 OR total issues > 10) | **BLOCKED** — systemic problems; recommend going back to TASKS.md (step 3) rather than patching |
| Any Critical or Major issues (but below escalation thresholds) | **CHANGES REQUESTED** |

**Step 4: Issue count quality pressure (applied after verdict)**

If fewer than 3 issues were found, you are likely NOT LOOKING HARD ENOUGH. Go back and re-examine:
- Edge cases and null/empty input handling
- Error messages — are they helpful or generic?
- Test quality — do assertions test real behavior or just "no exception thrown"?
- Performance — N+1 queries, unbounded loops, missing pagination
- Security — injection risks, missing auth checks, exposed internals
- Missing tests for error/edge paths from acceptance criteria
- Architecture violations or unauthorized deviations
- Documentation gaps

If still fewer than 3 after re-examination, document in one sentence why this code genuinely has fewer than 3 issues (e.g., "Trivial single-function config change with comprehensive existing test coverage"). This is acceptable but must be justified. **Do not override the severity-based verdict from Step 3** — if 2 Critical issues were found, the verdict is CHANGES REQUESTED regardless of total count.

### Review Verdicts

#### APPROVED
All checks pass. No critical or major issues. Code is ready for human reviewer at Gate 4.

#### CHANGES REQUESTED
One or more checks failed. List specific issues with:
- What failed
- Where (file path + identifier)
- What needs to change
- Which task to revisit (T1, T2, etc.)

#### BLOCKED
Cannot complete full review, OR systemic severity issues found. Reasons include:
- 3 or more Critical issues (systemic implementation problems)
- More than 10 issues that include Critical or Major findings
- Missing or incomplete tasks
- Missing tests
- Cannot trace acceptance criteria to code
- Required files not accessible (>30% threshold)
- Tests fail when executed

Note: Always produce a full review document even when BLOCKED. List what is missing and what was reviewable. If BLOCKED due to systemic issues, recommend going back to TASKS.md (step 3) rather than patching.

### Output Format

Produce REVIEW.md following the structure in `../../.framework/templates/REVIEW.template.md`.

Save review output to: `specs/XXX-{slug}/REVIEW.md`

### Constraints

- Do NOT approve code that fails acceptance criteria
- Do NOT approve code with missing tests
- Do NOT approve code that deviates from DESIGN.md without justification
- Do NOT fix code yourself — only report issues
- Do NOT add new requirements not in SPEC.md
- Do NOT fabricate line numbers — use function/class/method identifiers instead
- Do NOT trust implementation summaries at face value — verify claims against actual code
- Do NOT accept tests that only assert "no exception" or trivial truths — tests must validate real behavior
- Do NOT produce a review with zero issues without explicitly justifying why

### Severity Definitions

| Severity | Definition | Blocks Approval? |
|----------|------------|------------------|
| Critical | Acceptance criteria not met, security flaw, data loss risk, tests fail, false implementation claims | Yes |
| Major | CONSTITUTION violation, missing tests, design deviation, insufficient test quality | Yes |
| Minor | Style issues, minor improvements, optional refactoring, unused imports | No |

### After Review

- If APPROVED: Human reviewer (Tech Lead/Senior Dev) makes final decision at Gate 4
- If CHANGES REQUESTED: Developer fixes issues, then requests re-review
- If BLOCKED: Developer completes missing work, then requests re-review

## Verification

- [ ] All four phases completed in order (Phase 0 → Phase 3 → POST-PHASE)
- [ ] File inventory confirmed before any code review
- [ ] Every SPEC.md acceptance criterion traced to specific code
- [ ] Test suite executed and results recorded (or explicitly noted as not available)
- [ ] At least 3 issues found, or justification provided for fewer
- [ ] REVIEW.md saved to correct location
