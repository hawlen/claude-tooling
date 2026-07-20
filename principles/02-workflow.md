# Engineering workflow (Superpowers-owned)

Adopted 2026-07-20 from ai-os-template's "How work runs here". Requires the `superpowers@claude-plugins-official` plugin (installed by install.ps1).

Superpowers owns the workflow: brainstorm the spec with the user, write the plan, red/green TDD, implement in small steps (subagent-driven, following the dispatch-economy routing in principle 00), then review. Don't bypass it — no "just skip planning" or "skip tests" unless the user explicitly says so for a throwaway, or the effort-triage rule below applies.

## Effort triage (overrides default skill triggering)

- TRIVIAL (single file, reversible, known pattern, no design decision, no new dependency): skip brainstorming and planning — implement directly. Verification before completion still applies, always.
- Everything else: full Superpowers workflow.
- Escalation: the moment a "trivial" task fails once, surprises you, or grows beyond one file — stop and restart it through the full workflow. No second direct attempt.

## Specs before big builds

Any substantial build — and every overnight/autonomous build without exception — gets a professional tech spec first: brainstormed with the user, written to a file, and approved before implementation starts. The spec is the contract for the build; it must state scope, non-goals, success criteria, and how completion is verified with executed evidence. For correctness-critical builds, consider running under council-loop.

## Debugging discipline

For any real bug, systematic debugging applies from the FIRST failure — never patch blind. Circuit breaker: if the same failure survives 3 attempts, stop entirely — question the design, consider the `architect` agent.
