with import <nixpkgs> {};

pkgs.mkShell {
  buildInputs = [
    # terminal
    mosh
    starship
    zellij

    # editor
    kakoune
    helix
    nodePackages.bash-language-server
    ltex-ls
    rnix-lsp
    shellcheck
    taplo
    yaml-language-server

    # utilities
    gh
    git
    htop
    jq
    sqlite
    tree
    visidata
  ];
  shellHook = ''
    zellij attach "$(hostname)" \
    || zellij --session "$(hostname)" --layout "$(pwd)/.config/zellij/$(hostname).kdl" \
    || zellij --session "$(hostname)" --layout "$(pwd)/.config/zellij/default.kdl"
  '';
}
