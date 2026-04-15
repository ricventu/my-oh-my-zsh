export PATH="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/utils:$PATH"

export NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="${HOME}/.composer/vendor/bin:$NPM_PACKAGES/bin:/usr/local/bin:$PATH"
export EDITOR=cursor
export NEXT_EDITOR=cursor
export COMPOSER_MEMORY_LIMIT=-1

# HOMEBREW

# brew install fzf bat eza zoxide
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
eval "$(/usr/bin/env PATH_HELPER_ROOT="/opt/homebrew" /usr/libexec/path_helper -s)"
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH";
export PATH="/opt/homebrew/opt/php@8.4/bin:$PATH";
export PATH="/opt/homebrew/opt/php@8.4/sbin:$PATH";
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"

# Cursor Agent
export PATH="$HOME/.local/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


ZOXIDE_CMD_OVERRIDE='cd'
FZF_BASE=/opt/homebrew/opt/fzf
zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'header' yes

# alias cat='bat'
alias fzf='fzf --preview "bat --color=always --style=header,grid --line-range :500 {}"'
alias f='fzf'

alias zshrc='code ~/.zshrc "$ZSH" "$ZSH_CUSTOM"'
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'
alias xphp='XDEBUG_MODE=debug XDEBUG_TRIGGER=1 IDEKEY=PHPSTORM php'
alias docker-stop-all='dsta'
alias a='php artisan'
alias xa='xphp artisan'
alias artisan='php artisan'
alias xartisan='xphp artisan'
alias phpstan='[ -f phpstan ] && sh phpstan || sh vendor/bin/phpstan'
alias c='composer'
alias xc='xphp /opt/homebrew/bin/composer'
alias xcomposer='xphp /opt/homebrew/bin/composer'

function laravelsail() {
    docker run --rm --interactive --tty \
        --volume composer-cache:/root/.composer \
        --volume "$(pwd)":/app \
        -w /app \
        laravelsail/php84-composer:latest $@
}

# function php() {
#     laravelsail php $@
# }

# function composer() {
#     laravelsail composer $@
# }


function cargo() {
    docker run --rm --interactive --tty \
        --volume "$(pwd)":/app \
        -w /app \
        rust:latest cargo $@
}
function cargosh() {
    docker run --rm --interactive --tty \
        --volume "$(pwd)":/app \
        -w /app \
        rust:latest bash $@
}

function python() {
    docker run --rm --interactive --tty \
        --volume "$(pwd)":/app \
        -w /app \
        python:3.10.11-bullseye python $@
}


function docker_php_get_loaded_extensions() {
    docker run --rm -it $1 php -r "print_r(implode(PHP_EOL,get_loaded_extensions()));"
}

function docker_php_get_required_extensions() {
    docker run --rm -v "$PWD":/app -w /app $1 composer show --tree | grep -o "\-ext-.* " | cut -d- -f2- | sort | uniq 
}

function docker_php_get_required_extensions_not_installed() {
    IMAGE=$1
    LOADED=$(docker_php_get_loaded_extensions $IMAGE)
    REQUIRED=$(docker_php_get_required_extensions $IMAGE)

    MISSING=()
    while read -r line; do
    if ! grep -q -i "${line:4}" <<< "$LOADED"; then
        MISSING+=("$line")
    fi
    done <<< "$REQUIRED"
    printf '%s\n' "${MISSING[@]}"
}
