# Spec-First Framework: Project Folder Structure

## Complete Structure

```
project/
│
├── .cursor/
│   ├── commands/                       # Cursor slash commands (invoke rules + context)
│   │   ├── constitute.md
│   │   ├── specify.md
│   │   ├── design.md
│   │   ├── tasks.md
│   │   ├── implement.md
│   │   ├── review.md
│   │   ├── flow.md                     # Guided BMAD-style workflow (steps + menus)
│   │   ├── bug.md
│   │   ├── bugfix.md
│   │   ├── bugreview.md
│   │   ├── change.md                   # Change request (scope change) workflow
│   │   └── adversarial.md              # Adversarial review of any document
│   └── rules/
│       ├── spec-creation.mdc           # Rules for creating SPEC.md
│       ├── design-creation.mdc         # Rules for creating DESIGN.md
│       ├── task-creation.mdc           # Rules for creating TASKS.md
│       ├── implementation.mdc          # Rules for implementing code
│       ├── code-review.mdc             # Rules for code review
│       ├── bugfixing.mdc               # Rules for creating BUG.md
│       ├── bug-implementation.mdc      # Rules for implementing bugfixes
│       ├── bug-review.mdc              # Rules for reviewing bugfixes
│       ├── codebase-analysis.mdc       # Rules for analyzing legacy codebase
│       ├── legacy-assessment.mdc       # Rules for assessing tech debt/risks
│       ├── constitution-creation.mdc   # Rules for creating CONSTITUTION.md
│       ├── change-request.mdc          # Rules for change requests (impact, proposal, Amendment History)
│       └── adversarial-review.mdc      # Rules for adversarial doc review (≥10 issues)
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
│   │   ├── definition-of-done.md      # Step 4 DoD before [C] Continue to review
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
| `.cursor/commands/` | Cursor slash commands (run rule + template flow) | Project setup |
| `.cursor/rules/` | AI behavior rules (.mdc files) | Project setup |
| `.framework/steps/` | Step files for `/flow` (BMAD-style menus) | Project setup |
| `.framework/templates/` | Document templates | Project setup |
| `.framework/checklists/` | Checklists (definition-of-done, verification-checklist) | Project setup |
| `.framework/CONSTITUTION.md` | Project standards | Step 0 (once) |
| `docs/legacy-analysis/` | Legacy codebase analysis | Step 0 (brownfield only) |
| `specs/XXX/` | Feature specifications | Per spec |
| `bugs/BUG-XXX/` | Bug specifications | Per bug |
| `src/` | Actual code | Implementation |

---

## File Descriptions

### Rules (.mdc)

| File | Used In | Purpose |
|------|---------|---------|
| `spec-creation.mdc` | Step 1 | How AI creates SPEC.md |
| `design-creation.mdc` | Step 2 | How AI creates DESIGN.md |
| `task-creation.mdc` | Step 3 | How AI creates TASKS.md |
| `implementation.mdc` | Step 4 | How AI writes code |
| `code-review.mdc` | Step 5 | How AI reviews code |
| `bugfixing.mdc` | Bugfix Step 1 | How AI creates BUG.md |
| `bug-implementation.mdc` | Bugfix Step 2 | How AI implements bugfixes |
| `bug-review.mdc` | Bugfix Step 3 | How AI reviews bugfixes |
| `change-request.mdc` | Change request | How AI runs CR workflow (classification, impact, proposal, Amendment History) |
| `adversarial-review.mdc` | Anytime | How AI reviews any doc with ≥10 issues |
| `codebase-analysis.mdc` | Step 0 (legacy) | How AI analyzes existing code |
| `legacy-assessment.mdc` | Step 0 (legacy) | How AI identifies tech debt |
| `constitution-creation.mdc` | Step 0 | How AI creates CONSTITUTION.md |

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
├── .cursor/rules/          ✓ All rules
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
├── .cursor/rules/          ✓ All rules
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
| Change AI behavior | `.cursor/rules/*.mdc` |
| Change document structure | `.framework/templates/*.template.md` |
| Change step flow (/flow) | `.framework/steps/*.md` |
| Change DoD checklist | `.framework/checklists/definition-of-done.md` |
| Check project standards | `.framework/CONSTITUTION.md` |
| Understand legacy code | `docs/legacy-analysis/` |
| Find requirements | `specs/XXX/SPEC.md` |
| Find technical approach | `specs/XXX/DESIGN.md` |
| Find implementation tasks | `specs/XXX/TASKS.md` |
| Find bug reports | `bugs/BUG-XXX/BUG.md` |
| Find bug fix reviews | `bugs/BUG-XXX/REVIEW.md` |
