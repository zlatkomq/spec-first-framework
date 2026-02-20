---
name: 'step-04-implement'
description: 'Implement all tasks from TASKS.md'
nextStepFile: './step-05-review.md'

# References
ruleRef: '@skills/implementation/SKILL.md'
constitutionRef: '@.framework/CONSTITUTION.md'
verificationChecklist: '@.framework/checklists/verification-checklist.md'
stateFile: '{spec_folder}/.workflow-state.md'
specFile: '{spec_folder}/SPEC.md'
designFile: '{spec_folder}/DESIGN.md'
tasksFile: '{spec_folder}/TASKS.md'
reviewFile: '{spec_folder}/REVIEW.md'
summaryFile: '{spec_folder}/IMPLEMENTATION-SUMMARY.md'
---

# Step 4: Implementation

**Progress: Step 4 of 5** — Next: Code Review

## STEP GOAL

Implement all incomplete tasks from TASKS.md. Run a verification gate. Write the implementation summary for cross-spec learning.

## RULES

- READ this entire step file before taking any action.
- Apply {ruleRef} for all domain behavior, constraints, and output. Do not restate or override the rule.
- Load {constitutionRef}, {designFile}, and {tasksFile}.
- HALT and WAIT for user input at every menu.
- Do NOT load or look ahead to future step files.

## GATE

Check gate per {ruleRef}. If gate fails: `[B] Back to Tasks (step 3)` | `[X] Exit`. On [B]: load `./step-03-tasks.md`. On [X]: STOP.

## SEQUENCE

### 1. Load inputs

- Read {tasksFile}, {designFile}, {constitutionRef}.
- Read `{stateFile}` frontmatter: extract `stepsCompleted` and `implementationAttempts`.
- Count incomplete tasks (`[ ]` in {tasksFile}).

### 2. Determine entry state

**(A) Fresh entry** — no {reviewFile} with CHANGES REQUESTED/BLOCKED, `implementationAttempts` = 0:
- Incomplete tasks > 0: `[S] Start implementation` | `[X] Exit`
- All tasks `[x]`: skip to section 4.

**(B) Retry** — `implementationAttempts` > 0 and < 3:
- Display previous verification failures.
- `[R] Retry implementation (attempt {implementationAttempts+1} of 3)` | `[X] Exit`

**(C) Re-entry from review** — {reviewFile} exists with CHANGES REQUESTED or BLOCKED:
- Reset `implementationAttempts` to 0 in {stateFile}.
- Display review findings (Critical and Major issues).
- `[S] Start implementation addressing review findings` | `[X] Exit`

**(D) Exhausted** — `implementationAttempts` >= 3:
- `[M] Manual intervention` | `[B] Back to Tasks (step 3)` | `[B2] Back to Design (step 2)` | `[X] Exit`

**Menu routing:**
- **[S] or [R]:** Proceed to section 3.
- **[M]:** User provides manual verification results. If all pass → section 5. If failures → STOP.
- **[B]:** Trim `stepsCompleted` to keep up to `'step-02-design'`. Load `./step-03-tasks.md`.
- **[B2]:** Trim `stepsCompleted` to keep up to `'step-01-spec'`. Load `./step-02-design.md`.
- **[X]:** STOP.

### 3. Implementation session

Apply {ruleRef} with full context ({tasksFile}, {constitutionRef}, {designFile}, {specFile} for AC reference).

**Summary file lifecycle:**
- **Fresh entry or retry:** Delete existing `{summaryFile}` — rebuild from scratch.
- **Re-entry from review:** Keep existing `{summaryFile}`. Append only fix task entries.

Implement all incomplete tasks per {ruleRef}. When all done, proceed to section 4.

### 4. Verification gate

Run {verificationChecklist}.

- **PASS:** Proceed to section 5.
- **FAIL:** Increment `implementationAttempts` in {stateFile}. Display failures. Return to section 2 (retry path).

### 5. Finalize implementation summary

Finalize `{summaryFile}`: per-task anchor entries exist from section 3. Append aggregate sections per {ruleRef}: consolidated file list, test totals with raw output, key decisions, patterns, design feedback.

### 6. Present MENU

```
All {total} tasks implemented. Verification: PASS.

[C] Continue — proceed to Code Review (Step 5 of 5)
[B] Back to Tasks — re-edit TASKS.md (step 3)
[B2] Back to Design — re-edit DESIGN.md (step 2)
[X] Exit — pause workflow; resume later with /flow
```

- **[C]:** Update `{stateFile}`: append `'step-04-implement'` to `stepsCompleted`. Load and follow `{nextStepFile}`.
- **[B]:** Trim `stepsCompleted` to keep up to `'step-02-design'`. Load `./step-03-tasks.md`.
- **[B2]:** Trim `stepsCompleted` to keep up to `'step-01-spec'`. Load `./step-02-design.md`.
- **[X]:** Update `{stateFile}`: append `'step-04-implement'` to `stepsCompleted`. Display: "Workflow paused. Run `/flow {spec_id}` to resume." STOP.
- **Anything else:** Answer, then redisplay menu.
