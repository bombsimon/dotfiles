SED                    ?= sed -i
SOURCEFILE              = ~/.zshrc
OH_MY_ZSH_THEME         = bira
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

UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
  SED = sed -i ''
endif

.PHONY: help
help: ## Show this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; \
		{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean
clean: ## Remove all symbolic links, remove tmux config
	$(foreach s,$(SYMBOLIC_LINKS), rm -f ~/.$(s);)
	rm -f ~/.tmux.conf*
	$(SED) '\#dotfiles#d' $(SOURCEFILE)

.PHONY: dirs
dirs: ## Create required directories for configuration
	@$(foreach d,$(CONFIG_DIRECTORIES), mkdir -p ~/.config/$(d);)

.PHONY: links
links: dirs tmux ## Create symlinks for all configuration files
	@$(foreach s,$(SYMBOLIC_LINKS), test -f ~/.$(s) || ln -s $(PWD)/$(s) ~/.$(s);)
	@ln -s git-templates ~/.git-templates

$(HOME)/.oh-my-zsh: ## Install oh-my-zsh
	@sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

$(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting: $(HOME)/.oh-my-zsh ## oh-my-zsh plugin
	@git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		$${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

$(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions: $(HOME)/.oh-my-zsh ## oh-my-zsh plugin
	@git clone https://github.com/zsh-users/zsh-autosuggestions \
		$${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

$(HOME)/.oh-my-zsh/custom/plugins/zsh-fzf-history-search: $(HOME)/.oh-my-zsh ## oh-my-zsh plugin
	@git clone https://github.com/joshskidmore/zsh-fzf-history-search\
		$${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search

.PHONY: zsh-plugins
zsh-plugins: $(HOME)/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-fzf-history-search ## Install oh-my-zsh plugins

.PHONY: oh-my-zsh
oh-my-zsh: zsh-plugins $(HOME)/.oh-my-zsh ## Install oh-my-zsh and belonging plugins, update oh-my-zsh config
	@$(SED) 's/^ZSH_THEME=".\+"/ZSH_THEME="$(OH_MY_ZSH_THEME)"/' ~/.$(SHELLRC)
	@$(SED) 's/^plugins=(.\+)/plugins=(git docker docker-compose kubectl zsh-autosuggestions zsh-syntax-highlighting)/' $(SOURCEFILE)
	@grep "dotfiles/shellrc" $(HOME)/.$(SHELLRC) > /dev/null || \
		echo "" >> $(HOME)/.$(SHELLRC) && \
		echo ". ~/git/dotfiles/shellrc" >> $(HOME)/.$(SHELLRC)

.PHONY: tmux
tmux: ##  Setup tmux
	@$(shell [ -f ~/.tmux.conf ] || ln -s $(PWD)/gpakosz.tmux/.tmux.conf ~/.tmux.conf)
	@$(shell [ -f ~/.tmux.conf.local ] || cp $(PWD)/gpakosz.tmux/.tmux.conf.local ~/.tmux.conf.local)
	$(shell cat $(PWD)/tmux.conf.local >> ~/.tmux.conf.local)

# vim: set ts=4 sw=4 noexpandtab:
