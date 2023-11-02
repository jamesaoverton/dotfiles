with import <nixpkgs> {};

pkgs.mkShell {
  buildInputs = [
    # editor
    helix
    ltex-ls
    nil # nix language server
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
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
    # visidata
  ];
}
