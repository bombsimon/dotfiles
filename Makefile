VIMFILE    ?= ~/.config/nvim/init.vim
SOURCEFILE ?= ~/.bashrc

ifeq ($(shell which nvim),)
    VIMFILE = ~/.vimrc
endif

ifeq ($(shell uname -s),Darwin)
    SOURCEFILE = ~/.profile
endif

all: links source

dirs:
	mkdir -p ~/.config/nvim
	mkdir -p ~/.config/i3
	mkdir -p ~/.config/i3status

links: dirs
	[ -f $(VIMFILE) ]                || ln -s $(PWD)/vimrc $(VIMFILE)
	[ -f ~/.gitconfig ]              || ln -s $(PWD)/gitconfig ~/.gitconfig
	[ -f ~/.gitignore ]              || ln -s $(PWD)/gitignore ~/.gitignore
	[ -f ~/.ripgreprc ]              || ln -s $(PWD)/ripgreprc ~/.ripgreprc
	[ -f ~/.tmux.conf ]              || ln -s $(PWD)/tmux.conf ~/.tmux.conf
	[ -f ~/.tmux.conf.local ]        || ln -s $(PWD)/tmux.conf.local ~/.tmux.conf.local
	[ -f ~/.sqliterc ]               || ln -s $(PWD)/sqliterc ~/.sqliterc
	[ -f ~/.config/i3/config ]       || ln -s $(PWD)/i3/config ~/.config/i3/config
	[ -f ~/.config/i3status/config ] || ln -s $(PWD)/i3status/config ~/.config/i3status/config

source:
	[ -f $(SOURCEFILE) ]        || touch $(SOURCEFILE)
	grep dotfiles $(SOURCEFILE) || echo "[ -f ~/git/dotfiles/bashrc ] && source ~/git/dotfiles/bashrc" >> $(SOURCEFILE)

clean:
	rm -f ~/.vimrc
	rm -f ~/.config/nvim/init.vim
	rm -f ~/.gitconfig
	rm -f ~/.gitignore
	rm -f ~/.ripgreprc
	rm -f ~/.tmux.config
	rm -f ~/.tmux.config.local
	rm -f ~/.sqliterc
	rm -f ~/.config/i3/config
	rm -f ~/.config/i3status/config

.PHONY: all dirs links source clean

# vim: set ts=4 sw=4 noexpandtab:
