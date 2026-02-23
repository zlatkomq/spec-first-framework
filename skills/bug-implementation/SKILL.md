# Bug Implementation

## Description

Use when implementing a bugfix from an approved BUG.md (Status = CONFIRMED).
Not for bugs where BUG.md status is not CONFIRMED — STOP and inform the user. Not for reviewing the fix — use `../bug-review/SKILL.md` after implementation is complete.

## Instructions

You are implementing a bugfix based on an approved BUG.md. Follow these rules strictly.

### Terminal Access Prerequisite

Terminal access is required for verified bugfix implementation. You must be able to run tests to confirm the fix works and the regression test passes. If you cannot execute commands, HALT and inform the user that manual verification is needed.

### Required Inputs

Before implementing, you must have:
- Specific task from approved BUG.md (e.g., "Implement T1")
- Access to `bugs/BUG-XXX/BUG.md` for bug details
- Access to the original `specs/XXX/SPEC.md` (linked in BUG.md)
- Access to the original `specs/XXX/DESIGN.md` for architecture context
- Access to `../../CONSTITUTION.md` for coding standards

If BUG.md is not approved (Status != CONFIRMED), STOP and inform the user.

### Scope Control

#### Minimal Change Principle
- Fix ONLY what is broken — nothing more
- Do NOT "improve" or refactor adjacent code
- Do NOT add features while fixing the bug
- Do NOT change behavior beyond what's needed for the fix

#### What You CAN Change
- The specific code causing the bug
- Related code strictly necessary for the fix
- Test files (adding regression test)

#### What You CANNOT Change
- Unrelated files or functions
- API contracts (unless the bug is in the contract itself)
- Database schemas (unless explicitly in the bug scope)
- Dependencies (unless strictly required for the fix)

### Regression Test Requirement

Every bugfix MUST include a regression test. This is mandatory, not optional.

#### Regression Test Requirements
1. Test must be named to reference the bug: `test_bug_XXX_description` or similar
2. Test must reproduce the original bug scenario
3. Test must FAIL before the fix is applied (verify this mentally or explain)
4. Test must PASS after the fix is applied
5. Test must be placed in appropriate test directory per CONSTITUTION.md

#### Test Structure
```
# Example structure (adapt to project conventions)
def test_bug_001_safari_validation_fails():
    """
    Regression test for BUG-001: Safari validation fails

    Reproduction: [brief description of scenario]
    Related spec: FEAT-001
    """
    # Arrange: Set up the bug scenario
    # Act: Perform the action that triggered the bug
    # Assert: Verify correct behavior
```

### Implementation Process

#### For Investigation/Fix Tasks (T1)

1. **Locate the bug**
   - Follow the reproduction steps from BUG.md
   - Identify the exact file and function causing the issue
   - Update the "Root Cause Analysis" section in BUG.md with findings

2. **Implement the fix**
   - Make the minimal change needed
   - Follow CONSTITUTION.md coding standards
   - Ensure the fix aligns with DESIGN.md architecture

3. **Verify locally**
   - Run reproduction steps and confirm they no longer produce the bug
   - Run the full test suite — existing tests must still pass
   - Paste raw terminal output as evidence

#### For Regression Test Tasks (T2)

1. **Create the test**
   - Name it to reference the bug ID
   - Include a docstring explaining what bug this prevents
   - Cover the exact reproduction scenario

2. **Verify the test**
   - Confirm the test passes with the fix in place
   - Explain why it would have failed before the fix

### Red Flags — STOP

If you notice yourself doing any of these, STOP immediately:

- Fixing something without understanding why it broke
- Skipping the regression test ("the fix is obvious, test isn't needed")
- Changing more files than the bug requires
- Writing the fix before writing the regression test
- Saying "tests pass" without running them after the fix
- Thinking "I'll just improve this adjacent code while I'm here"
- Adding a feature disguised as a bug fix

### Rationalization Traps

These are common excuses AI agents use to bypass bugfix rules. If you catch yourself thinking any of these, the corresponding reality applies.

| Excuse | Reality |
|--------|---------|
| "The fix is obvious, no need to investigate" | Obvious symptoms hide non-obvious root causes. Phase 1 investigation is fast for simple bugs. |
| "Regression test isn't needed for this" | Every unfixed regression was once "too simple to test." Test takes 30 seconds. |
| "I'll write the test after the fix" | Test-after confirms what you built, not what's needed. Write regression test first. |
| "This adjacent code is broken too, might as well fix it" | Minimal change principle. File a separate bug for adjacent issues. |
| "The fix requires refactoring this module" | If the fix requires refactoring, HALT — the scope has grown beyond a bugfix. |
| "I already manually verified it works" | Manual verification leaves no record and can't be re-run. Automated regression test is mandatory. |
| "The API contract needs to change for this fix" | API contract changes are scope creep. HALT and ask before modifying contracts. |

### Standards Compliance

#### From CONSTITUTION.md
- Follow all coding standards (naming, structure, patterns)
- Use specified tech stack and libraries
- Follow file/folder structure conventions
- Apply error handling patterns

#### From DESIGN.md
- Respect the existing architecture
- Do not introduce new patterns not in the design
- Maintain component boundaries

### Output

After implementing each task, provide:

```
## Bug Fix Summary

**Bug:** BUG-XXX - [description]
**Task:** [Task ID and description]

**Root Cause:**
- [Brief explanation of why the bug occurred]

**Fix Applied:**
- [What was changed and why]

**Files Changed:**
- path/to/file.py (modified) - [what changed]

**Regression Test:**
- path/to/test_file.py (test_bug_XXX_description)
- Test verifies: [what the test checks]

**Verification:**
- [ ] Reproduction steps no longer produce bug
- [ ] Original acceptance criteria passes
- [ ] Regression test passes
- [ ] Existing tests still pass

**Notes:**
- [Any assumptions or decisions made, or "None"]
```

### Constraints

- Do NOT implement without an approved BUG.md
- Do NOT skip the regression test
- Do NOT make changes beyond the bug scope
- Do NOT modify the original SPEC.md or DESIGN.md
- Do NOT approve your own changes — that's for `../bug-review/SKILL.md`

## Verification

- [ ] BUG.md status is CONFIRMED (approved)
- [ ] Only the specified task is implemented
- [ ] Fix is minimal and focused
- [ ] Root cause is documented in BUG.md
- [ ] Regression test passes (terminal output recorded)
- [ ] Existing tests still pass (terminal output recorded)
- [ ] Code follows CONSTITUTION.md standards
- [ ] Implementation summary is provided
