
BASE=$(cd $(dirname ${BASH_SOURCE-$0}) && pwd -P)/../../..

#-------------
# Directories
#-------------

# These are sourced before anything else because they
# are referenced in the shared rc file.

export SANDBOX=$HOME/Sandbox
export BIN=$SANDBOX/bin
export DOTFILES=$SANDBOX/dotfiles
export INSTALLS=$SANDBOX/installs
export REPOS=$SANDBOX/repos

#--------
# Shared
#--------

source $BASE/host/shared/zsh.d/default.sh

#---------------
# Configuration
#---------------

export CLICOLOR=1

#-------------
# Development
#-------------

# pyenv virtualenv might not be installed under $PYENV_ROOT
export PYENV_VIRTUALENV_INSTALL_PREFIX=$( \
    export VIRTUALENV_INIT_DIRNAME=$(dirname $(which pyenv-virtualenv-init)); \
    export VIRTUALENV_INIT_LINK=$(readlink $(which pyenv-virtualenv-init)); \
    cd $(dirname "$VIRTUALENV_INIT_DIRNAME/$(dirname $VIRTUALENV_INIT_LINK)") \
        && pwd -P \
)

#------
# Path
#------

# Front of path (added in reverse)
pathmunge $PYTHON_USER_BASE/bin   # pip2 installs here
pathmunge $PYTHON3_USER_BASE/bin  # pip3 installs here
pathmunge $HOME/.local/bin  # pipsi installs here
pathmunge $PYENV_ROOT/bin  # pyenv

eval "$(/usr/local/bin/pyenv init -)"
eval "$(/usr/local/bin/pyenv virtualenv-init -)"
pathmunge $PYENV_ROOT/shims
pathmunge $PYENV_VIRTUALENV_INSTALL_PREFIX/shims


