# Formatting
    ## common
        bold='\033[1m'      # bold
        bou='\033[5m'       # bounce
        transp='\033[2m'    # transparent
        und='\033[4m'       # underlined
        inv='\033[7m'       # inverted (background color <> font color)
        normal='\033[m'     # format reset
        _0='\033[m'         # same as ${normal}
    ## foreground colors
        black='\033[30m'
        red='\033[31m'
        green='\033[32m'
        yellow='\033[33m'
        blue='\033[34m'
        violet='\033[35m'
        cyan='\033[36m'
        grey='\033[37m'
    ## background colors
        _black='\033[40m'
        _red='\033[41m'
        _green='\033[42m'
        _yellow='\033[43m'
        _blue='\033[44m'
        _violet='\033[45m'
        _cyan='\033[46m'
        _grey='\033[47m'

# Additional completion definitions for zsh
    fpath=(/usr/local/share/zsh-completions $fpath)

# Autocomplete
    autoload -U compinit
    compinit
    setopt completealiases
    zstyle ':completion:*' menu select

# Primary color
    if [[ -e ~/.color ]]; then
        primary_color=$(cat ~/.color)
    else
        primary_color='cyan'
    fi

# VCS
    setopt prompt_subst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'
    zstyle ':vcs_info:*' formats '%F{grey}%b ⭠%f'
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%F{grey}r%r'
    zstyle ':vcs_info:*' enable git cvs svn

    function vcs_info_wrapper() {
        vcs_info
        if [ -n "$vcs_info_msg_0_" ]; then
            echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
        fi
    }

# Prompt and colors
    autoload -U promptinit
    autoload -U colors && colors
    promptinit
    ZLE_RPROMPT_INDENT=0
    PROMPT='%* %1{⟩%} %{$fg_no_bold[${primary_color}]%}%n%{$reset_color%}%B@%b%m %{$fg_no_bold[${primary_color}]%}%#%{$reset_color%}  '
    RPROMPT='$(vcs_info_wrapper) %{$fg[${primary_color}]%}%~%{$reset_color%}'

# Path
    if [[ -e /db/bin ]]; then
        export PATH="/db/bin:$PATH"
    fi

    if [[ -e /usr/local/bin ]]; then
        export PATH="/usr/local/bin:$PATH"
    fi

    if [[ -e /usr/local/sbin ]]; then
        export PATH="/usr/local/sbin:$PATH"
    fi

# Aliases
    ## global
        alias -g NN='&>/dev/null'
        alias -g V='|vim -'
        alias -g G='|grep'
        alias -g Gv='|grep -v'
        alias -g L='|less'
        alias -g T='|tail'
        alias -g H='|head'
        alias -g W='|wc -l'

    ## common
        alias ls='/usr/local/Cellar/coreutils/8.24/bin/gls --color=auto -F --group-directories-first'
        alias ll='ls -la'
        alias l1='ls -1'
        alias grep='grep --color=auto'
        alias repo_up='svn info &> /dev/null && svn up || git pull'
        alias repo_up_with_log='svn info &> /dev/null && (svn up && svn log -l 5) || git pull'
        alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance(profile=\"roboslone-default\", pprint=True)'"

    ## OS X
        alias dnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Editor
    export EDITOR='vim'
    export HOMEBREW_EDITOR='vim'

# History
    SAVEHIST=100000
    HISTSIZE=100000
    HISTFILE=~/.zsh_history
    setopt extended_history
    setopt inc_append_history
    setopt share_history
    setopt hist_ignore_all_dups
    setopt hist_ignore_space
    setopt hist_reduce_blanks

# Locale
    export LC_ALL='en_US.UTF-8'

# Del key fix
    bindkey    "^[[3~"          delete-char
    bindkey    "^[3;5~"         delete-char

# Syntax highlighting
    if [[ -e ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
        source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi

# Working directory
    if [[ -e ~/.path ]]; then
        cd $(cat ~/.path)
    fi

# ZSH options
    setopt autocd
    setopt interactive_comments

# Constants
    WORDCHARS="@"

# iTerm2 integration
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# FZF
    if [[ -e ~/.fzf.zsh ]]; then
        source ~/.fzf.zsh
        export FZF_DEFAULT_OPTS='-i --multi --exact --prompt="" --no-mouse --margin=3 --color="fg:-1,bg:-1,hl:-1,fg+:-1,bg+:-1,info:-1,prompt:-1,pointer:-1,marker:32,spinner:-1,header:-1"'
    fi

# Functions
    function up() {
        if [[ -z "$@" ]]; then
            repo_up_with_log
        else
            for _dir in "$@"; do
                print "${cyan}Updating ${_dir}${_0}"
                _prev_dir=$(pwd)
                cd ${_dir} && repo_up || print "${red}Failed to update ${_dir}${_0}"
                cd ${_prev_dir}
                print
            done
        fi
    }

    function ve() {
        unset _env
        unset _fzf_bin
        deactivate &> /dev/null

        _fzf_bin=$(which fzf)
        if [ -e ${_fzf_bin} ]; then
            _env=$(find . -type f -name "activate" | ${_fzf_bin})
        else
            _env=$(find . -type f -name "activate" | head -1)
            print "${red}fzf is not installed, using autoselect${_0}"
        fi

        print "Selected virtualenv: ${green}${_env}${_0}"

        if [ -n ${_env} ]; then
            source ${_env}
            cd $(dirname ${_env})/../../
            [ -d 'src' ] && cd src
        fi
    }

    function ban() {
        sudo iptables -A INPUT -p tcp --destination-port "$*" -j DROP
        sudo ip6tables -A INPUT -p tcp --destination-port "$*" -j DROP
    }

    function unban() {
        sudo iptables -D INPUT -p tcp --destination-port "$*" -j DROP
        sudo ip6tables -D INPUT -p tcp --destination-port "$*" -j DROP
    }

# Additional config
    if [[ -e ~/.zshrc.ext ]]; then
        source ~/.zshrc.ext
    fi

