---
name: 'step-03-tasks'
description: 'Create or update TASKS.md for this feature'
nextStepFile: './step-04-implement.md'

# References
ruleRef: '@.cursor/rules/task-creation.mdc'
templateRef: '@.framework/templates/TASKS.template.md'
constitutionRef: '@.framework/CONSTITUTION.md'
stateFile: '{spec_folder}/.workflow-state.md'
specFile: '{spec_folder}/SPEC.md'
designFile: '{spec_folder}/DESIGN.md'
outputFile: '{spec_folder}/TASKS.md'
---

# Step 3: Create Task Breakdown

**Progress: Step 3 of 5** — Next: Implementation

## STEP GOAL

Create (or update) TASKS.md by applying the task-creation rules and template. Break the design into atomic, implementable tasks ordered by dependency.

## RULES

- READ this entire step file before taking any action.
- Apply {ruleRef} for all domain behavior, constraints, and output. Do not restate or override the rule.
- Use the template from {templateRef}.
- Load {constitutionRef}, {specFile}, and {designFile}.
- HALT and WAIT for user input at every menu.
- Do NOT load or look ahead to future step files.

## GATE

- Prerequisite: per {ruleRef}, required inputs must be satisfied (DESIGN approved). If not met: display a short message that TASKS cannot be created until DESIGN is approved; offer `[B] Back to Design (step 2)` | `[X] Exit`. On [B]: load and follow `./step-02-design.md`. On [X]: STOP.

## SEQUENCE

### 1. Load inputs

- Read {designFile} completely.
- Read {specFile} (for acceptance criteria traceability).
- Read {constitutionRef} (for coverage thresholds, patterns).

### 2. Check if TASKS.md already exists

- If `{outputFile}` exists:
  - Read it and present its current state (task list, status).
  - Ask: "TASKS.md already exists. Do you want to **update** it or **continue** to the next step?"
  - If update: proceed to section 3.
  - If continue and Status is APPROVED: skip to menu (section 5).
  - If continue but DRAFT: inform user "TASKS must be APPROVED before continuing." Redisplay choice.
- If not exists: proceed to section 3.

### 3. Create TASKS.md

- Apply {ruleRef} using {templateRef}. This includes:
  - Context gathering (previous spec intelligence, git history analysis)
  - Task creation with DESIGN.md traceability
  - Adversarial self-validation (reinvention check, vagueness check, coverage check)
- Save to `{outputFile}` with Status: DRAFT.

### 3.5. Present validation findings

- If the adversarial self-validation in {ruleRef} found any issues, present them alongside the TASKS.md:
  - "The following gaps were found during self-validation and have been addressed: [list]"
  - "The following potential concerns remain for your review: [list if any]"
- This gives the user visibility into what the AI caught and fixed automatically.

### 4. Approval gate

- Present the completed TASKS.md to the user.
- Ask: "Review the TASKS. Approve it (say 'approve' or 'yes') or tell me what to change."
- If user approves: update TASKS.md Status → APPROVED.
- If user requests changes: apply, re-save, re-present, loop.

### 5. Present MENU

Display:

```
TASKS.md is APPROVED.

[C] Continue — proceed to Implementation (Step 4 of 5)
[B] Back to Design — re-edit DESIGN.md (step 2)
[B2] Back to Spec — re-edit SPEC.md (step 1)
[X] Exit — pause workflow; resume later with /flow
```

### Menu handling

- **IF [C] Continue:**
  1. Update `{stateFile}`: append `'step-03-tasks'` to `stepsCompleted`.
  2. Read fully and follow: `{nextStepFile}` (step-04-implement.md).
- **IF [B] Back to Design:**
  1. Trim `stepsCompleted` in `{stateFile}` to keep only entries up to `'step-01-spec'`.
  2. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  3. Read fully and follow: `./step-02-design.md`.
- **IF [B2] Back to Spec:**
  1. Set `stepsCompleted` in `{stateFile}` to `[]` (empty).
  2. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  3. Read fully and follow: `./step-01-spec.md`.
- **IF [X] Exit:**
  - Update `{stateFile}`: append `'step-03-tasks'` to `stepsCompleted` (if TASKS is APPROVED).
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

- Proceeding without satisfying gate (DESIGN approved).
- Not updating state before loading next step.
- Loading next step before user selects [C].
