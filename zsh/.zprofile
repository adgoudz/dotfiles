
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

export SHELL=${SHELL:-$(whence zsh)}

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
export EDITOR=vim
export PAGER=less
export LESS=FRI

if [[ -z $LANG ]]; then
  export LANG=en_US.UTF-8
fi

# Development configuration

export BREW_PREFIX

export VIRTUALENVS_ROOT=$HOME/.local/share/virtualenvs
export WORKON_HOME=$VIRTUALENVS_ROOT

export PYTHON=$BREW_PREFIX/bin/python2
export PYTHON_USER_BASE=$($PYTHON -m site --user-base)

export PYTHON3=$BREW_PREFIX/bin/python3
export PYTHON3_USER_BASE=$($PYTHON3 -m site --user-base)

export PYTHONDONTWRITEBYTECODE=1

# Development path

path=($PYTHON_USER_BASE/bin $path)   # pip2
path=($PYTHON3_USER_BASE/bin $path)  # pip3

# Source local configuration

if [[ -e "${ZDOTDIR:-$HOME}/.zinclude" ]]; then
    include "${ZDOTDIR:-$HOME}/.zinclude/zprofile"
fi

