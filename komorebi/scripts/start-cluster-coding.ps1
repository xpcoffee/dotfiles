<#
.SYNOPSIS
  Example "workspace cluster" launcher: opens a set of programs together and
  lets komorebi's workspace_rules (in komorebi.json) auto-route each one to
  the right workspace as it opens.

.DESCRIPTION
  This is the answer to the optional "save workspace configuration so I can
  open clusters of programs together" requirement. komorebi has no built-in
  session save/restore, so the pattern instead is:

    1. Add a workspace_rules entry to komorebi.json naming the exe(s) that
       belong on a given workspace (see the "coding" workspace example in
       the proposal doc).
    2. Write a tiny script like this one per cluster that just launches the
       programs; komorebi does the routing.
    3. Bind the script to a shortcut/hotkey of your choosing if you want,
       or just run it from a terminal/launcher.

  Duplicate this file per cluster (e.g. start-cluster-writing.ps1,
  start-cluster-gaming.ps1) and edit the Start-Process lines.
#>

Start-Process "wt.exe"                                   # Windows Terminal
Start-Process "C:\Users\$env:USERNAME\AppData\Local\Programs\Microsoft VS Code\Code.exe"
Start-Process "msedge.exe" -ArgumentList "https://github.com"
