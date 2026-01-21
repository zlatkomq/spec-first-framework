# Spec-First AI Development Framework: Philosophy & Approach

## The Problem

Developers are using AI coding assistants (Cursor, Copilot, Claude) ad-hoc. Every developer prompts differently, there's no traceability from requirements to code, and quality varies wildly. "Vibe coding" works for prototypes but breaks down for production software.

Most software teams have no systematic approach to AI-assisted development. They're consumers of AI tools, not practitioners of AI methodology.

## The Solution

A structured, spec-first workflow that ensures:
- **Traceability** — Every line of code traces back to a requirement
- **Quality gates** — Human approval at critical checkpoints
- **Consistency** — Same process, same outputs, regardless of which developer or AI model
- **Auditability** — Complete paper trail from requirement to deployed code

## Scope

**This framework is for greenfield projects only.**

A separate repository with adapted rules and additional templates for brownfield/legacy codebases is planned. It will include codebase analysis, legacy assessment, and migration strategy tooling.

## Core Principles

### 1. Spec First, Code Second

Never start coding without a specification. The workflow enforces:

```
Requirements → SPEC.md → DESIGN.md → TASKS.md → Code → Review
```

Each document builds on the previous. Each transition has a human approval gate.

### 2. AI Proposes, Human Approves

AI is a force multiplier, not a replacement for human judgment. The framework uses AI to:
- Draft specifications from requirements
- Generate technical designs from specs
- Break down designs into atomic tasks
- Implement code from tasks
- Review code against acceptance criteria

But humans make the decisions:
- PO approves specifications (Gate 1)
- Tech Lead approves designs (Gate 2)
- Tech Lead approves task breakdowns (Gate 3)
- Reviewer approves final code (Gate 4)

### 3. Trust First, Enforce Later

The initial implementation is trust-based. Developers follow the workflow because it's the right thing to do, not because tooling forces them.

This allows:
- Fast adoption without infrastructure changes
- Learning what works before codifying it
- Flexibility to adapt the process

Later, enforcement can be added:
- CI checks that specs exist before PRs merge
- Automated validation of document structure
- Required approvals in git workflow

### 4. Feature-Level Granularity

The framework operates per-feature, not per-project. This means:
- Works for new projects of any size
- Specs stay focused and manageable
- Parallel work on multiple features is natural
- Scales from solo developers to large teams

### 5. Documents as Source of Truth

All specifications live in the repository alongside code:
- Version controlled
- Reviewable in PRs
- Always up to date
- No external tools required

## What This Framework Is NOT

### Not a Replacement for CI/CD

This framework layers on top of your existing CI/CD pipeline. It doesn't replace linting, testing, deployment, or any other tooling. It adds the specification and traceability layer that's missing.

### Not Tied to Any IDE

Built for Cursor first (using `.mdc` rule files), but the core concepts are portable:
- **Claude Code** — Rules become CLAUDE.md
- **Antigravity** — Rules adapt to their format
- **Any AI assistant** — The templates and workflow work anywhere

The methodology is the asset. The IDE-specific rules are just the implementation.

### Not a Heavy Process

Total framework overhead per feature:
- SPEC.md: 10-20 minutes
- DESIGN.md: 15-30 minutes
- TASKS.md: 10-15 minutes
- Reviews: Built into normal workflow

This is less time than debugging misunderstood requirements or reworking code that didn't meet acceptance criteria.

## Why This Matters

### For Software Teams

- Predictable quality regardless of team composition
- Faster onboarding of new developers
- Clear accountability and traceability
- Reduced rework from misunderstood requirements

### For Product Companies

- Consistent development velocity
- Auditable process for compliance requirements
- Knowledge capture in specifications, not just code
- Reduced bus factor — anyone can pick up a feature

### For Agencies & Consultancies

- Demonstrable process for client confidence
- Standardized methodology across projects
- Productizable offering for enablement services
- Competitive differentiation

### IP Ownership

This framework is yours to own. Unlike adopting third-party tools:
- You control the methodology
- You can evolve it based on learnings
- No vendor dependency
- No licensing fees

### The Reps Compound

Every project run through this framework teaches you what works. That knowledge compounds:
- Refined templates
- Better rules
- Documented patterns
- Trained team

Those who copy later get the framework but not the experience.

## Architecture Decisions

### Why Markdown?

- AI-readable (no parsing required)
- Human-readable (no special tools)
- Git-friendly (diffs, PRs, history)
- Portable (works everywhere)

### Why Separate Rules and Templates?

**Rules** (`.mdc`) define AI behavior — how to fill templates, what constraints to follow, when to ask questions.

**Templates** (`.template.md`) define document structure — what sections exist, what format to use.

This separation allows:
- Updating rules without changing structure
- Different rules for different contexts
- Clear distinction between "how" and "what"

### Why CONSTITUTION.md?

Project-level standards shouldn't repeat in every spec. CONSTITUTION.md captures:
- Tech stack and versions
- Coding conventions
- Testing requirements
- Security standards
- Quality gates

Every other document references it. Change the constitution, change the project standards everywhere.

### Why Human Gates?

AI makes mistakes. Specifications can be misunderstood. Designs can miss edge cases. Without human checkpoints:
- Errors propagate through the pipeline
- Bad assumptions become bad code
- Rework cost multiplies

The gates catch problems early when they're cheap to fix.

## Getting Started

1. **Copy the framework** into your project (`.cursor/` and `.framework/` folders)
2. **Create CONSTITUTION.md** for your project standards
3. **Pick a feature** and run it through the full workflow
4. **Learn and iterate** — refine rules based on what you discover

The first feature will feel slow. By the third feature, it will feel natural. By the tenth, you won't imagine working any other way.

## Roadmap

### Testing Phase Deep-Dive (TODO)

The current framework includes testing as part of TASKS.md and validates test existence in code review. A dedicated testing rules file may be added to:
- Define test structure conventions
- Handle bug discovery during testing
- Integrate with CI/CD test reporting
- Provide test-specific AI guidance

This is under evaluation to determine if it adds value or unnecessary complexity to the agnostic workflow.

### Brownfield Support (Separate Repository)

A dedicated repository for legacy/existing codebases is planned. It will reuse most of the per-feature workflow (SPEC → DESIGN → TASKS → Implementation → Review) but add a layer to the CONSTITUTION.md creation process based on legacy assessment.

Additional components:
- Codebase analysis rules and templates
- Legacy assessment documentation
- "Do not touch" boundary definitions
- Migration strategy tooling
- Extended CONSTITUTION.md with legacy patterns and constraints

### Enforcement Tooling (Planned)

- Pre-commit hooks validating document structure
- CI checks requiring specs before merge
- Automated linking between specs and PRs

### Multi-IDE Support (Planned)

- Claude Code (CLAUDE.md) adaptation
- Antigravity rules format
- Generic prompt templates for any AI

### Jira Integration (Planned)

Connect features to Jira via MCP server for bidirectional sync:
- Link FEAT-XXX specs to Jira tickets
- Sync status changes between TASKS.md and Jira subtasks
- Pull requirements from Jira into SPEC.md
- Push completion status back to Jira
