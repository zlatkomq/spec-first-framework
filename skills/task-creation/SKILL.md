# Task Creation

## Description

Use when creating a TASKS.md task breakdown document from an approved DESIGN.md.
Not for specs where DESIGN.md is not yet APPROVED — STOP and inform the user. Not for implementation — use the implementation skill.

## Instructions

You are creating a task breakdown document. Follow these rules strictly.

### Required Inputs

Before creating a TASKS.md, you must have:
- Approved DESIGN.md (load `specs/XXX/DESIGN.md`)
- Approved SPEC.md (load `specs/XXX/SPEC.md`) — for acceptance criteria traceability
- Access to `../../CONSTITUTION.md` for project standards

If DESIGN.md is not approved (Status != APPROVED), STOP and inform the user.

### Context Gathering (Before Task Creation)

Do NOT duplicate CONSTITUTION.md or DESIGN.md content into TASKS.md — the developer already loads those documents during implementation. Instead, gather only **genuinely new context** that doesn't exist elsewhere:

#### Previous Spec Intelligence

If other spec folders exist in `specs/` (this is not the first spec):
1. Find the most recently completed spec (one with a REVIEW.md that has verdict APPROVED)
2. Read that REVIEW.md — extract: recurring review feedback, patterns flagged, quality issues found
3. Read that spec's IMPLEMENTATION-SUMMARY.md (in the same spec folder, if exists) — extract:
   - **File List**: All files created/modified by the previous spec
   - **Decisions Made**: Implementation patterns and conventions established
   - **Code reuse opportunities**: Components that the current spec might use
4. **Load key source files**: For each file in the previous spec's IMPLEMENTATION-SUMMARY.md File List that is likely relevant to the current spec (same domain area, shared components), read the file to understand its public interface. This prevents reinventing existing code.
5. Summarize actionable intelligence in the "Previous Spec Learnings" section of TASKS.md

If this is the first spec, write "First spec — no previous learnings available."

#### Git History Analysis

If git is available:
1. Check the last 5 commit messages to understand recent work patterns
2. Note: conventions used (naming, structure), libraries added, file organization patterns
3. Include actionable intelligence in the "Previous Spec Learnings" section if relevant

If git is not available, skip this step.

### Template

Always use the template structure from `../../.framework/templates/TASKS.template.md`

### Field Rules

#### Metadata
- **ID**: Must match the DESIGN.md ID exactly
- **Name**: Must match the DESIGN.md Name exactly
- Status is always DRAFT until Tech Lead approves
- Author: developer name + "/ AI-assisted" (if name unknown, use "Developer / AI-assisted")
- Date: today's date

#### Overview
- Summarize the implementation approach from DESIGN.md
- Do not repeat DESIGN.md content — just reference it

#### Tasks
- Each task must be atomic: implementable in a single AI prompt
- Format: `- [ ] T1: [Brief description] (DESIGN: [section/component])`
- Every task MUST reference the relevant DESIGN.md section or component in parentheses
- Order tasks by implementation sequence (dependencies first)
- One task = one component/function/endpoint, not multiple
- If a task feels too big, split it

**Task markers:**
- `[ ]` = not started
- `[x]` = complete (tests verified passing)

#### Interface Contracts

Tasks that create components used by other tasks MUST declare what they produce.
Tasks that depend on another task's component MUST declare what they consume BY TASK ID.

The AI infers Produces signatures from DESIGN.md (architecture section, sequence diagrams, component interaction tables). If DESIGN.md does not contain enough detail to derive a concrete signature, flag this in the adversarial self-validation as: "DESIGN.md insufficient — cannot derive interface for T[N]. Design may need more detail."

Consumes references use the task ID + component name (e.g. `T3.RegistrationService`). The AI implementing a consuming task looks up the producing task's Produces declaration. This prevents signature drift — do NOT duplicate the full signature in Consumes.

Format:
```
- [ ] T3: Create RegistrationService (DESIGN: Services)
  - Produces: `RegistrationService.register(dto: CreateUserDTO) -> User`
- [ ] T4: Create UserRepository (DESIGN: Data Access)
  - Produces: `UserRepository.save(user: User) -> User`, `UserRepository.find_by_email(email: str) -> User | None`
- [ ] T5: Create registration endpoint (DESIGN: API Layer)
  - Consumes: T3.RegistrationService, T4.UserRepository
  - Produces: `POST /api/v1/auth/register` endpoint
```

`Produces`/`Consumes` are only required when a task creates or depends on another task's public interface. Purely internal tasks (config files, constants) skip this.

#### Verification Commands

Tasks SHOULD include a Verify field specifying the command to run and expected outcome when the task is complete:

```
- [ ] T3: Create RegistrationService (DESIGN: Services)
  - Produces: `RegistrationService.register(dto: CreateUserDTO) -> User`
  - Verify: `npm test -- --grep "RegistrationService"` → Expected: PASS
```

The Verify command must be:
- An actual executable command (not "run the tests")
- Specific to this task's scope (not the full test suite)
- Achievable given the task's scope

If the task's verify command cannot be determined at TASKS.md time (e.g., exact test file path unknown until implementation), write: `Verify: Run tests for [component name] → Expected: PASS`. The implementer resolves the exact command during implementation.

#### TDD Cycle

Each implementation task follows the TDD mandate in the implementation skill (RED→GREEN→REFACTOR). The task's Verify command corresponds to the GREEN verification step. Task creators should ensure the verify command and expected outcome are realistic for the task scope.

#### Testing (MANDATORY)
- Unit tests are ALWAYS required — never skip
- Create at least one unit test task per major component/function
- Format: `- [ ] Tx: Unit tests for [specific component/logic]` (continue numbering from last implementation task)
- Reference CONSTITUTION.md for coverage requirements

**Integration test mandate:**
- If DESIGN.md's Architecture section lists more than one component with Change Type "New", at least one integration test task is MANDATORY that tests the real call chain between them without mocks.
- This is mechanically checkable: count New components in the DESIGN.md component table. If count > 1 and they interact (appear in the same sequence diagram or dependency list), an integration test task must exist.
- "No integration tests required" is ONLY acceptable for specs where DESIGN.md describes a single New component with zero runtime dependencies on other New components in this spec.

#### Definition of Done
- Keep the standard checklist from template
- Add spec-specific items if needed (e.g., "Documentation updated")

### Task Sizing Guidelines

Each task must be a single action completable in **2–5 minutes**. If you can't describe what to build, which files to touch, and how to verify it in a few sentences, the task is too big.

| Too Big (split it) | Right Size (2–5 min) | Too Small (merge it) |
|-------------------|------------|---------------------|
| "Implement user authentication" | "Create login endpoint" | "Add import statement" |
| "Build entire API" | "Implement password validation" | "Write one unit test" |
| "Create database layer" | "Create User repository" | "Add field to model" |

#### Task Specificity Requirements

Every task MUST include:
- **Exact file paths** — `Create: src/services/registration.service.ts`, not "create a service for registration"
- **Exact verification command** — `npm test -- --grep "RegistrationService"`, not "run the tests"
- **Expected output** — `Expected: PASS (2 tests)`, not "should work"

Vague tasks are rejected. If two developers would create different files or run different commands from the same task description, the task is too vague.

| Vague (rejected) | Specific (accepted) |
|-------------------|---------------------|
| "Add validation" | "Add email format validation to `src/services/registration.service.ts`, test in `tests/services/registration.service.test.ts`" |
| "Create the data model" | "Create `src/models/user.model.ts` with fields from DESIGN.md Data Model section" |
| "Write tests for the API" | "Create `tests/routes/auth.register.test.ts` covering AC-1 through AC-3" |

### Constraints

- Do NOT include implementation details (belongs in code)
- Do NOT duplicate DESIGN.md content
- Do NOT skip testing tasks
- Do NOT create tasks that aren't traceable to DESIGN.md
- Do NOT number tests separately — continue task numbering (T1, T2... T5, T6 for tests)
- All bracket placeholders from template must be removed from output

### Red Flags — STOP

If you notice yourself doing any of these, STOP and reconsider before continuing.

- Creating a task that doesn't map to any DESIGN.md section or component
- Writing tasks so vague that two developers would implement them differently
- Skipping test tasks because "the implementation tasks already include testing"
- Including implementation details (actual code, algorithms) that belong in code, not TASKS.md
- Creating a task that encompasses multiple components or endpoints
- Omitting Produces/Consumes for tasks that clearly depend on each other

### Adversarial Self-Validation

After generating TASKS.md, run ALL checks below BEFORE presenting to the user. Fix any issues found. Note significant findings when presenting.

- [ ] **Reinvention**: No tasks duplicate functionality already in the codebase
- [ ] **Vagueness**: Every task is specific enough that two developers would implement it the same way
- [ ] **AC coverage**: Every SPEC.md acceptance criterion has at least one task addressing it
- [ ] **Test coverage**: Every significant component has a dedicated test task
- [ ] **Dependency order**: No task depends on a prerequisite that comes later in the sequence
- [ ] **Contract completeness**: Every inter-task dependency has matching Produces/Consumes declarations
- [ ] **Integration coverage**: If DESIGN.md has >1 New interacting components, at least one test task tests them together without mocks
- [ ] **Cross-spec reinvention**: No New component duplicates something from a previous spec's IMPLEMENTATION-SUMMARY.md
- [ ] **Verification commands**: Every task with a testable component has a Verify field (command + expected outcome)
- [ ] **File paths**: Every task specifies exact file paths to create or modify (no "create a file for X")
- [ ] **Granularity**: Every task is completable in 2–5 minutes as a single action

### Output

Save the file to: `specs/XXX-{slug}/TASKS.md`

Must be in the same folder as the corresponding SPEC.md and DESIGN.md.

## Verification

- [ ] Every component in DESIGN.md has corresponding task(s)
- [ ] Every task is atomic (one prompt = one task)
- [ ] Testing tasks are present (unit tests mandatory)
- [ ] Tasks are ordered by dependency
- [ ] Every task creating a public component has a Produces declaration
- [ ] Every Consumes reference uses task-ID format (T[N].ComponentName)
- [ ] Every Consumes reference maps to a Produces declaration on the referenced task
- [ ] Definition of Done is complete
- [ ] Status set to DRAFT
