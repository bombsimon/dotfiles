#!/bin/sh

packages="
  0x9ef.vscode-vlang
  alanz.vscode-hie-server
  archaeron.vscode-tabularize
  cfgweb.vscode-perl
  davidanson.vscode-markdownlint
  dbaeumer.vscode-eslint
  eamodio.gitlens
  esbenp.prettier-vscode
  golang.go
  hoovercj.haskell-linter
  jdinhlife.gruvbox
  justusadam.language-haskell
  kraih.mojolicious
  mjmcloug.vscode-elixir
  mohsen1.prettify-json
  ms-python.python
  ms-vscode.cmake-tools
  ms-vscode.cpptools
  ms-vscode.go
  rebornix.ruby
  redhat.java
  rust-lang.rust
  sbrink.elm
  sfodje.perlcritic
  shardulm94.trailing-spaces
  technosophos.vscode-make
  timonwong.shellcheck
  twxs.cmake
  vscjava.vscode-java-debug
  vscodevim.vim
"

for pkg in $packages; do
  code --install-extension "$pkg"
done

# vim: set ts=2 sw=2 et:
