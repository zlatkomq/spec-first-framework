# Technical Overview: Injecting Figma → UIX/UI-SPEC.md into the Spec-First Framework

**Purpose:** Propose how to add a process that produces a **UIX/UI-SPEC.md** file from Figma, *after* SPEC.md and DESIGN.md exist, with Figma file references per design segment. This document is for analysis and high-level direction before implementation.

---

## 1. How the Framework Works (Summary)

### 1.1 Artifact pipeline

The feature workflow is a **linear gate chain**:

```
CONSTITUTION (once)
    → SPEC.md        (Gate 1: PO approves)     — WHAT to build
    → DESIGN.md      (Gate 2: Tech Lead)     — HOW to build it
    → TASKS.md       (Gate 3: Tech Lead)     — Implementation breakdown
    → Implementation (Step 4)
    → Review         (Gate 4)                → Done
```

- **Step files** live in `.framework/steps/` (`step-01-spec.md` … `step-05-review.md`).
- **State** is in `specs/XXX-{slug}/.workflow-state.md`: `stepsCompleted` is a contiguous list (`step-01-spec`, `step-02-design`, …).
- **Next step** is determined by the *last* completed step’s `nextStepFile` in frontmatter.
- **Resume** is handled by `step-00-continue.md`, which validates `stepsCompleted` and offers [C] Continue / [B] Back / [X] Exit.

### 1.2 Design’s role

- **DESIGN.md** is created by `skills/design-creation/SKILL.md` from `.framework/templates/DESIGN.template.md`.
- It has: Metadata, Overview, **Architecture** (components table + optional Mermaid), conditional sections (Data Model, API, Dependencies, Security, Risks), **Acceptance Criteria Traceability**, Open Questions.
- **“Design segments”** in your question map naturally to:
  - **Architecture → Components** (rows in the “Components affected” table)
  - **Sections** of DESIGN.md (Overview, Architecture, Data Model, etc.)
- **TASKS.md** explicitly references DESIGN.md: each task has `(DESIGN: [section/component])` and traceability to SPEC acceptance criteria.

### 1.3 Key files to touch for any new step

| Concern | Location |
|--------|----------|
| New step definition | `.framework/steps/step-0X-{name}.md` |
| Step order / resume | `step-00-continue.md` (canonical list, back-step trim rules) |
| Flow entry / next step | `step-02-design.md` (or previous step) `nextStepFile` |
| New artifact template | `.framework/templates/{NAME}.template.md` |
| New skill (how to create artifact) | `skills/{name}/SKILL.md` |
| Command to run standalone | `.cursor/commands/{command}.md` |
| Workflow state | `workflow-state.template.md` (if new state fields needed) |
| Validation | `.cursor/commands/validate.md` (steps count, templates, skills) |

---

## 2. What “Figma + UIX/UI-SPEC.md” Is Intended to Be

From your description:

- **When:** After SPEC.md and DESIGN.md are created (and presumably approved).
- **What:** A **UIX/UI-SPEC.md** (or **UI-SPEC.md**) file.
- **Content:** Links to **Figma file(s)** for **each design segment** (e.g. per screen, per component, or per DESIGN.md section/component).

So the new artifact:

- **Consumes:** SPEC.md, DESIGN.md, and Figma (file URLs or file keys + frame/component identifiers).
- **Produces:** UIX/UI-SPEC.md that maps:
  - Design segments (e.g. “Front page”, “Site header”, “Auth flow”) → Figma link(s).

This supports:

- Implementation (dev/AI can open the right Figma for each component).
- Review (designer/reviewer can check that build matches Figma).
- Traceability (which Figma corresponds to which part of DESIGN.md / SPEC).

---

## 3. Injection Options (High-Level)

### Option A: New mandatory step (Step 2b) — between Design and Tasks

- **Position:** After `step-02-design`, before `step-03-tasks`.
- **New step:** e.g. `step-02b-uix.md` (or `step-02a-uix.md` depending on naming).
- **New artifact:** `specs/XXX-{slug}/UI-SPEC.md` (or `UIX/UI-SPEC.md`; see naming below).
- **Gate:** “UI-SPEC approved” before TASKS.md.
- **Pros:** Clear place in pipeline; every spec with UI gets a UI-SPEC; task creation can reference it.
- **Cons:** Not all specs have Figma; adds a step for non-UI work. Mitigation: make step **skippable** (e.g. “No Figma for this spec → [S] Skip”) so the canonical order stays 1 → 2 → 2b? → 3 → 4 → 5, but 2b can be skipped.

### Option B: Optional step (same position, skip allowed)

- Same as A, but **explicit skip**: e.g. “[S] Skip UIX — no Figma for this spec”. On skip, append something like `step-02b-uix-skipped` or simply `step-02b-uix` with a “skipped” flag in state so continue goes to step-03.
- **Pros:** No impact on backend-only specs; UI specs get a consistent place for Figma.
- **Cons:** Two ways to “complete” step 2b (done vs skipped); state/validation must handle both.

### Option C: Parallel track (no new step number)

- **UI-SPEC.md** is created **outside** the main flow: e.g. `/uix 001` or `/design-uix 001` that:
  - Requires SPEC + DESIGN approved.
  - Creates/updates `UI-SPEC.md` in the spec folder.
  - Does **not** change `stepsCompleted`; flow remains 1 → 2 → 3 → 4 → 5.
- **Pros:** No change to step count or resume logic; optional by nature.
- **Cons:** Not part of `/flow`; implementer must remember to run it; TASKS.md doesn’t have a formal “gate” that UI-SPEC exists.

### Option D: Design step extension (no new artifact)

- Extend DESIGN.md (or DESIGN.template.md) with an optional **“Figma / UI references”** section: e.g. a table “Component / Screen | Figma link”.
- **Pros:** No new file; no new step; single source of truth.
- **Cons:** Mixes technical design with design-asset links; DESIGN.md gets longer; some teams prefer to keep “design system” (Figma) separate from “technical design” (DESIGN.md).

**Recommendation for direction:** Prefer **Option B** (optional step 2b with explicit skip) so that:
- UI specs have a clear, gated place for Figma → UI-SPEC.
- Non-UI specs don’t block on Figma.
- Task creation (and optionally implementation skill) can “if present, use UI-SPEC” for UI tasks.

---

## 4. High-Level Shape of the New Pieces

### 4.1 Artifact: UI-SPEC.md (or UIX/UI-SPEC.md)

- **Naming:** `UI-SPEC.md` in `specs/XXX-{slug}/` is consistent with SPEC.md, DESIGN.md, TASKS.md. A subfolder `UIX/` is possible but adds nesting; recommend single file `UI-SPEC.md` unless you need multiple UI-related docs.
- **Suggested sections (to be refined in a template):**
  - **Metadata** (ID, Name, Status, Author, Date, optional Approved By).
  - **Overview** (1–2 sentences: this spec’s UI is defined in Figma; this doc maps DESIGN segments to Figma).
  - **Design segment → Figma mapping** (table):
    - Design segment (e.g. “Front page”, “Site header”, “Login form”) — aligned to DESIGN.md components/sections.
    - Figma link (file URL + optional node/frame ID for deep link).
    - Optional: Notes (e.g. “Mobile variant”, “Desktop only”).
  - **Figma file(s)** (list of main files used for this spec).
  - **Open questions** (e.g. missing frames, unclear ownership).

### 4.2 Skill: uix-creation (or ui-spec-creation)

- **Inputs:** Approved SPEC.md, approved DESIGN.md, and **Figma input** (user provides file URLs or “no Figma”).
- **Logic:**
  - Parse DESIGN.md (especially Architecture and any component/screen list).
  - For each segment, either attach a Figma link (from user) or mark “No Figma” / open question.
  - Output UI-SPEC.md per template.
- **Gate:** SPEC and DESIGN approved; no need to gate on Figma existence if skip is allowed.

### 4.3 Step: step-02b-uix.md (if Option A/B)

- **nextStepFile:** `./step-03-tasks.md`.
- **ruleRef:** `@skills/uix-creation/SKILL.md` (or `ui-spec-creation`).
- **templateRef:** `@.framework/templates/UI-SPEC.template.md`.
- **Gate:** SPEC + DESIGN approved (same as task step).
- **Sequence:** Load SPEC + DESIGN → create/update UI-SPEC.md → present → approve or skip → update state → continue to step-03.

### 4.4 Figma “file” granularity

You said “Figma file of each design segments”. Two interpretations:

- **One Figma file per spec** with multiple frames/pages → UI-SPEC rows are “segment → same file + frame/page/node”.
- **Multiple Figma files** (e.g. one per screen) → UI-SPEC rows are “segment → different file (and optional node)”.

The template and skill should support both: each row has “Figma link” (URL + optional fragment for node), so one or many files both work.

---

## 5. What to Analyze Before Implementation

1. **Exact placement**
   - Confirm Option B (optional step 2b) vs Option C (standalone command only) vs A (mandatory step).
   - Decide step naming: `step-02b-uix` vs `step-02a-uix` (and whether “02a” implies “before design” — it doesn’t; “02b” is clearer as “after design”).

2. **Canonical order in step-00-continue**
   - Today: `step-01-spec, step-02-design, step-03-tasks, step-04-implement, step-05-review`.
   - With 2b: `step-01-spec, step-02-design, step-02b-uix, step-03-tasks, step-04-implement, step-05-review`.
   - **Back-step trim rules:** “Back to Tasks” = keep up to `step-02b-uix`; “Back to Design” = keep up to `step-02-design`; “Back to UIX” = keep up to `step-02-design` and load step-02b-uix.

3. **Skip semantics**
   - If skipped: append `step-02b-uix` to `stepsCompleted` with a “skipped” flag, or a separate frontmatter field like `uixSkipped: true` so that:
     - Resume still goes to step-03.
     - Validate/reporting can show “UI-SPEC skipped” for this spec.

4. **Task creation**
   - Should TASKS.md reference UI-SPEC.md when present? (e.g. “(DESIGN: Architecture; UI: UI-SPEC § Front page)”.)
   - Optional: in `skills/task-creation/SKILL.md`, “If `specs/XXX/UI-SPEC.md` exists, list it in References and allow tasks to cite UI-SPEC segments.”

5. **Validate command**
   - Add step count (6 → 7), new template `UI-SPEC.template.md`, and new skill `skills/uix-creation/` (or `ui-spec-creation/`) to the checklist.

6. **Figma input format**
   - How does the user provide Figma links? (Paste URLs in chat, CSV, or a small config file in the spec folder?)
   - Support for Figma node IDs (e.g. `?node-id=123-456`) for deep links so “design segment” points to a specific frame.

7. **Constitution**
   - Optional: CONSTITUTION.template.md (or docs) can mention that UI specs may have UI-SPEC.md and how Figma is referenced (e.g. “Figma links in UI-SPEC.md use canonical file URL + node-id when available”).

---

## 6. Suggested Next Steps (For You to Analyze)

1. **Decide option:** A (mandatory), B (optional step), C (standalone only), or D (DESIGN section only).
2. **Define UI-SPEC.md template** (sections and table format) in a draft `.framework/templates/UI-SPEC.template.md`.
3. **Draft skill** `skills/uix-creation/SKILL.md` (required inputs, how to derive “design segments” from DESIGN.md, how to accept Figma links, output path).
4. **If step 2b:** Draft `step-02b-uix.md` and update `step-02-design.md` (`nextStepFile` → step-02b-uix), then update `step-00-continue.md` (canonical order + back-step rules + skip handling).
5. **Add command** (e.g. `/uix 001`) that applies the same skill for standalone use.
6. **Update validate** (steps, templates, skills).
7. **Optional:** Extend task-creation to reference UI-SPEC.md when present; optionally implementation skill to “prefer UI-SPEC for UI tasks”.

This gives you a clear technical overview and a direction to implement the Figma → UIX/UI-SPEC.md process after SPEC.md and DESIGN.md, with Figma file references per design segment, without committing to code yet.
