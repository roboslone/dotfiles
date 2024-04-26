export FZF_DEFAULT_OPTS='
  --color=bg+:#232626
  --color=bg:-1
  --color=border:#80868a
  --color=fg+:-1
  --color=fg:-1
  --color=gutter:-1
  --color=header:#87afaf
  --color=hl+:#b6d68f
  --color=hl:#b6d68f
  --color=info:#80868a
  --color=label:#aeaeae
  --color=marker:#b6d68f
  --color=pointer:#d4caa7
  --color=preview-bg:-1
  --color=prompt:#d7005f
  --color=query:#9ea3d1
  --color=scrollbar:#d4caa7
  --color=separator:#80868a
  --color=spinner:#d4caa7
  --info="right"
  --layout="reverse"
  --marker="+"
  --pointer="🡢"
  --preview-window="border-sharp"
  --prompt=""
  --scrollbar="│"
  --separator="─"
  --border="sharp"
  --height="-1"
'

# https://youtu.be/mmqDYw9C30I?si=tafLCTeElwqNQFGH&t=750
_fzf_comprun() {
	local command=$1
	shift

	case "$command" in
		vim|subl|code|goland) 	fzf --preview="bat -n --color=always --line-range :64 {}" ;;
		*) 						fzf ;;
	esac
}

eval "$(fzf --zsh)"
