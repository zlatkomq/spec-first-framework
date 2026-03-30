# Bug Review

## Summary

| Category | Status |
|----------|--------|
| Fix Verification | ✅ / ❌ |
| Regression Test | ✅ / ❌ |
| Minimal Change | ✅ / ❌ |
| CONSTITUTION Compliance | ✅ / ❌ |
| No Regressions | ✅ / ❌ |

**Verdict:** APPROVED / CHANGES REQUESTED / BLOCKED

---

## Bug Details

| Field | Value |
|-------|-------|
| Bug ID | BUG-XXX |
| Related Spec | [FEAT-XXX](link) |
| Severity | Critical / Major / Minor |

---

## Fix Verification

| Criterion | Status | Evidence |
|-----------|--------|----------|
| Reproduction steps fixed | PASS / FAIL | [explanation] |
| Root cause addressed | PASS / FAIL | [explanation] |
| Acceptance criteria satisfied | PASS / FAIL | [file path + function] |

---

## Regression Test

| Check | Status | Location |
|-------|--------|----------|
| Test exists | ✅ / ❌ | path/to/test.py (test_bug_XXX) |
| Covers scenario | ✅ / ❌ | [explanation] |
| Would fail without fix | ✅ / ❌ | [explanation] |

---

## Files Changed

| File | Change Type | Review Status |
|------|-------------|---------------|
| path/to/file.py | Modified | ✅ / ❌ |
| path/to/test.py | Created | ✅ / ❌ |

---

## Issues Found

[If none: "No issues found."]

### Issue 1: [Title]
- **Severity:** Critical / Major / Minor
- **Location:** path/to/file.py (function_name)
- **Problem:** [Description]
- **Fix:** [What needs to change]

---

## Recommendations

[Optional: Non-blocking suggestions for improvement, or "None."]

---

## Post-Approval Checklist

When APPROVED, complete these steps:

- [ ] Update BUG.md: Status → FIXED
- [ ] Update BUG.md: Date Fixed → [today's date]
- [ ] Update original SPEC.md: Add entry to Bug History table
