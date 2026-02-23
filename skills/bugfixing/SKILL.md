# Bugfixing

## Description

Use when creating a BUG.md specification document to initiate the bugfix workflow.
Not for new features or scope changes — use the spec-creation or change-request skill. Not for implementing the fix — use the bug-implementation skill after BUG.md is approved.

## Instructions

You are creating a bug specification document. Follow these rules strictly.

### Required Inputs

Before creating a BUG.md, you must have:
- Bug description from the reporter (what's wrong, how to reproduce)
- Reference to the original SPEC.md where the bug exists
- Access to `../../CONSTITUTION.md` for project context

If the bug description is unclear or the original spec is not provided, ASK for clarification. Do not guess.

### Step 0: Classification Verification

If a Jira ticket reference is provided (or the bug was reported via a Jira ticket):
1. Read the Jira ticket description (or user-provided description)
2. Read SPEC.md acceptance criteria
3. Compare: does the reported behavior violate an existing acceptance criterion?
   - **YES** — This is correctly classified as a bug. Proceed.
   - **NO** — Flag: "This may be a **Change Request**, not a bug. The reported behavior is not covered by any existing acceptance criterion in SPEC.md. Consider using `/change` instead."
4. Ask the user to confirm classification before proceeding. Do not skip this step.

If no Jira ticket reference is provided, skip directly to Pre-Creation Checks.

### Pre-Creation Checks

1. Verify the referenced SPEC.md exists and is APPROVED
2. Read the related DESIGN.md (if exists) to understand the intended architecture
3. Identify which acceptance criteria from SPEC.md is violated by this bug

If no acceptance criteria is clearly violated, ask the reporter to clarify the expected behavior.

### Template

Always use the template structure from `../../.framework/templates/BUG.template.md`

### Field Rules

#### Metadata
- **Bug ID**: Use next available BUG number. Check existing `bugs/` folder for highest number and increment.
- **Related Spec**: Link to the original SPEC.md (e.g., `[FEAT-001](../specs/FEAT-001-user-registration/SPEC.md)`)
- **Severity**: Ask if not provided. Must be one of: Critical, Major, Minor
  - Critical: System unusable, data loss, security vulnerability
  - Major: Feature broken, workaround exists
  - Minor: Cosmetic, edge case, low impact
- **Status**: Always DRAFT until Tech Lead approves, then set to CONFIRMED
- **Reporter**: Name of person who reported the bug
- **Date Reported**: Today's date
- **Date Fixed**: Leave empty until fixed

#### Summary
- One sentence describing what is broken
- Focus on the symptom, not the cause

#### Related Acceptance Criteria
- Quote the specific acceptance criterion from SPEC.md that is violated
- If multiple criteria are affected, list all of them
- If no direct criterion applies, describe what the expected behavior should be based on the spec

#### Reproduction
- **Environment**: Version/commit, environment (Production/Staging/Local)
- **Steps**: Numbered list of exact steps to reproduce
- **Expected**: What should happen per the spec
- **Actual**: What actually happens

If reproduction steps are incomplete, ASK for details. A bug without reproduction steps cannot be fixed.

#### Root Cause Analysis
- Leave empty initially (filled after investigation)
- Will be completed during implementation

#### Fix Approach
- Brief description of proposed fix (1-3 sentences)
- Reference the component from DESIGN.md that needs changing
- If unclear, write "To be determined during investigation"

#### Fix Verification Criteria
- Always include these standard criteria:
  - [ ] Original reproduction steps no longer produce the bug
  - [ ] Original acceptance criteria now passes
  - [ ] Regression test added covering this case
  - [ ] No new failures introduced
- Add bug-specific verification criteria if needed

#### Tasks
- Minimum 2 tasks:
  - T1: Investigation/fix task
  - T2: Add regression test
- Keep tasks atomic and focused

### AI Behavior

#### Step 1: Analyze
- Read the referenced SPEC.md thoroughly
- Read the related DESIGN.md to understand architecture
- Identify the violated acceptance criteria

#### Step 2: Clarify
Ask the reporter if not provided:
- Exact reproduction steps (step by step)
- Expected vs actual behavior
- Environment details (if relevant)
- Severity assessment

#### Step 3: Generate BUG.md
- Use `../../.framework/templates/BUG.template.md` structure
- Link to original spec
- Document reproduction steps exactly as provided
- Quote the violated acceptance criteria
- Propose fix approach (or mark as TBD)
- Define fix verification criteria

#### Step 4: Wait for Approval
BUG.md starts as DRAFT. Tech Lead must approve before implementation begins.

### Output

Save the file to: `bugs/BUG-XXX-{slug}/BUG.md`

- **XXX**: Zero-padded number (001, 002, etc.)
- **slug**: Lowercase, hyphen-separated, max 4 words describing the bug

Examples:
- `bugs/BUG-001-safari-validation-fails/BUG.md`
- `bugs/BUG-002-unicode-email-crash/BUG.md`

### Constraints

- Do NOT create a bug for something not covered by an existing spec
- Do NOT include extensive code snippets — reference files and functions instead
- Do NOT propose architectural changes — that requires a change request, not a bugfix
- Do NOT mark as anything other than DRAFT initially
- All bracket placeholders from template must be removed; if info is missing, ASK

## Verification

- [ ] Related SPEC.md is linked and APPROVED
- [ ] Acceptance criteria violation is identified and quoted
- [ ] Reproduction steps are complete and verifiable
- [ ] Severity is set appropriately
- [ ] Fix verification criteria are defined
- [ ] Tasks are atomic and include regression test
- [ ] Status is DRAFT
- [ ] File saved in correct location
