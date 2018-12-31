# Source perlbrew if installed
if test -e $HOME/perl5/perlbrew/etc/perlbrew.fish
    . $HOME/perl5/perlbrew/etc/perlbrew.fish
end

# Setup RVM - https://rvm.io/integration/fish
rvm default

alias l     "ls -lh"
alias lr    "ls -lrth"
alias vi    "nvim"
alias vim   "nvim"

set -x EDITOR   nvim
set -x VISUAL   nvim
set -x LESS     "-+F"
set -x GOROOT   /usr/local/go
set -x GOPATH   $HOME/go

set GOPATHS         "$GOPATH/bin:$GOROOT/bin"
set LOCALPATHS      "$HOME/bin:/usr/local/bin"
set NPMPATHS        "$NPM_PACKAGES/bin:./node_modules/bin"
set PERLPATHS       "$HOME/perl5/perlbrew/bin"
set PYTHONPATHS     "/usr/local/opt/python/libexec/bin"
set RUBYPATHS       "$HOME/.rvm/bin"
set RUSTPATHS       "$HOME/.cargo/bin"

set -x PATH $PATH $GOPATHS $LOCALPATHS $NPMPATHS $PERLPATHS $PYTHONPATHS $RUBYPATHS $RUSTPATHS

function weather --description 'Show current weather'
    perldoc -l ojo > /dev/null 2>&1
    if test $status -eq 0
        perl -Mojo -E 'binmode(STDOUT, "encoding(UTF-8)"); say g("http://wttr.in/stockholm?T")->dom->at("pre")->text'
    else
        echo -n "Cannot fetch weather, install ojo (Mojolicious)"
    end
end

function container_ip --description 'Get IP for a docker container'
    docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$argv"
end
