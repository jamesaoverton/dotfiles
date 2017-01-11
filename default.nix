# Global default packages for nix-shell
with import <nixpkgs> {};
stdenv.mkDerivation rec {
  name = "env";
  env = buildEnv { name = name; paths = buildInputs; };
  buildInputs = [
    # You can install these with: nix-env -i ...
    mosh tmux git vcsh neovim silver-searcher tree
  ];
}
