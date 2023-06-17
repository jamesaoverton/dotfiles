# James A. Overton's Dotfiles

These [dotfiles](http://dotfiles.github.io) are available at <https://github.com/jamesaoverton/dotfiles> and meant to be installed into `~/.config`.

## Scripts

I usually `ssh` into the machine and then run `resume` (in `bin/resume`) to start or re-attach to a [Zellij](https://github.com/zellij-org/zellij) session. This requires installing a binary in `~/config/bin/zellij`.

## Nix Packages

I only install a few packages user-wide, then rely on `~/.config/nix/shell.nix` for the packages that I use in general, and project-specific `shell.nix` configurations.

```
nix-env -iA nixpkgs.starship
```

## Nix on macOS

When using Nix on macOS in a multi-user installation the channel is controlled by the `root` user, so use `sudo -i` to make sure that `root`'s shell profile is loaded:

```
sudo -i nix-channel --list
sudo -i nix-channel --update
```

## Bash

To use the Nix version of Bash on macOS, first install it, then add it to `/etc/shells`, then use `chsh`:

```
nix-env -iA nixpkgs.bashInteractive
sudo sh -c "echo /Users/james/.nix-profile/bin/bash >> /etc/shells"
chsh -s /Users/james/.nix-profile/bin/bash
```

## Blink

I use the Blink Shell app on my iPad.

Settings > General > Keyboard > Shortcuts:
In iPadOS 16.1 I had to turn this off,
otherwise a floating menu for some keyboard options
would appear and cause multiple resize events
every time I switched tabs or apps.


