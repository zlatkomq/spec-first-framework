# Spec-First Framework: Live Workflow Demo

A real walkthrough of building 001 User Registration using the framework.

---

## Step 0: Create CONSTITUTION.md

**Prompt:**
```
@constitution-creation.mdc Create CONSTITUTION.md: Python 3.12, FastAPI, pytest
```

**AI Response:** Asked for missing information:
- Project Name?
- Project Type (GREENFIELD/BROWNFIELD)?
- Overview (what problem does it solve)?
- Database?
- Coverage threshold?

**User Answers:**
```
1. test app
2. Greenfield
3. Its for car selling app. Backend.
4. PostgreSQL
5. 70%
```

**AI Action:** Created CONSTITUTION.md with proposed standards (naming conventions, file structure, patterns).

**Open Questions Generated:**
- Which authentication provider?
- Deployment targets?
- Rate limiting requirements?

**User Answers:**
```
1. AUTH0
2. Docker
3. None
```

**AI Action:** Updated CONSTITUTION.md, removed open questions.

**Output:** `.framework/CONSTITUTION.md` (Status: DRAFT → ready for approval)

---

## Step 1: Create SPEC.md

**Prompt:**
```
@spec-creation.mdc Create SPEC.md for 001 user authentication:
it should have all standard features.
```

**AI Response:** Asked for clarification on "standard features":

| Feature | Include? |
|---------|----------|
| User registration | ? |
| User login | ? |
| Password reset | ? |
| Email verification | ? |
| Social login | ? |
| ... | |

Also asked:
- User roles?
- Who can register?
- Profile data at registration?

**User Answers:**
```
User registration only.
1. no
2. invite only
3. just email password
```

**AI Action:** Created SPEC.md with:
- 3 user stories
- 13 acceptance criteria (happy path, validation, password rules)
- Scope boundaries (in/out)
- Open questions about invite codes

**Open Questions Generated:**
- How are invite codes generated?
- Do they expire?
- Single-use or multi-use?
- Additional password requirements?

**User Answers:**
```
1. admin
2. no
3. single
4. no
```

**AI Action:** Updated SPEC.md, replaced open questions with "Decisions Made" table.

**Output:** `specs/001-user-registration/SPEC.md` (Status: DRAFT)

---

## Gate 1: PO Approval

**Prompt:**
```
Approve it
```

**AI Action:** Changed SPEC.md Status from DRAFT → APPROVED

---

## Step 2: Create DESIGN.md

**AI Behavior:** Before creating, checked SPEC.md status. Found DRAFT.

**AI Response:**
```
⛔ Cannot Proceed
The design-creation rules require SPEC.md to be APPROVED before creating DESIGN.md.
```

**After approval**, AI created DESIGN.md with:
- Component architecture (8 components)
- Mermaid sequence diagram
- Data model (User entity fields)
- API specification with RFC 7807 error formats
- Security considerations
- Acceptance criteria traceability table

**Output:** `specs/001-user-registration/DESIGN.md` (Status: DRAFT)

---

## Gate 2: Tech Lead Approval

**Prompt:**
```
yes
```

**AI Action:** Changed DESIGN.md Status from DRAFT → APPROVED

---

## Step 3: Create TASKS.md

**AI Action:** Created atomic task breakdown:

| Task | Description |
|------|-------------|
| T1 | Add dependencies |
| T2 | Create User model |
| T3 | Create auth schemas |
| T4 | Create UserRepository |
| T5 | Create RegistrationService |
| T6 | Create registration endpoint |
| T7 | Add auth router |
| T8 | Unit tests: password validation |
| T9 | Unit tests: registration service |
| T10 | Unit tests: user repository |
| T11 | Integration test: endpoint |

**Output:** `specs/001-user-registration/TASKS.md` (Status: DRAFT)

---

## Gate 3: Tech Lead Approval

**Prompt:**
```
yes
```

**AI Action:** Changed TASKS.md Status from DRAFT → APPROVED

---

## Step 4: Implementation

**Prompt:**
```
lets implement it to finish the whole workflow
```

**AI Action:** Implemented all 11 tasks:

| Task | Files Created |
|------|---------------|
| T1 | `requirements.txt` |
| T2 | `app/models/user.py` |
| T3 | `app/schemas/auth.py` |
| T4 | `app/repositories/user_repository.py` |
| T5 | `app/services/registration_service.py` |
| T6 | `app/api/v1/endpoints/auth.py` |
| T7 | `app/api/v1/router.py`, `app/main.py` |
| T8-T11 | `tests/unit/...`, `tests/integration/...` |

Each task followed implementation rules:
- Only implemented specified task
- Followed CONSTITUTION.md standards
- Matched DESIGN.md architecture
- Provided implementation summary

---

## Step 5: Code Review

**Prompt:**
```
@code-review.mdc Review 001 against @specs/001-user-registration/SPEC.md
```

**AI Action:** Inspected actual source code and tests, generated REVIEW.md:

| Check | Result |
|-------|--------|
| All 11 tasks implemented | ✅ |
| All 13 acceptance criteria | ✅ PASS |
| CONSTITUTION compliance | ✅ |
| DESIGN alignment | ✅ |
| Code quality | ✅ |

**Verdict:** APPROVED

**Minor Recommendations:** (non-blocking)
- Remove unused import
- Consider DI for service

**Output:** `specs/001-user-registration/REVIEW.md`

---

## Gate 4: Human Approval

**Prompt:**
```
Human approved
```

**AI Action:** Updated REVIEW.md and TASKS.md to mark spec complete.

---

## Summary

| Step | Time | Key Interaction |
|------|------|-----------------|
| CONSTITUTION | ~5 min | AI asked 8 clarifying questions |
| SPEC | ~5 min | AI asked about scope, captured 13 acceptance criteria |
| DESIGN | ~2 min | AI generated architecture, data model, API spec |
| TASKS | ~1 min | AI created 11 atomic tasks |
| Implementation | ~10 min | AI implemented all code + tests |
| Review | ~2 min | AI verified all criteria, approved |

**Total:** ~25 minutes from requirements to reviewed code

---

## Artifacts Produced

```
specs/001-user-registration/
├── SPEC.md       # What to build (13 acceptance criteria)
├── DESIGN.md     # How to build it (architecture, API, data model)
├── TASKS.md      # Implementation breakdown (11 tasks)
└── REVIEW.md     # Code review results (all passed)

app/                # Full implementation
tests/              # Unit + integration tests
requirements.txt    # Dependencies
```

---

## Key Framework Behaviors Demonstrated

1. **AI asks, doesn't assume** — Missing info triggers questions, not guesses
2. **Gates enforce order** — AI refused to proceed without approvals
3. **Traceability** — Every line of code traces to acceptance criteria
4. **Atomic tasks** — Each task = one prompt = one component
5. **Standards compliance** — Code follows CONSTITUTION.md automatically
6. **Comprehensive review** — AI verified all criteria against actual code
