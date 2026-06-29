#!/usr/bin/env pwsh
# fetch-ecc-reference.ps1 — recreate the READ-ONLY, markdown-only ECC reference snapshot.
#
# Pulls only the markdown asset directories from affaan-m/ECC at a pinned commit, then strips
# EVERYTHING executable (installer, hooks, src, *.js/*.py, package.json, MCP wiring, configs)
# and the heavy docs/ tree. The result is reference text we mine — never code we run.
#
# Idempotent: re-running replaces the local snapshot. The snapshot is gitignored.

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$PinnedSha = '2159ed2fdee361bfa5e8caac6dcd76f042f930c8'   # reviewed commit
$RepoUrl   = 'https://github.com/affaan-m/ECC.git'
$KeepDirs  = @('agents', 'skills', 'rules', 'commands')   # markdown asset dirs to mine

$here = Split-Path -Parent $PSCommandPath
$dest = Join-Path $here 'ECC'

if (Test-Path $dest) {
    Write-Host "[ecc-ref] removing existing snapshot..."
    Remove-Item -Recurse -Force $dest
}

Write-Host "[ecc-ref] sparse partial clone (blobless) ..."
git clone --filter=blob:none --no-checkout --sparse $RepoUrl $dest
git -C $dest sparse-checkout set @KeepDirs
git -C $dest checkout $PinnedSha

Write-Host "[ecc-ref] sanitizing to markdown-only ..."
Remove-Item -Recurse -Force (Join-Path $dest '.git')
if (Test-Path (Join-Path $dest 'docs')) { Remove-Item -Recurse -Force (Join-Path $dest 'docs') }
# drop every top-level file that isn't .md or LICENSE
Get-ChildItem $dest -File -Force | Where-Object { $_.Extension -ne '.md' -and $_.Name -ne 'LICENSE' } | Remove-Item -Force
# belt-and-suspenders: remove any executable/config that slipped into kept dirs
Get-ChildItem $dest -Recurse -File -Force -Include *.ps1,*.sh,*.js,*.mjs,*.cjs,*.py,*.cmd,*.bat,*.exe,*.json,*.yaml,*.yml,*.lock,*.toml -ErrorAction SilentlyContinue | Remove-Item -Force

$leftover = Get-ChildItem $dest -Recurse -File -Force -Include *.ps1,*.sh,*.js,*.mjs,*.cjs,*.py,*.cmd,*.bat,*.exe -ErrorAction SilentlyContinue
if ($leftover) { Write-Error "[ecc-ref] executables still present after sanitize — aborting"; exit 1 }

$files = (Get-ChildItem $dest -Recurse -File -Force | Measure-Object).Count
$mb    = [math]::Round(((Get-ChildItem $dest -Recurse -File -Force | Measure-Object Length -Sum).Sum / 1MB), 2)
Write-Host "[ecc-ref] done: $files markdown files, $mb MB, 0 executables  (commit $PinnedSha)"
