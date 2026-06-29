# reference/ — read-only mining layer

External Claude Code frameworks we **read and cherry-pick from**, but never install or run.
Nothing here is part of the global layer. Nothing here is executed. We lift individual,
*vetted* markdown assets out of these snapshots into the real hub (`../skills`, `../agents`,
`../commands`) one at a time, each with a `MANIFEST.md` entry.

> ⚠️ **READ-ONLY. DO NOT EXECUTE.** These are other people's frameworks captured for study.
> Treat every file as untrusted reference text, not as something to install.

The snapshots themselves are **gitignored** (see `.gitignore`) — they're large third-party
copies we don't want to redistribute or bloat the hub with. They're reproducible to an exact,
reviewed commit via the `fetch-*.ps1` scripts here.

---

## ECC — "Everything Claude Code" (affaan-m/ECC)

- **Source:** https://github.com/affaan-m/ECC
- **Pinned commit:** `2159ed2fdee361bfa5e8caac6dcd76f042f930c8`
- **License:** MIT (attribution preserved in `ECC/LICENSE`)
- **Recreate locally:** `powershell -ExecutionPolicy Bypass -File .\fetch-ecc-reference.ps1`

### Why it's here
ECC is the most-starred Claude Code config framework (it grew off an Anthropic × Forum Ventures
hackathon win + a viral launch). It is a maximalist "everything bag" — 67 agents, 270+ skills,
hooks, an installer, MCP wiring. We are **not** adopting it wholesale (auto-running hooks +
an npm-install-driven installer = a code-execution surface we don't control, and it collides
with our existing Superpowers / council-loop layer). Instead we mine it for individual ideas.

### What this snapshot includes (markdown only)
- `agents/`   — 67 subagent definitions
- `skills/`   — 270+ skill workflows
- `rules/`    — per-language always-follow rule sets
- `commands/` — slash-command definitions
- top-level `*.md` guides (`the-*-guide.md`, `RULES.md`, `SOUL.md`, `SECURITY.md`, …)

### What is deliberately EXCLUDED (the risk surface)
- `install.sh`, `install.ps1`, `scripts/`, `src/` — the installer + Node runtime
- `hooks/` — code that would auto-run on every session/edit/tool call
- `.mcp.json`, `mcp-configs/`, `integrations/` — MCP servers + external service wiring
- `package.json`, `*.js`, `*.py`, lockfiles, `ecc_dashboard.py` — all executable code
- `docs/` — 9.5 MB / 1496 files of the project's own docs (re-pull if ever needed)

## Mining workflow
1. Read an asset under `ECC/` (e.g. `ECC/agents/<name>.md`).
2. If it's genuinely better than what we have, copy it into `../agents/` (or `../skills/`,
   `../commands/`) — adapting names/paths to our conventions.
3. Add a `MANIFEST.md` entry (source = ECC + pinned commit) and wire it into `install.ps1`.
4. Commit. The hub only ever contains vetted, chosen assets — never a blind bulk import.
