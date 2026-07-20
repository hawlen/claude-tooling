# Claude Model Orchestration (Dispatch Economy)

The goal is to maximize completed development work per token spent.

Optimize for: first-pass correctness, minimal rework cycles, reduced repeated reasoning, low context re-reading, fast feature completion. Do NOT optimize for raw model usage reduction — optimize for total engineering throughput.

Scheme adopted 2026-07-20 from ai-os-template's "Model routing (dispatch economy)": the orchestrating session holds the context and delegates work DOWN to the cheapest model that can complete it with high confidence.

## The routing table

| Work type | Route | Model |
|---|---|---|
| Pure transcription / mechanical edits (complete code already in the task text, single-file fixes) | direct dispatch | **haiku** (cheapest tier) |
| Well-specified implementation from prose | `executor` agent | **sonnet** |
| Mechanical diff review | direct dispatch | **sonnet** |
| Subtle or risky review | `code-reviewer` agent | **opus** |
| Architecture decisions; final whole-branch review | `architect` agent (read-only, rare) | **fable** |
| Trivial-triage tasks | **no dispatch at all** | session model |

## Cardinal rules

1. **Always set the model explicitly when dispatching.** An omitted model silently inherits the expensive session model — that is the single biggest source of silent token waste.
2. **Trivial tasks stay in-session.** A subagent starts with zero context and must re-read it; for a small edit the handoff costs more than it saves. Trivial = single file, reversible, known pattern, no design decision, no new dependency.
3. **The table governs regardless of which model the session runs.** A big-model session delegates down (haiku/sonnet do the bulk); a Sonnet session still routes risky reviews UP to opus and architecture UP to fable — the table is about matching work to tier, in both directions.
4. **Escalation triggers:** the moment a "trivial" task fails once, surprises you, or grows beyond one file — stop and route it through the table properly; no second direct attempt. If the same failure survives 3 attempts, stop entirely and consider the `architect`.
5. **Missing agent fallback:** if a named agent is not installed on this machine, dispatch a general-purpose subagent with the same explicit model pin (e.g. `model: "opus"` for a risky review).

## Enforcement mechanics (Claude Code)

- **Agent tool:** pass the `model` option (`"haiku"` / `"sonnet"` / `"opus"` / `"fable"`) on every dispatch, or use the named agents (`executor`, `code-reviewer`, `architect`) whose frontmatter pins the model.
- **Workflow tool:** apply the same mapping via each `agent()` call's `model` option — haiku/sonnet for mechanical and execution stages, opus for review/judge stages, fable only for architecture-level decisions.
- **Agents deployed by this repo** (`agents/` → `~/.claude/agents/`): `executor` (sonnet), `architect` (fable, read-only). `code-reviewer` (opus) comes from the machine layer; use the fallback rule if absent.

## Efficiency rules (token optimization layer)

- Do not re-read files unless they have changed.
- Do not re-summarize already analyzed context.
- Batch edits instead of incremental micro-edits.
- Prefer full solutions over iterative patching when confidence is high.
- Prefer planning once, then executing fully; avoid model switching mid-task unless the table demands it.

## Philosophy

Haiku transcribes. Sonnet builds. Opus reviews. Fable defines direction.
Think once. Build once. Dispatch down. Minimize rework.
