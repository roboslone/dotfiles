# formatting
    ## common
        bold='\033[1m'      # bold
        bou='\033[5m'       # bounce
        transp='\033[2m'    # transparent
        und='\033[4m'       # underlined
        inv='\033[7m'       # inverted (background color <> font color)
        normal='\033[m'     # format reset
        _0='\033[m'         # same as ${normal}
    ## foreground
        black='\033[30m'
        red='\033[31m'
        green='\033[32m'
        yellow='\033[33m'
        blue='\033[34m'
        violet='\033[35m'
        cyan='\033[36m'
        grey='\033[37m'
    ## background
        _black='\033[40m'
        _red='\033[41m'
        _green='\033[42m'
        _yellow='\033[43m'
        _blue='\033[44m'
        _violet='\033[45m'
        _cyan='\033[46m'
        _grey='\033[47m'

# loading
    echo -e "${black}Loading...${_0}"

# platform
    unset PLATFORM_LINUX
    unset PLATFORM_DARWIN
    [[ $(uname) == 'Darwin' ]] && export PLATFORM_DARWIN=1 && export PLATFORM_LINUX=
    [[ $(uname) == 'Linux' ]] && export PLATFORM_LINUX=1 && export PLATFORM_DARWIN=

# autocomplete menu
    autoload -U compinit
    compinit
    setopt completealiases
    zstyle ':completion:*' menu select
    unsetopt nomatch

# shell history
    SAVEHIST=100000
    HISTSIZE=100000
    HISTFILE=~/.zsh_history
    setopt extended_history
    setopt inc_append_history
    setopt share_history
    setopt hist_ignore_all_dups
    setopt hist_ignore_space
    setopt hist_reduce_blanks

# shell options
    setopt autocd
    setopt interactive_comments

# additional completions
    if [[ -e /usr/local/share/zsh-completions ]]; then
        fpath=(/usr/local/share/zsh-completions $fpath)
    fi

# env
    export EDITOR='vim'
    export HOMEBREW_EDITOR='vim'
    export LC_ALL='en_US.UTF-8'
    export PNPM_HOME="/Users/akhristyukhin/Library/pnpm"

# path
    export PATH="$PNPM_HOME:/opt/homebrew/bin:$HOME/.cargo/bin:$HOME/.bin:/usr/local/sbin:/usr/local/bin:/db/bin:$PATH"

# aliases
    alias -g V='|vim -'
    alias -g G='|grep -i'
    alias -g Gv='|grep -iv'
    alias -g L='|less'
    alias -g T='|tail'
    alias -g H='|head'
    alias -g W='|wc -l'
    alias -g S='|subl'
    alias -g J='|jq .'

    [[ -n $PLATFORM_DARWIN ]] && alias ls='/opt/homebrew/bin/gls --color=auto -F --group-directories-first'
    [[ -n $PLATFORM_LINUX ]] && alias ls='ls --color=auto -F --group-directories-first'
    [[ -n $PLATFORM_DARWIN ]] && alias bup='mas outdated && mas upgrade; brew update && brew upgrade --greedy; brew doctor'
    [[ -n $PLATFORM_LINUX ]] && alias bup='sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y install linux-generic linux-headers-generic linux-image-generic && sudo apt-get -y autoclean && sudo apt-get -y autoremove'
    
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
    function gp() {
        git pull && git log --shortstat -n 1 --format="%ai %s"
        if [[ -z "$*" ]]; then; else
            git checkout "$*" && git pull && git log --shortstat -n 1 --format="%ai %s"
        fi
    }

    function gco() {
        git checkout $(git branch | grep -v '*' | fzf | tr -d '[:space:]')
    }

    function scrape() {
        yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 "$*"
    }

# includes
    if [[ -e "~/.zshrc.ext" ]]; then
        source "~/.zshrc.ext"
    fi

    # fzf
    if [[ -e "~/.fzf.zsh" ]]; then
        source "~/.fzf.zsh"
    fi

    # syntax highlighting
    if [[ -e ~/.config/dotfiles/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]]; then
        export FAST_WORK_DIR='~/.config/dotfiles/fast-syntax-highlighting-themes'
        source ~/.config/dotfiles/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    fi

    # suggest
    if [[ -e ~/.config/dotfiles/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]]; then
        source ~/.config/dotfiles/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
    fi

# prompt
    eval "$(starship init zsh)"

# zoxide
    eval "$(zoxide init --cmd cd zsh)"

# loaded
    clear
