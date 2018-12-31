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

## Other configuration

### tmux

To auto run `tmux` and start the **same** session as always (default 'main'
session) configure the terminal to auto run the following command in the shell
when started:
```
tmux new-session -A -s main
```

### Color palette

As seen in `vimrc` the current theme used is
[Gruvbox](https://github.com/morhetz/gruvbox). For iTerm2 i use the
`base16-default-dark-256` from
[base16-iterm2](https://github.com/martinlindhe/base16-iterm2) repository found
here (and also saved in `iterm/profiles.json`.

The colors from the base16 theme is also used for tmux as seen in
`tmux.conf.local`.
