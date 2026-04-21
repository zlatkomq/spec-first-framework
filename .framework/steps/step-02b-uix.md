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

Create (or update) UIX-SPEC.md by applying the uix-creation rules and template. Map DESIGN.md segments to Figma files and node IDs. When Figma is in scope, **fetch design context once** via the local MCP server **`figma-to-code`** (v2.0.0+) and save all artifacts under `{spec_folder}/figma/`. Those saved files are then the **only** source of design context for step-04 (implementation) and step-05 (review) — no automatic re-fetch, no fidelity loop. To refresh stale artifacts, the user explicitly runs `/uix-refresh {spec}` (or picks `[F] Force refresh` in this step's menu). This step is optional: if this spec has no Figma, choose [S] Skip to continue to Task Breakdown.

## RULES

- READ this entire step file before taking any action.
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
2. **Cache check:** Before any tool call, check whether the target file already exists under `{spec_folder}/figma/`. If yes, **read from disk and skip the MCP call** — calling MCP for an already-saved artifact is a FAILURE CONDITION. The only path that may delete + re-fetch is `/uix-refresh` (or `[F] Force refresh` in this step's menu). No agent is permitted to re-fetch automatically.
3. **Tool:** **`get_figma_file_structure(fileKey)`** -- always call first. Returns pages and top-level frames with `id` values; pick the `nodeId` for each DESIGN segment. (Not saved to disk; used only to resolve nodeIds.)
4. **Tool:** **`get_figma_design_tokens(fileKey, nodeId?)`** -- call once per file (or per top-level node). Save the response **as-is** to `{spec_folder}/figma/tokens.css`. This CSS `:root` block is the **only** allowed source of hex colors and font names for generated code.
5. **Tool:** **`get_figma_node_spec(fileKey, nodeId, maxDepth?)`** -- call per design segment. Returns token constraints header + canonical JSX tree (full prop set: `x y w h constraint-h/v layout sizing-h/v grow gap padding align-main/cross min/max bg radius border stroke-w opacity effects`) + flat geometry table + code-generation rules footer. Save **as-is** to `{spec_folder}/figma/<node-id>.md` where `<node-id>` uses **hyphens** (`123:456` -> `123-456.md`). Use `maxDepth` (default 12; reduce to 6–8 for small OS models on large frames).
6. **Tool (optional, multimodal/visual parity):** **`get_figma_frame_with_image(fileKey, nodeId, scale?)`** -- returns the same JSX spec plus a PNG download URL. Download the PNG and save to `{spec_folder}/figma/<node-id>.png`. The PNG is a **visual reference only**; the JSX numbers in the `.md` are the source of truth for all CSS values.
7. **Tool (optional, assets):** **`export_figma_assets(fileKey, nodeIds[], format)`** -- export icon/image assets (`"svg"` default, or `"png"`). Save downloaded files to `{spec_folder}/figma/assets/`.
8. **UIX-SPEC.md:** Reference every saved file (relative path, e.g. `./figma/123-456.md`, `./figma/tokens.css`, `./figma/assets/icon-foo.svg`) in the Design Context Artifacts table so **step 04** can locate layout references without guessing.

If MCP is unavailable (or `FIGMA_ACCESS_TOKEN` missing), skip 2a and note in UIX-SPEC **Open Questions** that design context is pending; do **not** fabricate file contents.

### 2b. Cached snapshot policy (normative for step 04 and step 05)

This section is **normative** for every agent or developer that consumes UIX-SPEC artifacts.

> **One fetch per artifact, ever, until an explicit `/uix-refresh`.** No automatic re-fetch, no compare-fix loop, no iteration.

#### Rules

1. **Step-02b owns all MCP calls.** The only place an agent may call `figma-to-code` MCP tools is during section 2a of this step (initial fetch) or during a `/uix-refresh` invocation. Step-04 and step-05 never call the MCP — they read from `{spec_folder}/figma/` only.
2. **File on disk is authoritative.** If `{spec_folder}/figma/<node-id>.md` or `tokens.css` exists, downstream agents treat it as the current truth. Mismatches between the saved snapshot and live Figma are the user's responsibility to resolve via `/uix-refresh`.
3. **No re-fetch from any agent.** If an agent sees drift while implementing or reviewing, it does **not** call MCP. It records the drift in `{spec_folder}/figma/drift-T<n>.md` (see "Drift artifact" below) and continues the single pass. Re-fetch is a human decision.
4. **Refresh path.** The user runs `/uix-refresh {spec}` (or selects `[F] Force refresh Figma artifacts` in this step's menu). That command deletes the cached files listed in UIX-SPEC's Design Context Artifacts table and re-fetches them via the section 2a tool sequence. Nothing else may delete cached files.

#### Drift artifact (one-shot, write-only, no loop)

When step-04 implements a UI task and notices visible mismatches against the cached `figma/<node-id>.md`, the agent writes a single drift file at `{spec_folder}/figma/drift-T<n>.md`:

```
---
task: T3
generatedAt: 2026-04-21T13:42:00Z
nodeIds: ["12:34", "12:36"]
status: noted   # noted | acknowledged | refresh-requested
---

## Drift noted during implementation

- [ ] Card body padding: implemented `16px`, cached Figma snapshot shows `24px` (node 12:34, prop `padding`)
- [ ] Title font-weight: implemented `600`, cached snapshot shows `700` (node 12:35)
```

This file is **write-once per task**. The agent does NOT loop, does NOT call MCP to re-verify, does NOT auto-fix items in repeated passes. Drift items are surfaced to step-05 (review), which decides whether they become `[AI-Review]` action-item tasks or trigger a `/uix-refresh` recommendation.

#### Handoff into UIX-SPEC

When saving `{outputFile}` with Figma in scope (section 3), add the following to the **Overview** paragraph:

> "Figma artifacts in `./figma/` are a frozen snapshot fetched once. Implementation reads them as-is; reviewers compare against them. To refresh after a Figma update, run `/uix-refresh {spec_id}`."

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
[F] Force refresh Figma artifacts -- delete cached files in figma/ and re-fetch via MCP (only path that re-calls MCP)
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
- **IF [F] Force refresh Figma artifacts:**
  1. Confirm: "This will delete every file under {figmaDir} that is listed in UIX-SPEC's Design Context Artifacts table and re-fetch each via MCP. Proceed? [Y/n]"
  2. On Y: for every artifact row in UIX-SPEC.md, delete the corresponding file (`tokens.css`, `<node-id>.md`, `<node-id>.png`, `assets/<name>.<ext>`). Then re-run section 2a tool sequence to re-fetch and save them.
  3. Do NOT touch `figma/drift-T<n>.md` files — drift is per-implementation-pass and is not a Figma artifact.
  4. Redisplay this menu.
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
- If Figma is in scope: section 2b cached snapshot policy is handed off in UIX-SPEC's Overview, naming `/uix-refresh` as the only refresh path.
- Status APPROVED before continuing (unless skipping).
- State updated before loading next step (`uixSkipped` set correctly).

## FAILURE CONDITIONS

- Proceeding without satisfying gate (SPEC and DESIGN approved).
- Inventing Figma URLs or node-ids not provided by the user.
- Not updating state before loading next step.
- Loading next step before user selects [C] or [S].
- Fabricating design context file contents without calling the MCP tool.
- Calling any `figma-to-code` MCP tool from outside section 2a or `/uix-refresh` (no automatic re-fetch, no fidelity loop, no compare-and-re-call from any agent).
- Re-fetching a cached file in `figma/` without an explicit user-initiated `/uix-refresh` or `[F] Force refresh`.
