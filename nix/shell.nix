with import <nixpkgs> {};

pkgs.mkShell {
  buildInputs = [
    # terminal
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
    entr
    gh
    git
    htop
    jq
    sqlite-interactive
    tree
    visidata
  ];
}
