# zinit
    ZINIT_HOME="${HOME}/.config/zinit"
    [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
    [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    source "${ZINIT_HOME}/zinit.zsh"

    zinit light zsh-users/zsh-completions
    zinit light zsh-users/zsh-autosuggestions
    zinit light zsh-users/zsh-syntax-highlighting
    zinit light romkatv/powerlevel10k
    zinit light Aloxaf/fzf-tab

# prompt
    source ~/.config/dotfiles/zsh/p10k.zsh

# platform
    unset PLATFORM_LINUX
    unset PLATFORM_DARWIN
    [[ $(uname) == 'Darwin' ]] && export PLATFORM_DARWIN=1 && export PLATFORM_LINUX=
    [[ $(uname) == 'Linux' ]] && export PLATFORM_LINUX=1 && export PLATFORM_DARWIN=

# autocompletion
    autoload -U compinit
    compinit
    setopt completealiases
    zstyle ':completion:*' menu no
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    unsetopt nomatch

    zinit cdreplay -q # compinit performance optimization

# shell history
    HISTSIZE=100000
    SAVEHIST=$HISTSIZE
    HISTFILE=~/.zsh_history
    HISTDUP=erase
    setopt appendhistory
    setopt sharehistory
    setopt hist_ignore_space
    setopt hist_ignore_all_dups
    setopt hist_save_no_dups
    setopt hist_ignore_dups
    setopt hist_find_no_dups

    # limits history search to current command
    bindkey "^[[A" history-search-backward
    bindkey "^[[B" history-search-forward

# shell options
    setopt autocd
    setopt interactive_comments

# env
    export LC_ALL='en_US.UTF-8'

# aliases
    alias -g V='|vim -'
    alias -g G='|grep -i'
    alias -g Gv='|grep -iv'
    alias -g T='|tail'
    alias -g H='|head'
    alias -g W='|wc -l'
    alias -g J='|jq .'
    
    alias ls='ls --color=auto -F --group-directories-first'
    alias ll='ls -lah'
    alias l1='ls -1'
    alias grep='grep --color=auto'
    alias GR='grep -RIi'
    alias ssh='ssh -o "logLevel=QUIET"'
    alias gs='git status'
    alias GC='git reset --hard HEAD && git clean -qfd'
    alias пы=gs
    alias пз=gp
    alias игз=bup

    [[ -n $PLATFORM_DARWIN ]] && alias ls='/opt/homebrew/bin/gls --color=auto -F --group-directories-first'

# constants
    WORDCHARS="@"

# working dir
    if [[ -e ~/.path ]]; then
        # Only change working directory if it's set to user's home.
        # Otherwise it breaks PyCharm's terminal by overwriting correct working dirs.
        if [[ "$(pwd)" == "$(eval echo "~$USER")" ]]; then
            cd $(cat ~/.path)
        fi
    fi

# functions
    function bup() {
        if [[ -n $PLATFORM_DARWIN ]]; then
            mas outdated && mas upgrade
        fi

        brew update && brew upgrade --greedy
        brew doctor

        zinit self-update && zinit update --parallel --quiet --all
    }

    function gp() {
        git pull && git log --shortstat -n 1 --format="%ai %s"
        if [[ -z "$*" ]]; then; else
            git checkout "$*" && git pull && git log --shortstat -n 1 --format="%ai %s"
        fi
    }

    function gco() {
        git checkout $(git branch | grep -v '*' | fzf | tr -d '[:space:]')
    }

# path
    export PATH="$HOME/.local/bin:$PATH"
    export PATH="/usr/local/bin:$PATH"
    export PATH="/usr/local/sbin:$PATH"
    export PATH="$HOME/.bin:$PATH"
    export PATH="$HOME/go/bin:$PATH"
    export PATH="$HOME/.fzf/bin:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/sbin:$PATH"

# includes
    # local
    if [[ -e ~/.zshrc.local ]]; then
        source ~/.zshrc.local
    fi

    # fzf
    if [[ -e ~/.config/dotfiles/fzf/fzf.zsh ]]; then
        source ~/.config/dotfiles/fzf/fzf.zsh
    fi

    # iTerm2
    if [[ -e ~/.config/dotfiles/zsh/.iterm2_shell_integration.zsh ]]; then
        source ~/.config/dotfiles/zsh/.iterm2_shell_integration.zsh
    fi
