# UIX Spec (Figma)

## Metadata

| Field | Value |
|-------|-------|
| ID | XXX |
| Name | |
| Status | DRAFT / APPROVED |
| Author | |
| Reviewer | |
| Date | |
| Approved By | |
| Approval Date | |
| Jira Ticket | |

---

## Overview

[1–2 sentences: This spec's UI is defined in Figma. This document maps DESIGN.md segments to Figma files and nodes, and references the cached design context under `./figma/` (fetched once in step-02b via the `figma-to-code` MCP). Downstream steps (04 implement, 05 review) read these files from disk and never re-call the MCP. Re-fetching is allowed only via the explicit `/uix-refresh` command.]

---

## Figma Files

[List of Figma files used for this spec. One row per file.]

| File | URL | Description |
|------|-----|-------------|
| | | |

---

## Design Segment → Figma Mapping

[Map each DESIGN.md component/screen to a Figma link. Use Node ID for deep links when available.]

| Design Segment | Figma File | Node ID (optional) | Figma Link | Notes |
|----------------|------------|---------------------|------------|-------|
| | | | | |
| | | | | |

- **Design Segment**: Component or screen name from DESIGN.md (e.g. Architecture table, section).
- **Figma File**: Short name or key from Figma Files table.
- **Node ID**: Figma node-id for deep link (e.g. `123:456` or `123-456`); leave empty if linking to file only.
- **Figma Link**: Full URL (with `?node-id=...` when Node ID is set).
- **Notes**: Optional (e.g. "Mobile variant", "Desktop only", "No Figma yet").

---

## Design Context Artifacts

[Cached files saved by the `figma-to-code` MCP under `./figma/`. Single source of truth for downstream steps. Do not edit by hand — refresh via `/uix-refresh`.]

| Artifact | Spec File | Source Tool | Description |
|----------|-----------|-------------|-------------|
| `./figma/tokens.css` | (file-level) | `get_figma_design_tokens` | CSS `:root` block — only allowed source of hex colors and font names. |
| `./figma/<node-id>.md` | (per design segment) | `get_figma_node_spec` | Token constraints header + canonical JSX prop tree + flat geometry table. |
| `./figma/<node-id>.png` | (optional, per segment) | `get_figma_frame_with_image` | Visual reference only; numbers come from the `.md`. |
| `./figma/assets/<file>` | (optional) | `export_figma_assets` | Exported icons / images. |

> Drift artifacts: step-04 may write `./figma/drift-T<n>.md` (one per UI task) recording observed mismatches against this snapshot. Drift files are kept across `/uix-refresh`.

---

## Open Questions

- [ ]
