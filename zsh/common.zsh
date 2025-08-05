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

# path
    export PATH="$HOME/.local/bin:$PATH"
    export PATH="/usr/local/bin:$PATH"
    export PATH="/usr/local/sbin:$PATH"
    export PATH="$HOME/.bin:$PATH"
    export PATH="$HOME/.fzf/bin:$PATH"
    export PATH="$HOME/.cargo/bin:$PATH"
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/sbin:$PATH"

# includes
    # local
    if [[ -e ~/.zshrc.local ]]; then
        source ~/.zshrc.local
    fi

    # additional completions
    if [[ -e /usr/local/share/zsh-completions ]]; then
        fpath=(/usr/local/share/zsh-completions $fpath)
    fi

    # fzf
    if [[ -e ~/.config/dotfiles/fzf/fzf.zsh ]]; then
        source ~/.config/dotfiles/fzf/fzf.zsh
    fi

    # syntax highlighting
    if [[ -e ~/.config/dotfiles/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]]; then
        export FAST_WORK_DIR='~/.config/dotfiles/zsh/fast-syntax-highlighting-themes'
        source ~/.config/dotfiles/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    fi

    # suggest
    if [[ -e ~/.config/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]]; then
        source ~/.config/dotfiles/zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
    fi

    # iTerm2
    if [[ -e ~/.config/dotfiles/zsh/.iterm2_shell_integration.zsh ]]; then
        source ~/.config/dotfiles/zsh/.iterm2_shell_integration.zsh
    fi

    # prompt
    if [[ -e ~/.config/dotfiles/zsh/powerlevel10k ]]; then
        source ~/.config/dotfiles/zsh/powerlevel10k/powerlevel10k.zsh-theme
        source ~/.config/dotfiles/zsh/p10k.zsh
    fi

    # zoxide
    eval "$(zoxide init --cmd cd zsh)"
