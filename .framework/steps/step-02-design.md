---
name: 'step-02-design'
description: 'Create or update DESIGN.md for this feature'
nextStepFile: './step-03-tasks.md'

# References
ruleRef: '@.cursor/rules/design-creation.mdc'
templateRef: '@.framework/templates/DESIGN.template.md'
constitutionRef: '@.framework/CONSTITUTION.md'
stateFile: '{spec_folder}/.workflow-state.md'
specFile: '{spec_folder}/SPEC.md'
outputFile: '{spec_folder}/DESIGN.md'
---

# Step 2: Create Technical Design

**Progress: Step 2 of 5** — Next: Task Breakdown

## STEP GOAL

Create (or update) DESIGN.md by applying the design-creation rules and template. The design must address HOW to build what SPEC.md describes, following CONSTITUTION.md standards.

## RULES

- READ this entire step file before taking any action.
- Apply {ruleRef} for all domain behavior, constraints, and output. Do not restate or override the rule.
- Use the template from {templateRef}.
- Load project context from {constitutionRef}.
- Load the approved SPEC.md from {specFile}.
- HALT and WAIT for user input at every menu.
- Do NOT load or look ahead to future step files.

## GATE

- Prerequisite: per {ruleRef}, required inputs must be satisfied (SPEC approved). If not met: display a short message that DESIGN cannot be created until SPEC is approved; offer `[B] Back to Spec (step 1)` | `[X] Exit`. On [B]: load and follow `./step-01-spec.md`. On [X]: STOP.

## SEQUENCE

### 1. Load inputs

- Read {specFile} completely (acceptance criteria, scope, user stories).
- Read {constitutionRef} for project standards.

### 2. Check if DESIGN.md already exists

- If `{outputFile}` exists:
  - Read it and present its current state.
  - Ask: "DESIGN.md already exists. Do you want to **update** it or **continue** to the next step?"
  - If update: proceed to section 3.
  - If continue and Status is APPROVED: skip to menu (section 5).
  - If continue but Status is DRAFT: inform user "DESIGN must be APPROVED before continuing." Redisplay choice.
- If not exists: proceed to section 3.

### 3. Create DESIGN.md

- Apply {ruleRef} using {templateRef}. Save to `{outputFile}` with Status: DRAFT.

### 4. Approval gate

- Present the completed DESIGN.md to the user.
- Ask: "Review the DESIGN. Approve it (say 'approve' or 'yes') or tell me what to change."
- If user approves: update DESIGN.md Status → APPROVED.
- If user requests changes: apply, re-save, re-present, loop.

### 5. Present MENU

Display:

```
DESIGN.md is APPROVED.

[C] Continue — proceed to Task Breakdown (Step 3 of 5)
[V] View SPEC.md — display for reference (read-only)
[B] Back to Spec — re-edit SPEC.md (step 1)
[X] Exit — pause workflow; resume later with /flow
```

### Menu handling

- **IF [C] Continue:**
  1. Update `{stateFile}`: append `'step-02-design'` to `stepsCompleted`.
  2. Read fully and follow: `{nextStepFile}` (step-03-tasks.md).
- **IF [V] View SPEC.md:**
  1. Read and display the full content of {specFile}.
  2. Redisplay this menu (no state changes).
- **IF [B] Back to Spec:**
  1. Trim `stepsCompleted` in `{stateFile}` to remove entries after step-01 (keep only entries up to and including `'step-01-spec'`; remove `'step-02-design'` if present).
  2. Read fully and follow: `./step-01-spec.md`.
- **IF [X] Exit:**
  - Update `{stateFile}`: append `'step-02-design'` to `stepsCompleted` (if DESIGN is APPROVED).
  - Display: "Workflow paused. Run `/flow {spec_id}` to resume."
  - STOP.
- **IF anything else:** Answer, then redisplay menu.

## CRITICAL COMPLETION NOTE

ONLY when [C] is selected and state is updated will you load and execute `{nextStepFile}`.

---

## SUCCESS CRITERIA

- All domain and quality criteria per {ruleRef} are satisfied.
- Status APPROVED before continuing.
- State updated before loading next step.

## FAILURE CONDITIONS

- Proceeding without satisfying gate (SPEC approved).
- Not updating state before loading next step.
- Loading next step before user selects [C].
