$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot

foreach ($directory in @('.claude', 'docs')) {
    New-Item -ItemType Directory -Path (Join-Path $projectRoot $directory) -Force | Out-Null
}

# Les jonctions Windows ne nécessitent pas le mode développeur ni les droits admin.
$linkType = if ($env:OS -eq 'Windows_NT') { 'Junction' } else { 'SymbolicLink' }
foreach ($link in @(
    @{ Path = '.codex'; Target = '.claude' },
    @{ Path = '.claude/docs'; Target = 'docs' }
)) {
    $linkPath = Join-Path $projectRoot $link.Path
    $targetPath = Join-Path $projectRoot $link.Target
    $existing = Get-Item -LiteralPath $linkPath -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.LinkType -notin @('Junction', 'SymbolicLink')) {
            throw "$linkPath existe et n'est pas un lien ; aucun fichier n'a été remplacé."
        }
        $existingTarget = $existing.Target
        if (-not [IO.Path]::IsPathRooted($existingTarget)) {
            $existingTarget = Join-Path (Split-Path $linkPath) $existingTarget
        }
        $existingTarget = [IO.Path]::GetFullPath($existingTarget)
        if ($existingTarget -ne [IO.Path]::GetFullPath($targetPath)) {
            throw "$linkPath pointe vers $existingTarget au lieu de $targetPath."
        }
    } else {
        New-Item -ItemType $linkType -Path $linkPath -Target $targetPath | Out-Null
    }
    Write-Output "$linkPath -> $targetPath"
}
