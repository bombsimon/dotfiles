SED                    ?= sed # Set to gsed for Darwin
SHELL_NAME             ?= zsh
OH_MY_ZSH_THEME         = bira
SHELLRC                 = $(SHELL_NAME)rc
SOURCEFILE              = ~/.$(SHELLRC)
CONFIG_DIRECTORIES      = fish/functions i3 i3status nvim bat
SYMBOLIC_LINKS          = config/nvim/init.vim config/nvim/coc-settings.json \
							gitconfig gitignore golangci.yml ideavimrc \
							my.cnf perlcriticrc perltidyrc ripgreprc sqliterc \
							alacritty.yaml \
							config/i3/config config/i3status/config \
							config/fish/config.fish \
							config/fish/functions/fish_prompt.fish \
							config/bat/config \
							config/starship.toml

.PHONY: help
help: ## Show this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: mostly-clean
mostly-clean: ## Remove all symbolic links, remove tmux config
	@$(foreach s,$(SYMBOLIC_LINKS), rm -f ~/.$(s);)
	@rm -f ~/.tmux.conf*
	@$(SED) -i '\#dotfiles#d' $(SOURCEFILE)
	@$(SED) -i '\#$(BASH_COMPLETION)#d' $(SOURCEFILE)

.PHONY: clean
clean: mostly-clean ## Remove everything and uninstall oh-my-zsh
	@uninstall_oh_my_zsh

.PHONY: dirs
dirs: ## Create required directories for configuration
	@$(foreach d,$(CONFIG_DIRECTORIES), mkdir -p ~/.config/$(d);)

.PHONY: links
links: dirs tmux ## Create symlinks for all configuration files
	@$(foreach s,$(SYMBOLIC_LINKS), test -f ~/.$(s) || ln -s $(PWD)/$(s) ~/.$(s);)

.PHONY: mac
mac: /usr/local/bin/brew ## Setup basic macOS applications
	@xcode-select --install
	@brew bundle

/usr/local/bin/brew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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
oh-my-zsh: zsh-plugins $(HOME)/.oh-my-zsh ## Install oh-my-zsh and belonging plugins, update oh-my-zsh config
	@$(SED) -i 's/^ZSH_THEME=".\+"/ZSH_THEME="$(OH_MY_ZSH_THEME)"/' ~/.$(SHELLRC)
	@$(SED) -i 's/^plugins=(.\+)/plugins=(git docker docker-compose kubectl zsh-autosuggestions zsh-syntax-highlighting)/' $(SOURCEFILE)
	@grep "dotfiles/shellrc" $(HOME)/.$(SHELLRC) > /dev/null || \
		echo "" >> $(HOME)/.$(SHELLRC) && \
		echo ". ~/git/dotfiles/shellrc" >> $(HOME)/.$(SHELLRC)

$(HOME)/.tmux.conf:
	@$(shell [ -f ~/.tmux.conf ] || ln -s $(PWD)/gpakosz.tmux/.tmux.conf ~/.tmux.conf)

$(HOME)/.tmux.conf.local:
	@$(shell [ -f ~/.tmux.conf.local ] || cp $(PWD)/gpakosz.tmux/.tmux.conf.local ~/.tmux.conf.local)

.PHONY: tmux
# TODO: This is broken - will append multiple times
tmux: $(HOME)/.tmux.conf $(HOME)/.tmux.conf.local ## Seup tmux config
	$(shell cat $(PWD)/tmux.conf.local >> ~/.tmux.conf.local)

# vim: set ts=4 sw=4 noexpandtab:
