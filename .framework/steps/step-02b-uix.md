---
name: 'step-02b-uix'
description: 'Create or update UIX-SPEC.md (Figma mapping) for this feature'
nextStepFile: './step-03-tasks.md'

# References
ruleRef: '@.cursor/rules/uix-creation.mdc'
templateRef: '@.framework/templates/UIX-SPEC.template.md'
stateFile: '{spec_folder}/.workflow-state.md'
specFile: '{spec_folder}/SPEC.md'
designFile: '{spec_folder}/DESIGN.md'
outputFile: '{spec_folder}/UIX-SPEC.md'
figmaDir: '{spec_folder}/figma/'
uixTokensFile: '{spec_folder}/figma/tokens.css'
uixContextPattern: '{spec_folder}/figma/*.md'
uixScreenshotPattern: '{spec_folder}/figma/*.png'
uixAssetsDir: '{spec_folder}/figma/assets/'
---

# Step 2b: Create UIX Spec (Figma) — Optional

**Progress: Step 2b (optional) of 5** — Next: Task Breakdown

## STEP GOAL

Create (or update) UIX-SPEC.md by applying the uix-creation rules and template. Map DESIGN.md segments to Figma files and node IDs. When Figma is in scope, **fetch design context** via the local MCP server **`figma-to-code`** (v2.0.0+) and save all artifacts under `{spec_folder}/figma/` for **step 04 (implementation)** to use as layout reference. **Downstream implementation must follow § 2b** (iterative Figma compare-fix loop — min 2 / max 5 passes with drift list) so UI output is pixel-accurate, not a single-pass approximation. This step is optional: if this spec has no Figma, choose [S] Skip to continue to Task Breakdown.

## RULES

- READ this entire step file before taking any action.
- When Figma is in scope for this spec, **§ 2b** defines a **mandatory iterative** Figma fidelity loop for UI implementation (min 2 / max 5 automatic re-fetch + compare-fix passes with a drift list). Implementation agents must follow § 2b in addition to UIX-SPEC artifacts.
- When this step says "Apply {ref}", read the referenced file completely and follow ALL its sections in order.
- Apply {ruleRef} for all domain behavior, constraints, and output. Do not restate or override the rule.
- Use the template from {templateRef}.
- Load the approved SPEC.md from {specFile} and DESIGN.md from {designFile}.
- HALT and WAIT for user input at every menu.
- Do NOT load or look ahead to future step files.

## GATE

Check gate per {ruleRef}. If SPEC.md or DESIGN.md is not APPROVED: `[B] Back to Design (step 2)` | `[X] Exit`. On [B]: load `./step-02-design.md`. On [X]: STOP.

<HARD-GATE>
Do NOT create UIX-SPEC.md without first reading DESIGN.md completely (Architecture, components).
Do NOT invent Figma URLs or node-ids — only use what the user provides.
</HARD-GATE>

## SEQUENCE

### 1. Load inputs

- Read {designFile} completely (Architecture, components affected).
- Read {specFile} for ID and Name (metadata).

### 2. Gather Figma input

- Ask the user: "Do you have Figma file(s) for this spec? If yes, provide the file URL(s) and, for each DESIGN segment, the Figma link and optional node-id. If no Figma for this spec, say 'skip' or 'no' to skip this step."

### 2a. Fetch design context via local Figma MCP (when Figma is provided)

Apply **{ruleRef} -> "Figma Design Context (figma-to-code-mcp-os v2.0.0)"** in full. Summary:

1. **Prerequisite:** Local MCP server **`figma-to-code`** (v2.0.0+) is connected. Server requires `FIGMA_ACCESS_TOKEN` (Personal Access Token) and is reachable at the URL configured in the user's MCP client. If the server is missing or returns tool-not-found for `get_figma_node_spec`, HALT and report version mismatch.
2. **Cache check:** Before any tool call, check whether the target file already exists under `{spec_folder}/figma/`. If yes, **read from disk and skip the MCP call** — calling MCP for an already-saved artifact is a FAILURE CONDITION (the only exception is the § 2b fidelity loop in step 04, which is allowed to invalidate and re-fetch).
3. **Tool:** **`get_figma_file_structure(fileKey)`** -- always call first. Returns pages and top-level frames with `id` values; pick the `nodeId` for each DESIGN segment. (Not saved to disk; used only to resolve nodeIds.)
4. **Tool:** **`get_figma_design_tokens(fileKey, nodeId?)`** -- call once per file (or per top-level node). Save the response **as-is** to `{spec_folder}/figma/tokens.css`. This CSS `:root` block is the **only** allowed source of hex colors and font names for generated code.
5. **Tool:** **`get_figma_node_spec(fileKey, nodeId, maxDepth?)`** -- call per design segment. Returns token constraints header + canonical JSX tree (full prop set: `x y w h constraint-h/v layout sizing-h/v grow gap padding align-main/cross min/max bg radius border stroke-w opacity effects`) + flat geometry table + code-generation rules footer. Save **as-is** to `{spec_folder}/figma/<node-id>.md` where `<node-id>` uses **hyphens** (`123:456` -> `123-456.md`). Use `maxDepth` (default 12; reduce to 6–8 for small OS models on large frames).
6. **Tool (optional, multimodal/visual parity):** **`get_figma_frame_with_image(fileKey, nodeId, scale?)`** -- returns the same JSX spec plus a PNG download URL. Download the PNG and save to `{spec_folder}/figma/<node-id>.png`. The PNG is a **visual reference only**; the JSX numbers in the `.md` are the source of truth for all CSS values.
7. **Tool (optional, assets):** **`export_figma_assets(fileKey, nodeIds[], format)`** -- export icon/image assets (`"svg"` default, or `"png"`). Save downloaded files to `{spec_folder}/figma/assets/`.
8. **UIX-SPEC.md:** Reference every saved file (relative path, e.g. `./figma/123-456.md`, `./figma/tokens.css`, `./figma/assets/icon-foo.svg`) in the Design Context Artifacts table so **step 04** can locate layout references without guessing.

If MCP is unavailable (or `FIGMA_ACCESS_TOKEN` missing), skip 2a and note in UIX-SPEC **Open Questions** that design context is pending; do **not** fabricate file contents.

### 2b. Figma -> code fidelity loop (normative for step 04)

This section is **normative** for any agent or developer that implements UI from this spec's Figma mapping. The first implementation pass is always a **draft** -- never treat it as pixel-perfect. Do **not** wait for the user to say "check Figma again"; iterative re-checking is the default workflow.

> **Iteration bounds: minimum 2, maximum 5** compare-fix passes after the initial UI build.

#### Loop procedure (execute once per pass)

For each iteration **i** (where i = 1 ... 5):

**Step A -- Re-fetch Figma (cache invalidation allowed here).**
For every node listed in UIX-SPEC's Design Context Artifacts table:
1. Delete the cached `{spec_folder}/figma/<node-id>.md` (and `.png` if present) — the loop is the one place where re-fetch is mandatory.
2. Call **`get_figma_node_spec(fileKey, nodeId, maxDepth?)`** and re-save to `{spec_folder}/figma/<node-id>.md`.
3. Optionally call **`get_figma_frame_with_image`** and re-save the PNG to `{spec_folder}/figma/<node-id>.png` for visual parity.
4. If tokens may have changed, also re-fetch **`get_figma_design_tokens`** and overwrite `{spec_folder}/figma/tokens.css`.

This gives the agent a fresh structural + token view of the target design -- the same as a developer re-opening Figma to compare.

**Step B -- Build / update the drift list.**
Compare the current implementation against the re-fetched Figma data. Write (or update) a concrete **drift list** at `{spec_folder}/figma/drift-T<n>.md` (one file per UI task, e.g. `drift-T3.md`) with this structure:

```
---
task: T3
pass: 2
maxPasses: 5
status: open   # open | resolved | hard-stop
---

## Pass 2 drift

- [ ] Card body padding: implemented `16px`, Figma `24px` (node 12:34, prop `padding`)
- [x] Title font-weight: was 600, fixed to 700 in pass 1
- ...
```

Resolved items stay in the file (checked off) so reviewers can see what was fixed across passes. Categories to check (all of them, every pass):

- Spacing: padding, margin, gap (e.g. "card body padding is 16px, Figma shows 24px")
- Typography: font-family, size, weight, line-height, letter-spacing
- Colors: fills, strokes, opacity, gradients
- Corner radii, shadows, borders
- Alignment, flex direction, order
- Component / frame sizing and constraints (width, height, min/max)

**Step C -- Exit check.**
If all items in the drift file are checked `[x]` (zero open) **and** i >= 2, set frontmatter `status: resolved` and end the loop -- fidelity is achieved. Skip remaining passes. If i < 2, continue to Step D even if no open items remain (a second Figma re-fetch often catches things the first comparison missed).

**Step D -- Fix.**
Address every open item in `drift-T<n>.md`, largest visual impact first. After fixing each item, **check it off `[x]`** in place (do not delete) so the file shows the full history of fixes across passes.

**Step E -- Hard stop guard.**
If i = 5 and `drift-T<n>.md` still has unchecked items, **stop iterating**. Set frontmatter `status: hard-stop`. Append the remaining open drift items to UIX-SPEC **Open Questions** (or a `## Remaining Drift` section) so the reviewer or user can see what was not fully resolved. Do not silently drop unresolved items.

After Step D (or Step E on the final pass), increment i and return to Step A for the next pass.

#### Key rules

- The loop MUST run **at least 2** full passes. Even if pass 1 shows zero drift, pass 2 re-fetches Figma and re-checks -- this catches missed details.
- The loop MUST NOT exceed **5** passes. This prevents infinite refinement while still allowing enough iterations to reach pixel-level accuracy.
- The drift list is the agent's **explicit awareness** of what remains wrong. Without it, passes are vague "make it closer" attempts. Every pass must produce or update the drift list before fixing.

#### Where this loop runs

This loop executes inside **step 04 (Implementation)** during the implementation of any UI-related task that has Figma mapping in UIX-SPEC. Step 04 must read this section (section 2b) and follow the loop procedure above for each such task.

#### Handoff into UIX-SPEC

When saving `{outputFile}` with Figma in scope (section 3), add the following to the **Overview** paragraph (or as a bullet under **Open Questions**):

> "Implementation of UI tasks must follow step-02b-uix section 2b: minimum 2 / maximum 5 Figma compare-fix iterations with automatic MCP re-fetch and a drift list per pass. See `.framework/steps/step-02b-uix.md` section 2b for the full loop procedure."

This ensures that any agent reading only UIX-SPEC knows the iterative bar and where to find the full instructions.

### 3. Create or skip

- **If user provides Figma data (or wants a skeleton):** Apply {ruleRef} using {templateRef}. Save to `{outputFile}` with Status: DRAFT. If section 2a ran, ensure all design context artifacts live under `{figmaDir}` (`tokens.css`, per-node `.md`/`.png` files, `assets/*`) and that every saved file is linked from UIX-SPEC's Design Context Artifacts table with relative path `./figma/<filename>`. Apply the **section 2b handoff** sentence (Overview or Open Questions). Go to section 4.
- **If user skips (no Figma):** Update `{stateFile}`: append `'step-02b-uix'` to `stepsCompleted`. Set `uixSkipped: true` in frontmatter. Offer to commit: "Commit workflow state? [Y/n]" -- if yes: `git add {stateFile}` and commit with message `"spec({spec_id}): skip UIX spec (no Figma)"`. Auto-continue: load and follow `{nextStepFile}`. STOP (do not present approval menu).

### 4. Approval gate

- Present UIX-SPEC.md to the user.
- Ask: "Review the UIX-SPEC. Approve to continue to Task Breakdown, or tell me what to change."

### 5. Present MENU

Display:

```
UIX-SPEC.md is APPROVED.

[C] Continue -- proceed to Task Breakdown (Step 3 of 5)
[V] View DESIGN.md -- display for reference (read-only)
[B] Back to Design -- re-edit DESIGN.md (step 2)
[S] Skip UIX -- remove Figma mapping, continue without it
[X] Exit -- pause workflow; resume later with /flow
```

### Menu handling

- **IF user approves (during approval gate):**
  1. Update Status -> APPROVED.
  2. Update `{stateFile}`: append `'step-02b-uix'` to `stepsCompleted`.
  3. Set `uixSkipped: false` in `{stateFile}` frontmatter.
  4. Offer to commit: "Commit UIX-SPEC.md (and the entire `{spec_folder}/figma/` directory) to the current branch? [Y/n]" -- if yes: `git add {outputFile} {spec_folder}/figma/ {stateFile}` and commit with message `"spec({spec_id}): create UIX spec (Figma)"`.
  5. Present menu (section 5).
- **IF [C] Continue:**
  1. Read fully and follow: `{nextStepFile}` (step-03-tasks.md).
- **IF [V] View DESIGN.md:**
  1. Read and display {designFile}. Redisplay menu.
- **IF [B] Back to Design:**
  1. Trim `stepsCompleted` in `{stateFile}` to keep only entries up to and including `'step-01-spec'` (remove `'step-02-design'` and `'step-02b-uix'` if present).
  2. Clear `tasksCompleted` in `{stateFile}` (set to `[]`).
  3. Read fully and follow: `./step-02-design.md`.
- **IF [S] Skip UIX:**
  1. Delete or leave {outputFile} as-is (user may keep a skeleton).
  2. Update `{stateFile}`: append `'step-02b-uix'` to `stepsCompleted` (if not already present), set `uixSkipped: true`.
  3. Offer to commit state.
  4. Read fully and follow: `{nextStepFile}`.
- **IF [X] Exit:**
  1. Update `{stateFile}`: append `'step-02b-uix'` to `stepsCompleted` (if approved or skipping). Set `uixSkipped` accordingly.
  2. Display: "Workflow paused. Run `/flow {spec_id}` to resume."
  3. STOP.
- **IF anything else:** Answer, then redisplay menu.

## CRITICAL COMPLETION NOTE

ONLY when `{nextStepFile}` is loaded via an explicit user action -- [C] Continue, [S] Skip, or the auto-continue after a skip in section 3 -- will you proceed to the next step. Do NOT load `{nextStepFile}` without one of these triggers. State must be updated before loading.

---

## SUCCESS CRITERIA

- All domain and quality criteria per {ruleRef} are satisfied.
- UIX-SPEC.md created with correct Figma mappings, or step skipped cleanly.
- Design context artifacts (if any) saved with correct naming and referenced in UIX-SPEC.md.
- If Figma is in scope: **section 2b** fidelity loop (min 2 / max 5 passes, drift list, automatic Figma re-fetch) is **handed off** in UIX-SPEC (Overview or Open Questions) so implementation agents execute the loop without user prompting.
- Status APPROVED before continuing (unless skipping).
- State updated before loading next step (`uixSkipped` set correctly).

## FAILURE CONDITIONS

- Proceeding without satisfying gate (SPEC and DESIGN approved).
- Inventing Figma URLs or node-ids not provided by the user.
- Not updating state before loading next step.
- Loading next step before user selects [C] or [S].
- Fabricating design context file contents without calling the MCP tool.
- Implementation agent skipping the section 2b fidelity loop or running fewer than 2 Figma compare-fix passes for UI tasks with Figma mapping.
