# Task Breakdown

## Metadata

| Field | Value |
|-------|-------|
| ID | XXX |
| Name | |
| Status | DRAFT / APPROVED |
| Author | |
| Date | |
| Approved By | |
| Approval Date | |
| Jira Ticket | |

---

## Overview

[Brief summary of implementation approach from DESIGN.md]

---

## Tasks

- [ ] T1: [description] (DESIGN: [section])
  - Produces: `[ClassName.method(param: Type) -> ReturnType]`
- [ ] T2: [description] (DESIGN: [section])
  - Consumes: T1.[ComponentName]
  - Produces: `[ClassName.method(param: Type) -> ReturnType]`
- [ ] T3: [description] (DESIGN: [section])
  - Consumes: T1.[ComponentName], T2.[ComponentName]
  - Produces: `[endpoint or interface]`
- [ ] T4: [description] (DESIGN: [section])

Produces/Consumes only required for tasks with inter-task dependencies. Consumes references use task ID (e.g. T1.UserRepository), not duplicated signatures.

Task markers: `[ ]` not started | `[x]` complete (verified)

---

## Testing

- [ ] Tx: Unit tests for [component/logic]
- [ ] Tx: Unit tests for [component/logic]
- [ ] Tx: Integration test for [flow/feature]

Write "No integration tests required." only if DESIGN.md explicitly states this is a purely isolated component.

Unit tests are always mandatory - never skip this section.

---

## Previous Spec Learnings

[Populated from the most recent completed spec's REVIEW.md and IMPLEMENTATION-SUMMARY.md. Leave empty if first spec.]

- Patterns established in prior specs
- Review feedback to apply
- Code reuse opportunities

---

## References

[Cite all technical details with source paths and sections]

- [Source: DESIGN.md#Section] for each technical detail referenced in tasks

---

## Definition of Done

- [ ] All tasks completed (T1-Tx)
- [ ] All tests passing
- [ ] Test coverage meets CONSTITUTION.md threshold
- [ ] Code reviewed and approved
- [ ] No open questions remaining

