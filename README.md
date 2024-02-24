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
-   [tmux]()
-   [emacs]() (not actively used)
-   [z-shell]() (not actively used)
-   [i3]() (not actively used)

See the READMEs in the subdirectories for more.
