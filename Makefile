VIMFILE                ?= ~/.config/nvim/init.vim
SOURCEFILE             ?= ~/.bashrc
BASH_COMP              ?= /etc/bash_completion

ifeq ($(shell which nvim),)
    VIMFILE = ~/.vimrc
endif

ifeq ($(shell uname -s),Darwin)
    SOURCEFILE = ~/.profile
    BASH_COMP  = $(shell brew --prefix)/etc/bash_completion
endif

BASH_COMP_D ?= $(BASH_COMP).d/
COMPLETE_DOCKER_COMPOSE = "1.22.0"
COMPLETE_DOCKER_MACHINE = "v0.14.0"

dirs:
	mkdir -p ~/.config/nvim
	mkdir -p ~/.config/fish/functions
	mkdir -p ~/.config/i3
	mkdir -p ~/.config/i3status

links: dirs
	[ -f $(VIMFILE) ]                                || ln -s $(PWD)/vimrc $(VIMFILE)
	[ -f ~/.gitconfig ]                              || ln -s $(PWD)/gitconfig ~/.gitconfig
	[ -f ~/.gitignore ]                              || ln -s $(PWD)/gitignore ~/.gitignore
	[ -f ~/.ripgreprc ]                              || ln -s $(PWD)/ripgreprc ~/.ripgreprc
	[ -f ~/.sqliterc ]                               || ln -s $(PWD)/sqliterc ~/.sqliterc
	[ -f ~/.my.cnf ]                                 || ln -s $(PWD)/my.cnf ~/.my.cnf
	[ -f ~/.tmux.conf ]                              || ln -s $(PWD)/gpakosz.tmux/.tmux.conf ~/.tmux.conf
	[ -f ~/.tmux.conf.local ]                        || cp $(PWD)/gpakosz.tmux/.tmux.conf.local ~/.tmux.conf.local && cat $(PWD)/tmux.conf.local >> ~/.tmux.conf.local
	[ -f ~/.config/i3/config ]                       || ln -s $(PWD)/i3/config ~/.config/i3/config
	[ -f ~/.config/i3status/config ]                 || ln -s $(PWD)/i3status/config ~/.config/i3status/config
	[ -f ~/.config/fish/config.fish ]                || ln -s $(PWD)/fish/config.fish ~/.config/fish/config.fish
	[ -f ~/.config/fish/functions/fish_prompt.fish ] || ln -s $(PWD)/fish/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish

mac:
	xcode-select --install
	brew bundle
	sudo curl -sL https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o $(BASH_COMP_D)/docker
	sudo curl -sL https://raw.githubusercontent.com/docker/compose/$(COMPLETE_DOCKER_COMPOSE)/contrib/completion/bash/docker-compose -o $(BASH_COMP_D)/docker-compose
	sudo curl -sL https://raw.githubusercontent.com/docker/machine/$(COMPLETE_DOCKER_MACHINE)/contrib/completion/bash/docker-machine.bash -o $(BASH_COMP_D)/docker-machine
	defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
	defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

source:
	[ -f $(SOURCEFILE) ]            || touch $(SOURCEFILE)
	grep dotfiles $(SOURCEFILE)     || echo "[ -f $(HOME)/git/dotfiles/bashrc ] && . $(HOME)/git/dotfiles/bashrc" >> $(SOURCEFILE)
	grep $(BASH_COMP) $(SOURCEFILE) || echo "[ -f $(BASH_COMP) ] && . $(BASH_COMP)" >> $(SOURCEFILE)

clean:
	rm -f ~/.vimrc
	rm -f ~/.config/nvim/init.vim
	rm -f ~/.gitconfig
	rm -f ~/.gitignore
	rm -f ~/.ripgreprc
	rm -f ~/.tmux.conf
	rm -f ~/.tmux.conf.local
	rm -f ~/.sqliterc
	rm -f ~/.config/i3/config
	rm -f ~/.config/i3status/config
	rm -f ~/.config/fish/config.fish
	rm -f ~/.config/fish/functions/functions.fish

.PHONY: all dirs links mac source clean

# vim: set ts=4 sw=4 noexpandtab:
