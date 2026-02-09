---
name: 'step-05-review'
description: 'Generate adversarial code review (REVIEW.md) for this feature'

# References
ruleRef: '@.cursor/rules/code-review.mdc'
templateRef: '@.framework/templates/REVIEW.template.md'
constitutionRef: '@.framework/CONSTITUTION.md'
stateFile: '{spec_folder}/.workflow-state.md'
specFile: '{spec_folder}/SPEC.md'
designFile: '{spec_folder}/DESIGN.md'
tasksFile: '{spec_folder}/TASKS.md'
outputFile: '{spec_folder}/REVIEW.md'
---

# Step 5: Code Review

**Progress: Step 5 of 5** — Final step

## STEP GOAL

Generate an adversarial REVIEW.md by applying the code-review rules. Inspect actual source code against SPEC, DESIGN, TASKS, and CONSTITUTION. Produce a verdict: APPROVED, CHANGES REQUESTED, or BLOCKED.

## RULES

- READ this entire step file before taking any action.
- Apply {ruleRef} for all domain behavior, constraints, and output. Do not restate or override the rule.
- Use the template from {templateRef}.
- Load {constitutionRef}, {specFile}, {designFile}, and {tasksFile}.
- HALT and WAIT for user input at every menu.
- **ALWAYS run the full review from scratch.** If this step is re-entered (e.g. after fixing issues from a previous review), do NOT resume a partial review — re-run all phases per {ruleRef} completely. Delete or overwrite the previous REVIEW.md.

## GATE

- Implementation must be complete (all tasks in {tasksFile} done).
- Check `tasksCompleted` in `{stateFile}` — all task IDs from {tasksFile} must be present.
- If tasks are incomplete: display "Not all tasks are implemented. Complete implementation first." Offer: `[B] Back to Implement (step 4)` | `[X] Exit`. On [B]: load and follow `./step-04-implement.md`. On [X]: STOP.

## SEQUENCE

### 1. Load inputs

- Read {specFile} (acceptance criteria).
- Read {designFile} (architecture, data model, API).
- Read {tasksFile} (task list, expected files).
- Read {constitutionRef} (standards, coverage thresholds).

### 2. Execute review (from scratch)

**IMPORTANT:** Even if a previous REVIEW.md exists, run the full review again from the beginning. Code may have changed since the last review.

Apply {ruleRef} in full (all phases and post-phase validation per rule).

### 3. Write REVIEW.md

- Save to `{outputFile}` using {templateRef}. Include verdict and findings per {ruleRef}.

### 4. Present results

Display the verdict and a summary of findings.

### 5. Present MENU

**IF verdict is APPROVED:**

```
REVIEW: APPROVED

[C] Complete — mark workflow as done
[B] Back to Implement — re-do a task
[X] Exit
```

**IF verdict is CHANGES REQUESTED or BLOCKED:**

```
REVIEW: {verdict}

Findings:
{list of critical/major issues with affected tasks/files}

[F] Fix — go back to Implementation (step 4) to address findings
[B] Back to Tasks — re-edit TASKS.md (step 3)
[B2] Back to Design — re-edit DESIGN.md (step 2)
[B3] Back to Spec — re-edit SPEC.md (step 1)
[X] Exit — pause workflow; resume later with /flow
```

### Menu handling

**APPROVED path:**

- **IF [C] Complete:**
  1. Update `{stateFile}`: append `'step-05-review'` to `stepsCompleted`.
  2. Display: "Feature workflow complete for spec {spec_id}. All artifacts: SPEC.md, DESIGN.md, TASKS.md, REVIEW.md are in `{spec_folder}/`."
  3. Display: "Human reviewer should make the final decision at Gate 4."
  4. STOP. Workflow is done.
- **IF [B] Back to Implement:**
  1. Trim `stepsCompleted` in `{stateFile}` to keep entries up to `'step-03-tasks'`.
  2. Read fully and follow: `./step-04-implement.md`.
  - (Step-04 will detect REVIEW.md with findings and display them.)
- **IF [X] Exit:**
  - Update `{stateFile}`: append `'step-05-review'` to `stepsCompleted`.
  - STOP.

**CHANGES REQUESTED / BLOCKED path:**

- **IF [F] Fix:**
  1. Trim `stepsCompleted` in `{stateFile}` to keep entries up to `'step-03-tasks'`.
  2. Do NOT clear `tasksCompleted` — keep the task progress so step-04 knows which tasks are done and can let the user selectively re-implement the affected ones.
  3. Read fully and follow: `./step-04-implement.md`.
  - (Step-04 will detect REVIEW.md with CHANGES REQUESTED and display the findings. The user can then re-implement specific tasks using [R] or [T]. After all fixes, they continue back to step-05 for a fresh review.)
- **IF [B] Back to Tasks:**
  1. Trim `stepsCompleted` to keep entries up to `'step-02-design'`.
  2. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  3. Read fully and follow: `./step-03-tasks.md`.
- **IF [B2] Back to Design:**
  1. Trim `stepsCompleted` to keep entries up to `'step-01-spec'`.
  2. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  3. Read fully and follow: `./step-02-design.md`.
- **IF [B3] Back to Spec:**
  1. Set `stepsCompleted` to `[]`.
  2. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  3. Read fully and follow: `./step-01-spec.md`.
- **IF [X] Exit:**
  - Display: "Workflow paused with review findings. Run `/flow {spec_id}` to resume and address issues."
  - Do NOT append `'step-05-review'` to `stepsCompleted` (review is not passed).
  - STOP.
- **IF anything else:** Answer, then redisplay menu.

---

## SUCCESS CRITERIA

- All domain and quality criteria per {ruleRef} are satisfied.
- REVIEW.md saved with verdict and findings.
- State updated on completion.
- Review run from scratch (never resumed partial review).
- Fix/back options presented when verdict is CHANGES REQUESTED or BLOCKED.

## FAILURE CONDITIONS

- Not running the full review from scratch when re-entering this step.
- Not updating state on completion.
- Not offering fix/back options on CHANGES REQUESTED or BLOCKED.
- Loading next step or completing workflow before user selects [C] or [X].
