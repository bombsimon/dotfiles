# Source perlbrew if installed
[ -f "$HOME/perl5/perlbrew/etc/bashrc" ] && . "$HOME/perl5/perlbrew/etc/bashrc"

# Source bash completions
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /etc/bash_completion ]           && . /etc/bash_completion

# Source RVM
[ -f "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"

# Try to use colors no matter what
export CLICOLOR=1;
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd;
export LS_OPTIONS='--color=auto'

alias l="ls -lh"
alias lr="ls -lrth"
[ "$(nvim -v)" ] && alias vi="nvim"
[ "$(nvim -v)" ] && alias vim="nvim"

export HISTCONTROL="ignoreboth"
export HISTSIZE=1000
export HISTFILESIZE=2000

export LESS="-+F"
export EDITOR="nvim"
export VISUAL="nvim"

export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"

unset MANPATH
mpath="$(manpath)"
export NPM_PACKAGES="$HOME/npm-packages"
export MANPATH="$NPM_PACKAGES/share/man:$mpath"

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

GOPATHS="$GOPATH/bin:$GOROOT/bin"
LOCALPATHS="$HOME/bin:/usr/local/bin"
NPMPATHS="$NPM_PACKAGES/bin:./node_modules/bin"
PERLPATHS="$HOME/perl5/perlbrew/bin"
PYTHONPATHS="/usr/local/opt/python/libexec/bin"
RUBYPATHS="$HOME/.rvm/bin"
RUSTPATHS="$HOME/.cargo/bin"

export PATH="$PATH:$PYTHONPATHS:$RUSTPATHS:$GOPATHS:$PERLPATHS:$RUBYPATHS:$NPMPATHS:$LOCALPATHS"

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

    # Arrow color
    local AC=$EMY
    [ "${EXITSTATUS}" -ne 0 ] && AC=$EMR

    # User color, red for root
    local UC=$W
    [ $UID -eq "0" ] && UC=$R

    # Without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
    # extra backslash in front of \$ to make bash colorize the prompt

    PS1="${AC}→ ${R}\\W${Y}$(parse_git_branch)${NONE} "
}

PROMPT_COMMAND=bash_prompt
