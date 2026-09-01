# komorebi + whkd (Windows tiling window manager)

Windows-side half of a cross-OS tiling setup; the Linux half is omarchy's
default Hyprland, configured to match via [`../hypr/tiling-consistency.conf`](../hypr/tiling-consistency.conf).
Both sides use the same modifier key (the Windows/Super key) and the same
layout for focus, move, workspaces, and the previous-tile toggle, so muscle
memory carries over between machines.

## Setup

```powershell
.\install.ps1
```

Run from PowerShell on a fresh machine (no admin rights required). It clones
this repo if needed, installs komorebi/whkd/PowerToys via winget, points whkd
at `whkdrc` in this folder via the `WHKD_CONFIG_HOME` environment variable,
starts everything with `komorebi.json` from this folder, and registers
autostart at login. Re-running it is safe — see the script's own header
comment for the full step list.

Since config is read straight out of this checkout (no symlinking), updating
any machine after an edit here is just `git pull` followed by `Win+Ctrl+R`
(or a reboot).

## Files

- `komorebi.json` — window manager config: 9 workspaces, borders/theme, and
  `float_rules`/`ignore_rules` so game launchers (Steam, Epic, GOG Galaxy,
  Battle.net) aren't tiled and can go exclusive fullscreen. Add specific game
  `.exe` names here as you hit friction with individual titles.
- `whkdrc` — the hotkey bindings. See the table below.
- `install.ps1` — one-shot setup/update script, see above.
- `scripts/start-cluster-coding.ps1` — example "workspace cluster" launcher
  (opens editor + terminal + browser together). `komorebi.json`'s
  `workspace_rules` route each app to the right workspace as it opens;
  duplicate this script per cluster you want.

## Keybindings

Modifier is the Windows key, written `Win` below (that's also the literal
keyword `whkdrc` uses — not `Super`, which is Hyprland's keyword for the same
physical key on the omarchy side).

| Action | Binding |
|---|---|
| Focus tile left/down/up/right | `Win+h/j/k/l` and `Win+arrows` |
| Move tile left/down/up/right | `Win+Shift+h/j/k/l` and arrows |
| Toggle to previously focused tile (e.g. terminal ↔ browser) | `` Win+` `` |
| Jump to workspace 1-9 | `Win+1..9` |
| Send tile to workspace 1-9 | `Win+Shift+1..9` |
| Next / previous workspace | `Win+Tab` / `Win+Shift+Tab` |
| Jump to former (last-focused) workspace | `Win+Ctrl+Tab` |
| Toggle fullscreen/monocle | `Win+F` |
| Toggle floating | `Win+T` |
| Close window | `Win+Q` |
| Pause tiling (gaming escape hatch) | `Win+P` |
| Reload configuration | `Win+Ctrl+R` |

### Known caveats

- **`Win+L`** is Windows' lock-workstation shortcut and, unlike the other
  `Win+` combos above, isn't a normal shell hotkey — low-level keyboard hooks
  (what whkd uses) don't reliably win against it. It's bound here to "focus
  right" for hjkl-completeness, but `Win+Right` is the reliable version of
  that action; if `Win+L` locks your screen instead, just delete that one
  line from `whkdrc`.
- This scheme intentionally overrides several native Windows shortcuts:
  `Win+1..9` (taskbar launch), `Win+Tab` (Task View), `Win+H` (voice typing),
  `Win+K` (cast/Connect), `Win+T` (cycle taskbar), `Win+X` (power-user
  quick-link menu), and `Win+P` (project/display mode for external
  monitors). Standard tradeoff for a tiling-WM workflow, but `Win+X` and
  `Win+P` specifically are common enough to be worth knowing about — move
  the binding off that key in `whkdrc` if you'd rather keep the native
  behavior.
- komorebi has a known issue where a window in native fullscreen can minimize
  if you switch away from its workspace and back
  ([LGUG2Z/komorebi#1191](https://github.com/LGUG2Z/komorebi/issues/1191)).
  Staying on a game's workspace while playing avoids it.
- `cycle-focus previous` (the previous-tile toggle) cycles by internal order,
  not strictly "most recently focused" — a clean toggle with exactly two
  tiles in a workspace, but may need `focus-last-workspace` instead with
  three or more.
