# AI OS

A configuration layer that makes every Claude Code session — on every PC you own — operate under the same universal principles, and keeps a ledger of what happens on each machine.

## What it actually does (honest scope)

| Goal | Mechanism | Status |
|---|---|---|
| Universal principles in every session | `install.ps1` deploys everything in `principles/` into `~/.claude/CLAUDE.md` (loaded by Claude Code at the start of every session, in every project) | ✅ v1 |
| Same principles on all PCs | This folder is a git repo. Push it to a **private** remote, clone on another PC, run `install.ps1`. Re-run after pulling updates. | ✅ v1 (manual sync) |
| "Knows everything that goes on" | Two sources: (1) Claude Code already stores full session transcripts under `~/.claude/projects/`; (2) AI OS registers SessionStart/SessionEnd hooks that append a machine-local ledger to `logs/activity.jsonl` | ✅ v1 (per-machine) |
| Model orchestration (dispatch economy: Haiku transcribes, Sonnet builds, Opus reviews, Fable architects) | `principles/00-model-orchestration.md` + `agents/` — enforced via subagent dispatch with explicit model pins | ✅ v1 |

### Known limits (by design, not bugs)

- **No automatic cloud sync.** A Claude Code subscription syncs your login and usage, not files or settings. Cross-PC distribution is git pull + `install.ps1`. A scheduled task could automate the pull later.
- **The main session model can't be hot-swapped by a config file.** You pick it with `/model`. The orchestration policy works around this: whatever model is running delegates work to subagents spawned at the right tier (`sonnet` / `opus` / `fable`).
- **The activity ledger is per-machine** and gitignored. Syncing it through the repo would require committing on every session — possible later via a hook, not enabled by default.

## Layout

```
AI OS/
├── README.md                     ← this file
├── install.ps1                   ← deploys principles + registers hooks (idempotent)
├── principles/
│   └── 00-model-orchestration.md ← universal principle #1 (add more as NN-name.md)
├── hooks/
│   └── log-session.ps1           ← SessionStart/SessionEnd → logs/activity.jsonl
└── logs/
    └── activity.jsonl            ← machine-local session ledger (gitignored)
```

## Install on a new PC

> ⚠️ Do NOT work from `main` after cloning: on this remote, `main` currently holds the
> AI OS *machine layer* (an unrelated history). This versioning layer lives on the
> `machine/<PCNAME>` branches until the two are reconciled. Start your machine branch
> from the newest logged machine branch (`git branch -r` to list them):

```powershell
git clone https://github.com/hawlen/ai-os.git "C:\AI OS"
cd "C:\AI OS"
git checkout -b "machine/$env:COMPUTERNAME" origin/machine/ODINVISION
powershell -ExecutionPolicy Bypass -File install.ps1
powershell -ExecutionPolicy Bypass -File connect-github.ps1   # one-time GitHub connection
```

The new PC's GitHub account must be a collaborator on the repo before its first
`sync.ps1` push (repo Settings → Collaborators).

`install.ps1` is idempotent and non-destructive:
- It writes the principles into `~/.claude/CLAUDE.md` **between `<!-- AI-OS:BEGIN -->` / `<!-- AI-OS:END -->` markers**, leaving anything you wrote outside the markers untouched. Re-running replaces only the managed block.
- It adds the logging hooks to `~/.claude/settings.json` only if they aren't already there, and if the checkout has moved it repoints existing hooks at the new path. Pass `-SkipHooks` to skip that part.

## Update the principles everywhere

1. Edit or add files in `principles/` on any PC.
2. Commit + push.
3. On each other PC: `git pull` then re-run `install.ps1`.

## Uninstall

- Delete the `<!-- AI-OS:BEGIN -->` … `<!-- AI-OS:END -->` block from `~/.claude/CLAUDE.md`.
- Remove the two hook entries containing `log-session.ps1` from `~/.claude/settings.json`.

## Versioning & multi-PC model

- **`main` is canonical and admin-only.** A git pre-push guard blocks pushing `main` unless `~/.ai-os-admin` exists — created by running `install.ps1 -Admin` on the admin PC only.
- **Every PC logs versions on its own branch** (`machine/<PCNAME>`). After any AI OS change or notable install: `sync.ps1 -Message "what changed and why"` — appends the explanation to `machines/<PCNAME>/log.md`, commits, and pushes. GitHub ends up holding every version of every PC, each with its reason.
- **Adopt / roll back:** `adopt.ps1 -Ref <branch|tag|commit>` applies any logged version to this PC (an older commit = rollback), re-installs, and logs the adoption as a new version.
- **Promote:** on the admin PC, `publish.ps1 -Ref <ref>` merges a reviewed version into `main` and pushes.
- Honest limit: the pre-push guard is a local safety rail against accidents — not hard server-side security. Hard enforcement needs branch protection on `main` in GitHub settings.

## Two computers, two rhythms (no collisions)

Working the same project from several PCs at different paces is the designed mode:

1. **Each PC commits only through `sync.ps1`, only to its own `machine/<PCNAME>` branch.** Two machines can work simultaneously and never conflict, because they never write to the same branch.
2. **Never check out another machine's branch to work on it.** Its branch is its log.
3. **To take the other PC's progress:** `adopt.ps1 -Ref origin/machine/<OTHERPC>` — fetches, overlays that version's content, re-installs, and records the adoption as a new logged version on *your* branch. No merges, ever.
4. Rhythm in practice: sync when you stop working on one machine, adopt when you sit down at the other. If you forget to adopt, nothing breaks — the machines just diverge until the next adopt.

## Roadmap ideas

- Auto-pull principles on a schedule (Windows Task Scheduler or a Claude Code scheduled task).
- Cross-machine ledger sync (hook that commits `logs/` to a separate branch).
- More principles: coding standards, security posture, project conventions.
