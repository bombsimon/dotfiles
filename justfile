symlinks := "\
    alacritty.yaml \
    config/bat/config \
    config/starship.toml \
    config/nvim/init.lua \
    config/nvim/lua \
    git-templates \
    gitconfig \
    gitignore \
    golangci.yml \
    ideavimrc \
    markdownlintrc \
    my.cnf \
    perlcriticrc \
    perltidyrc \
    ripgreprc \
    sqliterc \
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
  IdentitiesOnly yes
  AddKeysToAgent yes

Host github.com
  HostName github.com

Host gist.github.com
  HostName gist.github.com

Host gist.github.com github.com
  Port 22
  User git
  IdentityFile ~/.ssh/github"

# Show this help text
help:
    @just -l


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
    [ -e ~/.tmux.conf ]       || ln -s $(pwd)/gpakosz.tmux/.tmux.conf ~/.tmux.conf
    [ -e ~/.tmux.conf.local ] || cp $(pwd)/gpakosz.tmux/.tmux.conf.local ~/.tmux.conf.local && \
        cat $(pwd)/tmux.conf.local >> ~/.tmux.conf.local


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

    if [ -e ~/.oh-my-zsh ]; then
        echo "oh-my-zsh already installed"
        exit 0
    fi

    # Install ZSH
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Link custom shell file
    if ! grep shellrc ~/.zshrc > /dev/null; then
        printf "\n[ -f ~/git/dotfiles/shellrc ] && . ~/git/dotfiles/shellrc\n" >> ~/.zshrc
    fi

    # Set theme
    gsed -i 's/^ZSH_THEME=.\+/ZSH_THEME="{{zsh_theme}}"/' ~/.zshrc

    # Set plugins
    plugins=""
    for plugin in {{zsh_builtin_plugins}}; do
        plugins="$plugins $plugin"
    done

    for plugin in {{zsh_plugins}}; do
        name=$(basename $plugin | cut -f 1 -d '.')
        plugins="$plugins $name"
    done


    gsed -i "s/^plugins=(.\+)/plugins=($plugins)/" ~/.zshrc

    # Link custom shell file
    if !grep shellrc ~/.zshrc; then
        printf "\n. ~/.git/dotfiles/shellrc\n" >> ~/.zshrc
    fi


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
