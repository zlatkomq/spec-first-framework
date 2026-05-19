# Spec-First Framework — Client Handoff

**Start here.** This page tells you what you're receiving, who on your team should read each piece, and the order to do things in.

---

## What you're receiving

| # | Deliverable | Where | One-line description |
|---|---|---|---|
| 1 | **Spec-First Framework** (this repo) | [github.com/zlatkomq/spec-first-framework](https://github.com/zlatkomq/spec-first-framework) | The methodology: gated SPEC → DESIGN → UIX → TASKS → Implementation → Review workflow with AI-driven step files, templates, and slash commands. |
| 2 | **`figma-to-code` MCP server** | [github.com/zlatkomq/figma-mcp](https://github.com/zlatkomq/figma-mcp) | A small Node/Docker service that translates Figma files into deterministic JSON / JSX specs the AI consumes. Stands on its own; the framework calls it during the UIX step. |
| 3 | **Figma Designer Guide** | [docs/FIGMA-DESIGNER-GUIDE.md](FIGMA-DESIGNER-GUIDE.md) | A "design contract" for the people building your Figma files. Following it is what turns approximate AI implementations into pixel-accurate ones. |
| 4 | **Working example** | [docs/examples/001-user-registration/](examples/001-user-registration/) | A real spec run end-to-end: SPEC, DESIGN, TASKS, REVIEW for a "user registration" feature. Shows what every artifact looks like. |
| 5 | **Automated test suite** | [tests/](../tests/) | 16 skill tests + 13 end-to-end scenarios proving every skill enforces its rules. Run `cd tests && ./run-skill-tests.sh` to see them pass. |
| 6 | **Worked walkthrough** | [docs/WORKFLOW-DEMO.md](WORKFLOW-DEMO.md) | A narrated `/flow` run of the 001 User Registration feature with the prompts, AI responses, and artifacts at each step. |

---

## Who reads what

| Role on your team | Read first | Then |
|---|---|---|
| **Project owner / decision-maker** | This page, then [README §Status](../README.md#status) and [PHILOSOPHY.md](../PHILOSOPHY.md) | Skim [WORKFLOW-DEMO.md](WORKFLOW-DEMO.md) to see what an end-to-end run looks like |
| **Developer / tech lead** | [README §Installation](../README.md#installation) (both steps) | [Commands & Workflow Example](COMMANDS-WORKFLOW-EXAMPLE.md) → [WORKFLOW-DEMO.md](WORKFLOW-DEMO.md) → run `/flow` on a real spec |
| **Designer** | **[FIGMA-DESIGNER-GUIDE.md](FIGMA-DESIGNER-GUIDE.md)** — only doc they need | Optional: skim [README §Figma and UIX flow](../README.md#figma-and-uix-flow-layout-handoff) for context |
| **DevOps / infra** | [figma-mcp Installation](https://github.com/zlatkomq/figma-mcp#installation) and [figma-mcp Verification](https://github.com/zlatkomq/figma-mcp#verification) | Decide local vs Docker vs stdio deployment for the MCP server |

---

## Recommended order of operations

```
Day 0 — Orientation
    ▸ Project owner reads this page + PHILOSOPHY.md (~15 min)
    ▸ Developer reads README + Commands & Workflow Example (~30 min)
    ▸ Designer is sent FIGMA-DESIGNER-GUIDE.md

Day 1 — Setup (developer + devops)
    ▸ Step 1: install editor plugin (Cursor / Claude Code / OpenCode)
    ▸ Step 2: install spec-first CLI, run `spec-first init` in a test project
    ▸ Deploy figma-to-code MCP server (local Node or Docker)
    ▸ Configure editor MCP client; verify with first /uix call
    ▸ End of day: developer can run `/flow` end-to-end without errors

Day 2 — First real feature
    ▸ Run /constitute to capture your project's standards
    ▸ Pick a small feature; run /flow on it
    ▸ Designer hands off the first Figma file built per FIGMA-DESIGNER-GUIDE.md
    ▸ Compare output against the worked example in docs/examples/001-user-registration/
```

Realistic adoption timeline: **half-day setup, half-day learning curve, productive on day 2**. Teams that have used SPEC.md-style workflows before move faster.

---

## How to verify everything's working

1. **Framework install (developer):** run `/constitute` in your editor → if the agent asks clarifying questions and writes a `CONSTITUTION.md` to your project root, Step 1 + Step 2 of installation succeeded.
2. **Figma MCP install:** in your editor, ask *"List MCP tools available from figma-to-code"* → you should see 5 tools (`get_figma_file_structure`, `get_figma_design_tokens`, `get_figma_node_spec`, `get_figma_frame_with_image`, `export_figma_assets`).
3. **Test suite:** `cd tests && ./run-skill-tests.sh` → expect *Passed: 16 / Failed: 0*.
4. **First `/uix` call:** see [README → First /uix call — what success looks like](../README.md#first-uix-call--what-success-looks-like) for the expected on-disk artifacts.

If any step fails, every doc points to the next one — but the two single most useful pages are:

- [figma-mcp Troubleshooting](https://github.com/zlatkomq/figma-mcp#troubleshooting) — 9 common failure modes for the MCP server
- [README Installation table](../README.md#installation) — clarifies which of the two install steps gives you what

---

## What the framework does *not* do (set expectations)

- **It does not write code without a human approving each gate.** SPEC, DESIGN, UIX, TASKS all require explicit user approval before the next step runs.
- **It does not invent Figma layout values.** If the MCP can't reach Figma, the workflow halts and asks you — it does not guess colors or spacing.
- **It does not bypass tests.** Step 4 implementation runs a verification checklist (tests pass, lint clean, scope intact); a red gate halts the workflow.
- **It does not lock you into a vendor.** The figma-to-code MCP is open-source (you self-host); the framework runs in Cursor, Claude Code, or OpenCode — pick any.

---

## Versions in this handoff

| Component | Version |
|---|---|
| Spec-First Framework | 1.2.0 |
| `figma-to-code` MCP server | 2.0.0+ |
| Figma Designer Guide | v0.1 |

Future major versions of the MCP server will be flagged in the Designer Guide's version block — re-check there before rolling out a new MCP release to your team.

---

## Next step

If you're the developer or tech lead and ready to install: open [README → Installation](../README.md#installation) and follow Step 1 + Step 2. Plan ~1 hour for the first machine, ~15 minutes per additional teammate.

If you're the project owner deciding whether to adopt: read [PHILOSOPHY.md](../PHILOSOPHY.md) (the *why*) and skim [WORKFLOW-DEMO.md](WORKFLOW-DEMO.md) (the *how*).
