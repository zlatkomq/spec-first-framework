---
name: 'step-02b-uix'
description: 'Create or update UIX-SPEC.md (Figma mapping) for this feature'
nextStepFile: './step-03-tasks.md'

# References
ruleRef: '@skills/uix-creation/SKILL.md'
templateRef: '@.framework/templates/UIX-SPEC.template.md'
stateFile: '{spec_folder}/.workflow-state.md'
specFile: '{spec_folder}/SPEC.md'
designFile: '{spec_folder}/DESIGN.md'
outputFile: '{spec_folder}/UIX-SPEC.md'
figmaDir: '{spec_folder}/figma'
---

# Step 3: Create UIX Spec (Figma)

**Progress: Step 3 of 6** — Next: Task Breakdown

## STEP GOAL

Create (or update) UIX-SPEC.md by applying the uix-creation rules and template. Map DESIGN.md segments to Figma files and node IDs. When Figma is in scope, **fetch design context once** via the local MCP server **`figma-to-code`** (v2.0.0+) using granular tools (`get_figma_file_structure`, `get_figma_design_tokens`, `get_figma_node_spec`, optionally `get_figma_frame_with_image`, `export_figma_assets`). Save every response to `{figmaDir}/` — these on-disk files become the **single source of truth** for downstream steps. **No automatic re-fetch, no fidelity loop.** Re-fetch is allowed only via the explicit `/uix-refresh` command (or this step's `[F] Force refresh` menu). This step is optional: if this spec has no Figma, choose [S] Skip to continue to Task Breakdown.

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

### 2a. Fetch design context via MCP `figma-to-code` v2.0.0+ (when Figma is provided)

Apply **{ruleRef} → "Figma design context (MCP `figma-to-code` v2.0.0+)"** in full. Summary:

1. **Prerequisite:** Team MCP server **`figma-to-code`** v2.0.0+ is reachable from your editor (Cursor / Claude / OpenCode MCP). The `FIGMA_ACCESS_TOKEN` lives on the **server** (rack `docker-compose.yml`) — developers do **not** configure a token locally; just be on the **VPN** and have `~/.cursor/mcp.json` (or equivalent) pointing at the server URL. If the server is unreachable (e.g. off VPN, server down) → skip 2a and note in UIX-SPEC **Open Questions**; do NOT fabricate.
2. **Cache check:** Before any tool call, check `{figmaDir}/` for the target file. If it exists, **read from disk and skip the MCP call**. Calling MCP for an already-saved artifact is a FAILURE CONDITION. The only path that may delete + re-fetch is `/uix-refresh` (or `[F] Force refresh` in this step's menu). No agent is permitted to re-fetch automatically.
3. **Tool sequence (only for files NOT yet on disk):**
   1. **`get_figma_file_structure(fileKey)`** — resolve nodeIds for each DESIGN segment. Not saved.
   2. **`get_figma_design_tokens(fileKey)`** → save response **as-is** to `{figmaDir}/tokens.css`.
   3. **`get_figma_node_spec(fileKey, nodeId, maxDepth?)`** per design segment → save **as-is** to `{figmaDir}/<node-id>.md` (hyphen form: `123:456` → `123-456.md`).
   4. **`get_figma_frame_with_image(fileKey, nodeId)`** (optional, visual parity) → download PNG to `{figmaDir}/<node-id>.png`.
   5. **`export_figma_assets(fileKey, nodeIds[], format)`** (optional) → save assets to `{figmaDir}/assets/`.
4. **UIX-SPEC.md:** Add every saved file as a row in the **Design Context Artifacts** table with its relative path (`./figma/<filename>`).

### 2b. Cached snapshot policy (no fidelity loop)

The `{figmaDir}/` files saved in 2a are the **definitive design context** for the rest of the workflow. **Step 04 and step 05 read from `{figmaDir}/` only — they do NOT call the MCP under any circumstances.**

- **One fetch per artifact, ever**, until an explicit `/uix-refresh`.
- **No automatic re-fetch, no compare-fix loop, no fidelity passes.**
- Step 04 may write a one-shot drift file at `{figmaDir}/drift-T<n>.md` when it observes mismatches between implementation and the cached snapshot — that file is informational input for step 05; it does NOT trigger re-fetching.
- If, after step 04 starts, the user wants to refresh design data: they must explicitly run `/uix-refresh {spec_id}`, which re-runs section 2a's tool sequence after deleting the listed cached files.

### 3. Create or skip

- **If user provides Figma data (or wants a skeleton):** Apply {ruleRef} using {templateRef}. Save to `{outputFile}` with Status: DRAFT. If section 2a ran, ensure all artifacts live under `{figmaDir}/` and are listed in UIX-SPEC's **Design Context Artifacts** table. Go to section 4.
- **If user skips (no Figma):** Update `{stateFile}`: append `'step-02b-uix'` to `stepsCompleted`. Set `uixSkipped: true` in frontmatter. Offer to commit: "Commit workflow state? [Y/n]" — if yes: `git add {stateFile}` and commit with message `"spec({spec_id}): skip UIX spec (no Figma)"`. Auto-continue: load and follow `{nextStepFile}`. STOP (do not present approval menu).

### 4. Approval gate

- Present UIX-SPEC.md to the user.
- Ask: "Review the UIX-SPEC. Approve to continue to Task Breakdown, or tell me what to change. (Say [V] to view DESIGN.md, [B] to go back to Design, [F] to force-refresh Figma artifacts, [S] to skip UIX (no Figma), or [X] to exit.)"
- If user requests changes: apply, re-save, re-present. Loop until approved or skip.
- If user approves: update Status → APPROVED. Update `{stateFile}`: append `'step-02b-uix'` to `stepsCompleted` (early save). Offer to commit: "Commit UIX-SPEC.md (and the `figma/` directory) to the current branch? [Y/n]" — if yes: `git add {outputFile} {figmaDir}/ {stateFile}` and commit with message `"spec({spec_id}): create UIX spec (Figma)"`. Auto-continue: load and follow `{nextStepFile}`.
- **[V]:** Display {designFile}. Re-ask.
- **[B]:** Trim `stepsCompleted` in `{stateFile}` to keep only up to `'step-02-design'`. Load `./step-02-design.md`.
- **[F] Force refresh Figma artifacts:** Confirm with the user the list of files in `{figmaDir}/` to be deleted (preserve any `drift-T*.md` files). On Y, delete each artifact listed in UIX-SPEC's Design Context Artifacts table and re-run section 2a's tool sequence. Update UIX-SPEC `Date` field. Re-present.
- **[S]:** Delete or leave {outputFile} as-is (user may keep a skeleton). Update `{stateFile}`: append `'step-02b-uix'` to `stepsCompleted`, set `uixSkipped: true`. Offer to commit state. Auto-continue: load and follow `{nextStepFile}`.
- **[X]:** Update `{stateFile}`: append `'step-02b-uix'` to `stepsCompleted` (if approved). Display: "Workflow paused. Run `/flow {spec_id}` to resume." STOP.
- **Anything else:** Answer, then re-ask.

## FAILURE CONDITIONS

- Calling any `figma-to-code` MCP tool for an artifact already saved on disk in `{figmaDir}/` (outside of `[F]` / `/uix-refresh`).
- Saving Figma artifacts outside of `{figmaDir}/`.
- Implementing any "compare and re-fetch" or "fidelity loop" behavior in this or any downstream step.
- Fabricating Figma file contents when MCP is unavailable.
