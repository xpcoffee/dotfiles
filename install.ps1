#!/usr/bin/env pwsh
#
# install.ps1
#
# Windows counterpart to install.sh, for the Claude Code config only.
#
# The Windows desktop app and the Windows CLI read %USERPROFILE%\.claude, which
# WSL's ~/.claude never touches. GNU stow is not available here, so this links
# the same packages with native symlinks (Developer Mode lets a normal user
# create them; no elevation needed) and generates settings.json the same way
# bin/claude-build-settings does.
#
# Re-run after pulling or after editing any settings source.

$ErrorActionPreference = 'Stop'

$repo = $PSScriptRoot
$claudeSrc = Join-Path $repo '.claude'
$dest = Join-Path $HOME '.claude'

New-Item -ItemType Directory -Force -Path $dest | Out-Null

##################
#    Symlinks    #
##################

# settings.json is generated, not linked, for the same reason as on Linux:
# the work overlay must never be able to flow back into this public repo.
$links = [ordered]@{
    (Join-Path $dest 'commands')           = (Join-Path $claudeSrc 'commands')
    (Join-Path $dest 'skills')             = (Join-Path $claudeSrc 'skills')
    (Join-Path $dest 'agents')             = (Join-Path $claudeSrc 'agents')
    (Join-Path $dest 'writing')            = (Join-Path $claudeSrc 'writing')
    (Join-Path $dest 'mcp_settings.json')  = (Join-Path $claudeSrc 'mcp_settings.json')
    # On Linux this is stowed to ~/CLAUDE.md and picked up by the walk from any
    # cwd under $HOME. Here it goes to the real user-scope path so it applies
    # to repos on other drives too.
    (Join-Path $dest 'CLAUDE.md')          = (Join-Path $repo 'claude-md\CLAUDE.md')
}

foreach ($link in $links.Keys) {
    $target = $links[$link]

    if (-not (Test-Path -LiteralPath $target)) {
        Write-Host "skip   $(Split-Path $link -Leaf) (no $target)"
        continue
    }

    $existing = Get-Item -LiteralPath $link -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.LinkType -eq 'SymbolicLink') {
            $existing.Delete()
        } else {
            # Never destroy a real file or directory that is already there.
            $backup = "$link.bak"
            Write-Warning "$link is not a symlink; moving it to $backup"
            Move-Item -LiteralPath $link -Destination $backup -Force
        }
    }

    New-Item -ItemType SymbolicLink -Path $link -Target $target | Out-Null
    Write-Host "link   $link -> $target"
}

######################
#    settings.json   #
######################

# base (public, committed) + work-settings.json (private) + windows-settings.json
# (public, committed). The Windows overlay is applied last so its path fixes win
# over Linux paths in either of the others.
#
# Merge is RFC 7386 style with one addition: arrays append (base order first,
# then overlay entries the base does not already hold), matching the jq merge in
# bin/claude-build-settings. A null in an overlay DELETES the key -- the bash
# version keeps the base value there instead, because on Linux nothing needs
# removing; on Windows the Linux-only marketplace and plugin entries do.

function Merge-Setting {
    param($Base, $Overlay)

    if ($Base -is [System.Management.Automation.PSCustomObject] -and
        $Overlay -is [System.Management.Automation.PSCustomObject]) {
        $out = [ordered]@{}
        foreach ($p in $Base.PSObject.Properties) { $out[$p.Name] = $p.Value }
        foreach ($p in $Overlay.PSObject.Properties) {
            if ($null -eq $p.Value) { $out.Remove($p.Name); continue }
            if ($out.Contains($p.Name)) { $out[$p.Name] = Merge-Setting $out[$p.Name] $p.Value }
            else { $out[$p.Name] = $p.Value }
        }
        return [pscustomobject]$out
    }

    if ($Base -is [array] -and $Overlay -is [array]) {
        return @($Base) + @($Overlay | Where-Object { @($Base) -notcontains $_ })
    }

    return $Overlay
}

function Read-Overlay {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return $null }
    # {{HOME}} keeps this repo free of the local username; forward slashes so the
    # value needs no JSON escaping and matches how Claude writes paths.
    (Get-Content -LiteralPath $Path -Raw).Replace('{{HOME}}', $HOME.Replace('\', '/')) |
        ConvertFrom-Json
}

$settings = Read-Overlay (Join-Path $claudeSrc 'settings.json')
$applied = @('base')

foreach ($name in @('work-settings.json', 'windows-settings.json')) {
    $overlay = Read-Overlay (Join-Path $claudeSrc $name)
    if ($overlay) {
        $settings = Merge-Setting $settings $overlay
        $applied += $name
    }
}

$out = Join-Path $dest 'settings.json'
$settings | ConvertTo-Json -Depth 30 | Set-Content -LiteralPath $out -Encoding utf8
Write-Host "build  $out ($($applied -join ' + '))"

########################
#   This repo's hooks  #
########################

# pre-commit blocks work material from reaching this public repo. See .githooks/.
git -C $repo config core.hooksPath .githooks

####################
#   Dependencies   #
####################

# The PreToolUse hooks in settings.json pipe through jq. Without it every Bash
# call reports a failing hook.
if (-not (Get-Command jq -ErrorAction SilentlyContinue)) {
    Write-Warning 'jq is not on PATH; the PreToolUse hooks will fail on every Bash call. Install it with: winget install jqlang.jq'
}

Write-Host 'Claude Code dotfiles installed.'
