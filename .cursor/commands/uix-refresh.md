# uix-refresh

Force-refresh the cached Figma snapshot for a spec. The **only** path that re-calls the `figma-to-code` MCP after the initial fetch in step-02b.

## Usage

`/uix-refresh {spec}` — e.g. `/uix-refresh 006` or `/uix-refresh @specs/006-user-export/UIX-SPEC.md`.

If no spec is provided, ask which spec to refresh.

## Preconditions

- `{spec_folder}/UIX-SPEC.md` must exist with at least one row in **Design Context Artifacts**.
- The local `figma-to-code` MCP server (v2.0.0+) must be connected and `FIGMA_ACCESS_TOKEN` set. If not, HALT and tell the user to start the server / set the token.

## Procedure

Apply `@.cursor/rules/uix-creation.mdc` § "Figma Design Context (figma-to-code-mcp-os v2.0.0)". Behavior:

1. **Confirm with the user:**
   "About to delete and re-fetch the following cached files for spec {spec_id}:
   - {list every file path from UIX-SPEC.md Design Context Artifacts table}

   Drift files (`figma/drift-T*.md`) will be **kept** (they are per-implementation-pass artifacts, not Figma data).

   Proceed? [Y/n]"

2. **On Y:**
   - For every artifact row in UIX-SPEC.md's **Design Context Artifacts** table, delete the file from disk.
   - Re-run the section 2a tool sequence from `@.framework/steps/step-02b-uix.md`:
     a. `get_figma_file_structure(fileKey)` — confirm node IDs are still valid; if any node is missing, surface as an Open Question in UIX-SPEC.md and continue with the rest.
     b. `get_figma_design_tokens` → re-save `figma/tokens.css`.
     c. `get_figma_node_spec` per node → re-save `figma/<node-id>.md`.
     d. `get_figma_frame_with_image` per node that previously had a `.png` → re-save `figma/<node-id>.png`.
     e. `export_figma_assets` per asset that previously existed under `figma/assets/` → re-save.
   - Update UIX-SPEC.md metadata `Date` field to today.
   - Offer to commit: "Commit refreshed Figma snapshot? [Y/n]" → `git add {spec_folder}/figma/ {spec_folder}/UIX-SPEC.md` with message `"spec({spec_id}): refresh Figma snapshot"`.

3. **On n:** STOP. No files touched.

## Constraints

- Do NOT delete `figma/drift-T*.md` files — those are implementation drift records, not Figma artifacts.
- Do NOT touch UIX-SPEC.md's mapping rows or Open Questions; only update the snapshot files and the `Date` field.
- Do NOT call MCP for any artifact NOT listed in UIX-SPEC.md's Design Context Artifacts table — refresh is scoped exactly to what UIX-SPEC declares.
- Do NOT modify `.workflow-state.md` — refresh does not change workflow position.

## After refresh

If the user is mid-flow, recommend:
- "Snapshot refreshed. If implementation has already started for any UI task, you may want to re-run those tasks against the new snapshot: in `/flow {spec_id}` go to step-04 and pick `[R] Re-implement` for the affected task(s)."
