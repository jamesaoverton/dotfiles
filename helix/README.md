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
  rnix-lsp \
  shellcheck \
  taplo-cli
```

Rust only seems to work within a nix-shell:

```sh
nix-shell -p gcc rustc rustfmt cargo rust-analyzer
```

Python is trickier than the other LSPs.
Try something like:

```sh
nix-shell -p python310Packages.ujson
pip install 'python-lsp-server[all]'
```

I got spell checking working for Markdown using `ltex-ls`.
In `language.toml`:

```toml
[[language]]
name = "markdown"
language-server = { command = "ltex-ls" }
file-types = ["md", "markdown", "qmd"]
scope = "source.markdown"
roots = []
```

Then `nix-shell -p ltex-ls`.
It uses max CPU for ~10 seconds, then calms down.
There are some nice code actions,
but adding to dictionary does not work.
It detects a `lang: en-CA` line in Markdown YAML frontmatter.
I **finally** got some configuration to work in `language.toml`:

```toml
config.ltex.dictionary.en-US = ["OMOP"]
```

It's supposed to work with external files
<https://valentjn.github.io/ltex/vscode-ltex/setting-scopes-files.html#external-setting-files>but I could not get that to work.
I guess it only works in VSCode:
<https://github.com/valentjn/ltex-ls/issues/157>.


# Overview

Overall, Helix is great for code.
I would say that Kakoune has a more principled design,
but it's hard to beat the LSP and tree-sitter magic.

Helix is not really suitable for editing prose,
because of two major limitations:

1. no soft wrapping for long lines
2. no spell checking

Both of these are being worked on.


## Tips

- `xml` is not supported, so just use `html`
  - strangely, there's no tree-sitter grammar for XML


# Theme

I made a customized solarized theme.
This requires mosh 1.4.0 or later,
but Nix 22.05 just has mosh 1.3.2.
I was able to install this one package from unstable:

```
nix-env -I nixpkgs=channel:nixpkgs-unstable -uA mosh
```


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


