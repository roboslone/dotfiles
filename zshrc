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

# Platform specific variables
    unset PLATFORM_LINUX
    unset PLATFORM_DARWIN
    [[ $(uname) == 'Darwin' ]] && export PLATFORM_DARWIN=1 && export PLATFORM_LINUX=
    [[ $(uname) == 'Linux' ]] && export PLATFORM_LINUX=1 && export PLATFORM_DARWIN=

# Autocomplete
    autoload -U compinit
    compinit
    setopt completealiases
    zstyle ':completion:*' menu select
    unsetopt nomatch

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
    PROMPT='%* %{$fg_no_bold[${primary_color}]%}%1{⟩%}%{$reset_color%} '
    RPROMPT='$(vcs_info_wrapper) %{$fg_no_bold[${primary_color}]%}%n%{$reset_color%}%B@%b%m%{$fg_no_bold[${primary_color}]%}%{$reset_color%} %{$fg[${primary_color}]%}%~%{$reset_color%}'

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
        alias -g G='|grep -i'
        alias -g Gv='|grep -iv'
        alias -g L='|less'
        alias -g T='|tail'
        alias -g H='|head'
        alias -g W='|wc -l'

    ## common
        [[ -n $PLATFORM_LINUX ]] && alias ls='ls --color=auto -F --group-directories-first'
        [[ -n $PLATFORM_DARWIN ]] && alias ls='/usr/local/Cellar/coreutils/8.26/bin/gls --color=auto -F --group-directories-first'
        alias ll='ls -la'
        alias l1='ls -1'
        alias grep='grep --color=auto'
        alias Lf='less +F'
        alias GR='grep -RIi'
        alias ssh='ssh -o "logLevel=QUIET"'
        alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance(pprint=True)'"
        alias repo_up='svn info &> /dev/null && svn up -q || git pull -q'
        alias repo_up_with_log='svn info &> /dev/null && (svn up && svn log -l 5) || git pull'

    ## OS X only
        [[ -n $PLATFORM_DARWIN ]] && alias dnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
        [[ -n $PLATFORM_DARWIN ]] && alias bup='brew update && brew upgrade'

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

# Autosuggestions
    if [[ -e ~/.zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
        ## external
        source ~/.zsh-autosuggestions/zsh-autosuggestions.zsh
    else
        ## embedded

        # Fish-like fast/unobtrusive autosuggestions for zsh.
        # https://github.com/zsh-users/zsh-autosuggestions
        # v0.3.2
        # Copyright (c) 2013 Thiago de Arruda
        # Copyright (c) 2016 Eric Freese
        # 
        # Permission is hereby granted, free of charge, to any person
        # obtaining a copy of this software and associated documentation
        # files (the "Software"), to deal in the Software without
        # restriction, including without limitation the rights to use,
        # copy, modify, merge, publish, distribute, sublicense, and/or sell
        # copies of the Software, and to permit persons to whom the
        # Software is furnished to do so, subject to the following
        # conditions:
        # 
        # The above copyright notice and this permission notice shall be
        # included in all copies or substantial portions of the Software.
        # 
        # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
        # EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
        # OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
        # NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
        # HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
        # WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
        # FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
        # OTHER DEALINGS IN THE SOFTWARE.

        #--------------------------------------------------------------------#
        # Global Configuration Variables                                     #
        #--------------------------------------------------------------------#

        # Color to use when highlighting suggestion
        # Uses format of `region_highlight`
        # More info: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Widgets
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

        # Prefix to use when saving original versions of bound widgets
        ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX=autosuggest-orig-

        ZSH_AUTOSUGGEST_STRATEGY=default

        # Widgets that clear the suggestion
        ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
            history-search-forward
            history-search-backward
            history-beginning-search-forward
            history-beginning-search-backward
            history-substring-search-up
            history-substring-search-down
            up-line-or-history
            down-line-or-history
            accept-line
        )

        # Widgets that accept the entire suggestion
        ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
            forward-char
            end-of-line
            vi-forward-char
            vi-end-of-line
            vi-add-eol
        )

        # Widgets that accept the entire suggestion and execute it
        ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=(
        )

        # Widgets that accept the suggestion as far as the cursor moves
        ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
            forward-word
            vi-forward-word
            vi-forward-word-end
            vi-forward-blank-word
            vi-forward-blank-word-end
        )

        #--------------------------------------------------------------------#
        # Handle Deprecated Variables/Widgets                                #
        #--------------------------------------------------------------------#

        _zsh_autosuggest_deprecated_warning() {
            >&2 echo "zsh-autosuggestions: $@"
        }

        _zsh_autosuggest_check_deprecated_config() {
            if [ -n "$AUTOSUGGESTION_HIGHLIGHT_COLOR" ]; then
                _zsh_autosuggest_deprecated_warning "AUTOSUGGESTION_HIGHLIGHT_COLOR is deprecated. Use ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE instead."
                [ -z "$ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE" ] && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=$AUTOSUGGESTION_HIGHLIGHT_STYLE
                unset AUTOSUGGESTION_HIGHLIGHT_STYLE
            fi

            if [ -n "$AUTOSUGGESTION_HIGHLIGHT_CURSOR" ]; then
                _zsh_autosuggest_deprecated_warning "AUTOSUGGESTION_HIGHLIGHT_CURSOR is deprecated."
                unset AUTOSUGGESTION_HIGHLIGHT_CURSOR
            fi

            if [ -n "$AUTOSUGGESTION_ACCEPT_RIGHT_ARROW" ]; then
                _zsh_autosuggest_deprecated_warning "AUTOSUGGESTION_ACCEPT_RIGHT_ARROW is deprecated. The right arrow now accepts the suggestion by default."
                unset AUTOSUGGESTION_ACCEPT_RIGHT_ARROW
            fi
        }

        _zsh_autosuggest_deprecated_start_widget() {
            _zsh_autosuggest_deprecated_warning "The autosuggest-start widget is deprecated. For more info, see the README at https://github.com/zsh-users/zsh-autosuggestions."
            zle -D autosuggest-start
            eval "zle-line-init() {
                $(echo $functions[${widgets[zle-line-init]#*:}] | sed -e 's/zle autosuggest-start//g')
            }"
        }

        zle -N autosuggest-start _zsh_autosuggest_deprecated_start_widget

        #--------------------------------------------------------------------#
        # Widget Helpers                                                     #
        #--------------------------------------------------------------------#

        # Bind a single widget to an autosuggest widget, saving a reference to the original widget
        _zsh_autosuggest_bind_widget() {
            local widget=$1
            local autosuggest_action=$2
            local prefix=$ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX

            # Save a reference to the original widget
            case $widgets[$widget] in
                # Already bound
                user:_zsh_autosuggest_(bound|orig)_*);;

                # User-defined widget
                user:*)
                    zle -N $prefix$widget ${widgets[$widget]#*:}
                    ;;

                # Built-in widget
                builtin)
                    eval "_zsh_autosuggest_orig_${(q)widget}() { zle .${(q)widget} }"
                    zle -N $prefix$widget _zsh_autosuggest_orig_$widget
                    ;;

                # Completion widget
                completion:*)
                    eval "zle -C $prefix${(q)widget} ${${(s.:.)widgets[$widget]}[2,3]}"
                    ;;
            esac

            # Pass the original widget's name explicitly into the autosuggest
            # function. Use this passed in widget name to call the original
            # widget instead of relying on the $WIDGET variable being set
            # correctly. $WIDGET cannot be trusted because other plugins call
            # zle without the `-w` flag (e.g. `zle self-insert` instead of
            # `zle self-insert -w`).
            eval "_zsh_autosuggest_bound_${(q)widget}() {
                _zsh_autosuggest_widget_$autosuggest_action $prefix${(q)widget} \$@
            }"

            # Create the bound widget
            zle -N $widget _zsh_autosuggest_bound_$widget
        }

        # Map all configured widgets to the right autosuggest widgets
        _zsh_autosuggest_bind_widgets() {
            local widget;

            # Find every widget we might want to bind and bind it appropriately
            for widget in ${${(f)"$(builtin zle -la)"}:#(.*|_*|orig-*|autosuggest-*|$ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX*|zle-line-*|run-help|which-command|beep|set-local-history|yank)}; do
                if [ ${ZSH_AUTOSUGGEST_CLEAR_WIDGETS[(r)$widget]} ]; then
                    _zsh_autosuggest_bind_widget $widget clear
                elif [ ${ZSH_AUTOSUGGEST_ACCEPT_WIDGETS[(r)$widget]} ]; then
                    _zsh_autosuggest_bind_widget $widget accept
                elif [ ${ZSH_AUTOSUGGEST_EXECUTE_WIDGETS[(r)$widget]} ]; then
                    _zsh_autosuggest_bind_widget $widget execute
                elif [ ${ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS[(r)$widget]} ]; then
                    _zsh_autosuggest_bind_widget $widget partial_accept
                else
                    # Assume any unspecified widget might modify the buffer
                    _zsh_autosuggest_bind_widget $widget modify
                fi
            done
        }

        # Given the name of an original widget and args, invoke it, if it exists
        _zsh_autosuggest_invoke_original_widget() {
            # Do nothing unless called with at least one arg
            [ $# -gt 0 ] || return

            local original_widget_name="$1"

            shift

            if [ $widgets[$original_widget_name] ]; then
                zle $original_widget_name -- $@
            fi
        }

        #--------------------------------------------------------------------#
        # Highlighting                                                       #
        #--------------------------------------------------------------------#

        # If there was a highlight, remove it
        _zsh_autosuggest_highlight_reset() {
            typeset -g _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT

            if [ -n "$_ZSH_AUTOSUGGEST_LAST_HIGHLIGHT" ]; then
                region_highlight=("${(@)region_highlight:#$_ZSH_AUTOSUGGEST_LAST_HIGHLIGHT}")
                unset _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT
            fi
        }

        # If there's a suggestion, highlight it
        _zsh_autosuggest_highlight_apply() {
            typeset -g _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT

            if [ $#POSTDISPLAY -gt 0 ]; then
                _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT="$#BUFFER $(($#BUFFER + $#POSTDISPLAY)) $ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE"
                region_highlight+=("$_ZSH_AUTOSUGGEST_LAST_HIGHLIGHT")
            else
                unset _ZSH_AUTOSUGGEST_LAST_HIGHLIGHT
            fi
        }

        #--------------------------------------------------------------------#
        # Autosuggest Widget Implementations                                 #
        #--------------------------------------------------------------------#

        # Clear the suggestion
        _zsh_autosuggest_clear() {
            # Remove the suggestion
            unset POSTDISPLAY

            _zsh_autosuggest_invoke_original_widget $@
        }

        # Modify the buffer and get a new suggestion
        _zsh_autosuggest_modify() {
            local -i retval

            # Clear suggestion while original widget runs
            unset POSTDISPLAY

            # Original widget modifies the buffer
            _zsh_autosuggest_invoke_original_widget $@
            retval=$?

            # Get a new suggestion if the buffer is not empty after modification
            local suggestion
            if [ $#BUFFER -gt 0 ]; then
                suggestion="$(_zsh_autosuggest_suggestion "$BUFFER")"
            fi

            # Add the suggestion to the POSTDISPLAY
            if [ -n "$suggestion" ]; then
                POSTDISPLAY="${suggestion#$BUFFER}"
            else
                unset POSTDISPLAY
            fi

            return $retval
        }

        # Accept the entire suggestion
        _zsh_autosuggest_accept() {
            local -i max_cursor_pos=$#BUFFER

            # When vicmd keymap is active, the cursor can't move all the way
            # to the end of the buffer
            if [ "$KEYMAP" = "vicmd" ]; then
                max_cursor_pos=$((max_cursor_pos - 1))
            fi

            # Only accept if the cursor is at the end of the buffer
            if [ $CURSOR -eq $max_cursor_pos ]; then
                # Add the suggestion to the buffer
                BUFFER="$BUFFER$POSTDISPLAY"

                # Remove the suggestion
                unset POSTDISPLAY

                # Move the cursor to the end of the buffer
                CURSOR=${#BUFFER}
            fi

            _zsh_autosuggest_invoke_original_widget $@
        }

        # Accept the entire suggestion and execute it
        _zsh_autosuggest_execute() {
            # Add the suggestion to the buffer
            BUFFER="$BUFFER$POSTDISPLAY"

            # Remove the suggestion
            unset POSTDISPLAY

            # Call the original `accept-line` to handle syntax highlighting or
            # other potential custom behavior
            _zsh_autosuggest_invoke_original_widget "accept-line"
        }

        # Partially accept the suggestion
        _zsh_autosuggest_partial_accept() {
            local -i retval

            # Save the contents of the buffer so we can restore later if needed
            local original_buffer="$BUFFER"

            # Temporarily accept the suggestion.
            BUFFER="$BUFFER$POSTDISPLAY"

            # Original widget moves the cursor
            _zsh_autosuggest_invoke_original_widget $@
            retval=$?

            # If we've moved past the end of the original buffer
            if [ $CURSOR -gt $#original_buffer ]; then
                # Set POSTDISPLAY to text right of the cursor
                POSTDISPLAY="$RBUFFER"

                # Clip the buffer at the cursor
                BUFFER="$LBUFFER"
            else
                # Restore the original buffer
                BUFFER="$original_buffer"
            fi

            return $retval
        }

        for action in clear modify accept partial_accept execute; do
            eval "_zsh_autosuggest_widget_$action() {
                local -i retval

                _zsh_autosuggest_highlight_reset

                _zsh_autosuggest_$action \$@
                retval=\$?

                _zsh_autosuggest_highlight_apply

                return \$retval
            }"
        done

        zle -N autosuggest-accept _zsh_autosuggest_widget_accept
        zle -N autosuggest-clear _zsh_autosuggest_widget_clear
        zle -N autosuggest-execute _zsh_autosuggest_widget_execute

        #--------------------------------------------------------------------#
        # Suggestion                                                         #
        #--------------------------------------------------------------------#

        # Delegate to the selected strategy to determine a suggestion
        _zsh_autosuggest_suggestion() {
            local escaped_prefix="$(_zsh_autosuggest_escape_command "$1")"
            local strategy_function="_zsh_autosuggest_strategy_$ZSH_AUTOSUGGEST_STRATEGY"

            if [ -n "$functions[$strategy_function]" ]; then
                echo -E "$($strategy_function "$escaped_prefix")"
            fi
        }

        _zsh_autosuggest_escape_command() {
            setopt localoptions EXTENDED_GLOB

            # Escape special chars in the string (requires EXTENDED_GLOB)
            echo -E "${1//(#m)[\\()\[\]|*?]/\\$MATCH}"
        }

        #--------------------------------------------------------------------#
        # Default Suggestion Strategy                                        #
        #--------------------------------------------------------------------#
        # Suggests the most recent history item that matches the given
        # prefix.
        #

        _zsh_autosuggest_strategy_default() {
            local prefix="$1"

            # Get the keys of the history items that match
            local -a histkeys
            histkeys=(${(k)history[(r)$prefix*]})

            # Echo the value of the first key
            echo -E "${history[$histkeys[1]]}"
        }

        #--------------------------------------------------------------------#
        # Match Previous Command Suggestion Strategy                         #
        #--------------------------------------------------------------------#
        # Suggests the most recent history item that matches the given
        # prefix and whose preceding history item also matches the most
        # recently executed command.
        #
        # For example, suppose your history has the following entries:
        #   - pwd
        #   - ls foo
        #   - ls bar
        #   - pwd
        #
        # Given the history list above, when you type 'ls', the suggestion
        # will be 'ls foo' rather than 'ls bar' because your most recently
        # executed command (pwd) was previously followed by 'ls foo'.
        #

        _zsh_autosuggest_strategy_match_prev_cmd() {
            local prefix="$1"

            # Get all history event numbers that correspond to history
            # entries that match pattern $prefix*
            local history_match_keys
            history_match_keys=(${(k)history[(R)$prefix*]})

            # By default we use the first history number (most recent history entry)
            local histkey="${history_match_keys[1]}"

            # Get the previously executed command
            local prev_cmd="$(_zsh_autosuggest_escape_command "${history[$((HISTCMD-1))]}")"

            # Iterate up to the first 200 history event numbers that match $prefix
            for key in "${(@)history_match_keys[1,200]}"; do
                # Stop if we ran out of history
                [[ $key -gt 1 ]] || break

                # See if the history entry preceding the suggestion matches the
                # previous command, and use it if it does
                if [[ "${history[$((key - 1))]}" == "$prev_cmd" ]]; then
                    histkey="$key"
                    break
                fi
            done

            # Echo the matched history entry
            echo -E "$history[$histkey]"
        }

        #--------------------------------------------------------------------#
        # Start                                                              #
        #--------------------------------------------------------------------#

        # Start the autosuggestion widgets
        _zsh_autosuggest_start() {
            _zsh_autosuggest_check_deprecated_config
            _zsh_autosuggest_bind_widgets
        }

        autoload -Uz add-zsh-hook
        add-zsh-hook precmd _zsh_autosuggest_start

    fi

# Working directory
    if [[ -e ~/.path ]]; then
        # Only change working directory if it's set to user's home.
        # Otherwise it breaks PyCharm's terminal by overwriting correct working dirs.
        if [[ "$(pwd)" == "$(eval echo "~$USER")" ]]; then
            cd $(cat ~/.path)
        fi
    fi

# ZSH options
    setopt autocd
    setopt interactive_comments

# Constants
    WORDCHARS="@"

# FZF
    if [[ -e "${HOME}/.fzf.zsh" ]]; then
        source "${HOME}/.fzf.zsh"
        export FZF_DEFAULT_OPTS='--height 100% -i --multi --exact --prompt="" --no-mouse --margin=3 --color="fg:-1,bg:-1,hl:-1,fg+:-1,bg+:-1,info:-1,prompt:-1,pointer:-1,marker:32,spinner:-1,header:-1"'
    fi

# iTerm2 shell integration
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

# Functions
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

    function check_power_capping() {
        _cmd="[ \$(cat /proc/cpuinfo | grep 'cpu MHz' | awk '{print int(\$4)}' | sort -g | tail -1) -ge 1300 ] || echo CAPPING"
        sky run -Up --cqudp "${_cmd}" "$@"
    }

    function ils() {
        _OLD_IFS=$IFS
        IFS=$'\n'
        for i in $(ih list -s "$*"); do
            print ${i}
        done
        IFS=${_OLD_IFS}
    }

    function icd() {
        _OLD_IFS=$IFS
        IFS=$'\n'

        _fzf_bin=$(which fzf)
        if [ -e ${_fzf_bin} ]; then
            _instance=$(ils "$*" | fzf)
        else
            print "${red}fzf is not installed${_0}"
            return 1
        fi

        if [ -z ${_instance} ]; then
            print "${yellow}no instance selected${_0}"
        else
            print "${_instance}"
            $(print "${_instance}" | grep bsconfig) && cd ${_instance} || cd /db/iss3/instances/$(print ${_instance} | awk '{print$2}')
        fi

        IFS=${_OLD_IFS}
    }

    function grep_logs {
        unset _configuration
        unset _log_name
        unset _text
        unset _script_path

        _configuration="$1"
        shift
        _log_name="$1"
        shift
        _text="$*"

        print
        print "${cyan}Configuration:${_0} ${_configuration}"
        print "${cyan}Log file:     ${_0} ${_log_name}"
        print "${cyan}Text:         ${_0} ${_text}"

        _script_path=$(mktemp)

        echo '#!/usr/bin/env zsh' >> "${_script_path}"
        echo 'source /home/roboslone/.zshrc' >> "${_script_path}"
        echo "idir=\$(ils ${_configuration} | tail -1 | awk -F ' ' '{print\$2}')" >> "${_script_path}"
        echo "grep '${_text}' /db/iss3/instances/\${idir}/${_log_name} " >> "${_script_path}"

        print "\n${cyan}Script:${black}"
        cat "${_script_path}"
        print "${_0}"

        sky run -Up -F "${_script_path}" "C@${_configuration}"
    }

# Additional config
    if [[ -e ~/.zshrc.ext ]]; then
        source ~/.zshrc.ext
    fi

# Disable AirPort interface (for PyCharm to be able to connect to IPv6-only hosts)
    [[ -n $PLATFORM_DARWIN ]] && disable_airdrop

# Check System Integrity Protection check.
    [[ -n $PLATFORM_DARWIN ]] && check_sip
