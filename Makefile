SED                    ?= gsed
BASH_COMPLETION         = /etc/bash_completion
COMPLETE_DOCKER_COMPOSE = 1.25.0
COMPLETE_DOCKER_MACHINE = v0.16.0
CONFIG_DIRECTORIES      = fish/functions i3 i3status nvim
SHELL_NAME             ?= zsh
OH_MY_ZSH_THEME         = bira
SHELLRC                 = $(SHELL_NAME)rc
SOURCEFILE              = ~/.$(SHELLRC)
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

help: ## Show this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

bash_completion: ## Install bash completion for docker, docker-compose and add it to the shell config file
	@echo "Downloading bash completion files"
	@sudo curl -sL https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker \
		-o $(BASH_COMPLETION_D)/docker
	@sudo curl -sL https://raw.githubusercontent.com/docker/compose/$(COMPLETE_DOCKER_COMPOSE)/contrib/completion/bash/docker-compose \
		-o $(BASH_COMPLETION_D)/docker-compose
	@sudo curl -sL https://raw.githubusercontent.com/docker/machine/$(COMPLETE_DOCKER_MACHINE)/contrib/completion/bash/docker-machine.bash \
		-o $(BASH_COMPLETION_D)/docker-machine
	@grep $(BASH_COMPLETION) $(SOURCEFILE) || echo "\n[ -f $(BASH_COMPLETION) ] && . $(BASH_COMPLETION)" >> $(SOURCEFILE)

mostly-clean: ## Remove all symbolig links, remove tmux config, uninstall oh-my-zsh
	@echo "Removing all symbolic links"
	@$(foreach s,$(SYMBOLIC_LINKS), rm -f ~/.$(s);)
	@echo "Removing tmux config"
	@rm -f ~/.tmux.conf*
	@echo "Restoring source file"
	@$(SED) -i '\#dotfiles#d' $(SOURCEFILE)
	@$(SED) -i '\#$(BASH_COMPLETION)#d' $(SOURCEFILE)

clean: mostly-clean ## Remove everything and uninstall oh-my-zsh
	@echo "Removing oh-my-zsh"
	@uninstall_oh_my_zsh

create-source: ## Create a source file for the shell (bashrc or zshrc)
	@echo "Creating $(SHELLRC) file"
	@cp shell_config $(HOME)/.$(SHELLRC)
	@echo "" >> $(HOME)/.$(SHELLRC)
	@cat $(SHELLRC) >> $(HOME)/.$(SHELLRC)

dirs: ## Create requirerd directories for configuration
	@echo "Creating required directories (if not exist)"
	@$(foreach d,$(CONFIG_DIRECTORIES), mkdir -p ~/.config/$(d);)

links: dirs tmux ## Create symlinks for all configuration files
	@echo "Creating symbolic links for all config files"
	@$(foreach s,$(SYMBOLIC_LINKS), test -f ~/.$(s) || ln -s $(PWD)/$(s) ~/.$(s);)

/usr/local/bin/brew: ## Install brerw
	@echo "Installing Brew (https://brew.sh)"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

mac: /usr/local/bin/brew ## Setup basic macOS applications
	@echo "Configuring macOS"
	@xcode-select --install
	@brew bundle

$(HOME)/.oh-my-zsh: ## Install oh-my-zsh
	@echo "Installing oh-my-zsh"
	@sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

$(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting: $(HOME)/.oh-my-zsh ## oh-my-zsh plugin
	@echo "Installing zsh-syntax-highlighting"
	@git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		$${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

$(HOME)/.oh-my-zsh/custom//plugins/zsh-autosuggestions: $(HOME)/.oh-my-zsh ## oh-my-zsh plugin
	@echo "Installing zsh-autosuggestions"
	@git clone https://github.com/zsh-users/zsh-autosuggestions \
		$${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

zsh-plugins: $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting $(HOME)/.oh-my-zsh/custom//plugins/zsh-autosuggestions ## Install oh-my-zsh plugins

oh-my-zsh: zsh-plugins ## Install oh-my-zsh and belonging plugins, update oh-my-zsh config
	@echo "Setting up oh-my-zsh"
	@echo "Setting theme '$(OH_MY_ZSH_THEME)'"
	@$(SED) -i 's/ZSH_THEME=".\+"/ZSH_THEME="$(OH_MY_ZSH_THEME)"/' ~/.$(SHELLRC)
	@echo "Updating config"
	@$(SED) -i 's/plugins=(git)/plugins=(git docker docker-compose zsh-autosuggestions zsh-syntax-highlighting)/' $(SOURCEFILE)
	@grep "Custom config" $(HOME)/.$(SHELLRC) > /dev/null || \
		(echo "" >> $(HOME)/.$(SHELLRC) && \
		echo "# Custom config" >> $(HOME)/.$(SHELLRC) && \
		cat shell_config >> $(HOME)/.$(SHELLRC) && \
		echo "" >> $(HOME)/.$(SHELLRC) && \
		cat zshrc >> $(HOME)/.$(SHELLRC) && \

source: create-source ## Create directories used in source file
	@echo "Adding rc and completions to be sourced"
	@mkdir -p $(HOME)/.bin # Used in PATH

tmux: ## Seup tmux config
	@echo "Symlinking and configuring tmux"
	@$(shell [ -f ~/.tmux.conf ]       || ln -s $(PWD)/gpakosz.tmux/.tmux.conf ~/.tmux.conf)
	@$(shell [ -f ~/.tmux.conf.local ] || cp $(PWD)/gpakosz.tmux/.tmux.conf.local ~/.tmux.conf.local && cat $(PWD)/tmux.conf.local >> ~/.tmux.conf.local)

.PHONY: bash_completion clean create-source dirs links mac oh-my-zsh source clean

# vim: set ts=4 sw=4 noexpandtab:
