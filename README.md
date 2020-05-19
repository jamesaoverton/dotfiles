# James A. Overton's Dotfiles

These [dotfiles](http://dotfiles.github.io) are managed using [vcsh](https://github.com/RichiH/vcsh) and available at <https://github.com/jamesaoverton/dotfiles>. To start using them, first install `vcsh`, then clone the files with:

    vcsh clone git@github.com:jamesaoverton/dotfiles dotfiles

Then you can use `vcsh dotfiles ...` to do pretty much anything that you would normally do with `git ...`.

## Nix Packages

Here are some standard packages that I use with Nix and NixOS:

```
mosh tmux git vcsh neovim silver-searcher tree
```

You can install these into a temporary shell like so:

```
nix-shell -p $(grep ^mosh README.md)
```

Or you can install them into your user environment like so:

```
nix-env -i $(grep ^mosh README.md)
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

## NeoVim

To use the [NeoVim](https://neovim.io) configuration in `.config/nvim/init.vim` you first have to install [vim-plug](https://github.com/junegunn/vim-plug) and then run `:PlugInstall`.

## Tmux

To use the [tmux](https://github.com/tmux/tmux/wiki) configuration in `.config/tmux/tmux.conf` you first have to install [tpm](https://github.com/tmux-plugins/tpm).
