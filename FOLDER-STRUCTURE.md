# Spec-First Framework: Project Folder Structure

## Complete Structure

```
project/
│
├── skills/                             # Canonical cross-platform skill files (SKILL.md open standard)
│   ├── spec-creation/SKILL.md          # How AI creates SPEC.md
│   ├── constitution-creation/SKILL.md  # How AI creates CONSTITUTION.md
│   ├── design-creation/SKILL.md        # How AI creates DESIGN.md
│   ├── task-creation/SKILL.md          # How AI creates TASKS.md
│   ├── implementation/SKILL.md         # How AI writes code
│   ├── code-review/SKILL.md            # How AI reviews code
│   ├── adversarial-review/SKILL.md     # How AI reviews any doc with ≥10 issues
│   ├── bugfixing/SKILL.md              # How AI creates BUG.md
│   ├── bug-implementation/SKILL.md     # How AI implements bugfixes
│   ├── bug-review/SKILL.md             # How AI reviews bugfixes
│   └── change-request/SKILL.md         # How AI runs change request workflow
│
├── .cursor-plugin/
│   └── plugin.json                     # Cursor platform adapter (skills path)
├── .claude-plugin/
│   └── plugin.json                     # Claude Code platform adapter (skills path)
├── .opencode/
│   ├── plugins/
│   │   └── spec-first.js               # OpenCode ES Module plugin (system prompt injection)
│   └── INSTALL.md                      # Manual setup instructions (symlink plugin + skills)
│
├── .cursor/
│   └── commands/                       # Cursor slash commands (invoke skills + context)
│       ├── constitute.md
│       ├── specify.md
│       ├── design.md
│       ├── tasks.md
│       ├── implement.md
│       ├── review.md
│       ├── flow.md                     # Guided BMAD-style workflow (steps + menus)
│       ├── bug.md
│       ├── bugfix.md
│       ├── bugreview.md
│       ├── change.md                   # Change request (scope change) workflow
│       ├── adversarial.md              # Adversarial review of any document
│       └── validate.md                 # Framework integrity check
│
├── .framework/
│   ├── steps/                          # BMAD-style step files for /flow
│   │   ├── step-00-continue.md         # Resume logic
│   │   ├── step-01-spec.md
│   │   ├── step-02-design.md
│   │   ├── step-03-tasks.md
│   │   ├── step-04-implement.md
│   │   └── step-05-review.md
│   ├── templates/
│   │   ├── SPEC.template.md            # Template structure for specifications
│   │   ├── DESIGN.template.md          # Template structure for technical design
│   │   ├── TASKS.template.md           # Template structure for task breakdown
│   │   ├── CONSTITUTION.template.md    # Template structure for project constitution
│   │   ├── BUG.template.md             # Template for bug reports
│   │   ├── REVIEW.template.md          # Template for code review (incl. Implementation Summary Cross-Reference, Auto-Fix)
│   │   ├── BUG-REVIEW.template.md      # Template for bug review
│   │   ├── workflow-state.template.md  # State file template for /flow (jiraTicket, sowRef)
│   │   ├── CHANGE-PROPOSAL.template.md # Template for change proposals (classification, impact)
│   │   ├── SPEC-CURRENT.template.md    # Template for compiled spec (SPEC + bugs + CRs)
│   │   ├── CODEBASE-ANALYSIS.template.md   # Template for codebase analysis (legacy)
│   │   └── LEGACY-ASSESSMENT.template.md   # Template for legacy assessment
│   ├── checklists/
│   │   └── verification-checklist.md  # Step 4 verification gate after implementation
│   └── CONSTITUTION.md                 # Project-level standards (THE source of truth)
│
├── docs/
│   └── legacy-analysis/                # Only for brownfield projects
│       ├── CODEBASE-ANALYSIS.md        # Tech stack, patterns, structure detected
│       └── LEGACY-ASSESSMENT.md        # Tech debt, risks, do-not-touch areas
│
├── specs/
│   ├── 001-user-authentication/
│   │   ├── .workflow-state.md          # Workflow progress (created by /flow, committed to git)
│   │   ├── SPEC.md                     # What to build
│   │   ├── DESIGN.md                   # How to build it
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
│       ├── .workflow-state.md          # Tracks stepsCompleted + implementationAttempts
│       ├── SPEC.md
│       ├── DESIGN.md
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
| `.framework/CONSTITUTION.md` | Project standards | Step 0 (once) |
| `docs/legacy-analysis/` | Legacy codebase analysis | Step 0 (brownfield only) |
| `specs/XXX/` | Feature specifications | Per spec |
| `bugs/BUG-XXX/` | Bug specifications | Per bug |
| `src/` | Actual code | Implementation |

---

## File Descriptions

### Skills (SKILL.md)

Skills are in the open SKILL.md format — compatible with Cursor 2.4+, Claude Code, OpenCode, Codex, and Gemini CLI. Each skill lives in `skills/<name>/SKILL.md`.

| Skill Directory | Used In | Purpose |
|----------------|---------|---------|
| `skills/spec-creation/` | Step 1 | How AI creates SPEC.md |
| `skills/design-creation/` | Step 2 | How AI creates DESIGN.md |
| `skills/task-creation/` | Step 3 | How AI creates TASKS.md |
| `skills/implementation/` | Step 4 | How AI writes code |
| `skills/code-review/` | Step 5 | How AI reviews code |
| `skills/bugfixing/` | Bugfix Step 1 | How AI creates BUG.md |
| `skills/bug-implementation/` | Bugfix Step 2 | How AI implements bugfixes |
| `skills/bug-review/` | Bugfix Step 3 | How AI reviews bugfixes |
| `skills/change-request/` | Change request | How AI runs CR workflow (classification, impact, proposal, Amendment History) |
| `skills/adversarial-review/` | Anytime | How AI reviews any doc with ≥10 issues |
| `skills/constitution-creation/` | Step 0 | How AI creates CONSTITUTION.md |

### Templates

| File | Used In | Purpose |
|------|---------|---------|
| `SPEC.template.md` | Step 1 | Structure for specifications |
| `DESIGN.template.md` | Step 2 | Structure for technical design |
| `TASKS.template.md` | Step 3 | Structure for task breakdown |
| `REVIEW.template.md` | Step 5 | Structure for code reviews (Implementation Summary Cross-Reference, Auto-Fix) |
| `BUG.template.md` | Bugfix Step 1 | Structure for bug reports |
| `BUG-REVIEW.template.md` | Bugfix Step 3 | Structure for bug fix reviews |
| `workflow-state.template.md` | `/flow` | State file (stepsCompleted, jiraTicket, sowRef) |
| `CHANGE-PROPOSAL.template.md` | `/change` | Structure for change proposals |
| `SPEC-CURRENT.template.md` | Regeneration | Header/instructions for compiled spec (SPEC + bugs + CRs) |
| `CONSTITUTION.template.md` | Step 0 | Structure for project standards |
| `CODEBASE-ANALYSIS.template.md` | Step 0 (legacy) | Structure for codebase analysis |
| `LEGACY-ASSESSMENT.template.md` | Step 0 (legacy) | Structure for tech debt assessment |

### Outputs

| File | Created By | Approved By | Purpose |
|------|------------|-------------|---------|
| `CONSTITUTION.md` | Tech Lead + AI | Tech Lead | Project-wide standards |
| `CODEBASE-ANALYSIS.md` | Developer + AI | Tech Lead | Legacy codebase documentation |
| `LEGACY-ASSESSMENT.md` | Developer + AI | Tech Lead | Tech debt inventory |
| `SPEC.md` | PO/BA + AI | PO/Client | What to build |
| `DESIGN.md` | Developer + AI | Tech Lead | How to build it |
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
├── skills/                 ✓ All 11 skills
├── .cursor-plugin/         ✓ Cursor adapter
├── .claude-plugin/         ✓ Claude Code adapter
├── .opencode/              ✓ OpenCode adapter
├── .framework/
│   ├── templates/          ✓ All templates
│   └── CONSTITUTION.md     ✓ Created fresh
├── docs/
│   └── legacy-analysis/    ✗ NOT NEEDED
├── specs/                  ✓ Specs
└── src/                    ✓ New code
```

### Brownfield (Existing Codebase)

```
project/
├── skills/                 ✓ All 11 skills
├── .cursor-plugin/         ✓ Cursor adapter
├── .claude-plugin/         ✓ Claude Code adapter
├── .opencode/              ✓ OpenCode adapter
├── .framework/
│   ├── templates/          ✓ All templates
│   └── CONSTITUTION.md     ✓ Created from analysis
├── docs/
│   └── legacy-analysis/    ✓ REQUIRED
│       ├── CODEBASE-ANALYSIS.md
│       └── LEGACY-ASSESSMENT.md
├── specs/                  ✓ Specs
└── src/                    ✓ Existing + new code
```

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
| Check project standards | `.framework/CONSTITUTION.md` |
| Understand legacy code | `docs/legacy-analysis/` |
| Find requirements | `specs/XXX/SPEC.md` |
| Find technical approach | `specs/XXX/DESIGN.md` |
| Find implementation tasks | `specs/XXX/TASKS.md` |
| Find bug reports | `bugs/BUG-XXX/BUG.md` |
| Find bug fix reviews | `bugs/BUG-XXX/REVIEW.md` |
