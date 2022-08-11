# Configuration.
    DEFAULT_USERNAME="roboslone"
    DEFAULT_HOSTNAME="roboslone-m1"
    export HOSTNAME=$(hostname)

# Formatting.
    ## Common.
        bold='\033[1m'      # bold
        bou='\033[5m'       # bounce
        transp='\033[2m'    # transparent
        und='\033[4m'       # underlined
        inv='\033[7m'       # inverted (background color <> font color)
        normal='\033[m'     # format reset
        _0='\033[m'         # same as ${normal}
    ## Foreground colors.
        black='\033[30m'
        red='\033[31m'
        green='\033[32m'
        yellow='\033[33m'
        blue='\033[34m'
        violet='\033[35m'
        cyan='\033[36m'
        grey='\033[37m'
    ## Background colors.
        _black='\033[40m'
        _red='\033[41m'
        _green='\033[42m'
        _yellow='\033[43m'
        _blue='\033[44m'
        _violet='\033[45m'
        _cyan='\033[46m'
        _grey='\033[47m'

# Loading...
	echo -e "${black}Loading...${_0}"

# Platform specific variables.
    unset PLATFORM_LINUX
    unset PLATFORM_DARWIN
    [[ $(uname) == 'Darwin' ]] && export PLATFORM_DARWIN=1 && export PLATFORM_LINUX=
    [[ $(uname) == 'Linux' ]] && export PLATFORM_LINUX=1 && export PLATFORM_DARWIN=

# Autocomplete.
    autoload -U compinit
    compinit
    setopt completealiases
    zstyle ':completion:*' menu select
    unsetopt nomatch

# Additional completions for ZSH.
    if [[ -e /usr/local/share/zsh-completions ]]; then
        fpath=(/usr/local/share/zsh-completions $fpath)
    fi

# Primary color.
    if [[ -e ~/.color ]]; then
        primary_color=$(cat ~/.color)
    else
        primary_color='cyan'
    fi

# VCS.
    setopt prompt_subst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'
    zstyle ':vcs_info:*' formats '%F{yellow}%b%f'
    zstyle ':vcs_info:git:*' formats '%F{black}%i@%F{yellow}%b%f'
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%F{yellow}r%r'
    zstyle ':vcs_info:*' enable git svn

    function vcs_info_wrapper() {
        vcs_info
        if [ -n "$vcs_info_msg_0_" ]; then
            echo "${vcs_info_msg_0_}$del %F{black}|%f"
        fi
    }

# Path.
    export PATH="$HOME/.cargo/bin:$HOME/.bin:/usr/local/sbin:/usr/local/bin:/db/bin:$PATH"

# Aliases.
    ## Global.
        alias -g NN='&>/dev/null'
        alias -g V='|vim -'
        alias -g G='|grep -i'
        alias -g Gv='|grep -iv'
        alias -g L='|less'
        alias -g T='|tail'
        alias -g H='|head'
        alias -g W='|wc -l'
        alias -g Y='ya make -q &&'
        alias -g DBG='LOGGING_LEVEL=DEBUG'
        alias -g S='|subl'

    ## Common.
        [[ -n $PLATFORM_LINUX ]] && alias ls='ls --color=auto -F --group-directories-first'
        [[ -n $PLATFORM_DARWIN ]] && alias ls='/opt/homebrew/bin/gls --color=auto -F --group-directories-first'
        alias ll='ls -la'
        alias l1='ls -1'
        alias grep='grep --color=auto'
        alias Lf='less +F'
        alias GR='grep -RIi'
        alias ssh='ssh -o "logLevel=QUIET"'
        alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance(pprint=True)'"
        alias repo_up='svn info &> /dev/null && svn up -q; git pull --quiet && git submodule update --init --recursive --quiet'
        alias repo_up_with_log='svn info &> /dev/null && (svn up && svn log -l 5) || git pull'
        alias gs='git status'
        alias fav='echo $(pwd) >> ~/.favorite_dirs'
        alias GC='git reset --hard HEAD && git clean -qfd'

    ## macOS only.
        [[ -n $PLATFORM_DARWIN ]] && alias dnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
        [[ -n $PLATFORM_DARWIN ]] && alias bup='brew update && brew upgrade; brew doctor'

    ## Linux only.
        [[ -n $PLATFORM_LINUX ]] && alias bup='sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y install linux-generic linux-headers-generic linux-image-generic && sudo apt-get -y autoclean && sudo apt-get -y autoremove'

# Editor.
    export EDITOR='vim'
    [[ -n $PLATFORM_DARWIN ]] && export HOMEBREW_EDITOR='vim'

# History.
    SAVEHIST=100000
    HISTSIZE=100000
    HISTFILE=~/.zsh_history
    setopt extended_history
    setopt inc_append_history
    setopt share_history
    setopt hist_ignore_all_dups
    setopt hist_ignore_space
    setopt hist_reduce_blanks

# Locale.
    export LC_ALL='en_US.UTF-8'

# Del key fix (macOS only).
    if [[ -n $PLATFORM_DARWIN ]]; then
        bindkey "^[[3~"     delete-char
        bindkey "^[3;5~"    delete-char
    fi

# Syntax highlighting.
	export FAST_WORK_DIR='~/Dotfiles/fast-syntax-highlighting-themes'

    if [[ -e ~/Dotfiles/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]]; then
        source ~/Dotfiles/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
    fi

# Suggest.
	if [[ -e ~/Dotfiles/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]]; then
        source ~/Dotfiles/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
    fi

# Working directory.
    if [[ -e ~/.path ]]; then
        # Only change working directory if it's set to user's home.
        # Otherwise it breaks PyCharm's terminal by overwriting correct working dirs.
        if [[ "$(pwd)" == "$(eval echo "~$USER")" ]]; then
            cd $(cat ~/.path)
        fi
    fi

# ZSH options.
    setopt autocd
    setopt interactive_comments

# Constants.
    WORDCHARS="@"

# FZF.
    if [[ -e "${HOME}/.fzf.zsh" ]]; then
        source "${HOME}/.fzf.zsh"
        export FZF_DEFAULT_OPTS='--pointer="🡢" --height 100% -i --multi --exact --prompt="" --no-mouse --margin=3 --color="fg:-1,bg:-1,hl:-1,fg+:-1,bg+:-1,info:-1,prompt:-1,pointer:-1,marker:32,spinner:-1,header:-1"'
    fi

# iTerm2 shell integration.
    if [[ -e "${HOME}/.iterm2_shell_integration.zsh" ]]; then
        ## external
        source "${HOME}/.iterm2_shell_integration.zsh"
    else
        ## embedded
        if [[ -o interactive ]]; then
            if [ "$TERM" != "screen" -a "$ITERM_SHELL_INTEGRATION_INSTALLED" = "" ]; then
                ITERM_SHELL_INTEGRATION_INSTALLED=Yes
                ITERM2_SHOULD_DECORATE_PROMPT="1"
                # Indicates start of command output. Runs just before command executes.
                iterm2_before_cmd_executes() {
                    printf "\033]133;C;\007"
                }

                iterm2_set_user_var() {
                    printf "\033]1337;SetUserVar=%s=%s\007" "$1" $(printf "%s" "$2" | base64 | tr -d '\n')
                }

                # Users can write their own version of this method. It should call
                # iterm2_set_user_var but not produce any other output.
                # e.g., iterm2_set_user_var currentDirectory $PWD
                # Accessible in iTerm2 (in a badge now, elsewhere in the future) as
                # \(user.currentDirectory).
                whence -v iterm2_print_user_vars > /dev/null 2>&1
                if [ $? -ne 0 ]; then
                    iterm2_print_user_vars() {
                    }
                fi

                iterm2_print_state_data() {
                    printf "\033]1337;RemoteHost=%s@%s\007" "$USER" "$iterm2_hostname"
                    printf "\033]1337;CurrentDir=%s\007" "$PWD"
                    iterm2_print_user_vars
                }

                # Report return code of command; runs after command finishes but before prompt
                iterm2_after_cmd_executes() {
                    printf "\033]133;D;%s\007" "$STATUS"
                    iterm2_print_state_data
                }

                # Mark start of prompt
                iterm2_prompt_mark() {
                    printf "\033]133;A\007"
                }

                # Mark end of prompt
                iterm2_prompt_end() {
                    printf "\033]133;B\007"
                }

                # There are three possible paths in life.
                #
                # 1) A command is entered at the prompt and you press return.
                #        The following steps happen:
                #        * iterm2_preexec is invoked
                #            * PS1 is set to ITERM2_PRECMD_PS1
                #            * ITERM2_SHOULD_DECORATE_PROMPT is set to 1
                #        * The command executes (possibly reading or modifying PS1)
                #        * iterm2_precmd is invoked
                #            * ITERM2_PRECMD_PS1 is set to PS1 (as modified by command execution)
                #            * PS1 gets our escape sequences added to it
                #        * zsh displays your prompt
                #        * You start entering a command
                #
                # 2) You press ^C while entering a command at the prompt.
                #        The following steps happen:
                #        * (iterm2_preexec is NOT invoked)
                #        * iterm2_precmd is invoked
                #            * iterm2_before_cmd_executes is called since we detected that iterm2_preexec was not run
                #            * (ITERM2_PRECMD_PS1 and PS1 are not messed with, since PS1 already has our escape
                #                sequences and ITERM2_PRECMD_PS1 already has PS1's original value)
                #        * zsh displays your prompt
                #        * You start entering a command
                #
                # 3) A new shell is born.
                #        * PS1 has some initial value, either zsh's default or a value set before this script is sourced.
                #        * iterm2_precmd is invoked
                #            * ITERM2_SHOULD_DECORATE_PROMPT is initialized to 1
                #            * ITERM2_PRECMD_PS1 is set to the initial value of PS1
                #            * PS1 gets our escape sequences added to it
                #        * Your prompt is shown and you may begin entering a command.
                #
                # Invariants:
                # * ITERM2_SHOULD_DECORATE_PROMPT is 1 during and just after command execution, and "" while the prompt is
                #     shown and until you enter a command and press return.
                # * PS1 does not have our escape sequences during command execution
                # * After the command executes but before a new one begins, PS1 has escape sequences and
                #     ITERM2_PRECMD_PS1 has PS1's original value.
                iterm2_decorate_prompt() {
                    # This should be a raw PS1 without iTerm2's stuff. It could be changed during command
                    # execution.
                    ITERM2_PRECMD_PS1="$PS1"
                    ITERM2_SHOULD_DECORATE_PROMPT=""

                    # Add our escape sequences just before the prompt is shown.
                    if [[ $PS1 == *'$(iterm2_prompt_mark)'* ]]
                    then
                        PS1="$PS1%{$(iterm2_prompt_end)%}"
                    else
                        PS1="%{$(iterm2_prompt_mark)%}$PS1%{$(iterm2_prompt_end)%}"
                    fi
                }

                iterm2_precmd() {
                    local STATUS="$?"
                    if [ -z "$ITERM2_SHOULD_DECORATE_PROMPT" ]; then
                        # You pressed ^C while entering a command (iterm2_preexec did not run)
                        iterm2_before_cmd_executes
                    fi

                    iterm2_after_cmd_executes "$STATUS"

                    if [ -n "$ITERM2_SHOULD_DECORATE_PROMPT" ]; then
                        iterm2_decorate_prompt
                    fi
                }

                # This is not run if you press ^C while entering a command.
                iterm2_preexec() {
                    # Set PS1 back to its raw value prior to executing the command.
                    PS1="$ITERM2_PRECMD_PS1"
                    ITERM2_SHOULD_DECORATE_PROMPT="1"
                    iterm2_before_cmd_executes
                }

                # If hostname -f is slow on your system, set iterm2_hostname prior to sourcing this script.
                [[ -z "$iterm2_hostname" ]] && iterm2_hostname=`hostname -f`

                [[ -z $precmd_functions ]] && precmd_functions=()
                precmd_functions=($precmd_functions iterm2_precmd)

                [[ -z $preexec_functions ]] && preexec_functions=()
                preexec_functions=($preexec_functions iterm2_preexec)

                iterm2_print_state_data
                printf "\033]1337;ShellIntegrationVersion=5;shell=zsh\007"
            fi
        fi

    fi

# Functions.
    function disable_airdrop() {
        ifconfig awdl0 &> /dev/null || (print 'AirDrop interface (awdl0) does not exist' && return 1)
        ifconfig awdl0 | grep status | grep inactive &> /dev/null && return 0
        sudo ifconfig awdl0 down && print 'AirDrop interface disabled' && return 0
        print 'failed to disable AirDrop interface' && return 2
    }

    function check_sip() {
        csrutil status | grep 'enabled' > /dev/null || print "${_red}System Integrity Protection is disabled!${_0}"
    }

    function up() {
        if [[ -z "$@" ]]; then
            repo_up_with_log
        else
            for _dir in "$@"; do
                print -n "==> updating '${_dir}' "
                _prev_dir=$(pwd)
                cd ${_dir} &> /dev/null && repo_up &> /dev/null && print "${green}OK${_0}" || print "${red}FAIL${_0}"
                cd ${_prev_dir}
            done
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

    function ils() {
        _OLD_IFS=$IFS
        IFS=$'\n'
        for i in $(ih list -s "$*"); do
            print ${i}
        done
        IFS=${_OLD_IFS}
    }

    function st() {
        # VCS status.
        unset _output

        svn info &>/dev/null
        if [ $? -eq 0 ]; then
            _output=$(svn st | grep -v 'W155007' | sed 's/       / /' | sed 's/^/    /' 1>&1)
            if [ -n "${_output}" ]; then
                print "\n${yellow}# SVN${_0}"
                print "${_output}"
            fi
        fi

        if [ -d .git ]; then
            _output=$(git status -s | sed 's/^ /    /' 2>&1)
            if [ $? -eq 0 ]; then
                if [ -n "${_output}" ]; then
                    print "\n${yellow}# Git${_0}"
                    print "${_output}"
                fi
            fi
        fi

        print
    }

    function svnsync() {
        print "${green}Sync status:${_0}"
        st

        print "\n${yellow}Committing in 5 seconds...${_0}"
        sleep 5
        svn ci -m "github sync ($(git rev-parse HEAD)@$(git rev-parse --abbrev-ref HEAD))"
    }

    function fcd() {
        unset _target_dir
        _target_dir="$(cat ~/.favorite_dirs | fzf)"
        cd "${_target_dir}"
        echo -e "\n${green}-> ${_target_dir}${_0}"
    }

    function gp() {
        git pull && git log -n 1 --format="%ai %s"
        if [[ -z "$*" ]]; then; else
            git checkout "$*" && git pull && git log -n 1 --format="%ai %s"
        fi
    }

    function gpm() {
	gp master
    }

    function gcm() {
	git co master
    }

    function gfm() {
	git fetch -u origin master:master
    }

    function gco() {
	git checkout -b "akhristyukhin/$*"
    }

    function b64() {
        echo "$*" | base64 -d
    }

# Shortcut bindings.
    zle -N fcd
    bindkey ^h fcd

    autoload -z edit-command-line
    zle -N edit-command-line
    bindkey "^X^E" edit-command-line

# Additional config.
    if [[ -e ~/.zshrc.ext ]]; then
        source ~/.zshrc.ext
    fi

# Prompt and colors.
    if [[ "$USER" == "$DEFAULT_USERNAME" ]]; then
        _display_user=""
    else
        _display_user="$USER@"
    fi

    if [[ "$(hostname)" == "$DEFAULT_HOSTNAME" ]]; then
        _display_host=""
    else
        _display_host="$(hostname) %F{black}|%f "
    fi

    autoload -U promptinit
    autoload -U colors && colors
    promptinit
    #PROMPT='%* %{$fg_no_bold[${primary_color}]%}|%{$reset_color%} '
    #RPROMPT='$(vcs_info_wrapper) %{$fg_no_bold[${primary_color}]%}${_display_user}%{$reset_color%}${_display_host}%{$fg_no_bold[${primary_color}]%}%{$reset_color%}%{$fg[${primary_color}]%}%~%{$reset_color%}'
    eval "$(starship init zsh)"

# Done loading.
	clear

# Check System Integrity Protection check.
    [[ -n $PLATFORM_DARWIN ]] && check_sip

