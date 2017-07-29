
BASE=$(cd $(dirname ${BASH_SOURCE-$0}) && pwd -P)/../../..

#-----------
# Shortcuts
#-----------

export SANDBOX=$HOME/Sandbox
export BIN=$SANDBOX/bin
export DOTFILES=$SANDBOX/dotfiles
export INSTALLS=$SANDBOX/installs
export REPOS=$SANDBOX/repos

#---------------
# Configuration
#---------------

export CLICOLOR=1

#-------------
# Development
#-------------

export PYTHON=/usr/local/bin/python
export PYTHON3=/usr/local/bin/python3

export PYTHON_USER_BASE=$($PYTHON -m site --user-base)
export PYTHON3_USER_BASE=$($PYTHON3 -m site --user-base)

export PYENV_ROOT=$HOME/.local/pyenv
export WORKON_HOME=$HOME/.local/venvs

#------
# Path
#------

eval "$(/usr/local/bin/pyenv init -)" 

# Front of path (in reverse)
pathmunge $PYTHON_USER_BASE/bin
pathmunge $PYTHON3_USER_BASE/bin
pathmunge $PYENV_ROOT/shims
pathmunge $HOME/.local/bin

#--------
# Shared
#--------

source $BASE/host/shared/zsh.d/default.sh
