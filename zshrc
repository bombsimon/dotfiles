# Source perlbrew if installed
[ -f "$HOME/perl5/perlbrew/etc/bashrc" ] && . "$HOME/perl5/perlbrew/etc/bashrc"

# Source ghcup for Haskell
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

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

# Init pyenv
eval "$(pyenv init -)"

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

function prompt {
    local EXITSTATUS="$?"
    local NONE="%f"    # Unsets color to term's fg color

    # Regular colors
    local K="%F{black}"
    local R="%F{red}"
    local G="%F{green}"
    local Y="%F{yellow}"
    local B="%F{blue}"
    local M="%F{magenta}"
    local C="%F{cyan}"
    local W="%F{white}"

    # Bolded colors
    local EMK="%B${K}%b"
    local EMR="%B${R}%b"
    local EMG="%B${G}%b"
    local EMY="%B${Y}%b"
    local EMB="%B${B}%b"
    local EMM="%B${M}%b"
    local EMC="%B${C}%b"
    local EMW="%B${W}%b"

    # Prompt prefix
    local PP="${PROMPT_PREFIX:-}"

    # Arrow color
    local AC="%(?.${EMY}.${EMR})"

    # User color, red for root
    local UC=$W
    [ $UID -eq "0" ] && UC=$R


    autoload -Uz vcs_info
    precmd_vcs_info() { vcs_info }
    precmd_functions+=( precmd_vcs_info )
    setopt prompt_subst
    zstyle ':vcs_info:git:*' formats ' [%b]'

    PROMPT="${PP}${AC}-> ${R}%1~${Y}\$vcs_info_msg_0_${NONE} "
}

prompt
