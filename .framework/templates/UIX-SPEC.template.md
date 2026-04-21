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

[1–2 sentences: This spec's UI is defined in Figma. This document maps DESIGN.md segments to Figma files and nodes for implementation and review.]

[When Figma is in scope, append the cached-snapshot handoff sentence, e.g.:
"Figma artifacts in `./figma/` are a frozen snapshot fetched once via the local `figma-to-code` MCP. Step-04 implementation and step-05 review read them as-is and never re-fetch. Tokens in `./figma/tokens.css` are the only allowed source of hex codes and font names. To refresh after a Figma update, run `/uix-refresh XXX`. Drift noticed during implementation is recorded once-per-task in `./figma/drift-T<n>.md` and handled by step-05."]

---

## Figma Files

[List of Figma files used for this spec. One row per file.]

| File | URL | Description |
|------|-----|-------------|
| | | |

---

## Design Segment → Figma Mapping

[Map each DESIGN.md component/screen to a Figma link. Use Node ID for deep links when available. The `Spec File` column points to the saved `./figma/<node-id>.md` artifact when fetched via MCP.]

| Design Segment | Figma File | Node ID | Figma Link | Spec File | Notes |
|----------------|------------|---------|------------|-----------|-------|
| | | | | | |
| | | | | | |

- **Design Segment**: Component or screen name from DESIGN.md (e.g. Architecture table, section).
- **Figma File**: Short name or key from Figma Files table.
- **Node ID**: Figma node-id for deep link (e.g. `123:456` or `123-456`); leave empty if linking to file only.
- **Figma Link**: Full URL (with `?node-id=...` when Node ID is set).
- **Notes**: Optional (e.g. "Mobile variant", "Desktop only", "No Figma yet").

---

## Design Context Artifacts

[All Figma artifacts live under `./figma/` (never at the spec folder root). Populated by step-02b-uix when the local `figma-to-code` MCP server is connected. Types: `tokens` (single `tokens.css`), `context` (per-node JSX + geometry `.md`), `screenshot` (per-node `.png`), `asset` (SVG/PNG in `./figma/assets/`).]

| Artifact File | Type | Node ID | Description |
|---------------|------|---------|-------------|
| `./figma/tokens.css` | tokens | — | CSS `:root` color variables + font families (source of truth) |
| `./figma/<node-id>.md` | context | | Full spec: token constraints + JSX tree + geometry table + code rules |
| `./figma/<node-id>.png` | screenshot | | Visual reference only (JSX numbers are source of truth) |
| `./figma/assets/<name>.svg` | asset | | Exported icon/image |

---

## Open Questions

- [ ]
