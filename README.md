# dotfiles

This repo maintains a collection of configuration files that I use.

It uses [`GNU stow`](https://www.gnu.org/software/stow/manual/stow.html) to symlink configuration to where software expects it to be.

## Getting started

Link dotfiles.

In the case of conflict, this will 'adopt' files that currently exist on the host. And output them.

```shell
./install.sh
```

Restore changes you don't want to keep using `git`.

## Contents

This contains my configuration for:

-   git
-   vim
-   [fish-shell](https://fishshell.com/)
-   [tmux](https://github.com/tmux/tmux/wiki)
-   [z-shell](https://www.zsh.org/) (not actively used)
-   [i3](https://i3wm.org/) (not actively used)
-   emacs (not actively used)

See the READMEs in the subdirectories for more.

For more tools see [the wiki](https://github.com/xpcoffee/dotfiles/wiki/Tooling).
