# Commands & Workflow Usage Example

How to use the Cursor commands to run the full spec-first workflow. Each command runs a subflow (rule + template); you only provide the reference or description.

---

## Commands Overview

| Command | What it does | User provides |
|--------|----------------|----------------|
| `/constitute` | Create/update `.framework/CONSTITUTION.md` | Project description (tech stack, standards) |
| `/specify` | Create `specs/XXX-slug/SPEC.md` | Spec ID + requirement (or just requirement; ID asked if missing) |
| `/design` | Create `specs/XXX-slug/DESIGN.md` | Spec reference (e.g. 006 or path) |
| `/tasks` | Create `specs/XXX-slug/TASKS.md` | Spec/design reference (e.g. 006 or path) |
| `/implement` | Implement one task from TASKS.md | Task reference (e.g. T3 from 006) |
| `/review` | Generate `specs/XXX-slug/REVIEW.md` | Spec reference (e.g. 006 or path) |
| `/bug` | Create `bugs/BUG-XXX-slug/BUG.md` | Original spec reference + bug description |
| `/bugfix` | Implement one task from BUG.md | Task reference (e.g. T1 from BUG-001) |
| `/bugreview` | Generate `bugs/BUG-XXX-slug/REVIEW.md` | Bug reference (e.g. BUG-001 or path) |

---

## Feature Workflow Example (006 – Chatbot Widget)

**One-time (or when project standards change):**

```
/constitute FastAPI backend, Python 3.12, PostgreSQL 16, 80% coverage, Pydantic validation, Ruff + mypy.
```
→ Creates/updates `.framework/CONSTITUTION.md`. Human (Tech Lead) approves.

---

**Step 1 – Spec (Gate 1: PO approves)**

```
/specify 006-chatbot: simple chatbot widget with mocked data for now.
```
→ Creates `specs/006-chatbot/SPEC.md`. Human (PO) approves.

---

**Step 2 – Design (Gate 2: Tech Lead approves)**

```
/design 006
```
or
```
/design @specs/006-chatbot/SPEC.md
```
→ Creates `specs/006-chatbot/DESIGN.md`. Human (Tech Lead) approves.

---

**Step 3 – Tasks (Gate 3: Tech Lead approves)**

```
/tasks 006
```
or
```
/tasks @specs/006-chatbot/DESIGN.md
```
→ Creates `specs/006-chatbot/TASKS.md`. Human (Tech Lead) approves.

---

**Step 4 – Implementation (per task)**

```
/implement T1 from 006
```
```
/implement T2 from 006
```
… repeat for each task (T1, T2, T3, …).

→ Implements code per task. No human gate per task; gate is at review.

---

**Step 5 – Code review (Gate 4: Reviewer approves)**

```
/review 006
```
or
```
/review @specs/006-chatbot/SPEC.md
```
→ Creates `specs/006-chatbot/REVIEW.md`. Human (Reviewer) approves. Feature done.

---

## Bugfix Workflow Example (BUG-001)

**Step 1 – Bug report (Gate 1: Tech Lead confirms)**

```
/bug @specs/006-chatbot/SPEC.md – Deleted user still visible in chat widget. Steps: 1) Delete user in admin 2) Open chatbot 3) User name still appears in header. Expected: removed. Actual: still shown.
```
→ Creates `bugs/BUG-001-deleted-user-still-visible/BUG.md`. Human (Tech Lead) confirms.

---

**Step 2 – Implement fix (per task from BUG.md)**

```
/bugfix T1 from BUG-001
```
```
/bugfix T2 from BUG-001
```
… repeat for each task in BUG.md.

→ Implements fix + regression test per task.

---

**Step 3 – Bug review (Gate 2: Reviewer approves)**

```
/bugreview BUG-001
```
or
```
/bugreview @bugs/BUG-001-deleted-user-still-visible/BUG.md
```
→ Creates `bugs/BUG-001-deleted-user-still-visible/REVIEW.md`. Human (Reviewer) approves. Update SPEC.md Bug History. Done.

---

## Minimal Prompt Examples (when you omit the message)

If you run a command with no message, the AI will ask for the missing input:

| Command | You run | AI asks |
|--------|---------|--------|
| `/constitute` | (nothing) | Project description (tech stack, standards) |
| `/specify` | (nothing) | Spec ID and/or requirement |
| `/design` | (nothing) | Which spec to design (e.g. 006) |
| `/tasks` | (nothing) | Which design to break down (e.g. 006) |
| `/implement` | (nothing) | Which task (e.g. T3 from 006) |
| `/review` | (nothing) | Which spec to review (e.g. 006) |
| `/bug` | (nothing) | Original spec reference + bug description |
| `/bugfix` | (nothing) | Which bug task (e.g. T1 from BUG-001) |
| `/bugreview` | (nothing) | Which bug to review (e.g. BUG-001) |

---

## Flow Summary

**Feature:**  
`/constitute` (once) → `/specify` → `/design` → `/tasks` → `/implement` (per task) → `/review`

**Bugfix:**  
`/bug` → `/bugfix` (per task) → `/bugreview`

Each command only runs the subflow (rule + template); all detailed rules live in the `.mdc` files.
