# Source perlbrew if installed
[ -f "$HOME/perl5/perlbrew/etc/bashrc" ] && . "$HOME/perl5/perlbrew/etc/bashrc"

# Source bash completions
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /etc/bash_completion ]           && . /etc/bash_completion

# Source ghcup for Haskell
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

# Enable globstar for bash (if supported)
[ "$(shopt | grep globstar)" ] && shopt -s globstar

# Silence Apple prompting they're now using zsh (if you for some reason isn't
# running a separate installation of bash > 3.x)
export BASH_SILENCE_DEPRECATION_WARNING=1

# Try to use colors no matter what
export CLICOLOR=1;
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd;
export LS_OPTIONS='--color=auto'
export COLORTERM=truecolor

# Support GPG signing
export GPG_TTY=$(tty)

alias l="ls -lh"
alias lr="ls -lrth"

[ "$(nvim -v 2> /dev/null)" ] && alias vi="nvim"
[ "$(nvim -v 2> /dev/null)" ] && alias vim="nvim"

[ "$(python3 --version 2> /dev/null)" ] && alias python='python3'
[ "$(python3 --version 2> /dev/null)" ] && alias pip='pip3'

[ "$(npm --version 2> /dev/null)" ] && PATH="$PATH:$(npm bin)"

export NPM_PACKAGES="$HOME/.npm"
export NPM_CONFIG_PREFIX="$NPM_PACKAGES"

export HISTCONTROL="ignoreboth"
export HISTSIZE=1000
export HISTFILESIZE=2000

export LESS="-+F"
export EDITOR="nvim"
export VISUAL="nvim"

export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export GO111MODULE="auto"

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

GOPATHS="$GOPATH/bin:$GOROOT/bin"
LOCALPATHS="$HOME/bin:$HOME/.bin:$HOME/.local/bin:/usr/local/bin"
NPMPATHS="$NPM_PACKAGES/bin"
PERLPATHS="$HOME/perl5/perlbrew/bin"
PYTHONPATHS="/usr/local/opt/python/libexec/bin"
RUBYPATHS="$HOME/.rvm/bin"
RUSTPATHS="$HOME/.cargo/bin"
CIQPATHS="$HOME/.connectiq-sdk/bin"

# Keg-only formulas refusin to link for macOS-provided software.
BREWPATHS="/usr/local/opt/curl/bin"

export PATH="$CIQPATHS:$PYTHONPATHS:$RUSTPATHS:$GOPATHS:$PERLPATHS:$RUBYPATHS:$NPMPATHS:$LOCALPATHS:$BREWPATHS:$PATH"

# Source RVM last to make it apper first in PATH
[ -f "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"

function java8 {
    _rm_and_link_java
}

function java12 {
    _rm_and_link_java "jdk-12.0.2.jdk"
}

function _rm_and_link_java {
    rm -f "$HOME/.bin/java"
    rm -f "$HOME/.bin/javac"
    JAVA_VERSION=${1:-jdk1.8.0_221.jdk}

    ln -s "/Library/Java/JavaVirtualMachines/${JAVA_VERSION}/Contents/Home/bin/java" "$HOME/.bin/java"
    ln -s "/Library/Java/JavaVirtualMachines/${JAVA_VERSION}/Contents/Home/bin/javac" "$HOME/.bin/javac"
}

function rr {
    if [ -f "/var/run/reboot-required" ]; then
        echo "Reboot required!!";
    else
        echo "No reboot needed";
    fi
}

function container_ip {
    docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$1"
}

function weather {
    if perldoc -l ojo > /dev/null 2>&1; then
        perl -Mojo -E 'binmode(STDOUT, "encoding(UTF-8)"); say g("http://wttr.in/stockholm?T")->dom->at("pre")->text'
    else
        echo "Cannot fetch weather, install ojo (Mojolicious)"
    fi
}

function parse_git_branch {
    if [ ! "$(which git)" ]; then
        return
    fi

    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

function bash_prompt {
    local EXITSTATUS="$?"
    local NONE="\[\033[0m\]"    # Unsets color to term's fg color

    # Regular colors
    local K="\[\033[0;30m\]"    # Black
    local R="\[\033[0;31m\]"    # Red
    local G="\[\033[0;32m\]"    # Green
    local Y="\[\033[0;33m\]"    # Yellow
    local B="\[\033[0;34m\]"    # Blue
    local M="\[\033[0;35m\]"    # Magenta
    local C="\[\033[0;36m\]"    # Cyan
    local W="\[\033[0;37m\]"    # White

    # Bolded colors
    local EMK="\[\033[1;30m\]"
    local EMR="\[\033[1;31m\]"
    local EMG="\[\033[1;32m\]"
    local EMY="\[\033[1;33m\]"
    local EMB="\[\033[1;34m\]"
    local EMM="\[\033[1;35m\]"
    local EMC="\[\033[1;36m\]"
    local EMW="\[\033[1;37m\]"

    # Background colors
    local BGK="\[\033[40m\]"
    local BGR="\[\033[41m\]"
    local BGG="\[\033[42m\]"
    local BGY="\[\033[43m\]"
    local BGB="\[\033[44m\]"
    local BGM="\[\033[45m\]"
    local BGC="\[\033[46m\]"
    local BGW="\[\033[47m\]"

    # Prompt prefix
    local PP="${PROMPT_PREFIX:-}"

    # Arrow color
    local AC=$EMY
    [ "${EXITSTATUS}" -ne 0 ] && AC=$EMR

    # User color, red for root
    local UC=$W
    [ $UID -eq "0" ] && UC=$R

    # Without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
    # extra backslash in front of \$ to make bash colorize the prompt

    PS1="${PP}${AC}→ ${R}\\W${Y}$(parse_git_branch)${NONE} "
}

PROMPT_COMMAND=bash_prompt
