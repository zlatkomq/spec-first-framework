---
name: 'step-03-tasks'
description: 'Create or update TASKS.md for this feature'
nextStepFile: './step-04-implement.md'

# References
ruleRef: '@skills/task-creation/SKILL.md'
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

Check gate per {ruleRef}. If gate fails: `[B] Back to Design (step 2)` | `[X] Exit`. On [B]: load `./step-02-design.md`. On [X]: STOP.

<HARD-GATE>
Do NOT create TASKS.md without first reading DESIGN.md and SPEC.md completely.
Do NOT create tasks that are not traceable to a specific DESIGN.md section.
Do NOT skip the adversarial self-validation — run ALL checks before presenting to user.
</HARD-GATE>

## SEQUENCE

### 1. Load inputs

- Read {designFile} completely.
- Read {specFile} (for acceptance criteria traceability).
- Read {constitutionRef} (for coverage thresholds, patterns).

### 2. Create TASKS.md

- Apply {ruleRef} using {templateRef}. This includes context gathering (previous spec intelligence, git history) and adversarial self-validation per the rule.
- Save to `{outputFile}` with Status: DRAFT.

### 3. Present validation findings

- If the adversarial self-validation in {ruleRef} found issues, present them alongside TASKS.md:
  - "Gaps found and addressed: [list]"
  - "Potential concerns for your review: [list if any]"

### 4. Approval gate

- Present TASKS.md to the user.
- Ask: "Review the TASKS. Approve it (say 'approve' or 'yes') or tell me what to change."
- If user approves: update Status → APPROVED.
- If user requests changes: apply, re-save, re-present. Loop until approved.

### 5. Present MENU

```
TASKS.md is APPROVED.

[C] Continue — proceed to Implementation (Step 4 of 5)
[V] View DESIGN.md — display for reference (read-only)
[B] Back to Design — re-edit DESIGN.md (step 2)
[B2] Back to Spec — re-edit SPEC.md (step 1)
[X] Exit — pause workflow; resume later with /flow
```

- **[C]:** Update `{stateFile}`: append `'step-03-tasks'` to `stepsCompleted`. Load and follow `{nextStepFile}`.
- **[V]:** Display {designFile}. Redisplay menu.
- **[B]:** Trim `stepsCompleted` in `{stateFile}` to keep only up to `'step-01-spec'`. Load `./step-02-design.md`.
- **[B2]:** Set `stepsCompleted` to `[]`. Load `./step-01-spec.md`.
- **[X]:** Update `{stateFile}`: append `'step-03-tasks'` to `stepsCompleted` (if approved). Display: "Workflow paused. Run `/flow {spec_id}` to resume." STOP.
- **Anything else:** Answer, then redisplay menu.
