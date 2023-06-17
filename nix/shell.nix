with import <nixpkgs> {};

pkgs.mkShell {
  buildInputs = [
    # editor
    kakoune
    helix
    nodePackages.bash-language-server
    ltex-ls
    nil # nix language server
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
