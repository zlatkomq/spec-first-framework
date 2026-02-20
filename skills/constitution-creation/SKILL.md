# Constitution Creation

## Description

Use when creating or updating the `CONSTITUTION.md` project standards document from a Tech Lead's project description.
Not for feature specifications — use the spec-creation skill. Not for technical design — use the design-creation skill.

## Instructions

You are creating a project constitution document. Follow these rules strictly.

### Required Inputs

Before creating a CONSTITUTION.md, you must have:
- Freeform project description from Tech Lead (tech stack, standards, constraints)

If the input is too vague to fill required sections, ASK for clarification. Do not invent standards.

### Template

Always use the template structure from `../../.framework/templates/CONSTITUTION.template.md`

### Field Rules

#### Metadata
- **Project Name**: Extract from input or ask if unclear
- **Project Type**: GREENFIELD or BROWNFIELD (ask if not specified)
- Status is always DRAFT until Tech Lead approves
- Author: Tech Lead name + "/ AI-assisted"
- Date: today's date

#### Overview
- Maximum 3 sentences
- Must answer: What is this project? What problem does it solve?
- If not provided, ASK — do not invent project purpose

#### Tech Stack
- Every layer mentioned must have a concrete version (e.g., "Python 3.12", not "Python" or "latest")
- If version not specified, ASK
- Common layers: Language, Framework, Database, Testing, Linting
- Add rows for additional tech (ORM, caching, message queue, etc.) if mentioned

#### Coding Standards

**Naming Conventions**
- Must be specific and enforceable (e.g., "snake_case" not "descriptive names")
- Provide concrete examples for each element
- If not specified, propose language-standard conventions and confirm with user

**File Structure**
- Show actual folder tree, not abstract descriptions
- Must reflect the framework's conventions (e.g., FastAPI, Django, Express patterns)
- If not specified, propose standard structure for the chosen framework

**Patterns to Use / Avoid**
- Be specific (e.g., "Repository pattern for data access" not "use good patterns")
- Include at least 2 items in each list
- If not specified, propose common patterns for the tech stack and confirm

#### Testing Standards
- Coverage threshold must be a number (e.g., "80%", not "high")
- Specify test frameworks explicitly
- If not specified, ASK for coverage requirement — do not assume

#### API Standards
- Only include if project has an API
- Error format should be concrete (e.g., "RFC 7807 Problem Details" or show JSON structure)
- If project has no API, remove this section entirely

#### Security Standards
- Must include at least: input validation approach, authentication method (if applicable), secrets handling
- Be specific (e.g., "Use Pydantic for input validation" not "validate inputs")
- If not specified, propose security baseline and confirm

#### Quality Gates
- List concrete checks that must pass before merge
- Typical gates: linting, type checking, unit tests, coverage threshold, security scan
- These should be automatable in CI/CD

#### Open Questions
- Capture any unresolved decisions
- Format as checklist: `- [ ] Question here?`
- These should be resolved before first spec begins

### Constraints

- Do NOT invent project requirements or standards not provided
- Do NOT use vague language ("appropriate", "proper", "good") — be specific
- Do NOT leave placeholder text — ask if info is missing
- Do NOT include brownfield sections (Legacy Boundaries, Migration Strategy) for greenfield projects
- All bracket placeholders from template must be removed from output
- Versions must be concrete (3.12, not "latest")

### Output

Save the file to: `.framework/CONSTITUTION.md`

## Verification

- [ ] All required sections filled (no placeholders)
- [ ] Tech stack has concrete versions
- [ ] Naming conventions have examples
- [ ] Coverage threshold is a specific number
- [ ] Quality gates are actionable
- [ ] Status set to DRAFT
- [ ] File saved in correct location
