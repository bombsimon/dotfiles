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
