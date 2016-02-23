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
    PROMPT='%* %1{⟩%} %{$fg_no_bold[${primary_color}]%}%n%{$reset_color%}%B@%b%m %{$fg_no_bold[${primary_color}]%}%#%{$reset_color%} '
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

    ## common
        alias ls='/usr/local/Cellar/coreutils/8.24/bin/gls --color=auto -F --group-directories-first'
        alias ll='ls -la'
        alias l1='ls -1'
        alias grep='grep --color=auto'
        alias up='svn info &> /dev/null && (svn up && svn log -l 5) || git pull'
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
    export LC_ALL='ru_RU.UTF-8'

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

# FZF
    if [[ -e ~/.fzf.zsh ]]; then
        source ~/.fzf.zsh
        export FZF_DEFAULT_OPTS='-i --prompt="" --no-mouse -x -e +c'
    fi

# iTerm2 shell integration
    if [[ -o login ]]; then
        if [ x"$TERM" != "xscreen" ]; then
            # Indicates start of command output. Runs just before command executes.
            iterm2_before_cmd_executes() {
                printf "\033]133;C;\r\007"
            }

            iterm2_set_user_var() {
                printf "\033]1337;SetUserVar=%s=%s\007" "$1" $(printf "%s" "$2" | base64)
            }

            # Users can write their own version of this method. It should call
            # iterm2_set_user_var but not produce any other output.
            # e.g., iterm2_set_user_var currentDirectory $PWD
            # Accessible in iTerm2 (in a badge now, elsewhere in the future) as
            # \(user.currentDirectory).
            iterm2_print_user_vars() {
            }

            iterm2_print_state_data() {
                printf "\033]1337;RemoteHost=%s@%s\007" "$USER" "$iterm2_hostname"
                printf "\033]1337;CurrentDir=%s\007" "$PWD"
                iterm2_print_user_vars
            }

            # Report return code of command; runs after command finishes but before prompt
            iterm2_after_cmd_executes() {
                printf "\033]133;D;$?\007"
                iterm2_print_state_data
            }

            # Mark start of prompt
            iterm2_prompt_start() {
                printf "\033]133;A\007"
            }

            # Mark end of prompt
            iterm2_prompt_end() {
                printf "\033]133;B\007"
            }

            iterm2_precmd() {
                iterm2_after_cmd_executes

                # The user or another precmd may have changed PS1 (e.g., powerline-shell).
                # Ensure that our escape sequences are added back in.
                if [[ "$ITERM2_SAVED_PS1" != "$PS1" ]]; then
                    PS1="%{$(iterm2_prompt_start)%}$PS1%{$(iterm2_prompt_end)%}"
                    ITERM2_SAVED_PS1="$PS1"
                fi
            }

            iterm2_preexec() {
                PS1="$ITERM2_SAVED_PS1"
                iterm2_before_cmd_executes
            }

            # If hostname -f is slow on your system, set iterm2_hostname prior to sourcing this script.
            [[ -z "$iterm2_hostname" ]] && iterm2_hostname=`hostname -f`

            [[ -z $precmd_functions ]] && precmd_functions=()
            precmd_functions=($precmd_functions iterm2_precmd)

            [[ -z $preexec_functions ]] && preexec_functions=()
            preexec_functions=($preexec_functions iterm2_preexec)

            iterm2_print_state_data
            printf "\033]1337;ShellIntegrationVersion=1\007"
        fi
    fi

# Functions
    function ban() {
        sudo iptables -A INPUT -p tcp --destination-port "$*" -j DROP
        sudo ip6tables -A INPUT -p tcp --destination-port "$*" -j DROP
    }

    function unban() {
        sudo iptables -D INPUT -p tcp --destination-port "$*" -j DROP
        sudo ip6tables -D INPUT -p tcp --destination-port "$*" -j DROP
    }

    pegb() {
        source /Users/roboslone/Documents/Experiments/pyenv-greenbox/bin/activate
    }

# Additional config
    if [[ -e ~/.zshrc.ext ]]; then
        source ~/.zshrc.ext
    fi
