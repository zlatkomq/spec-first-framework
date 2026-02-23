# flow

Run the full spec-first feature workflow for a given spec: create/update SPEC, DESIGN, TASKS, implement, and review — step by step with menus to continue, go back, or exit.

If the user provides no message after `/flow`, ask which spec to work on.

## 1. Parse user input

The user's message after `/flow` can take several forms. Parse it as follows:

1. **Split on colon (`:`)**: Everything before the first `:` is the **spec reference**. Everything after is the **requirement description** (passed to step-01 as starting input). If no colon, the entire message is the spec reference and there is no requirement description.

   Examples:
   - `/flow 001-user-registration: Users should be able to register` → ref: `001-user-registration`, description: `Users should be able to register`
   - `/flow 001` → ref: `001`, description: (none)
   - `/flow 001-user-registration` → ref: `001-user-registration`, description: (none)

2. **Parse the spec reference** to extract `spec_id` and `spec_slug`:
   - If reference matches `{ID}-{slug}` (e.g. `001-user-registration`): extract both.
   - If reference is just an ID (e.g. `001`): `spec_id` = `001`, `spec_slug` = unknown (resolve below).
   - If reference is a path (e.g. `specs/001-user-registration`): extract from the folder name.

## 2. Resolve spec folder

- Search `specs/` for a folder starting with `{spec_id}` (e.g. `001`).
  - **If exactly one match** (e.g. `specs/001-user-registration/`): use it. Extract `spec_slug` from the folder name if not already known.
  - **If multiple matches**: list them and ask the user which one.
  - **If no match and `spec_slug` is known** (user provided `001-user-registration`): the folder doesn't exist yet. Set `spec_folder` = `specs/{spec_id}-{spec_slug}`. Step-01 will create it when saving SPEC.md.
  - **If no match and `spec_slug` is unknown** (user only provided `001`): ask the user for a slug. Example: "No spec folder found for 001. What slug should I use? (e.g. `user-registration`)"

- Final variables:
  - `spec_id` (e.g. `001`)
  - `spec_slug` (e.g. `user-registration`)
  - `spec_folder` (e.g. `specs/001-user-registration`)

## 3. Check for CONSTITUTION.md

- Verify `CONSTITUTION.md` exists.
- If missing: display "No CONSTITUTION.md found. Run `/constitute` first to set up project standards." STOP.

## 4. Check workflow state

- Look for `{spec_folder}/.workflow-state.md`.

### Case A: State file exists and stepsCompleted is non-empty

The workflow was started before and is in progress (or complete).

- Read fully and follow: `.framework/steps/step-00-continue.md`.
- Pass context: `spec_id`, `spec_slug`, `spec_folder` (these are available as variables for all step files to use as `{spec_id}`, `{spec_slug}`, `{spec_folder}`).

### Case B: State file does not exist or stepsCompleted is empty

This is a fresh start.

1. If the spec folder does not exist, it will be created by step-01 when it saves SPEC.md.
2. Create `{spec_folder}/.workflow-state.md` from the template `.framework/templates/workflow-state.template.md`. Fill in `specId`, `specSlug`, `specFolder` in the frontmatter. Set `stepsCompleted: []`.
3. Read fully and follow: `.framework/steps/step-01-spec.md`.
4. Pass any requirement description from the user's message to step-01 (so it can use it as starting input for the spec).

## Variable resolution

When loading any step file, the following variables (resolved in sections 1–2 above) are available and must be substituted into any `{placeholder}` references within the step file:

| Variable | Source | Example |
|----------|--------|---------|
| `{spec_id}` | Parsed from user input (section 1) | `001` |
| `{spec_slug}` | Parsed from user input or folder name (section 2) | `user-registration` |
| `{spec_folder}` | Resolved folder path (section 2) | `specs/001-user-registration` |

Step files use these to construct paths like `{spec_folder}/SPEC.md`, `{spec_folder}/.workflow-state.md`, etc.

These variables are set ONCE during flow.md execution and remain constant for the entire workflow session (all step files use the same values).

## Step execution rules

When a step file says "Read fully and follow: {nextStepFile}":
1. Read the entire next step file.
2. Execute its instruction sequence (create/update artifacts, apply rules, interact with user).
3. When the step presents a menu, halt and wait for user input.
4. Handle [C], [B], [X], and other choices as the step file instructs.
5. If [C]: the step updates state and then says "load and follow next step" — do so.
6. If [B]: the step trims state and says "load and follow step-XX" — do so.
7. Repeat until workflow is complete or user chooses [X].

## Reference

- Step files: `.framework/steps/step-00-continue.md` through `step-05-review.md`
- State template: `.framework/templates/workflow-state.template.md`
- Skills: `skills/spec-creation/SKILL.md`, `skills/design-creation/SKILL.md`, `skills/task-creation/SKILL.md`, `skills/implementation/SKILL.md`, `skills/code-review/SKILL.md`
- Templates: `.framework/templates/SPEC.template.md`, `DESIGN.template.md`, `TASKS.template.md`, `REVIEW.template.md`
- Project standards: `CONSTITUTION.md`
