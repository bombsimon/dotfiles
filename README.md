# dotfiles

My personal dotfiles. Combination of configuration for tools used both under
macOS and Linux.

## Install

A simple makefile can help install.

```
# Clone repository
mkdir -p ~/git
git clone git@github.com:bombsimon/dotfiles.git ~/git/dotfiles

# Install
cd ~/git/dotfiles && make all
```

## Prerequisites

Most of the things used is setup with Brew, however the configuration should
also work under other Linux. The setup for
[`coc.vim`](https://github.com/neoclide/coc.nvim) is the one which is most
special so remmber to read the installation notes. All required Python
dependencies can be installed by running `pip install --upgrade -r
requirements.txt`

### vim/neovim

As seen in [`vimrc`](vimrc) there are a few fixers and linters applied. For
other things such as auto installing
[vim-plug](https://github.com/junegunn/vim-plug) toos like
[curl](https://curl.haxx.se/) is required. The list below shows all dependencies
used.

* [Black](https://github.com/python/black)
* [ctags](https://ctags.io/)
* [curl](https://curl.haxx.se/)
* [eslint](https://eslint.org/)
* [flake8](http://flake8.pycqa.org/en/latest/)
* [golangci-lint](https://github.com/golangci/golangci-lint)
* [jq](https://stedolan.github.io/jq/)
* [nodejs](https://nodejs.org/en/)
* [perltidy](https://metacpan.org/pod/perltidy)
* [pylint](https://www.pylint.org/)
* [rubocop](https://github.com/rubocop-hq/rubocop)
* [yarn](https://yarnpkg.com/en/)

## Other configuration

### tmux

To auto run `tmux` and start the **same** session as always (default 'main'
session) configure the terminal to auto run the following command in the shell
when started:

```sh
tmux new-session -A -s main
```

When shell is changed (i.e `chsh -s /usr/local/bin/fish`), the tmux server must
be restarted with `tmux kill-server` for changes to take effect.

### Color palette

As seen in `vimrc` the current theme used is
[Gruvbox](https://github.com/morhetz/gruvbox). For iTerm2 i use the
`base16-default-dark-256` from
[base16-iterm2](https://github.com/martinlindhe/base16-iterm2) repository found
here (and also saved in `iterm/profiles.json`.

The colors from the base16 theme is also used for tmux as seen in
`tmux.conf.local`.

![screenshot](https://raw.githubusercontent.com/bombsimon/dotfiles/master/img/screenshot01.png)
