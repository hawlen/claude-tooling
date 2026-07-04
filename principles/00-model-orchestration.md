# Claude Model Orchestration (Efficiency Optimized)

The goal is to maximize completed development work per token spent.

Optimize for: first-pass correctness, minimal rework cycles, reduced repeated reasoning, low context re-reading, fast feature completion.

Do NOT optimize for raw model usage reduction. Optimize for total engineering throughput.

## Core Principle

> Use the least powerful model that can complete the *current decision step with high confidence and low risk of rework.*

Escalate only when it reduces total future work (debugging, rework, or redesign).

## Model Roles

### Sonnet 5 — Executor (Default)

Use for ~all mechanical and well-specified work: code implementation, file editing, refactoring, straightforward debugging, writing tests, reading codebase context, applying known patterns, large multi-file changes, documentation, repetitive or structured tasks.

**Rule:** If the task is clearly defined → Sonnet executes immediately.

### Opus 4.8 — Engineering Lead (Optimization Layer)

Use when reasoning upfront will reduce implementation cycles: implementation plans, medium-complexity debugging, cross-module integration design, API design, performance optimization, code reviews, clarifying ambiguous requirements, resolving uncertainty before coding.

**Rule:** Use Opus when there is uncertainty that would otherwise cause rework. Opus exists to reduce Sonnet retries.

### Fable 5 — Principal Architect (Rare Use)

Use only when decisions have system-wide impact or require novel reasoning: system architecture, AI agent design, complex algorithms, security-critical design, deep architectural tradeoffs, final approval of major production changes.

**Rule:** Fable is only used when both Sonnet and Opus are insufficient to avoid systemic design risk.

## Decision Strategy

1. **Try Sonnet first by default** — when the task is well-defined, the solution is known or standard, and it can be implemented without ambiguity.
2. **Escalate to Opus BEFORE coding if:** requirements are unclear; multiple design paths exist; mistakes would require rework across files; debugging has already failed once; integration between systems is required.
3. **Escalate to Fable if:** architecture affects many subsystems; novel algorithm or system design is required; security or correctness is critical; Opus cannot confidently define a solution; the problem has already failed multiple approaches.
4. **Always return to Sonnet after planning.** Once Opus or Fable defines a solution, Sonnet executes it. Do NOT use Opus/Fable for repetitive implementation.

## Execution Flow Patterns

- Simple feature: Sonnet → implement → done
- Medium feature: Sonnet → (if uncertain) Opus plan → Sonnet implementation
- Complex feature: Sonnet → Opus design → Sonnet implementation → Opus review
- Architecture-level: Sonnet → Opus exploration → Fable decision → Sonnet implementation
- Debugging: Sonnet fix attempt → Opus diagnosis → Sonnet fix → Fable only if systemic

## Efficiency Rules (Token Optimization Layer)

- Do not re-read files unless they have changed.
- Do not re-summarize already analyzed context.
- Batch edits instead of incremental micro-edits.
- Prefer full solutions over iterative patching when confidence is high.
- Avoid model switching mid-task unless necessary.
- Prefer planning once, then executing fully.

Most token waste comes from repeated Sonnet debugging loops, premature implementation without planning, and unnecessary Fable involvement. Most efficiency gains come from using Opus briefly to eliminate ambiguity, letting Sonnet execute in bulk, and reserving Fable for true system-level decisions.

## How to enforce this inside Claude Code (mechanics)

A config file cannot swap the main session's model — the user picks that with `/model`. Whatever model is currently running enforces this policy through **delegation**:

- **If you are running as Sonnet** and a Step-2/Step-3 trigger fires: spawn a planning subagent via the Agent tool with `model: "opus"` (or `"fable"` for Step-3 triggers), get the plan/decision back, then execute it yourself. Do not grind through failed debugging loops — one failed fix attempt is the escalation trigger.
- **If you are running as Opus or Fable**: do the planning/design inline (you are the right tier for it), then delegate bulk mechanical implementation to subagents with `model: "sonnet"` when the work is large and well-specified. For small edits, just do them — spawning a subagent that re-reads context costs more than it saves.
- **Workflow tool**: apply the same mapping via each `agent()` call's `model` option — `sonnet` for execution stages, `opus` for review/judge stages, `fable` only for architecture-level decisions.
- **Escalation is not free.** A subagent starts with zero context and must re-read it. Only escalate when the rework risk genuinely exceeds that cost — that is the whole point of this policy.
- Recommended session default on all machines: Sonnet 5 for day-to-day work (`/model sonnet`), with escalation happening through subagents per the rules above.

## Philosophy

Sonnet builds. Opus removes uncertainty. Fable defines direction.
Think once. Build once. Minimize rework.
