# Source bash completions
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
[ -f /etc/bash_completion ]           && . /etc/bash_completion

# Enable globstar for bash (if supported)
[ "$(shopt | grep globstar)" ] && shopt -s globstar

# Silence Apple prompting they're now using zsh (if you for some reason isn't
# running a separate installation of bash > 3.x)
export BASH_SILENCE_DEPRECATION_WARNING=1

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
