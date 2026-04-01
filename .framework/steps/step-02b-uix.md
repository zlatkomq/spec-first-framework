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
uixContextPattern: '{spec_folder}/figma_context_*.md'
uixScreenshotPattern: '{spec_folder}/figma_screenshot_*.png'
---

# Step 2b: Create UIX Spec (Figma) — Optional

**Progress: Step 2b (optional) of 5** — Next: Task Breakdown

## STEP GOAL

Create (or update) UIX-SPEC.md by applying the uix-creation rules and template. Map DESIGN.md segments to Figma files and node IDs. When Figma is in scope, **fetch design context** via the official Figma MCP server **`figma`** (tool **`get_design_context`**) and save artifacts under the spec folder for **step 04 (implementation)** to use as layout reference. This step is optional: if this spec has no Figma, choose [S] Skip to continue to Task Breakdown.

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

### 2a. Fetch design context via official Figma MCP (when Figma is provided)

Apply **{ruleRef} → "Figma Design Context (Official Figma MCP)"** in full. Summary:

1. **Prerequisite:** Official Figma MCP server **`figma`** is connected (remote at `https://mcp.figma.com/mcp`). User must have authenticated via OAuth through their MCP client (e.g. Cursor). No local server or API token env var required.
2. **Tool:** **`get_design_context`**
   - Pass the user's Figma URL directly; the tool extracts `fileKey` and `node-id` automatically.
   - Prefer a **single root frame or component** per call to keep context bounded.
   - Returns a structured design representation (React + Tailwind by default; customizable via prompt).
3. **Tool (optional):** **`get_screenshot`** — capture a visual reference for each key frame/component.
4. **Tool (optional):** **`get_variable_defs`** — extract design tokens (colors, spacing, typography) when needed.
5. **Save:** Write the `get_design_context` result to `{spec_folder}/figma_context_<NODE_URL_FORM>.md` where `<NODE_URL_FORM>` uses **hyphens** (`0:1` → `figma_context_0-1.md`). For a **full-frame** pull with no specific node, use **`figma_context_full.md`**. Save screenshots (if any) as `{spec_folder}/figma_screenshot_<NODE_URL_FORM>.png`.
6. **UIX-SPEC.md:** Reference each saved file (relative path, e.g. `./figma_context_0-1.md`) in the Design Context Artifacts table so **step 04** can locate layout references without guessing.

If MCP is unavailable (or user hasn't authenticated), skip 2a and note in UIX-SPEC **Open Questions** that design context is pending; do **not** fabricate file contents.

### 3. Create or skip

- **If user provides Figma data (or wants a skeleton):** Apply {ruleRef} using {templateRef}. Save to `{outputFile}` with Status: DRAFT. If section 2a ran, ensure design context artifacts match `{uixContextPattern}` naming (and screenshots match `{uixScreenshotPattern}`) and are linked from UIX-SPEC. Go to section 4.
- **If user skips (no Figma):** Update `{stateFile}`: append `'step-02b-uix'` to `stepsCompleted`. Set `uixSkipped: true` in frontmatter. Offer to commit: "Commit workflow state? [Y/n]" — if yes: `git add {stateFile}` and commit with message `"spec({spec_id}): skip UIX spec (no Figma)"`. Auto-continue: load and follow `{nextStepFile}`. STOP (do not present approval menu).

### 4. Approval gate

- Present UIX-SPEC.md to the user.
- Ask: "Review the UIX-SPEC. Approve to continue to Task Breakdown, or tell me what to change."

### 5. Present MENU

Display:

```
UIX-SPEC.md is APPROVED.

[C] Continue — proceed to Task Breakdown (Step 3 of 5)
[V] View DESIGN.md — display for reference (read-only)
[B] Back to Design — re-edit DESIGN.md (step 2)
[S] Skip UIX — remove Figma mapping, continue without it
[X] Exit — pause workflow; resume later with /flow
```

### Menu handling

- **IF user approves (during approval gate):**
  1. Update Status → APPROVED.
  2. Update `{stateFile}`: append `'step-02b-uix'` to `stepsCompleted`.
  3. Set `uixSkipped: false` in `{stateFile}` frontmatter.
  4. Offer to commit: "Commit UIX-SPEC.md (and any `figma_context_*.md` / `figma_screenshot_*.png` files) to the current branch? [Y/n]" — if yes: `git add {outputFile} {spec_folder}/figma_context_*.md {spec_folder}/figma_screenshot_*.png {stateFile}` (shell glob as appropriate) and commit with message `"spec({spec_id}): create UIX spec (Figma)"`.
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

ONLY when `{nextStepFile}` is loaded via an explicit user action — [C] Continue, [S] Skip, or the auto-continue after a skip in section 3 — will you proceed to the next step. Do NOT load `{nextStepFile}` without one of these triggers. State must be updated before loading.

---

## SUCCESS CRITERIA

- All domain and quality criteria per {ruleRef} are satisfied.
- UIX-SPEC.md created with correct Figma mappings, or step skipped cleanly.
- Design context artifacts (if any) saved with correct naming and referenced in UIX-SPEC.md.
- Status APPROVED before continuing (unless skipping).
- State updated before loading next step (`uixSkipped` set correctly).

## FAILURE CONDITIONS

- Proceeding without satisfying gate (SPEC and DESIGN approved).
- Inventing Figma URLs or node-ids not provided by the user.
- Not updating state before loading next step.
- Loading next step before user selects [C] or [S].
- Fabricating design context file contents without calling the MCP tool.
