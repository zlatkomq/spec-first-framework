# UIX Creation

## Description

Use when creating a UIX-SPEC.md document that maps DESIGN.md segments to Figma files and node IDs.
Not for specs where DESIGN.md is not yet APPROVED — STOP and inform the user. Not for technical design — use the design-creation skill.

## Instructions

You are creating a UIX Spec (Figma) document. Follow these rules strictly.

### No implementation substitution rule (CRITICAL)

The agent MUST implement the UI exactly as defined by the Figma node structure and layout properties.

The agent MUST NOT replace the defined layout with any abstraction, component, or implementation pattern that is not explicitly present in the Figma node tree.

This includes, but is not limited to:
- introducing new structural elements
- wrapping content into reusable components not defined in Figma
- altering layout behavior (e.g. scroll, alignment, distribution)
- simplifying or reinterpreting the structure

If Figma defines layout via explicit properties (layout direction, gap, sizing, constraints), the implementation MUST directly reflect those properties.

### Required Inputs

Before creating a UIX-SPEC.md, you must have:
- Approved SPEC.md (load `specs/XXX/SPEC.md`)
- Approved DESIGN.md (load `specs/XXX/DESIGN.md`)
- Access to `../../.framework/templates/UIX-SPEC.template.md`

If SPEC.md or DESIGN.md is not approved (Status != APPROVED), STOP and inform the user.

### Template

Always use the template structure from `../../.framework/templates/UIX-SPEC.template.md`

### Field Rules

#### Metadata
- **ID**: Must match the SPEC.md and DESIGN.md ID exactly
- **Name**: Must match the SPEC.md and DESIGN.md Name exactly
- Status is always DRAFT until Tech Lead approves
- Author: designer or developer name + "/ AI-assisted"
- Reviewer: leave blank (Tech Lead or Designer fills this)
- Date: today's date

#### Overview
- 1–2 sentences: This spec's UI is defined in Figma; this document maps DESIGN.md segments to Figma files and nodes for implementation and review.

#### Figma Files
- One row per Figma file used for this spec
- **File**: Short name or key (e.g. "Consumer App – Front Page", "Design System")
- **URL**: Full Figma file URL (e.g. `https://www.figma.com/design/...` or `https://www.figma.com/file/...`)
- **Description**: Optional brief description (e.g. "Main consumer screens", "Shared components")

#### Design Segment → Figma Mapping
- **Design Segment**: Taken from DESIGN.md — use the Architecture "Components affected" table (Component column) and/or logical UI segments (screens, flows). One row per segment that has or will have a Figma counterpart.
- **Figma File**: Short name from the Figma Files table above
- **Node ID**: Figma node-id for deep link (e.g. `123:456` or `123-456`). Leave empty if linking to file or page only. Format in link as `?node-id=123-456` (Figma uses hyphen in URLs).
- **Figma Link**: Full URL. If Node ID is set, append `?node-id=XXX` (use hyphen: `123-456`).
- **Notes**: Optional (e.g. "Mobile variant", "Desktop only", "Placeholder – no frame yet")

Build the mapping by:
1. Reading DESIGN.md Architecture section and listing each component/screen that has UI.
2. Asking the user for Figma file URL(s) and, for each segment, the link and optional node-id (or "no Figma" for that segment).
3. Populating the table. If user provides no Figma at all, create a skeleton with Design Segment filled from DESIGN.md and Figma columns empty or "—"; add an Open Question that Figma links are pending.

### Constraints

- Do NOT invent Figma URLs or node-ids — only use what the user (or existing UIX-SPEC.md) provides.
- Do NOT add design segments that do not appear in DESIGN.md.
- All bracket placeholders from template must be removed from output; if info is missing, add an Open Question.

### Figma design context (MCP `figma-to-code` v2.0.0+)

When capturing machine-readable layout for **implementation handoff**, use the **team MCP server** named `figma-to-code` (v2.0.0+, OS-model optimised — `figma-to-code-mcp-os`), self-hosted on the rack. The `FIGMA_ACCESS_TOKEN` is configured **on the server** (rack `docker-compose.yml`); developers do NOT need a local token — they just need to be on the **VPN** and have `~/.cursor/mcp.json` (or equivalent) pointing at the server URL.

#### CACHE POLICY — fetch once, never re-fetch (no exceptions, no loops)

The MCP server is treated as a **last-resort fetcher**. Local files in `specs/XXX-{slug}/figma/` are the **single source of truth** for all subsequent reads, including by step-04 implementation and step-05 review.

**Three rules. No exceptions.**

1. **Fetch once → save to disk.** Every successful MCP tool response MUST be saved as a file under `specs/XXX-{slug}/figma/`. The save is part of the call — never call without saving.
2. **File on disk → never re-fetch.** Before any MCP tool call, check whether the target file already exists. If it does, **read from disk and DO NOT call the MCP**. Cached files are read for coding/review purposes; they are never invalidated by an agent.
3. **Re-fetch only on explicit user request.** The only path that may delete + re-fetch a cached artifact is the `/uix-refresh` command (or the `[F] Force refresh` menu option in step-02b). No automatic re-fetch, no re-looping logic, ever.

| Artifact | MCP Tool | Cache rule |
|----------|----------|------------|
| `figma/tokens.css` | `get_figma_design_tokens` | File exists → read it. Never re-fetch except via `/uix-refresh`. |
| `figma/<node-id>.md` | `get_figma_node_spec` | File exists → read it. Never re-fetch except via `/uix-refresh`. |
| `figma/<node-id>.png` | `get_figma_frame_with_image` | File exists → read it. Never re-fetch except via `/uix-refresh`. |
| `figma/assets/<name>.<ext>` | `export_figma_assets` | File exists → read it. Never re-fetch except via `/uix-refresh`. |

Calling the MCP for an artifact already saved on disk — outside of an explicit `/uix-refresh` invocation — is a **FAILURE CONDITION** reported in REVIEW.md.

#### Tool call sequence (initial fetch in step-02b, or `/uix-refresh`)

1. **`get_figma_file_structure(fileKey)`** — always first. Returns pages and top-level frames with `id` values. Pick the `nodeId` for each DESIGN segment. Not saved to disk; used only to resolve nodeIds.
2. **`get_figma_design_tokens(fileKey, nodeId?)`** — call once per file. Save response **as-is** to `specs/XXX-{slug}/figma/tokens.css`. This CSS `:root` block is the **only** allowed source of hex colors and font names for generated code.
3. **`get_figma_node_spec(fileKey, nodeId, maxDepth?)`** — call per design segment. Returns token constraints header + canonical JSX tree (full prop set: `x y w h constraint-h/v layout sizing-h/v grow gap padding align-main/cross min/max bg radius border stroke-w opacity effects`) + flat geometry table + code-generation rules footer. Save **as-is** to `specs/XXX-{slug}/figma/<node-id>.md` where `<node-id>` uses **hyphens** (`123:456` → `123-456.md`). `maxDepth` default 12; reduce to 6–8 for small OS models on large frames.
4. **`get_figma_frame_with_image(fileKey, nodeId, scale?)`** — optional, multimodal/visual parity. Returns the same JSX spec plus a PNG download URL. Download the PNG and save to `specs/XXX-{slug}/figma/<node-id>.png`. The PNG is a **visual reference only**; the JSX numbers in the `.md` are the source of truth for all CSS values.
5. **`export_figma_assets(fileKey, nodeIds[], format)`** — optional. Export icon/image assets (`"svg"` default, or `"png"`). Save downloaded files to `specs/XXX-{slug}/figma/assets/`.

#### SVG export rule — `svg_ex_` nodes (CRITICAL)

Any Figma node whose name starts with **`svg_ex_`** MUST be exported and saved as a standalone `.svg` file. This is a built-in behaviour of the `figma-to-code` MCP server — it automatically identifies and exports these nodes.

Rules:

- When `get_figma_node_spec` or `get_figma_file_structure` returns a node whose name begins with `svg_ex_`, the agent MUST call `export_figma_assets` for that node with `format = "svg"` (if not already cached).
- The resulting `.svg` file MUST be saved to `specs/XXX-{slug}/figma/assets/<node-name>.svg` (use the node's original name as the filename, replacing any unsupported characters with `-`).
- The cached `.svg` file is then the **only** allowed source for that graphic in any generated code or spec — the agent MUST reference it by its relative path (e.g. `./figma/assets/svg_ex_logo.svg`) and MUST NOT inline the SVG markup or substitute a placeholder.
- Cache policy applies identically: if the `.svg` file already exists on disk, read from disk and DO NOT call the MCP again.

#### Drift artifact (one-shot, write-only, no loop)

When step-04 implements a UI task and notices visible mismatches against the cached `figma/<node-id>.md`, the agent writes a single drift file at `specs/XXX-{slug}/figma/drift-T<n>.md`:

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

This file is **write-once per task**. The agent does NOT loop, does NOT call MCP to re-verify, does NOT auto-fix items in repeated passes. Drift items are surfaced to step-05 (review).

#### Saving and referencing

- Create the `figma/` directory at the spec folder root before saving any files.
- Add each saved file to the **Design Context Artifacts** table in UIX-SPEC.md with its relative path (`./figma/<filename>`).
- Do NOT save figma artifacts outside of `specs/XXX-{slug}/figma/`.
- Do NOT fabricate file contents — only save actual MCP tool responses.

If MCP is unreachable (off VPN, server down, `mcp.json` not configured), note in **Open Questions** that design context is pending. Do NOT fabricate file contents.

### Constraints (additions)

- Do NOT call any `figma-to-code` MCP tool for an artifact already saved on disk in `figma/` — read from cache.
- Do NOT re-fetch, re-call, or re-loop any MCP tool automatically. Re-fetch is permitted only via the explicit `/uix-refresh` command.
- Do NOT implement any "compare and re-fetch" or "fidelity loop" behavior — there is no automatic Figma re-fetch in any step.
- All figma artifacts MUST live under `specs/XXX-{slug}/figma/` — never at the spec folder root.

### Output

Save the file to: `specs/XXX-{slug}/UIX-SPEC.md`

Must be in the same folder as the corresponding SPEC.md and DESIGN.md.

### Component reconstruction rule (CRITICAL)

The agent MUST NOT infer, reinterpret, or introduce higher-level UI structures.

The UI MUST be reconstructed strictly from the Figma node tree.

Rules:

- Every rendered element MUST correspond to a node in `figma/<node-id>.md`
- The structure (nesting and hierarchy) MUST match the node tree exactly
- Layout MUST be derived only from explicit node properties:
  - layout direction
  - gap
  - padding
  - sizing
  - constraints

The agent MUST NOT:
- introduce structural abstractions not present in the node tree
- modify hierarchy (merge, split, reorder nodes)
- reinterpret layout into a different structure

Any structural deviation from the node tree is considered incorrect.

### Layout priority rule (CRITICAL)

The agent MUST derive layout ONLY from `figma/<node-id>.md`.

The PNG is used ONLY for visual verification.

Layout behavior (scrolling, direction, spacing) MUST NOT be inferred from visuals.

## Verification

- [ ] ID and Name match SPEC.md and DESIGN.md
- [ ] Every row in Design Segment → Figma Mapping corresponds to a component or UI segment from DESIGN.md
- [ ] Figma Files table lists each distinct file referenced in the mapping
- [ ] Node IDs, when present, are reflected in Figma Link (e.g. `?node-id=123-456`)
- [ ] Status set to DRAFT
- [ ] If MCP was used: `figma/` directory created with `tokens.css` and per-node `<node-id>.md` files; each artifact referenced in UIX-SPEC.md Design Context Artifacts table with relative path `./figma/<filename>`
- [ ] No artifact saved outside of `figma/`
- [ ] No MCP tool called for any file already on disk (cache rule)
- [ ] Every node whose name starts with `svg_ex_` has a corresponding `.svg` saved in `figma/assets/` and is referenced by its relative path in generated code/spec — never inlined or substituted