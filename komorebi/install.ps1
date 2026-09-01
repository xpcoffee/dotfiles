<#
.SYNOPSIS
  Installs and configures komorebi + whkd for a tiling window manager on Windows,
  reading its config straight out of the xpcoffee/dotfiles checkout so there is a
  single source of truth shared across machines.

.DESCRIPTION
  1. Verifies winget is available.
  2. Clones (or reuses) the dotfiles repo.
  3. Installs komorebi, whkd, and PowerToys via winget (idempotent - skips if present).
  4. Points whkd at <dotfiles>/komorebi/whkdrc via the WHKD_CONFIG_HOME env var.
  5. Fetches komorebi's community-maintained per-app tiling tweaks.
  6. Starts komorebi + whkd + the status bar using <dotfiles>/komorebi/komorebi.json.
  7. Registers autostart at login with the same config.

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
          "Copy them from the proposal into the dotfiles repo (see the 'Repo layout' " +
          "section of the proposal doc), commit, then re-run this script."
}

# --- 3. Install packages (idempotent) ------------------------------------
Write-Step "Installing komorebi, whkd, and PowerToys via winget (already-installed packages are skipped)"
$packages = @("LGUG2Z.komorebi", "LGUG2Z.whkd", "Microsoft.PowerToys")
foreach ($pkg in $packages) {
    winget install --id $pkg --exact --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        # winget returns non-zero for "already installed, nothing to do" as well as
        # genuine failures, so this is informational rather than fatal - check the
        # printed output above if a package you expect to be present seems missing.
        Write-Warn "winget exited with code $LASTEXITCODE while installing $pkg - check the output above; this is often just 'already installed'."
    }
}

# --- 4. Point whkd at the dotfiles copy of whkdrc ------------------------
Write-Step "Setting WHKD_CONFIG_HOME -> $KomorebiDir"
[Environment]::SetEnvironmentVariable("WHKD_CONFIG_HOME", $KomorebiDir, "User")
$env:WHKD_CONFIG_HOME = $KomorebiDir

# --- 5. Pull down community app-specific tiling tweaks -------------------
Write-Step "Fetching komorebi's community app-specific configuration"
try {
    komorebic fetch-app-specific-configuration
}
catch {
    Write-Warn "Could not fetch app-specific configuration (non-fatal): $_"
}

# --- 6. Start now ----------------------------------------------------------
Write-Step "Starting komorebi + whkd + bar"
try {
    komorebic start --whkd --bar -c "$KomorebiConfig"
}
catch {
    Write-Warn "komorebic start reported an error (it may already be running): $_"
}

# --- 7. Autostart on login --------------------------------------------------
Write-Step "Registering autostart at login"
komorebic enable-autostart --whkd --bar -c "$KomorebiConfig"

Write-Host ""
Write-Host "Done. komorebi + whkd are running and registered to start at login." -ForegroundColor Green
Write-Host "Config lives in the dotfiles repo: 'git pull' in $DotfilesPath, then Super+Ctrl+R (or 'komorebic reload-configuration'), picks up changes." -ForegroundColor Green
Write-Warn "This script does not touch PowerToys Keyboard Manager - double-check your CapsLock->Esc remap is still set there."
