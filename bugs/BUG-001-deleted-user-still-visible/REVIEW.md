# Bug Review: BUG-001

## Summary

| Category | Status |
|----------|--------|
| Fix Verification | ✅ |
| Regression Test | ✅ |
| Minimal Change | ✅ |
| CONSTITUTION Compliance | ✅ |
| No Regressions | ✅ |

**Verdict:** APPROVED

---

## Bug Details

| Field | Value |
|-------|-------|
| Bug ID | BUG-001 |
| Related Spec | [FEAT-002](../../specs/FEAT-002-user-crud/SPEC.md) |
| Severity | Major |

---

## Fix Verification

| Criterion | Status | Evidence |
|-----------|--------|----------|
| Reproduction steps fixed | PASS | get_by_id() now returns None for deleted users, endpoint returns 404 |
| Root cause addressed | PASS | Added is_deleted=False filter to query in get_by_id() |
| Acceptance criteria satisfied | PASS | app/repositories/user_repository.py (get_by_id) |

---

## Regression Test

| Check | Status | Location |
|-------|--------|----------|
| Test exists | ✅ | tests/unit/test_user_repository.py (test_bug_001_get_deleted_user_returns_none) |
| Covers scenario | ✅ | Creates user, soft-deletes, verifies get_by_id returns None |
| Would fail without fix | ✅ | Without the is_deleted filter, get_by_id would return the deleted user |

---

## Files Changed

| File | Change Type | Review Status |
|------|-------------|---------------|
| app/repositories/user_repository.py | Modified | ✅ |
| tests/unit/test_user_repository.py | Modified | ✅ |

---

## Issues Found

No issues found.

---

## Recommendations

None.

---

## Post-Approval Checklist

- [x] Update BUG.md: Status → FIXED
- [x] Update BUG.md: Date Fixed → 2026-01-26
- [x] Update original SPEC.md: Add entry to Bug History table:

```markdown
| [BUG-001](../../bugs/BUG-001-deleted-user-still-visible/BUG.md) | Soft-deleted users visible via detail endpoint | 2026-01-26 |
```
