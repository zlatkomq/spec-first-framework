# FAQ

Common questions about the Spec-First Framework and its companion tools.

---

## Why are you not using Figma's official Dev Mode MCP?

| Dimension | Figma Dev Mode MCP | Our `figma-to-code` MCP | Why it matters |
|---|---|---|---|
| **License** | Closed, part of Figma's product | MIT, open-source, self-hosted | You can audit, modify, fork — you own the contract |
| **Per-dev cost** | Desktop variant needs a Dev seat ($12–35/dev/month); remote is free but beta | Zero per-dev. One server-side Figma token covers any team size | No per-user licence; one cost, any team size |
| **Beta / future pricing** | Both variants are in beta. Write features explicitly become **paid usage-based** at GA. | Stable. No usage tiers, no future pricing changes from a vendor. | No surprise bills when Figma productionises beta features |
| **Output format** | Generic design data — built for human designer-to-developer handoff | Canonical JSX with fixed prop order + token-constraints header + code-gen rules footer. Tuned for small / OS LLMs (Qwen, Gemma). | Cheaper LLM bills + better generated code, especially on open-source models |
| **Cache contract** | Real-time fetch endpoint, no on-disk semantics | Fetch-once → save to disk → re-fetch only via explicit `/uix-refresh` | Deterministic workflow; step 5 (implement) and step 6 (review) read from disk, never call the MCP |

**Summary:** Figma's MCP is a fine general-purpose endpoint. Ours is purpose-built for Spec-First — open-source, no per-developer seat cost, output format tuned for AI code generation, and an on-disk cache contract that makes the whole workflow deterministic. We don't pay Figma for MCP access, and we're not exposed to whatever they decide to charge for the write features when they leave beta.

### Tradeoffs we acknowledge

- **We maintain it.** Figma's MCP gets updates from Figma automatically. Ours needs occasional maintenance when the Figma REST API changes (rare on read endpoints).
- **No Figma-native auth integration.** Ours uses a server-side Personal Access Token; theirs uses your Figma session.
- **Feature parity drift.** If Figma ships a new MCP capability we'd need to add it; theirs gets it for free.

### When would we switch back to Figma's official MCP?

If Figma's official MCP adds (a) a deterministic on-disk cache contract, (b) an output format tuned for LLM code generation rather than human designer-developer handoff, and (c) a plan-tier-neutral access model, the calculus changes. For now, ours fits the workflow better.

---

## Does Spec-First run tasks in parallel or sequentially?

**Sequential — one task at a time, by design.** Each task does get a fresh subagent (no context pollution between tasks), but the controller dispatches them **strictly in order**, fully completing one before starting the next.

### Per-task pipeline

```
For each task in TASKS.md (in declared order):
  1. Implementer subagent       — writes code + tests (TDD)
  2. Spec reviewer subagent     — verifies AC traceability, Produces/Consumes
  3. Quality reviewer subagent  — verifies CONSTITUTION compliance + code quality
  4. Regression-guard test run  — confirms previous tasks still pass
  5. Log anchor entry to IMPLEMENTATION-SUMMARY.md
  6. Mark complete in TodoWrite
  → only THEN: next task starts
```

### Why not parallel?

The framework explicitly forbids parallel dispatch in `skills/subagent-driven-development/SKILL.md` (Red Flags — Never): *"Dispatch multiple implementation subagents in parallel (conflicts)."* Three concrete reasons:

| Risk if parallel | What sequential gives us |
|---|---|
| Tasks share files / branch → write conflicts | Clean working tree per task; previous task is committed before next begins |
| Produces/Consumes dependencies (task N uses what task N-1 produced) | Each subagent reads IMPLEMENTATION-SUMMARY.md before starting — needs prior task DONE |
| Quality review of task N could be invalidated by task N+1 changing a shared file | Reviewer sees a stable snapshot per task |
| Failure isolation is hard (which agent broke what?) | A failing task halts the next; bisection is trivial |

### What "subagent-driven" actually buys

Fresh **context** per task, not parallelism. The big win is:

- **No accumulated context drift** — task 5's implementer doesn't have task 1's irrelevant context in its working memory
- **Per-task review gates** — issues caught immediately, not at end-of-spec
- **Cheaper LLM bills on long specs** — short fresh contexts cost less than one huge accumulated one
- **Cleaner audit trail** — each task's subagent IDs, reviewer reports, and gate outcomes are logged independently in IMPLEMENTATION-SUMMARY.md

### When parallelism *does* happen in Spec-First

- **Across separate specs** — you can run `/flow 001` and `/flow 002` in two different git worktrees on two different machines (or two Cursor windows). The `git-worktrees` skill is built for exactly this isolation.
- **Across separate projects** — different repos, different framework instances, no shared state.

Within a single spec's implementation phase, tasks are serial. That's the design.

---

## What if the AI writes wrong or hallucinated code?

The framework assumes the AI will sometimes be wrong — that's exactly why the workflow exists. Defences kick in at every stage:

| Defence | Where it lives | What it catches |
|---|---|---|
| TDD iron law | `skills/implementation/SKILL.md` | Failing test must exist before any production code. Code written first is deleted and restarted. |
| Per-task spec review | `skills/subagent-driven-development/SKILL.md` | AC traceability, Produces/Consumes contracts, no over- or under-build |
| Per-task quality review | Same skill | CONSTITUTION compliance, code quality, naming, error handling |
| Regression guard | After every quality fix | Full test suite must still pass before the next task |
| Verification checklist | `.framework/checklists/verification-checklist.md` | After all tasks: tests green, lint clean, type-check clean, scope intact, no HALT conditions, IMPLEMENTATION-SUMMARY.md complete |
| Code review (step 6) | `skills/code-review/SKILL.md` | Adversarial review of actual source against SPEC/DESIGN/TASKS. Verdict policy: <3 issues = re-examine, 3–10 = CHANGES REQUESTED, >10 = BLOCKED |
| Adversarial review | `/adversarial` command | On-demand extreme-skepticism review for any artifact; finds ≥10 issues mandatory |

The single most important guarantee: **no code ships without explicit human approval at every gate.** The AI never auto-merges.

---

## What's the failure mode when the agent gets stuck?

Bounded and explicit. Every gate has a 3-attempt limit:

- **Implementation gate failure (3×)** → manual intervention. The framework reports the failure mode and the task it was attempting; the user decides next steps.
- **Spec review failure (3×)** → HALT. Recommendation: revisit TASKS.md or SPEC.md (problem is likely in the spec, not the implementation).
- **Quality review failure (3×)** → HALT. Recommendation: revisit DESIGN.md (likely an architectural issue).
- **Auto-fix loop in code review (3×)** → escalation menu with classification: diverging / converging / churning. The framework explicitly names which pattern it's stuck in.

A separate path exists for "I need to investigate, not fix" — the `/debug` command + `skills/systematic-debugging/SKILL.md`. Phase 1 forbids any fix until root cause is named; instrumentation comes before analysis; one variable changes at a time. Use `/debug` *before* `/bug` when you need investigation rather than a formal bug report.

The framework never silently retries indefinitely. Every halt is visible and surfaces the situation to the user.

---

## How is this different from Cursor / Copilot / using AI directly?

Cursor and Copilot are **autocomplete + freeform chat**: ask, get code, ship. No mandatory artifact. No traceability. No gates. No review trail. Fast for prototypes; problematic for anything that needs auditing or shared responsibility across humans.

Spec-First wraps the same AI with:

- **Mandatory artifacts** — SPEC, DESIGN, UIX, TASKS, IMPLEMENTATION-SUMMARY, REVIEW live in your repo, in git, reviewable in PRs
- **Approval gates** — `Approved By` / `Approval Date` / `Jira Ticket` captured at every gate; the AI can't proceed without explicit human input
- **Traceability** — every line of code traces to a TASK, which traces to an AC, which traces to a SPEC. `git log --grep="(FEAT-001)"` finds everything for a feature
- **Subagent isolation** — fresh context per task, two-stage review, no accumulated context confusion
- **Verification gate** — tests, lint, type-check, scope intact before review is even allowed

The deliverable is *reviewable, auditable artifacts*. The code is a byproduct.

If you're shipping prototypes alone, autocomplete is enough. If multiple humans need to share responsibility for what shipped, Spec-First is what fills the gap.

---

## Are we locked into Cursor or any specific AI vendor?

No. The framework runs on the **SKILL.md** open standard with thin plugin adapters per editor host:

| Editor | Status |
|---|---|
| Cursor 2.4+ | First-class — plugin via marketplace |
| Claude Code | First-class — plugin via marketplace |
| OpenCode | Supported via manual plugin registration |
| Codex CLI | Supported via manual setup (symlink `.agents/skills` → `../skills`, optional `AGENTS.md` orientation file) — see [README → Step 1 → Codex](../README.md#codex-manual-setup) |
| Any MCP-compatible editor | Templates and step files are plain Markdown — works anywhere |

Vendor coupling is **at the editor layer**, not the framework. Switch editors without touching specs, designs, or any deliverable. The `figma-to-code` MCP runs locally / self-hosted, so swapping editors doesn't break design extraction either.

For the **LLM provider**: the framework doesn't talk to LLM APIs directly — it ships skills the editor's agent runs. Whatever models the editor supports (Claude, GPT, Gemini, Qwen, Llama, etc.) work, and you can swap models without changing anything in the framework.

---

## Where does our code go? Any privacy / security concerns?

Your code stays in your repo. The framework does not exfiltrate anything.

**External calls in normal operation:**

| Service | What it sees | Where it lives |
|---|---|---|
| Your LLM provider (whichever Cursor / Claude / OpenCode is configured for) | Whatever files you point the agent at, plus prompts | Your provider's privacy terms apply — pick a provider with the data-handling guarantees you need |
| `figma-to-code` MCP server | Your Figma file content (via Figma's REST API) | **Self-hosted by your team** — you control where it runs |
| Cursor Reporting backend | Hook telemetry: model, tokens, command, timing — **not your code** | **Self-hosted by your team** — runs anywhere |
| `legacy_ai_analyser` (brownfield only) | Your codebase scan | Runs locally inside Cursor as a plugin |

**External calls the framework does NOT make:**

- No phone-home telemetry to the framework's authors
- No automatic upload to any third-party service
- No license check or online activation

Compatible with **air-gapped, VPN-only, and on-premise** deployments. The only external dependency is whatever LLM provider you choose, and that's swappable at the editor level.

**Secrets:** standard `.gitignore` / `.cursorignore` rules apply. CONSTITUTION.md should explicitly list "no secrets in code" so the AI enforces it during code review and adversarial review.

---

## How is this different from BMAD-METHOD or GitHub Spec-Kit?

**vs BMAD-METHOD:** BMAD inspired the `/flow` + step-files + numbered-menus pattern. Spec-First Framework is "BMAD adapted for AI coding agents" — same discipline, different audience. Specifically, Spec-First adds:

- Skills format (SKILL.md cross-editor open standard) instead of BMAD's persona-driven prompts
- BMAD-fusion agency metadata: `Approved By`, `Approval Date`, `Jira Ticket`, `SOW Ref` on every gate
- Subagent-per-task model with fresh context + two-stage review
- Figma MCP integration with cached snapshot
- `/change` workflow with bug-vs-CR classification check
- Verification checklist with HARD-GATE conditions before review can run

**vs GitHub Spec-Kit:** Spec-Kit focuses on the SPEC artifact itself and conventions for writing it. Spec-First also wires implementation and review gates, and treats the SPEC as one link in a 6-step traced chain (CONSTITUTION → SPEC → DESIGN → UIX → TASKS → IMPLEMENTATION-SUMMARY → REVIEW). If Spec-Kit's SPEC format becomes a standard, Spec-First can align its `SPEC.template.md` to it without changing the rest of the pipeline.

**vs `.cursor/rules` files / Cursor agents alone:** rules are static AI behavior modifiers. Spec-First is workflow + artifacts + gates. You can use rules WITH Spec-First — they're complementary.

---

## How should we migrate from a previous BMAD-fusion rules-based workflow to the current main (v1.2.0)?

**TL;DR — the migration is reversible, takes ~1 hour per project, and your existing specs keep working untouched.** The methodology, artifacts, and gates are identical to what you have today. What changed is the *file format* the AI reads its own instructions from (`.cursor/rules/*.mdc` → cross-editor `skills/<name>/SKILL.md`), plus the addition of new companion deliverables (Figma flow, reporting, brownfield bootstrap).

### What stays the same — existing specs work as-is

- Every artifact in `specs/XXX/` and `bugs/BUG-XXX/` keeps working — `SPEC.md`, `DESIGN.md`, `TASKS.md`, `REVIEW.md`, `BUG.md` formats are unchanged
- `/flow` workflow, gate semantics, and approval pattern are unchanged
- BMAD-fusion agency metadata (`Approved By`, `Approval Date`, `Jira Ticket`, `SOW Ref`) preserved on every artifact
- `CONSTITUTION.md` format is unchanged
- Step file numbering shifts only because **step 3 is new** (UIX, optional) — old `step-04-implement.md` and `step-05-review.md` filenames are preserved; only the user-visible "Step N of 6" labels changed
- Your customisations to `specs/`, `bugs/`, and `CONSTITUTION.md` are preserved by `spec-first update`

### What changes

| Concern | Before (rules era) | After (v1.2.0 main) |
|---|---|---|
| AI instruction format | `.cursor/rules/*.mdc` (Cursor-specific) | `skills/<name>/SKILL.md` (cross-editor open standard) |
| Invocation | `@constitution-creation.mdc` | `/constitute` slash command (or `$constitute` in Codex) |
| Editor support | Cursor only | Cursor / Claude Code / OpenCode / Codex (manual setup) |
| Figma handoff | Manual | New optional step 2b: `/uix` + cached `figma/` snapshot |
| Telemetry | None | Cursor Reporting (optional, self-hosted) |
| Brownfield bootstrap | Manual `/constitute` | Optional [`legacy_ai_analyser`](https://github.com/zlatkomq/legacy_ai_analyser) plugin |

### Migration sequence (per project, ~1 hour)

```bash
# 1. Branch off and snapshot the current state — your rollback point
git checkout -b pre-spec-first-1.2.0-backup
git add -A && git commit -m "Snapshot before Spec-First 1.2.0 migration"
git push -u origin pre-spec-first-1.2.0-backup
git checkout main

# 2. Update the CLI to v0.6+
sudo curl -fsSL https://raw.githubusercontent.com/zlatkomq/spec-first-framework/main/spec-first.sh \
  -o /usr/local/bin/spec-first && sudo chmod +x /usr/local/bin/spec-first

# 3. Pull the new framework files into the project
#    Preserves:  specs/, bugs/, CONSTITUTION.md, .workflow-state.md files
#    Replaces:   .framework/templates/, .framework/steps/, .framework/checklists/,
#                skills/, .cursor/commands/, .cursor-plugin/, .claude-plugin/,
#                .opencode/, docs/, mcp.json, README, FOLDER-STRUCTURE, …
spec-first update

# 4. Remove the old rules directory — superseded by skills/
rm -rf .cursor/rules

# 5. Install the editor plugin (one-time per machine)
#    Cursor:
/add-plugin zlatkomq/spec-first-framework
#    Or Claude Code:
claude plugin marketplace add zlatkomq/spec-first-framework
claude plugin install spec-first-framework@spec-first-framework --scope project

# 6. (Optional) Deploy figma-to-code MCP if you want the new UIX flow.
#    See github.com/zlatkomq/figma-mcp

# 7. Smoke test: open the editor and resume any existing spec
/flow 001                              # should pick up where you left off
```

### In-flight work mid-migration

| Spec state | Recommendation |
|---|---|
| At a gate, waiting for approval | Just approve and `/flow {spec-id}` continues on the new framework — no special handling |
| Mid-implementation, some tasks `[x]` | Finish on the new framework — `subagent-driven-development` is a strict superset of the old behaviour; existing `IMPLEMENTATION-SUMMARY.md` entries remain valid input |
| UI work pending but no `UIX-SPEC.md` exists | The new step 2b is optional — pick `[S] Skip UIX` and continue exactly as before. To add a UIX-SPEC to a finished spec retroactively, run `/uix {spec-id}` standalone. |

### Common gotchas

- **"Cursor doesn't see my skills"** — Install the plugin via the marketplace (`/add-plugin`), not by copying files. Restart Cursor after install.
- **"`/constitute` doesn't trigger"** — Leftover `.cursor/rules/*.mdc` files conflict with skills. Delete them.
- **"My `.workflow-state.md` says `stepsCompleted: ['step-03-tasks']` but step-02b is new — did I skip UIX?"** — No. `step-02b-uix` only appears in `stepsCompleted` for specs created **after** the migration. The framework does not retroactively flag old specs as missing it.
- **"BMAD-fusion `Approved By` fields look wrong after update"** — They shouldn't be. `spec-first update` does not touch your existing artifacts. Check `git diff specs/` — if there are unexpected changes, revert.

### Rollback

```bash
git checkout pre-spec-first-1.2.0-backup
```

The backup branch you created in step 1 preserves the full previous state including `.cursor/rules/`. The new framework files in `.framework/`, `skills/`, etc. are reverted; your `specs/`, `bugs/`, and `CONSTITUTION.md` are unchanged either way.
