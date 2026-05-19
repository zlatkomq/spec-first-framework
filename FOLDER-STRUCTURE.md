# Spec-First Framework: Project Folder Structure

## Complete Structure

```
project/
│
├── skills/                                  # Canonical cross-platform skill files (SKILL.md open standard) — 16 skills
│   ├── spec-creation/SKILL.md               # How AI creates SPEC.md
│   ├── constitution-creation/SKILL.md       # How AI creates CONSTITUTION.md
│   ├── design-creation/SKILL.md             # How AI creates DESIGN.md
│   ├── uix-creation/SKILL.md                # How AI creates UIX-SPEC.md (Figma mapping; cached figma/ snapshot)
│   ├── task-creation/SKILL.md               # How AI creates TASKS.md
│   ├── implementation/SKILL.md              # How AI writes code (single-task)
│   ├── subagent-driven-development/SKILL.md # How /flow dispatches a subagent per task for multi-task specs
│   ├── code-review/SKILL.md                 # How AI reviews code
│   ├── adversarial-review/SKILL.md          # How AI reviews any doc with ≥10 issues
│   ├── bugfixing/SKILL.md                   # How AI creates BUG.md
│   ├── bug-implementation/SKILL.md          # How AI implements bugfixes
│   ├── bug-review/SKILL.md                  # How AI reviews bugfixes
│   ├── change-request/SKILL.md              # How AI runs change request workflow
│   ├── git-worktrees/SKILL.md               # Workspace isolation (feature branches via git worktree)
│   ├── finishing-development-branch/SKILL.md # Branch merge / PR / cleanup after a feature
│   └── systematic-debugging/SKILL.md        # Root-cause investigation (/debug command)
│
├── .cursor-plugin/
│   ├── plugin.json                          # Cursor plugin manifest (skills + commands path)
│   └── marketplace.json                     # Cursor marketplace metadata
├── .claude-plugin/
│   ├── plugin.json                          # Claude Code plugin manifest (skills path)
│   └── marketplace.json                     # Claude Code marketplace metadata
├── .opencode/
│   ├── plugins/
│   │   └── spec-first.js                    # OpenCode ES Module plugin (system prompt injection)
│   └── INSTALL.md                           # Manual setup instructions (symlink plugin + skills)
│
├── .cursor/
│   └── commands/                            # Cursor slash commands — 16 commands
│       ├── constitute.md                    #   /constitute — create CONSTITUTION.md
│       ├── specify.md                       #   /specify — create SPEC.md
│       ├── design.md                        #   /design — create DESIGN.md
│       ├── uix.md                           #   /uix — create UIX-SPEC.md (Figma)
│       ├── uix-refresh.md                   #   /uix-refresh — re-fetch cached Figma snapshot
│       ├── tasks.md                         #   /tasks — create TASKS.md
│       ├── implement.md                     #   /implement — implement tasks
│       ├── review.md                        #   /review — code review
│       ├── flow.md                          #   /flow — guided end-to-end workflow
│       ├── bug.md                           #   /bug — create BUG.md
│       ├── bugfix.md                        #   /bugfix — implement bug fix
│       ├── bugreview.md                     #   /bugreview — review bug fix
│       ├── change.md                        #   /change — scope change request
│       ├── adversarial.md                   #   /adversarial — extreme skepticism review (≥10 issues)
│       ├── debug.md                         #   /debug — systematic root-cause investigation
│       └── validate.md                      #   /validate — framework integrity check
│
├── .framework/
│   ├── steps/                          # BMAD-style step files for /flow
│   │   ├── step-00-continue.md         # Resume logic
│   │   ├── step-01-spec.md
│   │   ├── step-02-design.md
│   │   ├── step-02b-uix.md            # UIX Spec (Figma); optional step
│   │   ├── step-03-tasks.md
│   │   ├── step-04-implement.md
│   │   └── step-05-review.md
│   ├── templates/                          # Document templates — 11 files
│   │   ├── SPEC.template.md                # Template structure for specifications
│   │   ├── DESIGN.template.md              # Template structure for technical design
│   │   ├── UIX-SPEC.template.md            # Template for Figma files + segment → node-id mapping
│   │   ├── TASKS.template.md               # Template structure for task breakdown
│   │   ├── CONSTITUTION.template.md        # Template structure for project constitution
│   │   ├── BUG.template.md                 # Template for bug reports
│   │   ├── REVIEW.template.md              # Template for code review (Implementation Summary Cross-Reference, Auto-Fix)
│   │   ├── BUG-REVIEW.template.md          # Template for bug review
│   │   ├── workflow-state.template.md      # State file template for /flow (jiraTicket, sowRef, uixSkipped, …)
│   │   ├── CHANGE-PROPOSAL.template.md     # Template for change proposals (classification, impact)
│   │   └── SPEC-CURRENT.template.md        # Template for compiled spec (SPEC + bugs + CRs)
│   └── checklists/
│       └── verification-checklist.md       # Step 4 verification gate after implementation
│
├── mcp.json                                 # Reference MCP config (figma-to-code server, defaults to 127.0.0.1:3000)
├── spec-first.sh                            # Project-init CLI (downloaded to /usr/local/bin/spec-first)
│
├── CONSTITUTION.md                          # Project-level standards (THE source of truth)
│
├── docs/                                    # Repo documentation
│   ├── CLIENT-HANDOFF.md                    # One-page index for clients receiving the framework
│   ├── COMMANDS-WORKFLOW-EXAMPLE.md         # Standalone command usage
│   ├── WORKFLOW-DEMO.md                     # Worked /flow run end-to-end
│   ├── WORKFLOW-RETURN-AND-CONTINUE.md      # Resume / back / continue mechanics
│   ├── FIGMA-DESIGNER-GUIDE.md              # Design contract for designers (naming, layout, svg_ex_, …)
│   ├── UIX-FIGMA-INJECTION-OVERVIEW.md      # Historical: original design analysis for the UIX feature
│   ├── BMAD-FUSION-CHANGES.md               # Historical: v0.7.x BMAD fusion changes
│   ├── examples/                            # Working example: 001-user-registration (SPEC, DESIGN, TASKS, REVIEW)
│   └── legacy-analysis/                     # Stub (.gitkeep). Brownfield projects use the [legacy_ai_analyser](https://github.com/zlatkomq/legacy_ai_analyser) companion plugin, which writes to docs/ai/ instead
│
├── tests/                                   # Automated regression suite
│   ├── README.md
│   ├── run-skill-tests.sh                   # Runs the 16 skill tests
│   ├── test-helpers.sh                      # Shared assertion library
│   ├── test-<skill>.sh                      # 16 skill tests (one per skill in skills/)
│   └── e2e/                                 # 13 end-to-end scenario scripts (happy paths + gate failures)
│       └── scenarios/<skill>/<name>.scenario.sh
│
├── specs/
│   ├── 001-user-authentication/
│   │   ├── .workflow-state.md          # Workflow progress (created by /flow, committed to git)
│   │   ├── SPEC.md                     # What to build
│   │   ├── DESIGN.md                   # How to build it
│   │   ├── UIX-SPEC.md                 # Optional: Figma files + design segment → node-id mapping + Design Context Artifacts table
│   │   ├── figma/                      # Optional: cached design context (fetch-once snapshot from figma-to-code v2.0.0+ MCP)
│   │   │   ├── tokens.css              #   Design tokens — only allowed source of hex/font in generated code
│   │   │   ├── 123-456.md              #   Per-node JSX prop tree + flat geometry table
│   │   │   ├── 123-456.png             #   Optional visual reference (numbers come from .md)
│   │   │   ├── assets/                 #   Optional exported icons/images
│   │   │   └── drift-T3.md             #   Optional one-shot drift record from step-04 (write-once)
│   │   ├── TASKS.md                    # Implementation breakdown
│   │   ├── IMPLEMENTATION-SUMMARY.md   # Implementation record (files, decisions, tests)
│   │   └── REVIEW.md                   # Code review results
│   │
│   ├── 002-password-reset/
│   │   ├── .workflow-state.md
│   │   ├── SPEC.md
│   │   ├── DESIGN.md
│   │   ├── TASKS.md
│   │   ├── IMPLEMENTATION-SUMMARY.md
│   │   └── REVIEW.md
│   │
│   └── XXX-description/                # Pattern: {ID}-{slug}/
│       ├── .workflow-state.md          # Tracks stepsCompleted + implementationAttempts + uixSkipped
│       ├── SPEC.md
│       ├── DESIGN.md
│       ├── UIX-SPEC.md                 # Optional (step 3); skip if no Figma
│       ├── figma/                      # Optional: cached design context (see above)
│       ├── TASKS.md
│       ├── IMPLEMENTATION-SUMMARY.md
│       └── REVIEW.md
│
├── bugs/                               # Bug specifications (separate from features)
│   ├── BUG-001-description/
│   │   ├── BUG.md                      # Bug report and fix plan
│   │   └── REVIEW.md                   # Bug fix review
│   │
│   └── BUG-XXX-description/            # Pattern: BUG-{ID}-{slug}/
│       ├── BUG.md
│       └── REVIEW.md
│
└── src/                                # Your actual codebase
    └── ...
```

---

## Folder Descriptions

| Folder | Purpose | When Created |
|--------|---------|--------------|
| `skills/` | Cross-platform AI skills (SKILL.md open standard) | Project setup |
| `.cursor-plugin/` | Cursor platform adapter | Project setup |
| `.claude-plugin/` | Claude Code platform adapter | Project setup |
| `.opencode/` | OpenCode platform adapter | Project setup |
| `.cursor/commands/` | Cursor slash commands (run skill + template flow) | Project setup |
| `.framework/steps/` | Step files for `/flow` (BMAD-style menus) | Project setup |
| `.framework/templates/` | Document templates | Project setup |
| `.framework/checklists/` | Checklists (verification-checklist) | Project setup |
| `CONSTITUTION.md` | Project standards | Step 0 (once) |
| `docs/legacy-analysis/` | Stub (legacy placeholder; superseded by the `legacy_ai_analyser` plugin's `docs/ai/` output) | — |
| `docs/ai/` | Brownfield analysis artifacts: `CONSTITUTION.md`, `constitution.json`, `full-analysis-*.md`, `constitution-viewer.html` | Brownfield Step 0 (created by [legacy_ai_analyser](https://github.com/zlatkomq/legacy_ai_analyser)) |
| `specs/XXX/` | Feature specifications | Per spec |
| `bugs/BUG-XXX/` | Bug specifications | Per bug |
| `src/` | Actual code | Implementation |

---

## File Descriptions

### Skills (SKILL.md)

Skills are in the open SKILL.md format — compatible with Cursor 2.4+, Claude Code, OpenCode, Codex, and Gemini CLI. Each skill lives in `skills/<name>/SKILL.md`.

| Skill Directory | Used In | Purpose |
|----------------|---------|---------|
| `skills/constitution-creation/` | Step 0 (once per project) | How AI creates CONSTITUTION.md |
| `skills/spec-creation/` | Step 1 | How AI creates SPEC.md |
| `skills/design-creation/` | Step 2 | How AI creates DESIGN.md |
| `skills/uix-creation/` | Step 3 (optional) | How AI creates UIX-SPEC.md + caches Figma snapshot |
| `skills/task-creation/` | Step 4 | How AI creates TASKS.md |
| `skills/implementation/` | Step 5 (single-task) | How AI writes code for one task |
| `skills/subagent-driven-development/` | Step 5 (multi-task, default) | How `/flow` dispatches a subagent per task |
| `skills/code-review/` | Step 6 | How AI runs adversarial code review |
| `skills/adversarial-review/` | Anytime | How AI reviews any doc with ≥10 issues |
| `skills/bugfixing/` | Bugfix Step 1 | How AI creates BUG.md |
| `skills/bug-implementation/` | Bugfix Step 2 | How AI implements bugfixes |
| `skills/bug-review/` | Bugfix Step 3 | How AI reviews bugfixes |
| `skills/change-request/` | Change request | How AI runs CR workflow (classification, impact, proposal, Amendment History) |
| `skills/systematic-debugging/` | `/debug` | Root-cause investigation before fixing |
| `skills/git-worktrees/` | Step 5 (optional) | Workspace isolation per feature branch |
| `skills/finishing-development-branch/` | After Step 6 | Branch merge / PR / cleanup |

### Templates

| File | Used In | Purpose |
|------|---------|---------|
| `SPEC.template.md` | Step 1 | Structure for specifications |
| `DESIGN.template.md` | Step 2 | Structure for technical design |
| `UIX-SPEC.template.md` | Step 3 | Structure for Figma files + segment → node-id mapping |
| `TASKS.template.md` | Step 4 | Structure for task breakdown |
| `REVIEW.template.md` | Step 6 | Structure for code reviews (Implementation Summary Cross-Reference, Auto-Fix) |
| `BUG.template.md` | Bugfix Step 1 | Structure for bug reports |
| `BUG-REVIEW.template.md` | Bugfix Step 3 | Structure for bug fix reviews |
| `workflow-state.template.md` | `/flow` | State file (stepsCompleted, jiraTicket, sowRef) |
| `CHANGE-PROPOSAL.template.md` | `/change` | Structure for change proposals |
| `SPEC-CURRENT.template.md` | Regeneration | Header/instructions for compiled spec (SPEC + bugs + CRs) |
| `CONSTITUTION.template.md` | Step 0 | Structure for project standards |

### Outputs

| File | Created By | Approved By | Purpose |
|------|------------|-------------|---------|
| `CONSTITUTION.md` | Tech Lead + AI | Tech Lead | Project-wide standards |
| `SPEC.md` | PO/BA + AI | PO/Client | What to build |
| `DESIGN.md` | Developer + AI | Tech Lead | How to build it |
| `UIX-SPEC.md` | Designer/Dev + AI | Tech Lead | Figma files + design segment → node-id mapping + Design Context Artifacts table (optional) |
| `figma/` (directory) | step-02b (or `/uix-refresh`) | — (auto-managed) | Cached design context: `tokens.css`, `<node-id>.md`, `<node-id>.png`, `assets/`, `drift-T*.md`. Single source of truth for steps 4 and 5. Re-fetch only via `/uix-refresh`. |
| `TASKS.md` | Developer + AI | Tech Lead | Implementation steps |
| `BUG.md` | Developer + AI | Tech Lead | Bug report and fix plan |
| `IMPLEMENTATION-SUMMARY.md` | Developer + AI | — (auto-generated) | Implementation record (files, decisions, tests) |
| `REVIEW.md` (features) | Developer + AI | Reviewer | Adversarial code review |
| `REVIEW.md` (bugs) | Developer + AI | Reviewer | Bug fix verification |
| `SPEC-CURRENT.md` | Regeneration (after bug/CR) | — | Compiled spec (SPEC + bugs + amendments) |
| `.workflow-state.md` | `/flow` command | — (auto-managed) | Workflow progress (stepsCompleted, jiraTicket, sowRef) |

---

## Naming Conventions

### Spec Folders

```
{ID}-{slug}/

Examples:
001-user-authentication/
002-password-reset/
003-invoice-export/
042-fix-race-condition/
```

- **ID**: Sequential number, zero-padded (001, 002, ... 042, ... 100)
- **slug**: Lowercase, hyphen-separated, descriptive name
- **Type**: Defined inside SPEC.md (Feature, Bugfix, Refactor, etc.)

### Bug Folders

```
BUG-{ID}-{slug}/

Examples:
BUG-001-safari-validation-fails/
BUG-002-unicode-email-crash/
BUG-003-timeout-on-large-upload/
```

- **Prefix**: Always `BUG-` to distinguish from feature specs
- **ID**: Sequential number within bugs, zero-padded (001, 002, etc.)
- **slug**: Lowercase, hyphen-separated, describes the bug (max 4 words)
- **Links to**: Original SPEC.md in Related Spec field

### Document Files

- Always UPPERCASE for framework documents: `SPEC.md`, `DESIGN.md`, `TASKS.md`, `IMPLEMENTATION-SUMMARY.md`, `REVIEW.md`
- Distinguishes framework docs from regular project docs

### Git Policy

- `.workflow-state.md` is **committed to git** (not .gitignored). It provides team visibility into where each spec is in the workflow. It's a lightweight YAML frontmatter file — no noise in diffs.
- All spec artifacts (`SPEC.md`, `DESIGN.md`, `TASKS.md`, `IMPLEMENTATION-SUMMARY.md`, `REVIEW.md`) are committed.

---

## Greenfield vs Brownfield

### Greenfield (New Project)

```
project/
├── skills/                 ✓ All 16 skills
├── .cursor-plugin/         ✓ Cursor adapter
├── .claude-plugin/         ✓ Claude Code adapter
├── .opencode/              ✓ OpenCode adapter
├── .framework/
│   └── templates/          ✓ All templates
├── CONSTITUTION.md          ✓ Created fresh
├── docs/
│   └── legacy-analysis/    ✗ NOT NEEDED
├── specs/                  ✓ Specs
└── src/                    ✓ New code
```

### Brownfield (Existing Codebase) — ✅ Supported

Brownfield is supported via the companion Cursor plugin **[legacy_ai_analyser](https://github.com/zlatkomq/legacy_ai_analyser)**. The plugin replaces the manual `/constitute` step: it scans the existing code, architecture, APIs, data models, dependencies, and infrastructure, then writes its analysis artifacts under `docs/ai/`. After that, the standard Spec-First workflow (`/flow`, `/specify`, …) runs unchanged.

```
project/
├── skills/                 ✓ All 16 skills (same as greenfield)
├── .cursor-plugin/         ✓ Cursor adapter
├── .claude-plugin/         ✓ Claude Code adapter
├── .opencode/              ✓ OpenCode adapter
├── .framework/
│   └── templates/          ✓ All templates
├── CONSTITUTION.md         ✓ Generated by legacy_ai_analyser (copied / linked from docs/ai/CONSTITUTION.md)
├── docs/
│   └── ai/                 ✓ Created by legacy_ai_analyser
│       ├── CONSTITUTION.md             # Compact brownfield-aware cornerstone (the same content as project-root CONSTITUTION.md)
│       ├── constitution.json           # Machine-readable equivalent
│       ├── full-analysis-YYYY-MM-DD.md # Detailed reference
│       └── constitution-viewer.html    # Interactive UI for browsing the analysis
├── specs/                  ✓ Specs
└── src/                    ✓ Existing + new code
```

**Bootstrap sequence:**

```
# In Cursor, once per project:
/add-plugin zlatkomq/legacy_ai_analyser
/constitution                          # generates docs/ai/CONSTITUTION.md from your existing codebase
# Then continue with the standard workflow:
/flow 001-feature-slug: <requirement>
```

The pre-existing `docs/legacy-analysis/` stub remains for historical compatibility but is not used by the current brownfield flow.

---

## Quick Reference

### What goes where?

| I need to... | Look in... |
|--------------|------------|
| Run workflow via slash commands | `.cursor/commands/` or [Commands & Workflow Example](docs/COMMANDS-WORKFLOW-EXAMPLE.md) |
| Change AI behavior | `skills/<name>/SKILL.md` |
| Change document structure | `.framework/templates/*.template.md` |
| Change step flow (/flow) | `.framework/steps/*.md` |
| Change verification checklist | `.framework/checklists/verification-checklist.md` |
| Check project standards | `CONSTITUTION.md` |
| Understand legacy code (brownfield) | `docs/ai/` — generated by [legacy_ai_analyser](https://github.com/zlatkomq/legacy_ai_analyser) |
| Find requirements | `specs/XXX/SPEC.md` |
| Find technical approach | `specs/XXX/DESIGN.md` |
| Find implementation tasks | `specs/XXX/TASKS.md` |
| Find bug reports | `bugs/BUG-XXX/BUG.md` |
| Find bug fix reviews | `bugs/BUG-XXX/REVIEW.md` |
