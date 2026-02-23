# change

Handle a scope change or change request for an existing spec. Produces a Change Proposal document with impact analysis and, on approval, updates affected artifacts.

## Usage

`/change {spec_reference}` — where `{spec_reference}` is a spec ID (e.g. `001`), slug (e.g. `001-user-registration`), or folder path.

Optionally include a Jira ticket reference after a colon:

`/change 001: PROJ-456` — loads the spec and uses the Jira ticket for classification check.

## 1. Parse user input

- Split on colon (`:`): before = spec reference, after = Jira ticket ID or change description.
- Parse spec reference to extract `spec_id` and `spec_slug` (same logic as `/flow`).

## 2. Resolve spec folder

- Search `specs/` for a folder matching `{spec_id}`.
- If not found: "No spec folder found for {spec_id}. Cannot create a change request without an existing spec." STOP.
- Verify SPEC.md exists in the folder. If not: STOP.

## 3. Load context

- Read `{spec_folder}/SPEC.md` (acceptance criteria, scope, Bug History, Amendment History).
- Read `{spec_folder}/DESIGN.md` (if exists).
- Read `{spec_folder}/TASKS.md` (if exists).
- Read `CONSTITUTION.md` for project standards.

## 4. Apply rules

Apply @skills/change-request/SKILL.md — this handles:
- Classification check (if Jira ticket provided)
- Change analysis and impact assessment
- Change Proposal generation
- Approval and artifact updates
- Amendment History population
- SPEC-CURRENT.md regeneration

## Reference

- Skill: `skills/change-request/SKILL.md`
- Template: `.framework/templates/CHANGE-PROPOSAL.template.md`
- Output: `{spec_folder}/CHANGE-PROPOSAL-{date}.md`
