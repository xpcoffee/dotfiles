# dotfiles

This repo maintains a collection of configuration files that I use, as well as utilities to set things up.

## Pre-requisies

The install script uses [`GNU stow`](https://www.gnu.org/software/stow/manual/stow.html) uses it to link config.

* For mac: you can use `brew install stow` to install GNU stow.
* For linux: the script gets installed automatically ⚠


## Getting started

**Run the install script**

```shell
./install.sh
```

This will create simlinks to `~` and `~/.config/`, depending on the config.
    
If there was already a file existing for one of these files, the script will 'adopt' files that currently exist, and log out which files this has happened for.

  * This repo is version-controlled, so you can use `git diff` locally to see the difference between any files that have been adopted and what this repo contains.
  * You can then decide what to keep or revert.
  * Commit any changes so that they can be re-used in future.

For more tooling and steps to do after installing config see [the wiki](https://github.com/xpcoffee/dotfiles/wiki).
