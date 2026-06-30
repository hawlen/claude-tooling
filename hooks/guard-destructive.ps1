# PreToolUse guard for the Bash / PowerShell tools.
# Blocks a small set of genuinely irreversible commands. This is a backstop,
# NOT a sandbox: it pattern-matches and can be bypassed. Tune the list freely.
#
# Protocol: Claude Code passes the tool call as JSON on stdin. Exit 2 = block
# (stderr is shown to Claude); exit 0 = allow. We fail OPEN on any error so a
# bug here can never stop you from running commands.

try {
    $raw = [Console]::In.ReadToEnd()
    if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
    $data = $raw | ConvertFrom-Json
    $cmd  = [string]$data.tool_input.command
    if ([string]::IsNullOrWhiteSpace($cmd)) { exit 0 }
} catch {
    exit 0
}

function Deny([string]$why) {
    [Console]::Error.WriteLine(
        "BLOCKED by destructive-command guard: $why`n" +
        "Command: $cmd`n" +
        "If this is intentional, run it yourself in a terminal, or remove/relax the hook in .claude\settings.local.json."
    )
    exit 2
}

# Order-independent combo: recursive + force delete (PowerShell or aliases)
$looksLikeDelete = $cmd -imatch '(^|[\s;|&])(remove-item|ri|rm|rmdir|rd|del|erase)(\s|$)'
if ($looksLikeDelete -and $cmd -imatch '-recurse' -and $cmd -imatch '-force') {
    Deny "recursive force delete (Remove-Item -Recurse -Force)"
}

# Single-regex catches for other irreversible operations
$patterns = @(
    @{ rx = '\brm\s+-\w*[rf]\w*[rf]';        why = 'rm with combined -rf/-fr flags' },
    @{ rx = '\brm\s+-[rf]\b[^\n]*\s-[rf]\b';  why = 'rm -r -f (separated flags)' },
    @{ rx = '\b(rd|rmdir)\s+/s\b';            why = 'cmd recursive directory delete (rd /s)' },
    @{ rx = '\bdel\s+/[sq]\b';                why = 'cmd recursive/quiet delete (del /s /q)' },
    @{ rx = '\bformat\s+[a-zA-Z]:';           why = 'drive format (format X:)' },
    @{ rx = '\bFormat-Volume\b';              why = 'Format-Volume' },
    @{ rx = '\bClear-Disk\b';                 why = 'Clear-Disk' },
    @{ rx = '\bmkfs\b';                       why = 'mkfs (filesystem create/wipe)' },
    @{ rx = '\bdd\s+if=';                     why = 'dd raw disk write' },
    @{ rx = '>\s*/dev/sd';                    why = 'redirect to raw disk device' },
    @{ rx = 'DROP\s+(TABLE|DATABASE|SCHEMA)'; why = 'SQL DROP TABLE/DATABASE/SCHEMA' },
    @{ rx = 'TRUNCATE\s+TABLE';               why = 'SQL TRUNCATE TABLE' },
    @{ rx = ':\s*\(\s*\)\s*\{';               why = 'shell fork bomb' }
)

foreach ($p in $patterns) {
    if ($cmd -imatch $p.rx) { Deny $p.why }
}

exit 0
