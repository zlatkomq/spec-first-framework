# Change Proposal

## Metadata

| Field | Value |
|-------|-------|
| CR ID | CR-XXX |
| Related Spec | [FEAT-XXX](../specs/XXX-name/SPEC.md) |
| Status | PROPOSED / APPROVED / REJECTED |
| Requested By | |
| Date | |
| Approved By | |
| Approval Date | |
| Scope Classification | Minor / Moderate / Major |
| Jira Ticket | |

---

## Classification Verification

| Check | Result |
|-------|--------|
| Jira ticket provided | Yes / No |
| Matches existing AC violation | Yes (Bug) / No (CR) |
| Classification confirmed | Yes |

<!-- IF classification mismatch was flagged: document the resolution here. -->

---

## Issue Summary

**What changed:** [Clear description of the requested change]

**Why:** [Business or technical reason]

**Trigger category:** [Technical limitation / New requirement / Misunderstanding / Strategic pivot / Failed approach]

**Evidence:** [Client email, meeting notes, technical findings, etc.]

---

## Impact Analysis

### SPEC.md Impact

| Section | Impact | Description |
|---------|--------|-------------|
| Acceptance Criteria | Added / Modified / Removed / None | [details] |
| Scope | Changed / None | [details] |
| User Stories | Changed / None | [details] |

### DESIGN.md Impact

| Section | Impact | Description |
|---------|--------|-------------|
| Architecture | Changed / None | [details] |
| Data Model | Changed / None | [details] |
| API / Interfaces | Changed / None | [details] |

### TASKS.md Impact

| Section | Impact | Description |
|---------|--------|-------------|
| Tasks | Added / Modified / Removed / None | [details] |
| Testing | Changed / None | [details] |

#### Per-Task Impact (if implementation is in progress)

<!-- Include only if tasksCompleted is non-empty in workflow state -->

| Task | Status Before CR | Classification | Reason |
|------|-----------------|----------------|--------|
| T1: [description] | Completed / Not started | UNAFFECTED / INVALIDATED / REMOVED | [reason] |

**Summary**: {N} of {M} completed tasks remain valid. {K} will be reset.

### Downstream Impact

- Completed implementation affected: [Yes (describe) / No]
- Filed bugs affected: [Yes (list) / No]
- Definition of Done changed: [Yes (describe) / No]

---

## Recommended Approach

**Selected option:** [Direct Adjustment / Partial Rollback / Scope Reduction]

**Rationale:** [Why this approach over alternatives]

**Effort estimate:** [Low / Medium / High]

**Risk level:** [Low / Medium / High]

---

## Detailed Change Proposals

### Change 1: [Artifact — Section]

**OLD:**
```
[current content]
```

**NEW:**
```
[proposed content]
```

**Rationale:** [why]

### Change 2: [Artifact — Section]

**OLD:**
```
[current content]
```

**NEW:**
```
[proposed content]
```

**Rationale:** [why]

---

## Implementation Handoff

**For Minor scope:**
- Developer implements changes directly
- Resume `/flow` from the affected step

**For Moderate scope:**
- PM/Tech Lead reviews proposal before implementation
- May require going back to Design (step 2) or Tasks (step 3)

**For Major scope:**
- Architecture rethink required
- Go back to Spec (step 1) or Design (step 2)
- May require new `/flow` session

---

## Post-Approval Actions

- [ ] SPEC.md updated with approved changes
- [ ] DESIGN.md updated (if affected)
- [ ] TASKS.md updated (if affected)
- [ ] Amendment History entry added to SPEC.md:
      `| CR-XXX | [date] | [description] | [approver] |`
- [ ] SPEC-CURRENT.md regenerated
