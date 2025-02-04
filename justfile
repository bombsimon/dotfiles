symlinks := "\
    alacritty.toml \
    config/bat/config \
    config/starship.toml \
    config/nvim/init.lua \
    config/nvim/lua \
    config/nvim/package.json \
    config/nvim/snippets \
    git-templates \
    gitconfig \
    gitignore \
    golangci.yml \
    ideavimrc \
    markdownlintrc \
    my.cnf \
    perlcriticrc \
    perltidyrc \
    psqlrc \
    ripgreprc \
    sqliterc \
    tmux.conf \
    yamllint \
"

zsh_plugins := "\
    https://github.com/zsh-users/zsh-syntax-highlighting.git \
    https://github.com/zsh-users/zsh-autosuggestions \
    https://github.com/joshskidmore/zsh-fzf-history-search \
"

zsh_builtin_plugins := "\
    git \
    docker \
    docker-compose \
    kubectl \
"

zsh_theme := "bira"

ssh_config := "Host *
  ForwardAgent no
  IdentityAgent ~/.1password/agent.sock"

_help:
    @just -l


# Setup theme for bat
bat-theme:
    mkdir -p "$(bat --config-dir)/themes"
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
    bat cache --build

# Create symlinks for all config files
symlink:
    #!/usr/bin/env sh
    set -eu

    for file in {{symlinks}}; do
        filename=$(basename "$file")
        dirname=$(dirname "$file")
        if [ "$dirname" != "." ] && [ ! -e ~/.$dirname ]; then
            echo "Creating ~/.$dirname"
            mkdir -p "~/.$dirname"
        fi

        if [ ! -e ~/.$file ]; then
            echo "Linking $(pwd)/$file"
            ln -s "$(pwd)/$file" ~/.$file
        fi
    done


# Configure tmux
@tmux:
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


# Link VS Code configuration
@vscode:
    [ -e ~/Library/Application\ Support/Code/User/settings.json ] || \
        ln -s $(pwd)/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

    [ -e ~/Library/Application\ Support/Code/User/keybindings.json ] || \
        ln -s $(pwd)/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json


# Setup SSH config by configuring standard hosts
@ssh-config:
    [ -e ~/.ssh/config ] || echo "{{ssh_config}}" > ~/.ssh/config


# Setup and install zsh
oh-my-zsh:
    #!/usr/bin/env sh
    set -eu

    if [ "$(uname -s)" = "Darwin" ]; then
        sed="gsed"
    else
        sed="sed"
    fi

    if [ ! -e ~/.oh-my-zsh ]; then
        echo "Installing oh-my-zsh"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    # Link custom shell file
    if ! grep shellrc ~/.zshrc > /dev/null; then
        printf "\n[ -f ~/git/dotfiles/shellrc ] && . ~/git/dotfiles/shellrc\n" >> ~/.zshrc
    fi

    # Set theme
    if [ ! -e $ZSH/themes/nord-extended ]; then
        git clone https://github.com/fxbrit/nord-extended $ZSH/themes/nord-extended
    fi

    "$sed" -i 's,^ZSH_THEME=.\+,ZSH_THEME="{{zsh_theme}}",' ~/.zshrc

    # Set plugins
    plugins=""
    for plugin in {{zsh_builtin_plugins}}; do
        plugins="$plugins $plugin"
    done

    for plugin in {{zsh_plugins}}; do
        name=$(basename $plugin | cut -f 1 -d '.')
        plugins="$plugins $name"
    done

    "$sed" -i "s/^plugins=(.\+)/plugins=($plugins)/" ~/.zshrc

# Install zsh plugins
oh-my-zsh-plugins: oh-my-zsh
    #!/usr/bin/env sh
    set -eu

    for plugin in {{zsh_plugins}}; do
        name=$(basename $plugin | cut -f 1 -d '.')
        fqdn=~/.oh-my-zsh/custom/plugins/"$name"
        if [ -e "$fqdn" ]; then
            echo "$name already installed"
            continue
        fi

        git clone "$plugin" "$fqdn"
    done

# Change shell
change-shell to='/usr/bin/zsh':
    sudo bash -c 'echo /usr/bin/zsh >> /etc/shells'
    chsh -s /usr/bin/zsh

# Symlink op-ssh-sign to have git signing working with 1P
[macos]
@op-ssh-sign:
    ln -s /Applications/1Password.app/Contents/MacOS/op-ssh-sign ~/bin/op-ssh-sign

# Setup key repeat and keyboard accessibility
[macos]
@key-repeat: && reload
    defaults write com.apple.Accessibility KeyRepeatDelay -float 0.5
    defaults write com.apple.Accessibility KeyRepeatInterval -float 0.083333333
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 20
    # Use scroll gesture with the Ctrl (^) modifier key to zoom
    defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
    defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
    # Follow the keyboard focus while zoomed in
    defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true
    # Allow to tab between modal button
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 2


# The way I got these codes was to set the default settings, then dump my
# config with:
#
#     defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys > 1
#
# Then I changed to my preferred settings and ran
#
#     defaults read com.apple.symbolichotkeys AppleSymbolicHotKeys > 2
#
# And finally I diffed the files to see what I had changed.
#
#     diff -U5 -u 1 2
# Setup macOS shortcuts
[macos]
@shortcuts: && reload
    echo Configuring 'Save picture of screen to file'
    /usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:28:value:parameters" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:28:value:parameters array" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:28:value:parameters: integer 51" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:28:value:parameters: integer 20" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:28:value:parameters: integer 1441792" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    #
    echo Configuring 'Copy picture of screen to the clipboard'
    /usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:29:value:parameters" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:29:value:parameters array" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:29:value:parameters: integer 51" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:29:value:parameters: integer 20" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:29:value:parameters: integer 1179648" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    #
    echo Configuring 'Save picture of selected area to file'
    /usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:30:value:parameters" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:30:value:parameters array" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:30:value:parameters: integer 52" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:30:value:parameters: integer 21" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:30:value:parameters: integer 1441792" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    #
    echo Configuring 'Copy picture of selected area to the clipboard'
    /usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:31:value:parameters" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:31:value:parameters array" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:31:value:parameters: integer 52" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:31:value:parameters: integer 21" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:31:value:parameters: integer 1179648" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    #
    echo Configuring 'Show Spotlight search'
    /usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:64:value:parameters" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:64:value:parameters array" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 32" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 49" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:64:value:parameters: integer 262144" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    #
    echo Disabling 'Mission control'
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:32:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:34:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    #
    echo Disabling 'Application window'
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:33:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:35:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    #
    echo Disabling 'Move left a space'
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:79:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:80:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    #
    ehco Disabling 'Move right a space'
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:81:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:82:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist


# Reload macOS settings
[macos]
@reload:
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u


# vim: set ts=4 sw=4 et:
