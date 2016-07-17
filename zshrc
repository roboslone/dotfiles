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

# Platform specific variables.
    unset PLATFORM_LINUX
    unset PLATFORM_DARWIN
    [[ $(uname) == 'Darwin' ]] && export PLATFORM_DARWIN=1 && export PLATFORM_LINUX=
    [[ $(uname) == 'Linux' ]] && export PLATFORM_LINUX=1 && export PLATFORM_DARWIN=

# Autocomplete
    autoload -U compinit
    compinit
    setopt completealiases
    zstyle ':completion:*' menu select

# Additional completions for ZSH
    if [[ -e /usr/local/share/zsh-completions ]]; then
        fpath=(/usr/local/share/zsh-completions $fpath)
    fi

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
        alias -g W='|wc -l'

    ## common
        [[ -n $PLATFORM_LINUX ]] && alias ls='ls --color=auto -F --group-directories-first'
        [[ -n $PLATFORM_DARWIN ]] && alias ls='/usr/local/Cellar/coreutils/8.24/bin/gls --color=auto -F --group-directories-first'
        alias ll='ls -la'
        alias l1='ls -1'
        alias grep='grep --color=auto'
        alias Lf='less +F'
        alias GR='grep -R'
        alias repo_up='svn info &> /dev/null && svn up || git pull -q'
        alias repo_up_with_log='svn info &> /dev/null && (svn up && svn log -l 5) || git pull'
        alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance(profile=\"roboslone-default\", pprint=True)'"

    ## OS X only
        [[ -n $PLATFORM_DARWIN ]] && alias dnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

    ## bsconfig
        if [[ -n $PLATFORM_LINUX ]]; then
            alias bsh='sudo bsconfig configuration_history'
            alias bsp='sudo bsconfig configuration_prepare --now --shards'
            alias bsa='sudo bsconfig configuration_activate'
            alias bsaf='sudo bsconfig configuration_activate --force'
            alias bsd='sudo bsconfig configuration_deactivate --force'
            alias bsgp='sudo bsconfig --set global_configuration_prepare'
            alias bsga='sudo bsconfig --set global_configuration_activate'
            alias bsgd='sudo bsconfig --set global_configuration_deactivate'
            alias bssd='sudo bsconfig syncdisable --kill'
            alias bsse='sudo bsconfig syncenable'
            alias bssf='sudo bsconfig stop --force'
            alias bss='sudo bsconfig start'
            alias bscd='bsconfig configuration_dump'
            alias cmslookup='bsconfig global_listconfigurations | grep'
        fi

    ## skynet
        if [[ -n $PLATFORM_LINUX ]]; then
            alias check_heartbeat='tail -1000 /var/log/skynet/heartbeat-client.log | grep -i instancestatev3'
            alias check_skybone='ps -ef | grep skybone-dl | grep -v grep'
        fi

    ## power capping
        if [[ -n $PLATFORM_LINUX ]]; then
            alias disable_power_capping='ipmitool -t 0x2c -b 6 raw 0x2E 0xC1 0x57 0x01 0x00 0x0 0x1 0x0 0x0 0x64 0x0 0x70 0x17 0x0 0x0 0x00 0x00 0x3 0x0'
        fi

# Editor
    export EDITOR='vim'
    [[ -n $PLATFORM_DARWIN ]] && export HOMEBREW_EDITOR='vim'

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

# Del key fix (OS X only)
    if [[ -n $PLATFORM_DARWIN ]]; then
        bindkey "^[[3~"     delete-char
        bindkey "^[3;5~"    delete-char
    fi

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
    if [[ -e "${HOME}/.fzf.zsh" ]]; then
        source "${HOME}/.fzf.zsh"
        export FZF_DEFAULT_OPTS='-i --multi --exact --prompt="" --no-mouse --margin=3 --color="fg:-1,bg:-1,hl:-1,fg+:-1,bg+:-1,info:-1,prompt:-1,pointer:-1,marker:32,spinner:-1,header:-1"'
    fi

# iTerm2 shell integration
    if [[ -e "${HOME}/.iterm2_shell_integration.zsh" ]]; then
        ## external
        source "${HOME}/.iterm2_shell_integration.zsh"
    else
        ## embedded
        if [[ -o login ]]; then
            if [ "$TERM" != "screen" -a "$ITERM_SHELL_INTEGRATION_INSTALLED" = "" ]; then
                export ITERM_SHELL_INTEGRATION_INSTALLED=Yes
                ITERM2_SHOULD_DECORATE_PROMPT="1"
                # Indicates start of command output. Runs just before command executes.
                iterm2_before_cmd_executes() {
                    printf "\033]133;C;\007"
                }

                iterm2_set_user_var() {
                    printf "\033]1337;SetUserVar=%s=%s\007" "$1" $(printf "%s" "$2" | base64)
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
                iterm2_prompt_start() {
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
                    PS1="%{$(iterm2_prompt_start)%}$PS1%{$(iterm2_prompt_end)%}"
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
                printf "\033]1337;ShellIntegrationVersion=2;shell=zsh\007"
            fi
        fi
        alias imgcat=~/.iterm2/imgcat; alias it2dl=~/.iterm2/it2dl
    fi

# Functions
    function bsl() {
        if [[ -z "$*" ]]; then
            bsconfig list
        else
            bsconfig list | grep "$*"
        fi
    }

    function up() {
        if [[ -z "$@" ]]; then
            repo_up_with_log
        else
            for _dir in "$@"; do
                print "${blue}Updating '${_dir}'${_0}"
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

        if [ -z ${_env} ]; then
            print "${yellow}no virtualenv selected${_0}"
        else
            print "selected ${green}${_env}${_0}"
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

    function skylist() {
        sky list $@ | sed 's/^/+/g' | xargs
    }

    function check_topology() {
        for cms in $(sky list K@search_instrum-acms); do
            echo -n "$cms "; curl -s -I "http://${cms}/res/gencfg/releases/$*/generated/balancer/web_priemka_tun.cfg" 2>/dev/null | grep -R '^HTTP'
        done
    }

    function prepare_string() {
        print "sudo bsconfig configuration_prepare --now --shards $*; echo DONE"
    }

    function activate_string() {
        print "sudo bsconfig configuration_activate $*; echo DONE"
    }

    function activate_force_string() {
        print "sudo bsconfig configuration_activate --force $*; echo DONE"
    }

    function deactivate_string() {
        print "sudo bsconfig configuration_deactivate --force $*; sudo bsconfig configuration_deactivate --force $*; echo DONE"
    }

    function yr-prepare()
    {
        unset _conf
        unset _hosts

        _conf=$1
        shift
        _hosts=$@

        if [[ -z ${_conf} ]] || [[ -z ${_hosts} ]]; then
            print "Usage: $0 <conf> <hosts>"
            return 0
        fi

        yr $(skylist ${_hosts}) / "$(prepare_string ${_conf})"
    }

    function yr-activate()
    {
        unset _conf
        unset _hosts

        _conf=$1
        shift
        _hosts=$@

        if [[ -z ${_conf} ]] || [[ -z ${_hosts} ]]; then
            print "Usage: $0 <conf> <hosts>"
            return 0
        fi

        yr $(skylist ${_hosts}) / "$(activate_string ${_conf})"
    }

    function yr-activate-force()
    {
        unset _conf
        unset _hosts

        _conf=$1
        shift
        _hosts=$@

        if [[ -z ${_conf} ]] || [[ -z ${_hosts} ]]; then
            print "Usage: $0 <conf> <hosts>"
            return 0
        fi

        yr $(skylist ${_hosts}) / "$(activate_force_string ${_conf})"
    }

    function yr-deactivate()
    {
        unset _conf
        unset _hosts

        _conf=$1
        shift
        _hosts=$@

        if [[ -z ${_conf} ]] || [[ -z ${_hosts} ]]; then
            print "Usage: $0 <conf> <hosts>"
            return 0
        fi

        yr $(skylist ${_hosts}) / "$(deactivate_string ${_conf})"
    }

    function get-macs() {
        for h in $(sky list "$*"); do print -n "$h "; /Berkanavt/webscripts/admscripts/scripts/get_host_mac.sh $h; done
    }

    function fix-macs() {
        for h in $(sky list "$*"); do
            c_mac=$(/Berkanavt/webscripts/admscripts/scripts/get_host_mac.sh $h)
            /Berkanavt/webscripts/admscripts/scripts/dhcpm.sh $h $c_mac web-ubuntu-12.04-dev force
        done
    }

    function timed-prepare() {
        unset _time
        unset _conf
        unset _filters

        # without arguments
        if (( $# < 2 )); then
            print 'usage: timed-prepare <time> <configuration> [<filters>]'
            return 0
        fi

        # without filters
        if (( $# == 2 )); then
            _time=$1
            if ! [[ "${_time}" = <-> ]]; then
                print "Bad time: ${_time}"
                return 0
            fi

            shift
            _conf=$1
        fi

        # with filters
        if (( $# > 2 )); then
            _time=$1
            if ! [[ "${_time}" = <-> ]]; then
                print "Bad time: ${_time}"
                return 0
            fi

            shift
            _conf=$1
            shift

            if [[ "$1" == "." ]]; then
                shift
            fi

            _filters="$*"
        fi

        if [ -z "${_filters}" ]; then
            sky run --cqudp -Up -s ${_time} "sudo /db/bin/bsconfig configuration_prepare --now --shards ${_conf}" C@${_conf}
        else
            sky run --cqudp -Up -s ${_time} "sudo /db/bin/bsconfig configuration_prepare --now --shards ${_conf}" C@${_conf} . ${_filters}
        fi
    }

    function timed-activate() {
        unset _time
        unset _conf
        unset _filters

        # without arguments
        if (( $# < 2 )); then
            print 'usage: timed-activate <time> <configuration> [<filters>]'
            return 0
        fi

        # without filters
        if (( $# == 2 )); then
            _time=$1
            if ! [[ "${_time}" = <-> ]]; then
                print "Bad time: ${_time}"
                return 0
            fi

            shift
            _conf=$1
        fi

        # with filters
        if (( $# > 2 )); then
            _time=$1
            if ! [[ "${_time}" = <-> ]]; then
                print "Bad time: ${_time}"
                return 0
            fi

            shift
            _conf=$1
            shift

            if [[ "$1" == "." ]]; then
                shift
            fi

            _filters="$*"
        fi

        if [ -z "${_filters}" ]; then
            sky run --cqudp -Up -s ${_time} "sudo /db/bin/bsconfig configuration_activate ${_conf}" C@${_conf}
        else
            sky run --cqudp -Up -s ${_time} "sudo /db/bin/bsconfig configuration_activate ${_conf}" C@${_conf} . ${_filters}
        fi
    }

    function timed-activate-force() {
        unset _time
        unset _conf
        unset _filters

        # without arguments
        if (( $# < 2 )); then
            print 'usage: timed-activate-force <time> <configuration> [<filters>]'
            return 0
        fi

        # without filters
        if (( $# == 2 )); then
            _time=$1
            if ! [[ "${_time}" = <-> ]]; then
                print "Bad time: ${_time}"
                return 0
            fi

            shift
            _conf=$1
        fi

        # with filters
        if (( $# > 2 )); then
            _time=$1
            if ! [[ "${_time}" = <-> ]]; then
                print "Bad time: ${_time}"
                return 0
            fi

            shift
            _conf=$1
            shift

            if [[ "$1" == "." ]]; then
                shift
            fi

            _filters="$*"
        fi

        if [ -z "${_filters}" ]; then
            sky run --cqudp -Up -s ${_time} "sudo /db/bin/bsconfig configuration_activate --force ${_conf}" C@${_conf}
        else
            sky run --cqudp -Up -s ${_time} "sudo /db/bin/bsconfig configuration_activate --force ${_conf}" C@${_conf} . ${_filters}
        fi
    }

    function timed-deactivate-force() {
        unset _time
        unset _conf
        unset _filters

        # without arguments
        if (( $# < 2 )); then
            print 'usage: timed-deactivate-force <time> <configuration> [<filters>]'
            return 0
        fi

        # without filters
        if (( $# == 2 )); then
            _time=$1
            if ! [[ "${_time}" = <-> ]]; then
                print "Bad time: ${_time}"
                return 0
            fi

            shift
            _conf=$1
        fi

        # with filters
        if (( $# > 2 )); then
            _time=$1
            if ! [[ "${_time}" = <-> ]]; then
                print "Bad time: ${_time}"
                return 0
            fi

            shift
            _conf=$1
            shift

            if [[ "$1" == "." ]]; then
                shift
            fi

            _filters="$*"
        fi

        if [ -z "${_filters}" ]; then
            sky run --cqudp -Up -s ${_time} "sudo /db/bin/bsconfig configuration_deactivate --force ${_conf}" C@${_conf}
        else
            sky run --cqudp -Up -s ${_time} "sudo /db/bin/bsconfig configuration_deactivate --force ${_conf}" C@${_conf} . ${_filters}
        fi
    }

    function check_power_capping() {
        _cmd="[ \$(cat /proc/cpuinfo | grep 'cpu MHz' | awk '{print int(\$4)}' | sort -g | tail -1) -ge 1300 ] || echo CAPPING"
        sky run -Up --cqudp "${_cmd}" "$@"
    }

    function genconf() {
        print "${transp}Warning: You have to run 'svn up' manually${reset_color}"

        unset _start
        unset _end
        unset _head
        unset _logname
        unset _exitcode

        _start=$(date +%s)

        _head="$*"
        # Remove .conf from _head
        _head=${_head/.conf/}
        _logname="/tmp/genconf-${_head}-`date +%s`.log"

        print "Building ${_head}, log: ${green}${_logname}${reset_color}"

        bsconfig --logfile ${_logname} \
        --batch-mode --cms-xmlrpc-yr-url http://cmsearchvip.yandex.ru/xmlrpc/yr \
        --cms-xmlrpc-url http://cmsearchvip.yandex.ru/xmlrpc/bs/ \
        --cms-json-url http://cmsearchvip.yandex.ru/json/bs/ \
        genconf ${_head} ${_head}.conf --set

        _exitcode=$?
        _end=$(date +%s)
        let "_diff = ${_end} - ${_start}"

        if [[ ${_exitcode} -eq 0 ]]; then
            print "Built ${_head} in ${green}${_diff} sec${reset_color}"
        else
            grep -R 'ERROR' ${_logname}
            print "${red}${_head} failed to build${reset_color}"
        fi
    }

    function global_copy() {
        unset _start
        unset _end
        unset _head
        unset _logname
        unset _exitcode
        unset _conf

        if (( $# != 2 )); then
            print "Usage: $0 <head> <conf>"
            return 1
        fi

        _start=$(date +%s)

        _head=$1
        _conf=$2
        # Remove .conf from _head
        _head=${_head/.conf/}
        _logname="/tmp/global_copyconfiguration-${_head}-${_conf}-`date +%s`.log"

        print "Building ${_conf} <- ${_head}, log: ${green}${_logname}${reset_color}"
        
        bsconfig --logfile ${_logname} --batch-mode \
        --cms-xmlrpc-yr-url http://cmsearchvip.yandex.ru/xmlrpc/yr \
        --cms-xmlrpc-url http://cmsearchvip.yandex.ru/xmlrpc/bs/ \
        --cms-json-url http://cmsearchvip.yandex.ru/json/bs/ \
        global_copyconfiguration ${_head} ${_conf}

        _exitcode=$?
        _end=$(date +%s)
        let "_diff = ${_end} - ${_start}"

        if [[ ${_exitcode} -eq 0 ]]; then
            print "Built ${_conf} in ${green}${_diff} sec${reset_color}"
        else
            grep -R 'ERROR' ${_logname}
            print "${red}${_conf} failed to build${reset_color}"
        fi
    }

    function cdump() {
        unset _conf

        _conf="$*"
        _conf=${_conf/C@/}

        print "Dumping C@${_conf} -> ${green}/tmp/${_conf}.dump${_0}"

        bscd ${_conf} > /tmp/${_conf}.dump
    }

# Additional config
    if [[ -e ~/.zshrc.ext ]]; then
        source ~/.zshrc.ext
    fi
