$ErrorActionPreference = "Stop"

function Assert-Equal {
    param(
        [string]$Label,
        $Expected,
        $Actual
    )

    if ($Expected -ne $Actual) {
        throw "$Label expected $Expected but found $Actual"
    }
}

function Assert-Contains {
    param(
        [string]$Path,
        [string]$Needle
    )

    $text = Get-Content -Raw -Path $Path
    if ($text.IndexOf($Needle, [StringComparison]::Ordinal) -lt 0) {
        throw "$Path is missing required text: $Needle"
    }
}

$root = Split-Path -Parent $PSScriptRoot
$plugin = Get-Content -Raw -Path (Join-Path $root ".claude-plugin/plugin.json") | ConvertFrom-Json
$plan = Get-Content -Raw -Path (Join-Path $root "context/probe/test-plan.json") | ConvertFrom-Json
$index = Get-Content -Raw -Path (Join-Path $root "context/probe/probe-index.json") | ConvertFrom-Json

$skillFiles = Get-ChildItem -Path (Join-Path $root ".claude/skills") -Recurse -File -Filter "SKILL.md"
$publicationDirs = Get-ChildItem -Path (Join-Path $root "research/publications") -Directory

Assert-Equal -Label "plugin version" -Expected "2.3.0" -Actual $plugin.version
Assert-Equal -Label "probe plan version" -Expected $plugin.version -Actual $plan.version
Assert-Equal -Label "plugin skill count" -Expected 12 -Actual $plugin.skills.Count
Assert-Equal -Label "skill file count" -Expected $plugin.skills.Count -Actual $skillFiles.Count
Assert-Equal -Label "research publication count" -Expected 10 -Actual $publicationDirs.Count

$skillPaths = @($plugin.skills | ForEach-Object { $_ -replace "^\.\/", "" })
foreach ($skillPath in $skillPaths) {
    $expected = Join-Path $root (Join-Path $skillPath "SKILL.md")
    if (-not (Test-Path -Path $expected)) {
        throw "plugin skill path missing SKILL.md: $skillPath"
    }
}

Assert-Contains -Path (Join-Path $root "context/probe/test-plan.json") -Needle '"count-equals-12"'
Assert-Contains -Path (Join-Path $root "context/probe/test-plan.json") -Needle '"target": ".claude/skills/*/SKILL.md"'
Assert-Contains -Path (Join-Path $root "context/probe/probe-index.json") -Needle '"currentSurfaceCheck": "tests/check-probe-surface.ps1"'
Assert-Contains -Path (Join-Path $root "context/probe/current-surface.md") -Needle 'Plugin version: `2.3.0`'
Assert-Contains -Path (Join-Path $root "context/probe/current-surface.md") -Needle "Skill directories: 12"
Assert-Contains -Path (Join-Path $root "context/probe/current-surface.md") -Needle "Research publication directories: 10"
Assert-Contains -Path (Join-Path $root "context/probe/results/run-all-1770441200/report.md") -Needle "Historical probe boundary"
Assert-Contains -Path (Join-Path $root ".pitfall/panel-pitfalls.md") -Needle "**Status:** MITIGATED"
Assert-Contains -Path (Join-Path $root ".pitfall/panel-invariants.md") -Needle "PANEL-I-06"
Assert-Contains -Path (Join-Path $root ".roles/ROLE.md") -Needle 'PANEL-PF-05'

Write-Output "PANEL probe surface check passed."
