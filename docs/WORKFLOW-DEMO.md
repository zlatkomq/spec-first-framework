# Spec-First Framework: Live Workflow Demo

A real walkthrough of building **001 User Registration** using the guided `/flow` workflow on framework **v1.2.0**.

The final artifacts produced by this run are checked into the repo and can be browsed alongside the demo:

- [`docs/examples/001-user-registration/SPEC.md`](examples/001-user-registration/SPEC.md)
- [`docs/examples/001-user-registration/DESIGN.md`](examples/001-user-registration/DESIGN.md)
- [`docs/examples/001-user-registration/TASKS.md`](examples/001-user-registration/TASKS.md)
- [`docs/examples/001-user-registration/REVIEW.md`](examples/001-user-registration/REVIEW.md)

---

## Prerequisite: CONSTITUTION.md (once per project)

Before any spec, the project needs a `CONSTITUTION.md` describing its tech stack and standards. Run **once**:

```
/constitute Python 3.12, FastAPI, PostgreSQL, pytest 80% coverage, REST API
```

The `constitution-creation` skill asks **one question at a time** (project name, type, database, auth provider, deployment, coverage threshold, etc.) until concrete versions and decisions are captured. Output: `CONSTITUTION.md` at the project root with Status: DRAFT → APPROVED.

For this demo the constitution captures: **car selling platform backend, GREENFIELD, PostgreSQL, AUTH0, Docker, 70% coverage**.

---

## Run the guided workflow

```
/flow 001-user-registration: invite-only registration with email and password for a car selling backend
```

The `/flow` command does three things up front:

1. Creates the spec folder `specs/001-user-registration/`.
2. Initialises `.workflow-state.md` from `.framework/templates/workflow-state.template.md`:

   ```yaml
   ---
   stepsCompleted: []
   specId: '001'
   specSlug: 'user-registration'
   specFolder: 'specs/001-user-registration'
   implementationAttempts: 0
   jiraTicket: ''
   sowRef: ''
   fixAttempts: 0
   previousIssueCount: 0
   fixLoopActive: false
   uixSkipped: false
   featureBranch: ''
   baseBranch: ''
   worktreePath: ''
   ---
   ```

3. Loads `.framework/steps/step-01-spec.md` and begins.

At every gate the menu offers **[C] Continue · [B] Back · [X] Exit**. You can interrupt and resume any time with `/flow 001` — `step-00-continue.md` reads `stepsCompleted` and routes you to the right place.

---

## Step 1 of 6 — SPEC.md

**Skill applied:** `skills/spec-creation/SKILL.md` · **Template:** `.framework/templates/SPEC.template.md`

The spec-creation skill drafts `specs/001-user-registration/SPEC.md` then asks for the missing decisions:

- Who issues invite codes? → **admin**
- Do invite codes expire? → **no**
- Single-use or multi-use? → **single**
- Additional password requirements beyond standard? → **no**

The agent rewrites SPEC.md, replaces open questions with a **Decisions Made** table, and presents the draft for approval.

```
[C] Approve · [E] Edit · [V] View DESIGN · [B] Back · [X] Exit
```

### Gate 1 — Product Owner approval (BMAD metadata captured)

The skill records gate fields directly in `SPEC.md`:

| Field | Value |
|---|---|
| Status | APPROVED |
| Approved By | PO name |
| Approval Date | 2026-01-21 |
| Jira Ticket | PROJ-101 *(optional, set in `.workflow-state.md` or asked at approval)* |

`.workflow-state.md` is updated: `stepsCompleted: ['step-01-spec']`. The skill offers to commit (`spec(001): create SPEC.md`).

**Result:** 3 user stories, **13 acceptance criteria** (4 happy path, 5 validation, 4 password requirements) — see [SPEC.md](examples/001-user-registration/SPEC.md).

---

## Step 2 of 6 — DESIGN.md

**Skill applied:** `skills/design-creation/SKILL.md` · **Gate:** SPEC.md must be `APPROVED`

Before drafting, the skill verifies SPEC status. If it weren't APPROVED, the gate halts with:

```
⛔ Cannot Proceed
design-creation requires SPEC.md to be APPROVED before creating DESIGN.md.
```

With SPEC approved, the skill produces `specs/001-user-registration/DESIGN.md`: layered architecture (endpoint → service → repository), data model (User entity), API spec with RFC 7807 error format, security notes, and an acceptance-criteria traceability table linking every AC to a component.

### Gate 2 — Tech Lead approval

Same BMAD fields captured: **Approved By**, **Approval Date**, **Jira Ticket** (auto-inherited from state).

`.workflow-state.md`: `stepsCompleted: ['step-01-spec', 'step-02-design']`.

---

## Step 3 of 6 — UIX-SPEC.md *(optional, skipped for this demo)*

**Skill applied:** `skills/uix-creation/SKILL.md` · **Gate:** DESIGN.md must be `APPROVED`

This is the v1.2.0 **cached Figma snapshot** step. Because 001 User Registration is backend-only, the demo picks `[S] Skip UIX (no Figma)`. The skill writes `uixSkipped: true` into `.workflow-state.md`, appends `'step-02b-uix'` to `stepsCompleted`, and auto-continues to step 4.

> **What it would have done with a Figma file:** asked for the file URL, called the team MCP server `figma-to-code` (v2.0.0+) with the granular tool sequence — `get_figma_file_structure` → `get_figma_design_tokens` → `get_figma_node_spec` (optionally `get_figma_frame_with_image` and `export_figma_assets`) — and saved every response **once** to `specs/001-user-registration/figma/` (`tokens.css`, `<node-id>.md`, optional `<node-id>.png`, `assets/`). Those on-disk files then become the **single source of truth** for steps 5 and 6, which **never call the MCP**. The only sanctioned re-fetch path is the `/uix-refresh` command (or `[F] Force refresh` in the step's menu). See [Figma and UIX flow](../README.md#figma-and-uix-flow-layout-handoff) in the README.

---

## Step 4 of 6 — TASKS.md

**Skill applied:** `skills/task-creation/SKILL.md` · **Gate:** DESIGN.md must be `APPROVED`

The skill decomposes DESIGN.md into **atomic** tasks with explicit **Produces / Consumes** contracts so each task is independently implementable. Result for 001: **11 tasks** grouped Setup → Data → Repository → Service → API → Tests.

| Task | Description |
|---|---|
| T1 | Add dependencies (`passlib[bcrypt]`, `email-validator`) |
| T2 | Create User SQLAlchemy model |
| T3 | Create auth Pydantic schemas |
| T4 | Create UserRepository (`create()`, `get_by_email()`) |
| T5 | Create RegistrationService (password validation + registration logic) |
| T6 | Create registration endpoint |
| T7 | Add auth router and wire into `app/main.py` |
| T8 | Unit tests: password validation |
| T9 | Unit tests: RegistrationService |
| T10 | Unit tests: UserRepository |
| T11 | Integration test: registration endpoint |

Full file: [TASKS.md](examples/001-user-registration/TASKS.md).

### Gate 3 — Tech Lead approval (TASKS)

BMAD metadata captured. `.workflow-state.md`: `stepsCompleted: [..., 'step-03-tasks']`.

---

## Step 5 of 6 — Implementation

**Skill applied:** `skills/implementation/SKILL.md` (single-task) or `skills/subagent-driven-development/SKILL.md` (multi-task — default for 11 tasks) · **Gate:** TASKS.md must be `APPROVED`

For multi-task specs, `/flow` dispatches a **subagent per task** following the implementation skill's rules:

- **TDD iron law:** failing test first, then code. Code written before a test is **deleted**.
- **Per-task validation gate** before checkbox flip: tests exist, tests pass, ACs satisfied, no scope creep.
- **HALT after 3 consecutive failed attempts** on the same problem → invoke `systematic-debugging`.
- **IMPLEMENTATION-SUMMARY.md** is written **incrementally** — one `### T{N}` anchor per task, appended after that task's gates pass. Not as a single batch at the end.

After all 11 tasks are `[x]` in TASKS.md, step 5 runs the **verification gate** from [`.framework/checklists/verification-checklist.md`](../.framework/checklists/verification-checklist.md):

1. **Task Completion** — all `[x]` count matches total
2. **Test Suite Green** — full `pytest` run records pass/fail/skip counts
3. **Lint & Type Check** — zero errors (commands per CONSTITUTION.md)
4. **Implementation Summary** — file exists with per-task anchors
5. **HALT Conditions** — no unresolved HALTs
6. **Scope Integrity** — `git diff specs/` shows only TASKS checkbox + IMPLEMENTATION-SUMMARY changes

Gate fails up to 3 times (`implementationAttempts` increments) before routing to manual intervention.

**Files produced:**

```
requirements.txt
app/models/user.py
app/schemas/auth.py
app/repositories/user_repository.py
app/services/registration_service.py
app/api/v1/endpoints/auth.py
app/api/v1/router.py
app/main.py
tests/unit/services/test_password_validation.py
tests/unit/services/test_registration_service.py
tests/unit/repositories/test_user_repository.py
tests/integration/test_registration_endpoint.py
specs/001-user-registration/IMPLEMENTATION-SUMMARY.md
```

---

## Step 6 of 6 — Code Review

**Skill applied:** `skills/code-review/SKILL.md` · **Gate:** every task in TASKS.md must be `[x]`

The review skill runs **from scratch** (no resume): inspects actual source code (not just docs), runs the test suite, and produces [REVIEW.md](examples/001-user-registration/REVIEW.md) with a verdict from the framework's **issue-count policy**:

| Issue count | Verdict | What happens |
|---|---|---|
| < 3 | Re-examine — must justify low count in one sentence, else APPROVED | Continue to gate |
| 3–10 | **CHANGES REQUESTED** | `[F] Fix automatically` (re-loop, capped at 3 fix attempts) or `[B] Back to Implement` |
| > 10 | **BLOCKED** | Recommend re-implementing from TASKS rather than patching |

For this run: **Verdict APPROVED** — all 11 tasks traced to code + tests, all 13 acceptance criteria PASS, CONSTITUTION + DESIGN compliance verified, two non-blocking recommendations.

### Gate 4 — Reviewer approval → Done

`.workflow-state.md`: `stepsCompleted: [..., 'step-05-review']`. The skill offers to invoke `finishing-development-branch` (merge / PR / cleanup) if a feature branch / worktree was used.

---

## Resume, back, and continue

Any session can be paused and resumed:

```
/flow 001              # resumes from last completed step
[B]                    # go back one step from any menu
[C]                    # continue
[X]                    # exit, state preserved
```

See [WORKFLOW-RETURN-AND-CONTINUE.md](WORKFLOW-RETURN-AND-CONTINUE.md).

---

## Artifacts produced

```
CONSTITUTION.md                        # once per project (Status: APPROVED)

specs/001-user-registration/
├── .workflow-state.md                 # tracks /flow progress (managed by /flow)
├── SPEC.md                            # 13 acceptance criteria (APPROVED)
├── DESIGN.md                          # architecture, API, data model (APPROVED)
├── TASKS.md                           # 11 atomic tasks (APPROVED)
├── IMPLEMENTATION-SUMMARY.md          # per-task anchor entries + aggregate
└── REVIEW.md                          # verdict + AC traceability + recommendations

# If the spec had Figma, also:
# └── figma/
#     ├── tokens.css                   # design tokens (only allowed colour/font source)
#     ├── <node-id>.md                 # per-segment JSX tree + geometry
#     ├── <node-id>.png                # optional visual reference
#     ├── assets/                      # exported icons/images (svg_ex_ nodes)
#     └── drift-T<n>.md                # one-shot drift records from step 5

app/                                   # full implementation
tests/                                 # unit + integration tests
requirements.txt
```

---

## Approximate run time

| Step | Time | Notable interaction |
|---|---|---|
| `/constitute` *(once per project)* | ~5 min | One question at a time until concrete versions |
| Step 1 — SPEC | ~5 min | Clarifying Qs on invite codes; 13 ACs captured |
| Step 2 — DESIGN | ~2 min | Architecture, API, data model auto-generated from SPEC |
| Step 3 — UIX | skipped | Backend-only; `uixSkipped: true` |
| Step 4 — TASKS | ~1 min | 11 atomic tasks with Produces/Consumes contracts |
| Step 5 — Implementation | ~10–15 min | Subagent per task, TDD per task, verification gate |
| Step 6 — Review | ~3 min | Inspects code + runs tests, issue-count verdict |

**Total:** ~25–30 minutes from requirement to reviewed, gate-approved code.

---

## Key framework behaviours demonstrated

1. **AI asks, doesn't assume.** Missing info triggers clarifying questions — one at a time — never guesses.
2. **Gates enforce order.** Each step refuses to run unless the previous artifact is `APPROVED`. The verification gate refuses to ship code that fails tests, lint, or scope integrity.
3. **Traceability end-to-end.** Every line of code traces back through TASKS → DESIGN → SPEC acceptance criteria. BMAD agency metadata (Approved By, Approval Date, Jira Ticket) captured on every gate.
4. **Atomic tasks with explicit contracts.** Each task = one prompt = one component. Produces/Consumes makes dependencies machine-checkable.
5. **CONSTITUTION compliance.** Code follows project standards (naming, patterns, error format, test framework) automatically — no per-task reminding.
6. **Adversarial review against actual code.** Review skill inspects source files and runs the test suite — not a documentation pass.
7. **Resumable state.** `.workflow-state.md` lets you stop mid-spec and resume hours or days later without losing context.
8. **Figma is fetch-once.** When UI is in scope, design data is cached on disk in `figma/` and read from disk by every downstream step. No fidelity loops, no surprise MCP calls — only `/uix-refresh` re-fetches.
