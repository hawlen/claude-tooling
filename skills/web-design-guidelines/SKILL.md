---
name: web-design-guidelines
description: Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practices".
metadata:
  author: vercel
  version: "1.0.0"
  argument-hint: <file-or-pattern>
---

# Web Interface Guidelines

Review files for compliance with Vercel's Web Interface Guidelines.

> **Pinned, offline copy.** The rules live in `web-interface-guidelines.md` next to this file — a snapshot
> pinned for reproducibility, so reviews do **not** depend on a live network fetch. To update the rules,
> re-fetch `command.md` from `vercel-labs/web-interface-guidelines` over the pinned file.

## How It Works

1. Read the rules from `web-interface-guidelines.md` (in this skill's folder).
2. Read the specified files (or ask the user for files/pattern).
3. Check the files against every rule.
4. Output findings in the terse `file:line` format the rules specify.

## Usage

When a user provides a file or pattern argument:
1. Read the local `web-interface-guidelines.md`.
2. Read the specified files.
3. Apply all rules; output findings in the format the rules specify.

If no files are specified, ask the user which files to review.
