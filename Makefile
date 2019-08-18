BASH_COMPLETION        ?= /etc/bash_completion
COMPLETE_DOCKER_COMPOSE = 1.22.0
COMPLETE_DOCKER_MACHINE = v0.14.0
CONFIG_DIRECTORIES      = fish/functions i3 i3status nvim
INSTALL_BREW            =
SOURCEFILE             ?= ~/.bashrc
SYMBOLIC_LINKS          = config/nvim/init.vim config/nvim/coc-settings.json \
							gitconfig gitignore golangci.yml ideavimrc \
							my.cnf perlcriticrc perltidyrc ripgreprc sqliterc \
							config/i3/config config/i3status/config \
							config/fish/config.fish \
							config/fish/functions/fish_prompt.fish

ifeq ($(shell uname -s),Darwin)
    BASH_COMPLETION     = $(shell brew --prefix)$(BASH_COMPLETION)
    SOURCEFILE          = ~/.profile

ifeq (,$(shell which brew))
    INSTALL_BREW        = 1
endif

endif

BASH_COMPLETION_D      ?= $(BASH_COMPLETION).d

ifdef INSTALL_BREW
mac: brew
endif

bash_completion:
	sudo curl -sL https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker \
		-o $(BASH_COMPLETION_D)/docker
	sudo curl -sL https://raw.githubusercontent.com/docker/compose/$(COMPLETE_DOCKER_COMPOSE)/contrib/completion/bash/docker-compose \
		-o $(BASH_COMPLETION_D)/docker-compose
	sudo curl -sL https://raw.githubusercontent.com/docker/machine/$(COMPLETE_DOCKER_MACHINE)/contrib/completion/bash/docker-machine.bash \
		-o $(BASH_COMPLETION_D)/docker-machine

brew:
	@echo "Installing Brew (https://brew.sh)"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

clean:
	@echo "Removing all symbolic links"
	@$(foreach s,$(SYMBOLIC_LINKS), rm -f ~/.$(s);)
	@rm -f ~/.tmux.conf*

dirs:
	@echo "Creating required directories (if not exist)"
	@$(foreach d,$(CONFIG_DIRECTORIES), mkdir -p ~/.config/$(d);)

links: dirs tmux
	@echo "Creating symbolic links for all config files"
	@$(foreach s,$(SYMBOLIC_LINKS), test -f ~/.$(s) || ln -s $(PWD)/$(s) ~/.$(s);)

mac:
	@echo "Configuring macOS"
	xcode-select --install
	brew bundle
	defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
	defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)

source:
	@echo "Adding bashrc and bash completions to be sourced"
	[ -f $(SOURCEFILE) ]                  || touch $(SOURCEFILE)
	grep dotfiles $(SOURCEFILE)           || echo "[ -f $(HOME)/git/dotfiles/bashrc ] && . $(HOME)/git/dotfiles/bashrc" >> $(SOURCEFILE)
	grep $(BASH_COMPLETION) $(SOURCEFILE) || echo "[ -f $(BASH_COMPLETION) ] && . $(BASH_COMPLETION)" >> $(SOURCEFILE)

tmux:
	@echo "Symlinking and configuring tmux"
	@$(shell [ -f ~/.tmux.conf ]       || ln -s $(PWD)/gpakosz.tmux/.tmux.conf ~/.tmux.conf)
	@$(shell [ -f ~/.tmux.conf.local ] || cp $(PWD)/gpakosz.tmux/.tmux.conf.local ~/.tmux.conf.local && cat $(PWD)/tmux.conf.local >> ~/.tmux.conf.local)

.PHONY: bash_completion brew clean dirs links mac source clean

# vim: set ts=4 sw=4 noexpandtab:
