# Source perlbrew if installed
[ -f "$HOME/perl5/perlbrew/etc/bashrc" ] && source "$HOME/perl5/perlbrew/etc/bashrc"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && (eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)")
    alias l="ls -lh --color=auto"
    alias ls="ls --color=auto"
    alias lr="ls -lrth --color=auto"
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
else
    alias l="ls -lh"
    alias lr="ls -lrth"
fi

alias vi="nvim"
alias vim="nvim"

export HISTCONTROL="ignoreboth"
export HISTSIZE=1000
export HISTFILESIZE=2000

export LESS="-+F"
export EDITOR="nvim"
export VISUAL="nvim"

export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"

export GEM_PATH="$HOME/.rvm/gems/ruby-2.4.0"

unset MANPATH
mpath="$(manpath)"
export NPM_PACKAGES="$HOME/npm-packages"
export MANPATH="$NPM_PACKAGES/share/man:$mpath"

export RIPGREP_CONFIG_PATH="$HOME/ripgreprc"

GOPATHS="$GOPATH/bin:$GOROOT/bin"
PERLPATHS="$HOME/perl5/perlbrew/bin"
RUBYPATHS="$HOME/rvm/bin"
NPMPATHS="$NPM_PACKAGES/bin"
LOCALPATHS="$HOME/bin:/usr/local/bin"
RUSTPATHS="$HOME/cargo/bin"

export PATH="$RUSTPATHS:$GOPATHS:$PERLPATHS:$RUBYPATHS:$NPMPATHS:$LOCALPATHS:$PATH"

function rr {
    if [ -f "/var/run/reboot-required" ]; then
        echo "Reboot required!!";
    else
        echo "No reboot needed";
    fi
}

function container_ip {
    CONTAINER="$1"

    docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$CONTAINER"
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
