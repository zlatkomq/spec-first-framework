# Tasks

## Metadata

| Field | Value |
|-------|-------|
| ID | 001 |
| Name | User Registration |
| Status | DRAFT |
| Author | Developer / AI-assisted |
| Date | 2026-01-22 |
| Approved By | |
| Approval Date | |

---

## Overview

Implement invite-only user registration per DESIGN.md architecture: PasswordUtils (pure functions), UserRepository and InviteRepository (in-memory stores), RegistrationService (orchestrator), plus unit and integration tests.

---

## Previous Spec Learnings

First spec — no previous learnings available.

---

## Tasks

- [ ] T1: Create PasswordUtils module (DESIGN: PasswordUtils)
  - Create: `src/utils/password-utils.js`
  - Produces: `validatePassword(password: string) -> {valid: boolean, reason?: string}`
  - Produces: `hashPassword(password: string) -> string`
  - Verify: `node --test test/unit/password-utils.test.js` -> Expected: PASS (3 tests)

- [ ] T2: Create User model (DESIGN: Data Model / User)
  - Create: `src/models/user-model.js`
  - Produces: `createUser({email, passwordHash}) -> User`
  - Verify: `node --test test/unit/user-model.test.js` -> Expected: PASS (2 tests)

- [ ] T3: Create UserRepository (DESIGN: UserRepository)
  - Create: `src/services/user-repository.js`
  - Consumes: T2.createUser
  - Produces: `UserRepository.save(user) -> User`
  - Produces: `UserRepository.findByEmail(email) -> User|null`
  - Verify: `node --test test/unit/user-repository.test.js` -> Expected: PASS (3 tests)

- [ ] T4: Create InviteRepository (DESIGN: InviteRepository)
  - Create: `src/services/invite-repository.js`
  - Produces: `InviteRepository.findByCode(code) -> Invite|null`
  - Produces: `InviteRepository.markUsed(code, email) -> void`
  - Verify: `node --test test/unit/invite-repository.test.js` -> Expected: PASS (3 tests)

- [ ] T5: Create RegistrationService (DESIGN: RegistrationService)
  - Create: `src/services/registration-service.js`
  - Consumes: T1.validatePassword, T1.hashPassword, T3.UserRepository, T4.InviteRepository
  - Produces: `RegistrationService.register({email, password, inviteCode}) -> {success: boolean, user?: User, error?: string}`
  - Verify: `node --test test/unit/registration-service.test.js` -> Expected: PASS (5 tests)

## Testing

- [ ] T6: Unit tests for PasswordUtils
  - Create: `test/unit/password-utils.test.js`
  - Verify: `node --test test/unit/password-utils.test.js` -> Expected: PASS

- [ ] T7: Unit tests for UserRepository and InviteRepository
  - Create: `test/unit/user-repository.test.js`, `test/unit/invite-repository.test.js`
  - Verify: `node --test test/unit/` -> Expected: PASS

- [ ] T8: Unit tests for RegistrationService
  - Create: `test/unit/registration-service.test.js`
  - Verify: `node --test test/unit/registration-service.test.js` -> Expected: PASS

- [ ] T9: Integration test for registration flow
  - Create: `test/integration/registration-flow.test.js`
  - Verify: `node --test test/integration/` -> Expected: PASS

---

## Definition of Done

- [ ] All tasks completed (T1-T9)
- [ ] All tests passing (`npm test`)
- [ ] Test coverage meets 80% threshold (CONSTITUTION.md)
- [ ] Code reviewed and approved
- [ ] No open questions remaining
