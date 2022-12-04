# Helix

- https://helix-editor.com
- https://github.com/helix-editor/helix
- https://github.com/helix-editor/helix/wiki/How-to-install-the-default-language-servers

```sh
nix-shell -p helix \
  clojure-lsp \
  nodePackages.bash-language-server \
  nodePackages.dockerfile-language-server-nodejs \
  nodePackages.vscode-langservers-extracted \
  nodePackages.yaml-language-server \
  python39Packages.python-lsp-server \
  rnix-lsp \
  shellcheck \
  taplo-cli
```


# Overview

Overall, Helix is great for code.
I would say that Kakoune has a more principled design,
but it's hard to beat the LSP and tree-sitter magic.

Helix is not really suitable for editing prose,
because of two major limitations:

1. no soft wrapping for long lines
2. no spell checking

Both of these are being worked on.


# Customization

It's not very clear from the documentation,
but the `config.toml` lets you add custom menus
and insert custom commands into existing menus.

```toml
[keys.normal.space]
z = ":sh echo 'New command in existing menu'"

[keys.normal.C-j]
z = ":sh echo 'New command in new menu'"
```

# Features I Want

- better variables for scripting
- custom menu labels and stickiness
- soft line wrapping
- spell checking
- hooks: on open file type or path

