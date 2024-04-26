export FZF_DEFAULT_OPTS='--pointer="🡢" -i --multi --prompt="" --color="fg:-1,bg:-1,hl:-1,fg+:-1,bg+:-1,info:-1,prompt:-1,pointer:-1,marker:32,spinner:-1,header:-1"'

# https://youtu.be/mmqDYw9C30I?si=tafLCTeElwqNQFGH&t=750
_fzf_comprun() {
	local command=$1
	shift

	case "$command" in
		vim|subl|code|goland) 	fzf --preview="bat -n --color=always --line-range :200 {}" ;;
		*) 						fzf ;;
	esac
}

eval "$(fzf --zsh)"