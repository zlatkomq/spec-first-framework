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

### File Structure

```
src/
├── services/
├── models/
└── utils/
test/
├── unit/
└── integration/
```

### Patterns to Use

- Pure functions where possible
- Dependency injection for testability
- Early return over nested conditionals

### Patterns to Avoid

- Global mutable state
- Deeply nested callbacks
- Magic numbers without named constants

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

## Quality Gates

Before merge, code must pass:

- [ ] All tests pass (`npm test`)
- [ ] No linting errors
- [ ] Code reviewed by at least one peer
