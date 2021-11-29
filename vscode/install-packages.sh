#!/bin/sh

packages="
  asvetliakov.vscode-neovim
  bazelbuild.vscode-bazel
  bierner.markdown-preview-github-styles
  cheshirekow.cmake-format
  cpptools-linux.vsix
  davidanson.vscode-markdownlint
  dbaeumer.vscode-eslint
  eamodio.gitlens
  elixir-lsp.elixir-ls
  elmtooling.elm-ls-vscode
  equinusocio.vsc-material-theme
  esbenp.prettier-vscode
  golang.go
  haskell.haskell
  heptio.jsonnet
  hoovercj.haskell-linter
  mads-hartmann.bash-ide-vscode
  mblode.pretty-formatter
  ms-python.python
  ms-vscode.cmake-tools
  pkief.material-icon-theme
  redhat.java
  redhat.vscode-yaml
  rust-lang.rust
  sfodje.perlcritic
  sfodje.perltidy
  shardulm94.trailing-spaces
  timonwong.shellcheck
  twxs.cmake
  vlanguage.vscode-vlang
  wayou.vscode-todo-highlight
"

for pkg in $packages; do
  code --install-extension "$pkg"
done

# vim: set ts=2 sw=2 et:
