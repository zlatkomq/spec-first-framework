# Bug Report

## Metadata

| Field | Value |
|-------|-------|
| Bug ID | BUG-001 |
| Related Spec | 001-user-registration |
| Severity | Medium |
| Status | CONFIRMED |
| Reporter | QA / AI-assisted |
| Date Reported | 2026-02-01 |

---

## Summary

Email validation accepts emails without an `@` symbol. Users can register with strings like "notanemail" which should be rejected per the acceptance criteria.

---

## Reproduction

**Environment:** Node.js 22.x, in-memory repositories

**Steps:**
1. Create a valid invite code in the InviteRepository
2. Call `RegistrationService.register({ email: "notanemail", password: "validPass123", inviteCode: "valid-code" })`
3. Observe that registration succeeds instead of failing

**Expected:** Registration is rejected with an error message about invalid email format.
**Actual:** Registration succeeds and creates a user with email "notanemail".

---

## Related Acceptance Criteria

From SPEC.md:
> Given an email already registered, when a user attempts to register, then registration is rejected with "Email already in use" error.

The spec implies email validation is in place, but no explicit AC covers email format validation. This is a gap in the original spec that should also be addressed.

---

## Root Cause

The `RegistrationService.register()` method does not validate email format before creating the user. The `UserRepository.findByEmail()` only checks for uniqueness, not format validity.

---

## Fix Approach

Add email format validation to `RegistrationService.register()` before the uniqueness check. A simple regex check for `@` and `.` characters is sufficient for this scope.

---

## Verification Criteria

- [ ] Registration rejects emails without `@` symbol
- [ ] Registration rejects empty email strings
- [ ] Regression test added: `test/unit/registration-service.test.js` includes email format validation test
- [ ] All existing tests still pass
