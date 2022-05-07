
# Make sure these arrays ignore duplicates

typeset -gU path fpath cdpath

# Autoload custom functions

if [[ $fpath != *$DOTFILES/zsh/functions* ]]; then
    fpath=($DOTFILES/zsh/functions $fpath)
fi

autoload -U ${fpath[1]}/*(:t)

# Initial path (added in reverse)

path=(/bin $path)
path=(/sbin $path)
path=(/usr/bin $path)
path=(/usr/sbin $path)
path=($BREW_PREFIX/bin $path)
path=($BREW_PREFIX/sbin $path)
path=($SANDBOX/bin $path)

# $SHELL might not be set if zsh isn't our default
# login shell. Make sure it's set before anything
# tries to look for it.

export SHELL=$(whence zsh)

# Provide modern term capabilities if we can

if [[ -e $BREW_PREFIX/share/terminfo ]]; then
    export TERMINFO=$BREW_PREFIX/share/terminfo
fi

if [[ -z $TERM || $TERM != *256color ]]; then
    if [[ -e ${TERMINFO:-/usr/share/terminfo}/**/${TERM}-256color(#q[0]) ]]; then
        export TERM=${TERM}-256color
    fi
fi

# Command configuration

export EDITOR=vim
export PAGER=less
export LESS=FRIX

if [[ -z $LANG ]]; then
  export LANG=en_US.UTF-8
fi

# Development configuration

export HOMEBREW_NO_AUTO_UPDATE=1

export FZF_DEFAULT_COMMAND="find . -name '.*' -o -name '*'"
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --cycle
  -1
  --color=fg:8,fg+:7,hl:5,hl+:5,bg+:10
  --color=prompt:4,spinner:14,info:7,pointer:4,marker:1
'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/.ripgreprc

export VIRTUALENVS_ROOT=$HOME/.local/share/virtualenvs
export WORKON_HOME=$VIRTUALENVS_ROOT

export PYTHON3=$BREW_PREFIX/bin/python3
export PYTHON3_USER_BASE=$($PYTHON3 -m site --user-base)

export PYTHONDONTWRITEBYTECODE=1

# Development path

path=($PYTHON3_USER_BASE/bin $path)  # pip3

# Source local configuration

if [[ -e "$HOME/.config/zsh/zprofile.inc" ]]; then
    include "$HOME/.config/zsh/zprofile.inc"
fi

