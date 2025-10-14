export FZF_DEFAULT_OPTS='
  --color=bg+:#090909
  --color=bg:-1
  --color=border:#202020
  --color=fg+:#E5E9E9
  --color=fg:#909090
  --color=gutter:-1
  --color=header:#87afaf
  --color=hl+:#AAD94C
  --color=hl:#AAD94C
  --color=info:#909090
  --color=label:#909090
  --color=marker:#AAD94C
  --color=pointer:#D0C2A2
  --color=preview-bg:-1
  --color=prompt:#d7005f
  --color=query:#D0C2A2
  --color=scrollbar:#D0C2A2
  --color=separator:#202020
  --color=spinner:#D0C2A2
  --gutter=" "
  --info="right"
  --layout="reverse"
  --marker="+"
  --pointer=" "
  --preview-window="border-sharp"
  --prompt=""
  --scrollbar="│"
  --separator="─"
  --border="sharp"
  --height="-1"
'

eval "$(fzf --zsh)"
