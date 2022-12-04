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
}
