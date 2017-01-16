# James A. Overton's Dotfiles

These [dotfiles](http://dotfiles.github.io) are managed using [vcsh](https://github.com/RichiH/vcsh) and available at <https://github.com/jamesaoverton/dotfiles>. To start using them, first install `vcsh`, then clone the files with:

    vcsh clone git@github.com:jamesaoverton/dotfiles dotfiles

The `default.nix` file configures [Nix](https://nixos.org/nix/) with a set of tools I often use. On NixOS or with Nix installed, either:

1. run `nix-shell` in the same directory to read `defaults.nix` and switch to a new shell with these packages available

2. run `nix-env -i ...` with the list of packages to install them into the default environment

To use the [NeoVim](https://neovim.io) configuration in `.config/nvim/init.vim` you first have to install [vim-plug](https://github.com/junegunn/vim-plug) and then run `:PlugInstall`.

To use the Nix version of Bash on macOS, first install it, then add it to `/etc/shells`, then use `chsh`:

    nix-env -iA nixpkgs bashInteractive
    sudo echo "/Users/james/.nix-profile/bin/bash" >> /etc/shells
    chsh -s /Users/james/.nix-profile/bin/bash
