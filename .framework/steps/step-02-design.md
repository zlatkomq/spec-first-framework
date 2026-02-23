---
name: 'step-02-design'
description: 'Create or update DESIGN.md for this feature'
nextStepFile: './step-03-tasks.md'

# References
ruleRef: '@skills/design-creation/SKILL.md'
templateRef: '@.framework/templates/DESIGN.template.md'
constitutionRef: '@CONSTITUTION.md'
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

Check gate per {ruleRef}. If gate fails: `[B] Back to Spec (step 1)` | `[X] Exit`. On [B]: load `./step-01-spec.md`. On [X]: STOP.

<HARD-GATE>
Do NOT create DESIGN.md without first reading SPEC.md completely (acceptance criteria, scope, user stories).
Do NOT create DESIGN.md if SPEC.md Status is not APPROVED — check the gate first.
Do NOT include task breakdowns, code, or implementation details in DESIGN.md — that belongs in later steps.
Do NOT bypass user approval before proceeding to Task Breakdown.
</HARD-GATE>

## SEQUENCE

### 1. Load inputs

- Read {specFile} completely (acceptance criteria, scope, user stories).
- Read {constitutionRef} for project standards.

### 2. Create DESIGN.md

- Apply {ruleRef} using {templateRef}. Save to `{outputFile}` with Status: DRAFT.

### 3. Approval gate

- Present DESIGN.md to the user.
- Ask: "Review the DESIGN. Approve to continue to Task Breakdown, or tell me what to change. (Say [V] to view SPEC.md, [B] to go back to Spec, or [X] to exit.)"
- If user requests changes: apply, re-save, re-present. Loop until approved.
- If user approves: update Status → APPROVED. Update `{stateFile}`: append `'step-02-design'` to `stepsCompleted` (early save). Auto-continue: load and follow `{nextStepFile}`.
- **[V]:** Display {specFile}. Re-ask.
- **[B]:** Trim `stepsCompleted` in `{stateFile}` to keep only up to `'step-01-spec'`. Load `./step-01-spec.md`.
- **[X]:** Update `{stateFile}`: append `'step-02-design'` to `stepsCompleted` (if approved). Display: "Workflow paused. Run `/flow {spec_id}` to resume." STOP.
- **Anything else:** Answer, then re-ask.
