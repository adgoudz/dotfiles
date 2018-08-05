
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}%b %{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗ "
ZSH_THEME_GIT_PROMPT_CLEAN="%b "

ZSH_THEME_VIRTUALENV_PREFIX="%{$fg_bold[cyan]%}ⓔ%b %{$fg_bold[magenta]%}"
ZSH_THEME_VIRTUALENV_SUFFIX="%b "

PROMPT='%{$fg[blue]%}%3~ $(virtualenv_prompt_info)$(git_prompt_info)%{$reset_color%}'

export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
