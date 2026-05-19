# uix-refresh

Force-refresh the cached Figma snapshot for a spec. The **only** path that re-calls the `figma-to-code` MCP after the initial fetch in step-02b.

## Usage

`/uix-refresh {spec}` — e.g. `/uix-refresh 006` or `/uix-refresh @specs/006-user-export/UIX-SPEC.md`.

If no spec is provided, ask which spec to refresh.

## Preconditions

- `{spec_folder}/UIX-SPEC.md` must exist with at least one row in **Design Context Artifacts**.
- The team `figma-to-code` MCP server (v2.0.0+) must be reachable from your editor (you must be on the **VPN**, and `~/.cursor/mcp.json` must point at the server URL). The Figma access token is configured server-side — developers do NOT manage it locally. If the server is unreachable, HALT and tell the user to check VPN / MCP config.

## Procedure

Apply `@skills/uix-creation/SKILL.md` § "Figma design context (MCP `figma-to-code` v2.0.0+)". Behavior:

1. **Confirm with the user:**

   "About to delete and re-fetch the following cached files for spec `{spec_id}`:
   - {list every file path from UIX-SPEC.md Design Context Artifacts table}

   Drift files (`figma/drift-T*.md`) will be **kept** (they are per-implementation-pass artifacts, not Figma data).

   Proceed? [Y/n]"

2. **On Y:**
   - For every artifact row in UIX-SPEC.md's **Design Context Artifacts** table, delete the file from disk.
   - Re-run the section 2a tool sequence from `@.framework/steps/step-02b-uix.md`:
     1. `get_figma_file_structure(fileKey)` — confirm node IDs are still valid; if any node is missing, surface as an Open Question in UIX-SPEC.md and continue with the rest.
     2. `get_figma_design_tokens(fileKey)` → re-save `figma/tokens.css`.
     3. `get_figma_node_spec(fileKey, nodeId)` per node → re-save `figma/<node-id>.md`.
     4. `get_figma_frame_with_image(fileKey, nodeId)` per node that previously had a `.png` → re-save `figma/<node-id>.png`.
     5. `export_figma_assets(fileKey, nodeIds, format)` per asset that previously existed under `figma/assets/` → re-save.
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
