# Return and Continue in the Spec-First Workflow

How the BMAD-style step-file workflow handles **resume**, **go back and fix**, and **continue** — all from a single command: `/flow`.

---

## How it works

### One command: `/flow 001`

Run `/flow 001` (or `/flow 001-user-registration`) to start or resume the feature workflow for a spec. The command:

1. Resolves the spec folder (e.g. `specs/001-user-registration`).
2. Checks for a state file (`.workflow-state.md`) in that folder.
3. If state exists and workflow is in progress: loads the **continuation step** (step-00) which computes "where you left off" and offers [C] Continue.
4. If no state or fresh start: loads **step-01** (create SPEC) and starts the flow.

From there, the runner loads and executes one step at a time. Each step shows a menu:

- **[C] Continue** — update state, load and run the next step.
- **[B] Back to …** — trim state, load and run a previous step.
- **[X] Exit** — save state, stop. Resume later with `/flow 001`.

---

## Step chain

```
Step 1: SPEC.md    (spec-creation rules + template)
  ↓ [C]
Step 2: DESIGN.md  (design-creation rules + template; gate: SPEC approved)
  ↓ [C]
Step 3: TASKS.md   (task-creation rules + template; gate: DESIGN approved)
  ↓ [C]
Step 4: Implement  (implementation rules; gate: TASKS approved)
  ↓ [C]
Step 5: REVIEW.md  (code-review rules + template; gate: implementation done)
  ↓ [C]
Complete
```

Each step has a gate (e.g. SPEC must be APPROVED before DESIGN). If the gate isn't met, the step tells you and offers [B] Back to fix it.

---

## State

State lives in `specs/XXX-slug/.workflow-state.md` with YAML frontmatter:

```yaml
---
stepsCompleted: ['step-01-spec', 'step-02-design']
implementationAttempts: 0
specId: '001'
specSlug: 'user-registration'
specFolder: 'specs/001-user-registration'
---
```

- `stepsCompleted` is only updated when you choose **[C] Continue** (or **[X] Exit** after completing a step).
- `implementationAttempts` tracks how many times the verification gate has failed (0-3). After 3 failures, routes to manual intervention.
- Task completion is tracked by `[x]` checkboxes in TASKS.md (single source of truth — no separate state field).
- When you **[B] Back**, `stepsCompleted` is trimmed so that "last completed" reflects the step you're going back to.
- This file is **committed to git** (not .gitignored). It provides team visibility into where each spec is in the workflow.

---

## Scenarios

### Resume after a break

1. You stopped after Design (state: `stepsCompleted: ['step-01-spec', 'step-02-design']`).
2. Later, run `/flow 001`.
3. Continuation step shows: "Last completed: step-02-design. Next: Tasks. [C] Continue."
4. Press **[C]** — step-03 runs (creates TASKS.md).

### Resume mid-implementation

1. You're implementing tasks. You complete T1, T2, T3 (marked `[x]` in TASKS.md), then exit (state: `stepsCompleted: ['step-01-spec', 'step-02-design', 'step-03-tasks']`).
2. Later, run `/flow 001`.
3. Continuation step reads TASKS.md and shows: "Last completed: step-03-tasks. Next: Implementation. Implementation progress: 3 of 7 tasks completed."
4. Press **[C]** — step-04 loads, reads TASKS.md, sees T1/T2/T3 are `[x]`, and offers to continue with remaining tasks.

### Review fails — fix and re-review

1. Review fails (step 5, verdict: CHANGES REQUESTED). Findings list specific issues.
2. Menu shows: `[F] Fix` (auto-fix), `[B] Back to Implement`, `[B2] Back to Tasks`, `[B3] Back to Design`.
3. Choose **[F] Fix** — AI applies scoped fixes for Critical/Major issues and re-runs review (up to 3 fix attempts).
4. Or choose **[B] Back to Implement** — step-04 loads, detects REVIEW.md with CHANGES REQUESTED, and displays findings as context for re-implementation.
5. After fixes, step-05 runs a **fresh review from scratch** (not a partial re-review). New REVIEW.md is written.
6. If review passes, choose **[C] Complete**. Done.
7. If auto-fix exhausts 3 attempts, the framework classifies the situation (diverging/converging/churning) and recommends a path.

### Go back further (Design or Spec)

1. Review fails and the issue is in the design, not just implementation.
2. Choose **[B3] Back to Design** — state is trimmed, step-02 runs.
3. Fix DESIGN. **[C]** → step-03 (re-create Tasks). **[C]** → step-04 (re-implement). **[C]** → step-05 (review again).

### Fix within a step (loop before continuing)

1. At step 1, SPEC is created with Status: DRAFT.
2. You say "change AC3 wording."
3. SPEC is updated. You approve it. Status: APPROVED.
4. Menu: [C] Continue | [B] Back to Spec | [X] Exit.
5. You choose **[C]** — step advances. No intermediate saves until you're happy.

---

## File structure

```
.framework/
├── steps/
│   ├── step-00-continue.md    # Resume logic
│   ├── step-01-spec.md        # Create/update SPEC.md
│   ├── step-02-design.md      # Create/update DESIGN.md
│   ├── step-03-tasks.md       # Create/update TASKS.md
│   ├── step-04-implement.md   # Implement all tasks
│   └── step-05-review.md      # Generate REVIEW.md
└── templates/
    ├── workflow-state.template.md   # State file template
    ├── SPEC.template.md
    ├── DESIGN.template.md
    ├── TASKS.template.md
    └── REVIEW.template.md

.cursor/commands/
└── flow.md                    # Workflow runner (entry point)

specs/001-user-registration/
├── .workflow-state.md         # Per-spec state (created by /flow)
├── SPEC.md
├── DESIGN.md
├── TASKS.md
├── IMPLEMENTATION-SUMMARY.md  # Written after implementation (step 4)
└── REVIEW.md
```

---

## Standalone commands still work

You can still use `/specify`, `/design`, `/tasks`, `/implement`, `/review` for a single step without the full flow. The step-file workflow (`/flow`) is for guided, stateful execution with resume and back support.
