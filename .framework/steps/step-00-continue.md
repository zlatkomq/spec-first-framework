---
name: 'step-00-continue'
description: 'Resume an interrupted workflow from the last completed step'
stateFile: '{spec_folder}/.workflow-state.md'
tasksFile: '{spec_folder}/TASKS.md'
worktreeRef: '@skills/git-worktrees/SKILL.md'
---

# Step 0: Workflow Continuation

## STEP GOAL

Resume the feature workflow from where it was left off.

## RULES

- READ this entire step file before taking any action.
- Do NOT modify content from already completed steps.
- HALT and WAIT for user input at the menu.

## SEQUENCE

### 1. Load and validate state

Read `{stateFile}` frontmatter. Extract `stepsCompleted`, `specId`, `specSlug`, `specFolder`.

Reset counters: `fixAttempts` = 0, `previousIssueCount` = 0, `fixLoopActive` = false, `implementationAttempts` = 0.

Validate `stepsCompleted` is a contiguous prefix of the canonical order:

```
step-01-spec, step-02-design, step-03-tasks, step-04-implement, step-05-review
```

**If validation fails** (gaps, out-of-order, unknown entries):

```
Workflow state is corrupted: {specific problem}.

[R] Reset — clear stepsCompleted and start from Step 1
[X] Exit — fix .workflow-state.md manually
```

- **[R]:** Set `stepsCompleted` to `[]`, reset all counters. Load `./step-01-spec.md`.
- **[X]:** STOP.

### 2. Verify workspace context

Read `featureBranch`, `baseBranch`, `worktreePath` from {stateFile} frontmatter.

**If `featureBranch` is set** (implementation has started or completed):

1. Check current branch: `git branch --show-current`
2. Check if inside a worktree: compare `git rev-parse --show-toplevel` vs `git rev-parse --git-common-dir` (if they differ, you're in a worktree)

**If `worktreePath` is set and we are NOT inside it:**

```
A worktree exists for this spec at {worktreePath} on branch {featureBranch}.
You are currently on branch {currentBranch} at {currentPath}.

[W] Switch to worktree — cd into {worktreePath}
[C] Continue here — proceed on current branch
[X] Exit
```

- **[W]:** `cd` into `{worktreePath}`. Verify we're now on `{featureBranch}`. Proceed to section 3.
- **[C]:** Proceed to section 3 on the current branch.
- **[X]:** STOP.

**If `featureBranch` is set but `worktreePath` is empty** (direct branch, no worktree):

Check if current branch matches `{featureBranch}`. If not, display:

```
Note: This spec's work is on branch {featureBranch}, but you are on {currentBranch}.
Consider switching: git checkout {featureBranch}
```

Proceed to section 3 regardless.

**If `featureBranch` is empty** (steps 1-3, no implementation yet):

Skip this check. No branch context expected.

**State drift detection:**

If the last completed step is `step-03-tasks` (or earlier) but {tasksFile} has tasks marked `[x]`:

```
State drift detected: TASKS.md has completed tasks but workflow state shows
step 3 as last completed step. This may indicate implementation happened
outside the workflow.

[A] Accept — treat tasks as implemented, advance state to step-04-implement
[I] Ignore — proceed as if tasks are not implemented (re-implementation)
[X] Exit — investigate manually
```

- **[A]:** Append `'step-04-implement'` to `stepsCompleted` in {stateFile}. Proceed to section 3.
- **[I]:** Proceed to section 3 without changing state.
- **[X]:** STOP.

### 3. Handle workflow completion

If `stepsCompleted` contains `'step-05-review'`:

```
Workflow is already complete for spec {specId}.
All artifacts are in {specFolder}/.

[B] Back to a step — re-do a specific step
[X] Exit
```

- **[B]:** Ask which step (1-5). Trim `stepsCompleted` to keep entries before the chosen step. Reset all counters. Load the corresponding step file.
- **[X]:** STOP.

### 4. Determine next step and present menu

Get the last element from `stepsCompleted`. Load that step file's frontmatter and extract `nextStepFile`.

If the next step is `step-04-implement.md`: read {tasksFile} and count `[x]` vs total tasks for progress display.

```
Welcome back! Resuming workflow for spec {specId}.

Last completed: {last step}
Next step: {nextStepFile} (Step N of 5)
{If mid-step-04: "Implementation progress: {[x] count} of {total} tasks completed."}

[C] Continue — proceed to {next step}
[B] Back to a step — [1] Spec [2] Design [3] Tasks [4] Implement
[X] Exit
```

- **[C]:** Load and follow `nextStepFile`. Do NOT update `stepsCompleted` here — the next step does that.
- **[B]:** Trim `stepsCompleted` per chosen step:
  - Back to Spec (1): `[]`
  - Back to Design (2): keep `['step-01-spec']`
  - Back to Tasks (3): keep up to `['step-01-spec', 'step-02-design']`
  - Back to Implement (4): keep up to `['step-01-spec', 'step-02-design', 'step-03-tasks']`
  Reset all counters. Load the corresponding step file.
- **[X]:** Display: "Workflow paused. Run `/flow {specId}` to resume." STOP.
- **Anything else:** Answer, then redisplay menu.
