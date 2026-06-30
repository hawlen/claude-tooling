---
name: council-loop
description: >-
  Rigorous build-and-verify methodology for substantial coding, system-building,
  or research/backtest projects where correctness matters and self-deception is a
  real risk. Runs a "council" of verification roles plus a self-verifying loop in
  which nothing is DONE or TRUE until proven by EXECUTED EVIDENCE — tests actually
  run green (not claimed), findings reproduced, claims that survived an adversarial
  pass — never by assertion. ACTIVATION: trigger immediately whenever the user
  writes the token COUNCIL-LOOP anywhere in a prompt. ALSO consider proposing it at
  the start of any non-trivial build, any multi-component system, any
  research/backtest/analysis task, or anything money-, safety-, security-, or
  data-integrity-critical — even if the user doesn't name it. IMPORTANT: before
  applying, FIRST assess the project's scope and whether it's a genuine fit, THEN
  describe the concrete benefits and the tradeoff and ASK the user to confirm
  running it this way. Do NOT bulldoze trivial tasks (typo fixes, one-off scripts,
  throwaway prototypes) with the heavyweight process without confirmation.
---

# Council-Loop

A general methodology for building or verifying any project so that **correctness
is proven, not asserted**. The core idea: replace "an agent says it's done/true"
with "nothing is done or true until objective, executed evidence demonstrates it —
verified adversarially, reproduced where it matters, with the human owning the
judgment calls the process can't invent."

This skill is **project-agnostic**: the same skeleton serves a software build, a
research study, a data pipeline, an analysis, a model, or a verification task.

---

## STEP 0 — ACTIVATION, FIT ASSESSMENT, AND PROPOSAL (always do this first)

**When this skill comes into play:**
- The user wrote **`COUNCIL-LOOP`** in the prompt → treat as an explicit request;
  still do the quick fit assessment and propose the instantiation, but assume the
  user wants this methodology.
- OR you're starting a project that *looks* like a fit (see criteria) → proactively
  consider proposing it.

**First, assess scope and fit. This is a genuine fit when the work is:**
- A substantial, multi-component build (a system, not a snippet).
- Research / backtest / analysis where **being fooled is a risk** (overfitting,
  p-hacking, selecting and testing on the same data, false "edges").
- Correctness-critical: money, safety, security, data integrity, irreversible
  actions.
- Long-running, where you'll lose track of what's verified without a ledger.
- Anything where you'd otherwise be tempted to trust "looks good / tests pass"
  without running them.

**It is NOT a fit (say so briefly and proceed normally, no overhead) when:**
- It's a one-off small script, a quick fix, a typo, a tiny refactor.
- It's a throwaway prototype or exploration where speed >> rigor.
- There's no meaningful correctness, safety, or self-deception risk.
- The user explicitly wants quick-and-dirty.

**Then propose it (unless already clearly mandated), with benefits AND the honest
tradeoff, and WAIT for confirmation.** Template:

> This looks like a fit for the **Council-Loop** methodology, because
> [1–2 specific reasons grounded in THIS project — e.g. "it's a multi-module
> trading engine where a wrong risk calc costs real money" or "it's a backtest,
> and the easiest mistake is finding an edge that isn't real"].
>
> Running it this way would give you:
> - **Doneness you can trust** — components advance only when tests are *actually
>   run* and green, not when an agent claims so.
> - **Protection from self-deception** — every positive finding must survive an
>   adversarial gauntlet (leakage, baselines, multiple-comparisons, reproduction)
>   before it's believed. *(research/analysis)*
> - **No scope drift or premature abstraction** — a framer guards the spec; an
>   adversary hunts for unrequested work and over-engineering.
> - **A full audit trail** — every attempt, including failures, is logged.
> - **You stay in control** — the loop pauses and asks you for any judgment call
>   it shouldn't invent (the thesis, the values decision, the risk appetite).
>
> The tradeoff: it's **heavier** — more steps and more rigor per unit of work, so
> it's slower in the small but far more trustworthy in the large. Worth it for
> [this project]; overkill for trivial tasks.
>
> Want me to run this project under Council-Loop? If yes, I'll start by writing
> down what "done/true" means here before doing any work.

**Only proceed to the methodology below once the user confirms** (or has clearly
already mandated it via the activation word + an obviously-fitting project).

---

## THE ONE PRINCIPLE

> **Nothing is DONE or TRUE until objective, executed evidence demonstrates it —
> produced by actually running or checking, survived an adversarial pass, and
> (where it matters) independently reproduced. Assertion is not evidence. An
> un-attacked claim is not a verified claim.**

Everything below serves that sentence.

---

## FIND THE EVIDENCE TYPE (do this before any work)

Ask: **what artifact would convince a skeptic — as opposed to anyone's say-so?**
That artifact is the evidence the loop will demand. Name it explicitly. Examples:
- **Software build** → the test suite run green (pasted output) + the thing
  actually running + an end-to-end demo + the key invariant holding.
- **Research / backtest** → result holds out-of-sample + beats a null baseline +
  survives adversarial attack + reproduces. Claim is **presumed false** until then.
- **Data pipeline** → row counts, schema validation, reconciliation to source,
  sample audits.
- **Analysis / decision** → numbers recomputed independently + sensitivity check +
  a devil's-advocate pass.
- **Model** → held-out evaluation + ablations + error analysis on real cases.
- **Writing** → each claim traced to a source + a fresh reader's comprehension.

---

## THE COUNCIL (roles)

Run the work as a council so each risk has an owner. One agent may play several
roles, but each role's checklist must be **discharged explicitly** — the function
must happen, not the headcount.

- **Chair / Orchestrator** — runs the loop, owns the ledger, decides when evidence
  is solid enough to advance, enforces "verify before advance" and "no silent
  retries."
- **Architect / Framer** — owns the spec and the definition of done/true; selects
  the next piece; rejects work that doesn't fit; guards against scope drift and
  premature abstraction (don't generalize before two real cases exist).
- **Maker** — does the work (builds / analyzes / drafts).
- **Verifier** — produces the executed evidence: runs the tests / reproduces the
  result / validates the data — and **refuses to pass on failure or thin coverage.**
- **Adversary (red team / critic)** — actively tries to BREAK every positive
  result; enumerates how *this specific claim* could be wrong and attacks each way;
  assumes the claim is wrong until it survives.
- **Domain Authority** — usually the **human**: owns the judgment the council can't
  invent (thesis, question, taste, values, risk appetite). The loop pauses and asks.
- **Reporter** — writes the verdict with evidence and caveats attached; no claim
  printed without the thing that would falsify it beside it.

---

## THE LOOP (per piece of work, and per candidate claim)

1. **Define** the success/done criteria — written *before* the work (pre-register).
2. **Do** the work.
3. **Verify** with executed evidence — run it, don't claim it.
4. **Attack** — the Adversary runs the gauntlet of ways this claim could be wrong;
   each check emits *actual numbers/outputs*, never a bare pass/fail.
5. **Reproduce / confirm** — independently re-run (fresh seed / adjacent case /
   second pass). Reproduction is the evidence.
6. **Judge** — assign the verdict (DONE / NOT-DONE, or REAL / INCONCLUSIVE / FALSE)
   as a function of survived checks + reproduction, citing the evidence.
7. **Record** everything to the ledger — including failures and total attempt count.
8. **Advance** only on a solid verdict. On failure, refine or move on — and log the
   refinement as a **new** attempt (never a silent retry-until-it-passes).

---

## PRE-REGISTRATION (lock goalposts before peeking)

Write the success criteria *before* doing the work, machine-checkable where
possible. **Anything explored after seeing results is EXPLORATORY and cannot carry
a confirmed verdict** — it only generates a new hypothesis to test cleanly. In a
build this is the per-component definition-of-done; in research it's the
pre-registered primary test.

## THE LEDGER

Append-only record of **every** attempt — what was tried, parameters, evidence,
verdict, timestamp. It's how you honestly correct for how many things you tried
(research) and the audit trail/anti-silent-redo guard (build). **Killed attempts
stay logged, never deleted.** Implement it as a real file (e.g. JSONL on disk) when
running a coded project.

## HUMAN-IN-THE-LOOP — what the council never decides

The council automates **verification and orchestration**. It does **not** invent
the project's core judgment — the thesis, the question, the taste, the values
decision, the risk appetite. Keep an explicit list of these human-only decisions
up front; when the loop reaches one, **pause and ask** rather than guessing.

## VERIFY THE VERIFIER (meta-check)

A verification process you haven't tested gives false confidence. **Prove the
checker catches dishonesty:** feed it known-bad inputs and confirm it rejects them,
and a known-good input and confirm it passes. *(Research: inject a fake edge with
leakage / a baseline-only result / a p-hacked winner → the gauntlet must kill each,
while a clean synthetic-real signal passes. Build: a deliberately broken component
→ the test gate must fail it.)* If the checker can't tell injected-bad from
injected-good, fix it before trusting any real result.

---

## STANDING PRINCIPLES (the council's mandates)

1. Define success before you start; exploratory ≠ confirmatory.
2. Presumed not-done / not-true until executed evidence + survived attack +
   reproduction.
3. Log every attempt; you can't account for tries you didn't count.
4. Killed attempts are recorded, never buried.
5. Gaps and "no result" are findings, reported honestly — not failures to hide.
6. Verify before advancing; don't design forward past unvalidated work.
7. Never tweak-to-pass; a tweak is a new logged attempt.
8. Guard against premature abstraction.
9. Flag eager unrequested work; confirm it's wanted before keeping it.
10. Every verdict cites executed evidence (actual numbers/outputs), never assertion.
11. Ask the human for judgment calls; never invent the core thesis or values call.

## GUARDRAILS

Carry project-appropriate hard constraints into **every** step — safety, scope,
data-handling, reversibility (e.g. "paper only, no live actions," "read-only data,"
"no credentials," "commit at every green checkpoint so any risky step is
reversible," "never fabricate a result"). The Adversary and Verifier enforce these
on each pass; guardrails are never traded away for speed.

---

## INSTANTIATION (fill in once the user confirms, then begin the loop)

Write this out for the project before doing any work, and confirm it with the user:

```
PROJECT:                ______________________________________________
TYPE:                   build | discover | hybrid
DEFINITION OF DONE/TRUE  (written BEFORE work; machine-checkable if possible):
                        ______________________________________________
EVIDENCE TYPE           (the artifact that would convince a skeptic):
                        ______________________________________________
THE GAUNTLET            (enumerate how this could be WRONG → a check for each):
                        - ____________________________________________
                        - ____________________________________________
REPRODUCTION            (how a finding/component is independently re-confirmed):
                        ______________________________________________
ROLES                   (who/which agent plays each — one may hold many):
   Chair · Architect · Maker · Verifier · Adversary · Domain Authority (human) ·
   Reporter
HUMAN-ONLY DECISIONS    (the loop must PAUSE and ask, never invent):
                        ______________________________________________
GUARDRAILS              (hard constraints carried into every step):
                        ______________________________________________
LEDGER LOCATION         (where every attempt + verdict is recorded):
                        ______________________________________________
VERIFY-THE-VERIFIER     (known-bad + known-good inputs the gate must reject/pass
                         before it's trusted):
                        ______________________________________________
```

When running a **coded** project, make the loop real, not ceremonial: create the
ledger file, implement the gauntlet checks as code that emit actual numbers, run
the verify-the-verifier self-test before trusting the gate, and run tests
start-to-finish (pasting output) at every gate. Commit at each green checkpoint.

## THE SHORTEST VERSION

Define what would convince a skeptic, **before** you start. Do the work. Prove it
with something you actually ran. Attack it. Reproduce it. Record every try,
including failures. Advance only on real evidence. Let the machinery — not memory
or hope — decide what's done and true; keep the human in charge of the judgment it
can't make.
