
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}|%b%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[green]%}|%b %{$fg[red]%}✗ "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}|%b "

PROMPT='%{$fg[blue]%}%3~ $(git_prompt_info)%{$reset_color%}'

export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
