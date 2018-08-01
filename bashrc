# Source perlbrew if installed
[ -f "~/perl5/perlbrew/etc/bashrc" ] && source "~/perl5/perlbrew/etc/bashrc"

# Get name of git branch, used in prompt
function parse_git_branch {
    if [ ! "$(which git)" ]; then
        return
    fi

    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1] /'
}

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

export PS1='\[\e[32m\]\u\[\e[m\]@\[\e[34m\]\h\[\e[m\] (\[\e[31m\]\W\[\e[m\]) \[\e[33m\]`parse_git_branch`\[\e[m\]$ '

export HISTCONTROL="ignoreboth"
export HISTSIZE=1000
export HISTFILESIZE=2000

export LESS="-+F"
export EDITOR="nvim"
export VISUAL="nvim"

export GOROOT="/usr/local/go"
export GOPATH="~/go"

export GEM_PATH="~/.rvm/gems/ruby-2.4.0"

unset MANPATH
mpath="$(manpath)"
export NPM_PACKAGES="~/.npm-packages"
export MANPATH="$NPM_PACKAGES/share/man:$mpath"

export RIPGREP_CONFIG_PATH="~/.ripgreprc"

GOPATHS="$GOPATH/bin:$GOROOT/bin"
PERLPATHS="~/perl5/perlbrew/bin"
RUBYPATHS="~/.rvm/bin"
NPMPATHS="$NPM_PACKAGES/bin"
LOCALPATHS="~/bin:/usr/local/bin"
RUSTPATHS="~/.cargo/bin"

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
