# Design

## Metadata

| Field | Value |
|-------|-------|
| ID | 001 |
| Name | User Registration |
| Status | DRAFT |
| Author | Developer / AI-assisted |
| Reviewer | |
| Date | 2026-01-20 |
| Approved By | |
| Approval Date | |

---

## Overview

Implement invite-only user registration using a layered service architecture. The registration flow validates an invite code, checks email uniqueness, validates password strength, hashes the password, and creates a user record. All components use dependency injection for testability, following the constitution's coding standards.

---

## Architecture

| Component | Change Type | Description |
|-----------|-------------|-------------|
| RegistrationService | New | Orchestrates registration flow: validate invite, check email, validate password, create user |
| UserRepository | New | In-memory storage for user records with email uniqueness check |
| InviteRepository | New | In-memory storage for invite codes with validation and consumption |
| PasswordUtils | New | Pure functions for password validation and hashing |

---

## Data Model

### User

| Field | Type | Constraints |
|-------|------|-------------|
| id | string | Auto-generated UUID |
| email | string | Unique, required |
| passwordHash | string | Bcrypt hash |
| createdAt | Date | Auto-set on creation |

### Invite

| Field | Type | Constraints |
|-------|------|-------------|
| code | string | Unique, required |
| used | boolean | Default false |
| usedBy | string | null until consumed |

---

## Open Questions

- [ ] Should password hashing use bcrypt or scrypt?
- [ ] What is the minimum password length requirement?
