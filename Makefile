SED                    ?= gsed
BASH_COMPLETION         = /etc/bash_completion
COMPLETE_DOCKER_COMPOSE = 1.25.0
COMPLETE_DOCKER_MACHINE = v0.16.0
SHELL_NAME             ?= zsh
OH_MY_ZSH_THEME         = bira
SHELLRC                 = $(SHELL_NAME)rc
SOURCEFILE              = ~/.$(SHELLRC)
CONFIG_DIRECTORIES      = fish/functions i3 i3status nvim
SYMBOLIC_LINKS          = config/nvim/init.vim config/nvim/coc-settings.json \
							gitconfig gitignore golangci.yml ideavimrc \
							my.cnf perlcriticrc perltidyrc ripgreprc sqliterc \
							config/i3/config config/i3status/config \
							config/fish/config.fish \
							config/fish/functions/fish_prompt.fish

ifeq ($(shell uname -s),Darwin)
	BASH_COMPLETION    := $(shell brew --prefix)$(BASH_COMPLETION)
endif

BASH_COMPLETION_D       = $(BASH_COMPLETION).d

.PHONY: help
help: ## Show this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

$(BASH_COMPLETION_D)/docker:
	@sudo curl -sL \
		https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker \
		-o $(BASH_COMPLETION_D)/docker

$(BASH_COMPLETION_D)/docker-compose:
	@sudo curl -sL \
		https://raw.githubusercontent.com/docker/compose/$(COMPLETE_DOCKER_COMPOSE)/contrib/completion/bash/docker-compose \
		-o $(BASH_COMPLETION_D)/docker-compose

$(BASH_COMPLETION_D)/docker-machine:
	@sudo curl -sL \
		https://raw.githubusercontent.com/docker/machine/$(COMPLETE_DOCKER_MACHINE)/contrib/completion/bash/docker-machine.bash \
		-o $(BASH_COMPLETION_D)/docker-machine

.PHONY: bash-completion
bash-completion: $(BASH_COMPLETION_D)/docker $(BASH_COMPLETION_D)/docker-compose $(BASH_COMPLETION_D)/docker-machine ## Install bash completion for docker, docker-compose and add it to the shell config file
	@grep $(BASH_COMPLETION) $(SOURCEFILE) || echo "\n[ -f $(BASH_COMPLETION) ] && . $(BASH_COMPLETION)" >> $(SOURCEFILE)

.PHONY: mostly-clean
mostly-clean: ## Remove all symbolig links, remove tmux config, uninstall oh-my-zsh
	@$(foreach s,$(SYMBOLIC_LINKS), rm -f ~/.$(s);)
	@rm -f ~/.tmux.conf*
	@$(SED) -i '\#dotfiles#d' $(SOURCEFILE)
	@$(SED) -i '\#$(BASH_COMPLETION)#d' $(SOURCEFILE)

.PHONY: clean
clean: mostly-clean ## Remove everything and uninstall oh-my-zsh
	@uninstall_oh_my_zsh

.PHONY: create-source
create-source: ## Create a source file for the shell (bashrc or zshrc)
	@cp shell_config $(HOME)/.$(SHELLRC)
	@cat $(SHELLRC) >> $(HOME)/.$(SHELLRC)

.PHONY: dirs
dirs: ## Create requirerd directories for configuration
	@$(foreach d,$(CONFIG_DIRECTORIES), mkdir -p ~/.config/$(d);)

.PHONY: links
links: dirs tmux ## Create symlinks for all configuration files
	@$(foreach s,$(SYMBOLIC_LINKS), test -f ~/.$(s) || ln -s $(PWD)/$(s) ~/.$(s);)

/usr/local/bin/brew: ## Install brerw
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

.PHONY: mac
mac: /usr/local/bin/brew ## Setup basic macOS applications
	@xcode-select --install
	@brew bundle

$(HOME)/.pyenv:
	@curl https://pyenv.run | bash

$(HOME)/.oh-my-zsh: ## Install oh-my-zsh
	@sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

$(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting: $(HOME)/.oh-my-zsh ## oh-my-zsh plugin
	@git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		$${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

$(HOME)/.oh-my-zsh/custom//plugins/zsh-autosuggestions: $(HOME)/.oh-my-zsh ## oh-my-zsh plugin
	@git clone https://github.com/zsh-users/zsh-autosuggestions \
		$${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

.PHONY: zsh-plugins
zsh-plugins: $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting $(HOME)/.oh-my-zsh/custom//plugins/zsh-autosuggestions ## Install oh-my-zsh plugins

.PHONY: oh-my-zsh
oh-my-zsh: zsh-plugins ## Install oh-my-zsh and belonging plugins, update oh-my-zsh config
	@$(SED) -i 's/ZSH_THEME=".\+"/ZSH_THEME="$(OH_MY_ZSH_THEME)"/' ~/.$(SHELLRC)
	@$(SED) -i 's/plugins=(git)/plugins=(git docker docker-compose kubectl zsh-autosuggestions zsh-syntax-highlighting)/' $(SOURCEFILE)
	@grep "Custom config" $(HOME)/.$(SHELLRC) > /dev/null || \
		(echo "" >> $(HOME)/.$(SHELLRC) && \
		echo "# Custom config" >> $(HOME)/.$(SHELLRC) && \
		cat shell_config >> $(HOME)/.$(SHELLRC) && \
		echo "" >> $(HOME)/.$(SHELLRC) && \
		cat zshrc >> $(HOME)/.$(SHELLRC)

.PHONY: source
source: create-source ## Create directories used in source file
	@mkdir -p $(HOME)/.bin # Used in PATH

$(HOME)/.tmux.conf:
	@$(shell [ -f ~/.tmux.conf ] || ln -s $(PWD)/gpakosz.tmux/.tmux.conf ~/.tmux.conf)

$(HOME)/.tmux.conf.local:
	@$(shell [ -f ~/.tmux.conf.local ] || cp $(PWD)/gpakosz.tmux/.tmux.conf.local ~/.tmux.conf.local)

.PHONY: tmux
tmux: $(HOME)/.tmux.conf $(HOME)/.tmux.conf.local ## Seup tmux config
	$(shell cat $(PWD)/tmux.conf.local >> ~/.tmux.conf.local)

# vim: set ts=4 sw=4 noexpandtab:
