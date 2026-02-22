# Project Constitution

## Metadata

| Field | Value |
|-------|-------|
| Project Name | E2E Test Project |
| Project Type | GREENFIELD |
| Status | APPROVED |
| Author | Test Author |
| Date | 2026-01-01 |

---

## Overview

A simple Node.js project used for E2E testing of the spec-first workflow.

---

## Tech Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Language | JavaScript | ES2022 |
| Framework | Node.js | 22.x |
| Database | None | N/A |
| Testing | node:test | built-in |
| Linting | None | N/A |
| Package Manager | npm | 10.x |
| Module System | ESM | N/A |

---

## Project Structure

| Directory | Purpose |
|-----------|---------|
| Source | `src/` |
| Tests | `test/` |
| Config | N/A |

```
src/
├── services/
├── models/
└── utils/
test/
├── unit/
└── integration/
```

---

## Commands

| Action | Command |
|--------|---------|
| Run all tests | `npm test` |
| Run single test file | `node --test <file>` |
| Build | N/A |
| Lint | N/A |

---

## Coding Standards

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Files | kebab-case | user-service.js |
| Functions | camelCase | getUserById |
| Classes | PascalCase | UserService |
| Variables | camelCase | userName |
| Constants | UPPER_SNAKE | MAX_RETRIES |

### Patterns to Use

- Pure functions where possible
- Dependency injection for testability
- Early return over nested conditionals

### Patterns to Avoid

- Global mutable state
- Deeply nested callbacks
- Magic numbers without named constants

---

## Error Handling

| Concern | Approach |
|---------|----------|
| Strategy | Throw exceptions (custom Error subclasses) |
| Logging | No logging — simple CLI/test project |
| User-facing errors | Thrown errors with descriptive message property |

---

## Testing Standards

| Requirement | Value |
|-------------|-------|
| Minimum Coverage | 80% |
| Unit Tests Required | YES |
| Integration Tests Required | YES |

### Test File Conventions

- Test files go in `test/` directory
- Name: `<module>.test.js`
- Use `node:test` and `node:assert`

---

## Security Standards

| Concern | Approach |
|---------|----------|
| Input Validation | Manual validation with early returns and descriptive errors |
| Authentication | N/A |
| Secrets Handling | N/A — no secrets in test project |

---

## Quality Gates

Before merge, code must pass:

- [ ] All tests pass (`npm test`)
- [ ] No linting errors
- [ ] Code reviewed by at least one peer
