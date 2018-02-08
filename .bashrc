# Source perlbrew if installed
if [ -e $HOME/perl5/perlbrew/etc/bashrc ]; then
    source $HOME/perl5/perlbrew/etc/bashrc
fi

# Get name of git branch
function parse_git_branch {
    if [ ! $(which git) ]; then
        return
    fi

    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1] /'
}

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
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

alias vi="vim"

export PS1='\[\e[32m\]\u\[\e[m\]@\[\e[34m\]\h\[\e[m\] (\[\e[31m\]\W\[\e[m\]) \[\e[33m\]`parse_git_branch`\[\e[m\]$ '

export HISTCONTROL="ignoreboth"
export HISTSIZE=1000
export HISTFILESIZE=2000

export LESS="-+F"
export EDITOR="vim"
export VISUAL="vim"

export GOROOT="/user/local/go"
export GOPATH="$HOME/go"

export GEM_PATH="${HOME}/.rvm/gems/ruby-2.4.0"

unset MANPATH
export NPM_PACKAGES="${HOME}/.npm-packages"
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

export RIPGREP_CONFIG_PATH=~/.ripgreprc

export PATH="$HOME/perl5/perlbrew/bin:$HOME/.rvm/bin:$GOPATH/bin:$GOROOT/bin:$PATH"

function rr {
    if [ -f /var/run/reboot-required ]; then
        echo "Reboot required!!";
    else
        echo "No reboot needed";
    fi
}

function container_ip {                                                                     
    CONTAINER=$1                                                                            

    docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" $CONTAINER 
}                                                                                           
