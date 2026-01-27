# Changelog

All notable changes to the Spec-First AI Development Framework will be documented in this file.

## [0.4.0] - 2026-01-23

### Summary

First public release of the Spec-First AI Development Framework. This version provides a complete workflow for **greenfield backend API development** using AI-assisted coding.

### What's Included

#### Workflow
- **5-step development process**: SPEC → DESIGN → TASKS → Implementation → Review
- **4 quality gates** with human approval checkpoints
- **Full traceability** from requirements to code

#### Rules (`.cursor/rules/`)
- `spec-creation.mdc` — Create specifications from requirements
- `design-creation.mdc` — Generate technical designs from approved specs
- `task-creation.mdc` — Break designs into atomic, implementable tasks
- `implementation.mdc` — Implement code following standards
- `code-review.mdc` — Review code against acceptance criteria
- `constitution-creation.mdc` — Define project-level standards

#### Templates (`.framework/templates/`)
- `SPEC.template.md` — Specification structure
- `DESIGN.template.md` — Technical design structure
- `TASKS.template.md` — Task breakdown structure
- `CONSTITUTION.template.md` — Project standards structure

#### Example
- Complete 001 User Registration example showing full workflow execution

#### Documentation
- `README.md` — Quick start guide
- `PHILOSOPHY.md` — Framework principles and approach
- `FOLDER-STRUCTURE.md` — Detailed folder and file descriptions
- `WORKFLOW-DEMO.md` — Live walkthrough of the workflow

### Scope & Limitations

**Current version is optimized for:**
- Greenfield projects (new codebases)
- Backend API development (services, APIs, database-backed applications)
- Cursor IDE (using `.mdc` rule files)

**Not yet supported:**
- Frontend/mobile development (planned)
- Brownfield/legacy codebases (planned)
- Other IDEs (Claude Code, Antigravity — planned)
- Enforcement tooling (CI checks, pre-commit hooks — planned)

### How to Adopt

1. Copy `.cursor/` and `.framework/` folders into your project
2. Create `CONSTITUTION.md` using: `@constitution-creation.mdc` + your project description
3. For each spec, follow the workflow: SPEC → DESIGN → TASKS → Implementation → Review

See [README.md](README.md) for detailed instructions.

---

## Planned for Future Releases

### 0.5.0 (Planned)
- Frontend/mobile templates and rules
- Component architecture support
- State management patterns

### 0.6.0 (Planned)
- Brownfield/legacy codebase support
- Codebase analysis rules
- Legacy assessment templates

### 1.0.0 (Planned)
- Production-ready across all domains
- Enforcement tooling
- Multi-IDE support
- Jira integration
