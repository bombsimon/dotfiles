# Fix bindkeys (^A, ^E)
bindkey -e

# Remove ruby_prompt_info used in many zsh themes
function ruby_prompt_info { echo '' }

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

# Override theme prompt for oh-my-zsh
# PROMPT='╭─ %{$terminfo[bold]$fg[blue]%}%~ %{$reset_color%}$(git_prompt_info)$(virtualenv_prompt_info)
# ╰─%B$%b '
prompt
