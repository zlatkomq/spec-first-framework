# Code Review: XXX

## Summary

| Category | Status |
|----------|--------|
| Phase 0: File Inventory | COMPLETE / PARTIAL / BLOCKED |
| Phase 1: Reality Check | ✅ / ❌ |
| Phase 2: Spec Verification | ✅ / ❌ |
| Phase 3: Quality Audit | ✅ / ❌ |

**Verdict:** APPROVED / CHANGES REQUESTED / BLOCKED

**Issues Found:** [count] ([count] Critical, [count] Major, [count] Minor)

---

## Phase 0: File Inventory

| Metric | Count |
|--------|-------|
| Expected files (from TASKS.md) | [count] |
| Files verified accessible | [count] |
| Files not reviewable | [count] |

| File | Expected | Accessible | First 3 Lines (verification) |
|------|----------|------------|-------------------------------|
| path/to/file | Yes | Yes | `import x; class Foo...` |
| path/to/file | Yes | No | NOT REVIEWABLE — [reason] |

<!-- IF all files accessible: "All expected files verified accessible." -->
<!-- IF gaps <= 30%: "WARNING: {N} files not reviewed. Findings for those files are incomplete." -->
<!-- IF gaps > 30%: "BLOCKED — more than 30% of files not reviewable. Recommend splitting spec or reviewing in sections." -->

---

## Phase 1: Reality Check

### Git Reality Check

| Check | Result |
|-------|--------|
| Files changed (git diff) | [count] files |
| Files expected (TASKS.md) | [count] files |
| Discrepancies found | [count] |
| Uncommitted changes | Yes / No |
| Git access available | Yes / No |

**File Comparison:**

| File | Expected (TASKS.md) | Actual (git) | Status |
|------|---------------------|--------------|--------|
| path/to/file.py | Created | Created | ✅ |
| path/to/file.py | Modified | Not changed | ❌ CRITICAL |
| path/to/unexpected.py | Not listed | Modified | ⚠️ MEDIUM |

<!-- IF git not available: "Git verification not available — manual file inspection only." -->

### Dead Code & Placeholder Scan

| Pattern | Occurrences | Locations |
|---------|-------------|-----------|
| TODO/FIXME comments | [count] | [file:function, ...] |
| Empty catch/except blocks | [count] | [file:function, ...] |
| Hardcoded return values | [count] | [file:function, ...] |
| Debug statements (print/console.log) | [count] | [file:function, ...] |
| Commented-out code blocks | [count] | [file:function, ...] |
| Unused imports | [count] | [file, ...] |
| Stub/not-implemented markers | [count] | [file:function, ...] |

<!-- IF all clean: "No placeholder or dead code patterns found." -->

### Test Execution Results

| Metric | Result |
|--------|--------|
| Test suite executed | Yes / No |
| Total tests | [count] |
| Passed | [count] |
| Failed | [count] |
| Skipped | [count] |
| Coverage | [percent] (threshold: [percent] per CONSTITUTION.md) |

<!-- IF tests not executed: "Test execution not performed — manual verification required. Reviewer should run tests before approving." -->

<!-- IF failures: list each failed test with file path and brief reason -->

---

## Phase 2: Spec Verification

### Acceptance Criteria

| # | Criterion | Status | Evidence |
|---|-----------|--------|----------|
| 1 | Given X, when Y, then Z | PASS / FAIL | path/to/file.py (function_name) — [how it satisfies the criterion] |
| 2 | Given X, when Y, then Z | PASS / FAIL | path/to/file.py (function_name) — [how it satisfies the criterion] |

**Criteria with no corresponding test:**

[List any acceptance criteria that pass in code but have no dedicated test. Each is a MAJOR finding.]

<!-- IF all criteria have tests: "All acceptance criteria have corresponding tests." -->

### Task Completion

| Task | Status | Location |
|------|--------|----------|
| T1: [description] | ✅ / ❌ | path/to/file.py (function) |
| T2: [description] | ✅ / ❌ | path/to/file.py (class) |

---

## Phase 3: Quality Audit

### CONSTITUTION Compliance

#### Coding Standards

| Check | Status | Notes |
|-------|--------|-------|
| Naming conventions followed | ✅ / ❌ | [explanation] |
| File/folder structure correct | ✅ / ❌ | [explanation] |
| Code patterns match project standards | ✅ / ❌ | [explanation] |
| No prohibited patterns used | ✅ / ❌ | [explanation] |

#### Error Handling

| Check | Status | Notes |
|-------|--------|-------|
| Errors handled appropriately | ✅ / ❌ | [explanation] |
| No silent failures | ✅ / ❌ | [explanation] |
| Error messages are meaningful | ✅ / ❌ | [explanation] |

#### Security

| Check | Status | Notes |
|-------|--------|-------|
| Input validation present | ✅ / ❌ | [explanation] |
| Authentication/authorization correct | ✅ / ❌ / N/A | [explanation] |
| No hardcoded secrets or credentials | ✅ / ❌ | [explanation] |
| No sensitive data in logs/errors | ✅ / ❌ | [explanation] |

#### Testing Quality

| Check | Status | Notes |
|-------|--------|-------|
| Unit tests exist for new code | ✅ / ❌ | [explanation] |
| Tests assert real behavior | ✅ / ❌ | [explanation] |
| Tests cover error paths | ✅ / ❌ | [explanation] |
| No placeholder or trivial assertions | ✅ / ❌ | [explanation] |
| No duplicate test logic | ✅ / ❌ | [explanation] |
| Coverage meets threshold | ✅ / ❌ / ⚠️ | [explanation] |

### DESIGN Alignment

| Check | Status | Notes |
|-------|--------|-------|
| Architecture followed as specified | ✅ / ❌ | [explanation] |
| Data models match design | ✅ / ❌ | [explanation] |
| APIs/interfaces match design | ✅ / ❌ | [explanation] |
| No unauthorized deviations | ✅ / ❌ | [explanation] |

### Code Quality

| Check | Status | Notes |
|-------|--------|-------|
| No dead code or commented-out blocks | ✅ / ❌ | [explanation] |
| No TODO/FIXME without linked issue | ✅ / ❌ | [explanation] |
| No duplicate code that should be refactored | ✅ / ❌ | [explanation] |
| Dependencies added are justified | ✅ / ❌ | [explanation] |

---

## Issues Found

Minimum 3 issues expected. If fewer, see Issue Count Justification below.

### Issue 1: [Title]
- **Severity:** Critical / Major / Minor
- **Phase:** 1 / 2 / 3
- **Location:** path/to/file.py (ClassName.method_name)
- **Problem:** [Description]
- **Fix:** [What needs to change]
- **Task:** Revisit T[N] (if applicable)

### Issue 2: [Title]
- **Severity:** Critical / Major / Minor
- **Phase:** 1 / 2 / 3
- **Location:** path/to/file.py (ClassName.method_name)
- **Problem:** [Description]
- **Fix:** [What needs to change]
- **Task:** Revisit T[N] (if applicable)

### Issue 3: [Title]
- **Severity:** Critical / Major / Minor
- **Phase:** 1 / 2 / 3
- **Location:** path/to/file.py (ClassName.method_name)
- **Problem:** [Description]
- **Fix:** [What needs to change]
- **Task:** Revisit T[N] (if applicable)

---

## Issue Count Justification

[Required only if fewer than 3 issues found. One sentence explaining what was re-examined and why this code genuinely has fewer issues.]

<!-- IF more than 10 issues found: "BLOCKED — More than 10 issues found. The implementation needs fundamental rework, not incremental fixes. Recommend going back to TASKS.md (step 3)." -->

---

## Dev Agent Record Cross-Reference

| Check | Result |
|-------|--------|
| Files in Dev Agent Record File List | [count] |
| Files in git diff | [count] |
| Discrepancies | [count] |

| File | In Record | In Git | Status |
|------|-----------|--------|--------|
| path/to/file | Yes/No | Yes/No | Match / Undocumented / False claim |

---

## Auto-Fix Tracking

[Populated only if [F] Fix was chosen. Otherwise: "No auto-fixes applied."]

| Attempt | Issue # | Description | Fix Applied | Files Changed |
|---------|---------|-------------|-------------|---------------|
| | | | | |

---

## Action Items Created

[Populated only if [A] Action Items was chosen. Otherwise: "No action items created."]

| Task | Severity | Description | File |
|------|----------|-------------|------|
| [AI-Review][Critical] ... | Critical | ... | path/to/file |

---

## Recommendations

[Optional: Non-blocking suggestions for improvement, or "None."]