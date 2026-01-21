# Spec-First Framework: Project Folder Structure

## Complete Structure

```
project/
│
├── .cursor/
│   └── rules/
│       ├── spec-creation.mdc           # Rules for creating SPEC.md
│       ├── design-creation.mdc         # Rules for creating DESIGN.md
│       ├── task-creation.mdc           # Rules for creating TASKS.md
│       ├── implementation.mdc          # Rules for implementing code
│       ├── code-review.mdc             # Rules for code review
│       ├── codebase-analysis.mdc       # Rules for analyzing legacy codebase
│       ├── legacy-assessment.mdc       # Rules for assessing tech debt/risks
│       └── constitution-creation.mdc   # Rules for creating CONSTITUTION.md
│
├── .framework/
│   ├── templates/
│   │   ├── SPEC.template.md            # Template structure for specifications
│   │   ├── DESIGN.template.md          # Template structure for technical design
│   │   ├── TASKS.template.md           # Template structure for task breakdown
│   │   ├── CONSTITUTION.template.md    # Template structure for project constitution
│   │   ├── CODEBASE-ANALYSIS.template.md   # Template for codebase analysis (legacy)
│   │   └── LEGACY-ASSESSMENT.template.md   # Template for legacy assessment
│   │
│   └── CONSTITUTION.md                 # Project-level standards (THE source of truth)
│
├── docs/
│   └── legacy-analysis/                # Only for brownfield projects
│       ├── CODEBASE-ANALYSIS.md        # Tech stack, patterns, structure detected
│       └── LEGACY-ASSESSMENT.md        # Tech debt, risks, do-not-touch areas
│
├── specs/
│   ├── FEAT-001-user-authentication/
│   │   ├── SPEC.md                     # What to build
│   │   ├── DESIGN.md                   # How to build it
│   │   └── TASKS.md                    # Implementation breakdown
│   │
│   ├── FEAT-002-password-reset/
│   │   ├── SPEC.md
│   │   ├── DESIGN.md
│   │   └── TASKS.md
│   │
│   └── FEAT-XXX-feature-name/          # Pattern: FEAT-{ID}-{slug}/
│       ├── SPEC.md
│       ├── DESIGN.md
│       └── TASKS.md
│
└── src/                                # Your actual codebase
    └── ...
```

---

## Folder Descriptions

| Folder | Purpose | When Created |
|--------|---------|--------------|
| `.cursor/rules/` | AI behavior rules (.mdc files) | Project setup |
| `.framework/templates/` | Document templates | Project setup |
| `.framework/CONSTITUTION.md` | Project standards | Step 0 (once) |
| `docs/legacy-analysis/` | Legacy codebase analysis | Step 0 (brownfield only) |
| `specs/FEAT-XXX/` | Feature specifications | Per feature |
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
| `codebase-analysis.mdc` | Step 0 (legacy) | How AI analyzes existing code |
| `legacy-assessment.mdc` | Step 0 (legacy) | How AI identifies tech debt |
| `constitution-creation.mdc` | Step 0 | How AI creates CONSTITUTION.md |

### Templates

| File | Used In | Purpose |
|------|---------|---------|
| `SPEC.template.md` | Step 1 | Structure for specifications |
| `DESIGN.template.md` | Step 2 | Structure for technical design |
| `TASKS.template.md` | Step 3 | Structure for task breakdown |
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

---

## Naming Conventions

### Feature Folders

```
FEAT-{ID}-{slug}/

Examples:
FEAT-001-user-authentication/
FEAT-002-password-reset/
FEAT-003-invoice-export/
FEAT-042-dashboard-redesign/
```

- **ID**: Sequential number, zero-padded (001, 002, ... 042, ... 100)
- **slug**: Lowercase, hyphen-separated, descriptive name

### Document Files

- Always UPPERCASE for framework documents: `SPEC.md`, `DESIGN.md`, `TASKS.md`
- Distinguishes framework docs from regular project docs

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
├── specs/                  ✓ Feature specs
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
├── specs/                  ✓ Feature specs
└── src/                    ✓ Existing + new code
```

---

## Quick Reference

### What goes where?

| I need to... | Look in... |
|--------------|------------|
| Change AI behavior | `.cursor/rules/*.mdc` |
| Change document structure | `.framework/templates/*.template.md` |
| Check project standards | `.framework/CONSTITUTION.md` |
| Understand legacy code | `docs/legacy-analysis/` |
| Find feature requirements | `specs/FEAT-XXX/SPEC.md` |
| Find technical approach | `specs/FEAT-XXX/DESIGN.md` |
| Find implementation tasks | `specs/FEAT-XXX/TASKS.md` |
