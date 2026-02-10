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
| `/flow` | **Run full guided workflow** (BMAD-style): loads step files, runs them on [C] Continue / [B] Back / [X] Exit. Resumes from last completed step. | Spec reference (e.g. 001 or path) + optional requirement — see [Workflow return and continue](WORKFLOW-RETURN-AND-CONTINUE.md) |
| `/bug` | Create `bugs/BUG-XXX-slug/BUG.md` | Original spec reference + bug description |
| `/bugfix` | Implement one task from BUG.md | Task reference (e.g. T1 from BUG-001) |
| `/bugreview` | Generate `bugs/BUG-XXX-slug/REVIEW.md` | Bug reference (e.g. BUG-001 or path) |
| `/change` | Handle scope change: classification check, impact analysis, Change Proposal. After approval: update SPEC/DESIGN/TASKS, Amendment History, SPEC-CURRENT.md. | Spec reference (e.g. 001) + optional Jira ref or description |
| `/adversarial` | Review any document (spec, design, doc) with extreme skepticism; find at least 10 issues. | Document or content to review (e.g. @SPEC.md or paste) |

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

## Change Request Example (/change)

When scope changes (new requirement, client request) and no existing AC is violated:

```
/change 006
```
or with Jira:
```
/change 006: PROJ-456
```

→ Classification check (bug vs CR) → impact analysis → Change Proposal document. After human approval: SPEC/DESIGN/TASKS updated, Amendment History row added to SPEC.md, SPEC-CURRENT.md regenerated.

---

## Adversarial Review Example (/adversarial)

To sanity-check a spec or design before approving a gate:

```
/adversarial @specs/006-chatbot/SPEC.md
```

→ AI reviews the document with extreme skepticism and reports at least 10 potential issues. Use to find gaps, ambiguities, or risks before Gate 1/2/3.

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
| `/change` | (nothing) | Which spec (e.g. 001) + optional Jira ref |
| `/adversarial` | (nothing) | What to review (e.g. @SPEC.md or paste content) |

---

## Flow Summary

**Feature (standalone commands):**  
`/constitute` (once) → `/specify` → `/design` → `/tasks` → `/implement` (per task) → `/review`

**Feature (guided workflow — recommended):**  
`/constitute` (once) → `/flow 001-slug: requirements` → runs all steps with menus: [C] Continue, [B] Back, [X] Exit.  
Resume anytime with `/flow 001`.

**Bugfix:**  
`/bug` → `/bugfix` (per task) → `/bugreview`

**Change request (scope change):**  
`/change 001` or `/change 001: PROJ-123` → classification check → impact analysis → Change Proposal → after approval: SPEC/DESIGN/TASKS + Amendment History + SPEC-CURRENT.md

**Adversarial review (any doc):**  
`/adversarial` + document (e.g. @SPEC.md) → find ≥10 issues. Use before gate approval or to sanity-check.

Each standalone command runs one subflow (rule + template). `/flow` runs the full feature workflow step by step using `.framework/steps/`. See [Workflow return and continue](WORKFLOW-RETURN-AND-CONTINUE.md) for details.

---

## Guided Workflow Example (using /flow)

```
/flow 002-chatbot: simple chatbot widget with mocked data
```

**What happens:**

1. Runner creates `specs/002-chatbot/` and `.workflow-state.md`, then loads step-01-spec.
2. Step 1: AI asks clarifying questions, creates SPEC.md (DRAFT). You review and approve. Menu: [C] Continue.
3. Press **[C]** → Step 2: AI creates DESIGN.md. You approve. [C] Continue.
4. Press **[C]** → Step 3: AI creates TASKS.md. You approve. [C] Continue.
5. Press **[C]** → Step 4: AI implements tasks. You confirm all done. [C] Continue.
6. Press **[C]** → Step 5: AI generates REVIEW.md. If approved: [C] Complete. If issues: [F] Fix or [B] Back.

**Resume after a break:**

```
/flow 002
```
→ "Last completed: step-02-design. Next: Tasks. [C] Continue."

**Go back and fix:**

At any step, choose [B] to go back. Fix the issue, then [C] through the remaining steps.

---
