# Bug Report

## Metadata

| Field | Value |
|-------|-------|
| Bug ID | BUG-001 |
| Related Spec | [FEAT-002](../../specs/FEAT-002-user-crud/SPEC.md) |
| Severity | Major |
| Status | FIXED |
| Reporter | QA Team |
| Date Reported | 2026-01-26 |
| Date Fixed | 2026-01-26 |

---

## Summary

Soft-deleted users can still be retrieved via GET /api/v1/users/{user_id} instead of returning 404 Not Found.

---

## Related Acceptance Criteria

From [FEAT-002-user-crud/SPEC.md](../../specs/FEAT-002-user-crud/SPEC.md):

> Given a soft-deleted user, when the admin requests user details by ID, then a 404 Not Found error is returned.

---

## Reproduction

**Environment:**
- Version/Commit: main branch, commit abc123
- Environment: Staging

**Steps to Reproduce:**
1. As admin, create a new user via POST /api/v1/users with email "test@example.com"
2. Note the returned user_id (e.g., "550e8400-e29b-41d4-a716-446655440000")
3. Delete the user via DELETE /api/v1/users/{user_id}
4. Verify deletion returns 204 No Content
5. Request user details via GET /api/v1/users/{user_id}

**Expected Behavior:**
GET /api/v1/users/{user_id} should return 404 Not Found with RFC 7807 error response:
```json
{
  "type": "https://api.testapp.com/errors/user-not-found",
  "title": "User Not Found",
  "status": 404,
  "detail": "User with ID 550e8400-e29b-41d4-a716-446655440000 was not found."
}
```

**Actual Behavior:**
GET /api/v1/users/{user_id} returns 200 OK with the user's data, including soft-deleted users.

---

## Root Cause Analysis

- **Component:** `app/repositories/user_repository.py` (UserRepository.get_by_id)
- **Cause:** The get_by_id method does not filter out soft-deleted users (missing `is_deleted=False` condition in query)
- **Introduced in:** Unknown

---

## Fix Approach

Update `UserRepository.get_by_id()` to include `is_deleted=False` filter in the query, consistent with how `list_all()` filters deleted users. This matches the pattern documented in DESIGN.md under "Acceptance Criteria Traceability": "Repository filters is_deleted=False".

---

## Fix Verification Criteria

- [ ] Original reproduction steps no longer produce the bug (step 5 returns 404)
- [ ] Original acceptance criteria now passes
- [ ] Regression test added covering this case
- [ ] No new failures introduced
- [ ] GET /api/v1/users list endpoint still correctly excludes deleted users

---

## Tasks

- [x] T1: Fix UserRepository.get_by_id() to filter soft-deleted users
- [x] T2: Add regression test for BUG-001 (test_get_deleted_user_returns_404)

---

## Implementation Summary

**Bug:** BUG-001 - Soft-deleted users visible via detail endpoint
**Task:** T1 + T2

**Root Cause:**
The `get_by_id()` method in UserRepository was missing the `is_deleted=False` filter that exists in `list_all()`.

**Fix Applied:**
Added `.filter(User.is_deleted == False)` to the query in `get_by_id()` method.

**Files Changed:**
- app/repositories/user_repository.py (modified) - Added is_deleted filter to get_by_id query
- tests/unit/test_user_repository.py (modified) - Added test_bug_001_get_deleted_user_returns_none

**Regression Test:**
- tests/unit/test_user_repository.py (test_bug_001_get_deleted_user_returns_none)
- Test verifies: get_by_id() returns None for soft-deleted users

**Verification:**
- [x] Reproduction steps no longer produce bug
- [x] Original acceptance criteria passes
- [x] Regression test passes
- [x] Existing tests still pass

**Notes:**
- None
