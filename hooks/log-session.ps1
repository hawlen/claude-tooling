# AI OS session ledger hook.
# Claude Code invokes this on SessionStart / SessionEnd and pipes the event payload as JSON on stdin.
# Appends one JSON line per event to logs/activity.jsonl. Must never fail or block the session.

try {
    $raw = [Console]::In.ReadToEnd()
    $payload = $null
    try { $payload = $raw | ConvertFrom-Json } catch {}

    $record = [ordered]@{
        ts       = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        machine  = $env:COMPUTERNAME
        event    = if ($payload -and $payload.hook_event_name) { $payload.hook_event_name } else { "unknown" }
        session  = if ($payload -and $payload.session_id) { $payload.session_id } else { $null }
        cwd      = if ($payload -and $payload.cwd) { $payload.cwd } else { $null }
        detail   = if ($payload -and $payload.source) { $payload.source } elseif ($payload -and $payload.reason) { $payload.reason } else { $null }
    }

    $logDir = Join-Path (Split-Path $PSScriptRoot -Parent) "logs"
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    $line = ($record | ConvertTo-Json -Compress)
    Add-Content -Path (Join-Path $logDir "activity.jsonl") -Value $line -Encoding UTF8
} catch {}
exit 0
