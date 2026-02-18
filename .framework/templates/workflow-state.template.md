---
stepsCompleted: []
specId: ''
specSlug: ''
specFolder: ''
implementationAttempts: 0
jiraTicket: ''
sowRef: ''
fixAttempts: 0
previousIssueCount: 0
fixLoopActive: false
---

Workflow state for this spec. Managed by `/flow` — do not edit manually.

- **stepsCompleted**: Which workflow steps are done (e.g. `['step-01-spec', 'step-02-design']`).
- **implementationAttempts**: Number of times the full implementation has failed the verification gate (0-3). Reset to 0 on fresh entry to step 4 or re-entry from review. Capped at 3 — after 3 failures, route to manual intervention.
- **jiraTicket**: Jira ticket ID linked to this spec (e.g. `PROJ-123`). Set when starting `/flow` or manually.
- **sowRef**: Statement of Work deliverable reference (optional). Links this spec to a contractual deliverable.
- **fixAttempts**: Number of times [F] Fix automatically has been used in the current step 5 session. Resets to 0 on fresh entry or any [B] exit. Capped at 3.
- **previousIssueCount**: Total issue count from the last review run. Used to detect whether auto-fixes are converging (count decreasing) or diverging (count increasing). Resets alongside fixAttempts.
- **fixLoopActive**: Set to `true` by the [F] handler before re-running the review. Section 2 of step 5 checks this flag: if `false`, resets fixAttempts and previousIssueCount (fresh entry). If `true`, preserves them (loop iteration).
