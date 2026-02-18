---
name: 'step-00-continue'
description: 'Resume an interrupted workflow from the last completed step'
stateFile: '{spec_folder}/.workflow-state.md'
tasksFile: '{spec_folder}/TASKS.md'
---

# Step 0: Workflow Continuation

## STEP GOAL

Resume the feature workflow from where it was left off. Determine the next step from the state file and offer the user a choice to continue, go back, or exit.

## RULES

- READ this entire step file before taking any action.
- Do NOT modify content from already completed steps.
- HALT and WAIT for user input at the menu.

## SEQUENCE

### 1. Load state

Read `{stateFile}` frontmatter. Extract:
- `stepsCompleted` — array of completed step names.
- `specId`, `specSlug`, `specFolder`.

Reset counters: set `fixAttempts` to `0`, `previousIssueCount` to `0`, `fixLoopActive` to `false`, and `implementationAttempts` to `0` in `{stateFile}`. Resuming via `/flow` always starts fresh counters.

### 2. Validate stepsCompleted

The canonical step order is:

```
step-01-spec, step-02-design, step-03-tasks, step-04-implement, step-05-review
```

Verify that `stepsCompleted` is a valid contiguous prefix of this sequence:
- The first N elements of `stepsCompleted` must match the first N entries of the canonical order, in order.
- Any entry not in the canonical list is invalid.
- Any gap (e.g. `step-01-spec` then `step-03-tasks`, skipping `step-02-design`) is invalid.
- Any out-of-order entry is invalid.

**If validation fails**, display a clear error with the specific problem:

```
Workflow state is corrupted: {specific problem, e.g. "step-02-design is missing between step-01-spec and step-03-tasks"}.

[R] Reset — clear stepsCompleted and start from Step 1 (Spec)
[X] Exit — pause workflow; fix .workflow-state.md manually
```

On [R]: set `stepsCompleted` to `[]`, reset `fixAttempts` to `0`, `previousIssueCount` to `0`, `fixLoopActive` to `false`, and `implementationAttempts` to `0` in `{stateFile}`. Then read fully and follow: `./step-01-spec.md`.

On [X]: STOP.

**If validation passes**, continue to section 3.

### 3. Handle workflow completion

If `stepsCompleted` contains `'step-05-review'`:

Display:

```
Workflow is already complete for spec {specId}.

All artifacts are in {specFolder}/:
- SPEC.md, DESIGN.md, TASKS.md, REVIEW.md

[B] Back to a step — re-do a specific step
[X] Exit
```

On [B]: ask "Which step? [1] Spec [2] Design [3] Tasks [4] Implement [5] Review" and load the corresponding step file. Trim `stepsCompleted` appropriately before loading.

On [X]: STOP.

### 4. Determine next step

1. Get the last element from `stepsCompleted` (e.g. `'step-02-design'`).
2. Load that step file from `.framework/steps/` and read its frontmatter.
3. Extract `nextStepFile` from the frontmatter.
4. That is the next step to run.

### 5. Check for partial implementation progress

If the next step is `step-04-implement.md`:

- Read {tasksFile}. Count tasks marked `[x]` vs total tasks.
- If any `[x]` tasks exist, include progress in the status display (section 6).

### 6. Present status and menu

Display:

```
Welcome back! Resuming workflow for spec {specId}.

Last completed: {last element of stepsCompleted}
Next step: {nextStepFile name} ({step N of 5})
```

**If there is partial implementation progress ([x] tasks found and next step is step-04):**

```
Implementation progress: {count of [x] tasks} of {total tasks} tasks completed.
```

```
[C] Continue — proceed to {next step description}
[B] Back to a step — [1] Spec [2] Design [3] Tasks [4] Implement
[X] Exit
```

### 7. Menu handling

- **IF [C] Continue:**
  - Read fully and follow the `nextStepFile` determined in section 4.
  - Do NOT append anything to `stepsCompleted` here — the next step will do that when the user completes it.

- **IF [B] Back to step N:**
  - User chooses which step (1–4).
  - Trim `stepsCompleted` to keep only entries before the chosen step:
    - Back to Spec (1): set `stepsCompleted` to `[]`.
    - Back to Design (2): keep only `['step-01-spec']`.
    - Back to Tasks (3): keep up to `['step-01-spec', 'step-02-design']`.
    - Back to Implement (4): keep up to `['step-01-spec', 'step-02-design', 'step-03-tasks']`.
  - Reset `fixAttempts` to `0`, `previousIssueCount` to `0`, `fixLoopActive` to `false`, and `implementationAttempts` to `0` in `{stateFile}`.
  - Update `{stateFile}` with trimmed `stepsCompleted`.
  - Read fully and follow the corresponding step file (e.g. `step-02-design.md`).

- **IF [X] Exit:**
  - Display: "Workflow paused. Run `/flow {specId}` to resume."
  - STOP.

- **IF anything else:** Answer, then redisplay menu.

---

## SUCCESS CRITERIA

- State correctly read and analyzed.
- `stepsCompleted` validated as a contiguous prefix of the canonical step order before any routing.
- Corrupted state detected and reported with clear error message and recovery options.
- Next step correctly determined from last completed step's frontmatter.
- Partial implementation progress displayed when applicable.
- User clearly informed of progress.
- Correct step file loaded on [C] or [B].
- Counters reset when going back to earlier steps.

## FAILURE CONDITIONS

- Modifying content from completed steps.
- Accepting a corrupted `stepsCompleted` (gaps, out-of-order, or unknown entries) without error.
- Loading wrong next step.
- Not trimming state when going back.
- Not showing implementation progress when resuming mid-step-04.
