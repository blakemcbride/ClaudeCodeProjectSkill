# Install, update or remove the project skills on Windows.
# Run it from a clone of the repository:
#
#   powershell -ExecutionPolicy Bypass -File install.ps1 [-Link] [-Project DIR] [-Uninstall]
#
#   (no option)    Copy the skills into %USERPROFILE%\.claude\skills, for
#                  every project. Run it again after "git pull" to update.
#   -Link          Link the skills (directory junctions) instead of copying
#                  them, so that "git pull" updates the installed skills too.
#   -Project DIR   Install into DIR\.claude\skills, for that project only.
#   -Uninstall     Remove the skills. PROJECTS.md and Projects\ in your
#                  projects are left alone.
#
# If CLAUDE_CONFIG_DIR is set, it is used in place of %USERPROFILE%\.claude.

param(
    [switch]$Link,
    [string]$Project,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

$src = Join-Path $PSScriptRoot 'skills'
if (-not (Test-Path -LiteralPath $src -PathType Container)) {
    throw "No skills directory beside this script."
}
$src = (Resolve-Path -LiteralPath $src).Path

if ($Project) {
    if (-not (Test-Path -LiteralPath $Project -PathType Container)) {
        throw "Not a directory: $Project"
    }
    $dest = Join-Path (Resolve-Path -LiteralPath $Project).Path '.claude\skills'
} elseif ($env:CLAUDE_CONFIG_DIR) {
    $dest = Join-Path $env:CLAUDE_CONFIG_DIR 'skills'
} else {
    $dest = Join-Path $HOME '.claude\skills'
}

if (-not $Uninstall) {
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    if ((Resolve-Path -LiteralPath $dest).Path -eq $src) {
        throw "$dest is this repository's own skills directory."
    }
}

# Remove one installed skill: a link or junction is unlinked, never
# followed; a directory is deleted.
function Remove-Skill([string]$name) {
    $target = Join-Path $dest $name
    $item = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
    if (-not $item) { return $false }
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        [IO.Directory]::Delete($target, $false)
    } else {
        Remove-Item -LiteralPath $target -Recurse -Force
    }
    return $true
}

$count = 0
foreach ($dir in Get-ChildItem -LiteralPath $src -Directory) {
    if (-not (Test-Path -LiteralPath (Join-Path $dir.FullName 'SKILL.md'))) { continue }
    $name = $dir.Name
    $target = Join-Path $dest $name
    if ($Uninstall) {
        if (-not (Remove-Skill $name)) { continue }
    } elseif ($Link) {
        Remove-Skill $name | Out-Null
        New-Item -ItemType Junction -Path $target -Target $dir.FullName | Out-Null
    } else {
        Remove-Skill $name | Out-Null
        Copy-Item -LiteralPath $dir.FullName -Destination $target -Recurse
    }
    $count++
}

if ($Uninstall) {
    Write-Host "Removed $count skills from $dest"
} else {
    if ($Link) {
        Write-Host "Linked $count skills in $dest to $src"
    } else {
        Write-Host "Copied $count skills to $dest"
    }
    Write-Host "Start a new Claude Code session; /skills lists them."
}
