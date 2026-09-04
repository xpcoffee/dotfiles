<#
.SYNOPSIS
  Installs and configures komorebi + whkd for a tiling window manager on Windows,
  reading its config straight out of the xpcoffee/dotfiles checkout so there is a
  single source of truth shared across machines.

.DESCRIPTION
  Follows komorebi's documented setup (https://lgug2z.github.io/komorebi/), with the
  one deviation that config is read from this repo instead of $Env:USERPROFILE. That
  is done the supported way, by pointing KOMOREBI_CONFIG_HOME/WHKD_CONFIG_HOME here,
  so every komorebic subcommand (check, start, reload-configuration, whkdrc, ...)
  resolves the same files.

  1. Verifies winget and git are available; warns if long paths aren't enabled.
  2. Clones (or reuses) the dotfiles repo.
  3. Installs komorebi and whkd via winget (idempotent - skips if present).
  4. Points komorebi and whkd at <dotfiles>/komorebi via the two CONFIG_HOME env vars.
  5. Fetches komorebi's community-maintained per-app tiling tweaks.
  6. Validates the configuration with `komorebic check` before starting anything.
  7. Starts komorebi + whkd.
  8. Registers autostart at login.

.PARAMETER DotfilesPath
  Local path to the xpcoffee/dotfiles clone. Defaults to $HOME\dotfiles.

.PARAMETER DotfilesRemote
  Git remote to clone from if DotfilesPath doesn't exist yet.

.EXAMPLE
  .\install.ps1
.EXAMPLE
  .\install.ps1 -DotfilesPath D:\code\dotfiles
#>

[CmdletBinding()]
param(
    [string]$DotfilesPath   = "$HOME\dotfiles",
    [string]$DotfilesRemote = "https://github.com/xpcoffee/dotfiles.git"
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Warn {
    param([string]$Message)
    Write-Host "!! $Message" -ForegroundColor Yellow
}

# --- 1. Pre-flight -----------------------------------------------------
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget was not found. Install 'App Installer' from the Microsoft Store, then re-run this script."
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git was not found on PATH. Install Git for Windows, then re-run this script."
}

# komorebi's docs list long path support as a prerequisite. Enabling it needs admin,
# which the rest of this script deliberately doesn't require, so just flag it.
$longPaths = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -ErrorAction SilentlyContinue).LongPathsEnabled
if ($longPaths -ne 1) {
    Write-Warn "Long path support is not enabled (a komorebi prerequisite). In an admin PowerShell, run:"
    Write-Warn "  Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -Value 1"
}

# --- 2. Dotfiles checkout ------------------------------------------------
if (-not (Test-Path $DotfilesPath)) {
    Write-Step "Cloning dotfiles to $DotfilesPath"
    git clone $DotfilesRemote $DotfilesPath
}
else {
    Write-Step "Using existing dotfiles checkout at $DotfilesPath"
}

$KomorebiDir    = Join-Path $DotfilesPath "komorebi"
$KomorebiConfig = Join-Path $KomorebiDir "komorebi.json"
$WhkdrcPath     = Join-Path $KomorebiDir "whkdrc"

if (-not (Test-Path $KomorebiConfig) -or -not (Test-Path $WhkdrcPath)) {
    throw "Expected to find komorebi.json and whkdrc under $KomorebiDir but didn't. " +
          "Check that the clone at $DotfilesPath is up to date."
}

# --- 3. Install packages (idempotent) ------------------------------------
# PowerToys is deliberately not installed here: it's unrelated to komorebi, and its
# installer needs an admin elevation prompt that turns this into an interactive script.
# See the README's "Optional extras" section.
Write-Step "Installing komorebi and whkd via winget (already-installed packages are skipped)"
$packages = @("LGUG2Z.komorebi", "LGUG2Z.whkd")
foreach ($pkg in $packages) {
    winget install --id $pkg --exact --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        # winget returns non-zero for "already installed, nothing to do" as well as
        # genuine failures, so this is informational rather than fatal - check the
        # printed output above if a package you expect to be present seems missing.
        Write-Warn "winget exited with code $LASTEXITCODE while installing $pkg - check the output above; this is often just 'already installed'."
    }
}

# winget updates PATH in the registry, but this already-running session won't see the
# newly installed komorebic until we re-read it. Without this, a first run on a clean
# machine fails at the first komorebic call below.
$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [Environment]::GetEnvironmentVariable("Path", "User")

if (-not (Get-Command komorebic -ErrorAction SilentlyContinue)) {
    throw "komorebic is still not on PATH after installing. Open a new shell and re-run this script."
}

# --- 4. Point komorebi and whkd at the dotfiles config -------------------
# This is what makes the repo the single source of truth: every komorebic subcommand
# resolves komorebi.json/whkdrc from here, so `komorebic check`, `start`, and
# `reload-configuration` (Win+Ctrl+R) all agree without passing --config around.
Write-Step "Setting KOMOREBI_CONFIG_HOME and WHKD_CONFIG_HOME -> $KomorebiDir"
foreach ($var in @("KOMOREBI_CONFIG_HOME", "WHKD_CONFIG_HOME")) {
    [Environment]::SetEnvironmentVariable($var, $KomorebiDir, "User")
    Set-Item -Path "Env:$var" -Value $KomorebiDir
}

# --- 5. Pull down community app-specific tiling tweaks -------------------
# Writes applications.json into KOMOREBI_CONFIG_HOME (this repo); it's gitignored.
Write-Step "Fetching komorebi's community app-specific configuration"
try {
    komorebic fetch-app-specific-configuration
}
catch {
    Write-Warn "Could not fetch app-specific configuration (non-fatal): $_"
}

# --- 6. Validate before starting -------------------------------------------
# `komorebic start` only reports "komorebi.exe did not start" when the config is bad,
# which is a miserable thing to debug. `check` prints the actual parse error.
Write-Step "Validating configuration"
komorebic check
if ($LASTEXITCODE -ne 0) {
    throw "komorebic check failed - fix the errors above before starting komorebi."
}

# --- 7. Start now ----------------------------------------------------------
Write-Step "Starting komorebi + whkd"
komorebic start --whkd

# --- 8. Autostart on login --------------------------------------------------
Write-Step "Registering autostart at login"
komorebic enable-autostart --whkd

Write-Host ""
Write-Host "Done. komorebi + whkd are running and registered to start at login." -ForegroundColor Green
Write-Host "Config lives in the dotfiles repo: 'git pull' in $DotfilesPath, then Win+Ctrl+R (or 'komorebic reload-configuration'), picks up changes." -ForegroundColor Green
Write-Host "Stop it cleanly with 'komorebic stop --whkd'." -ForegroundColor Green
