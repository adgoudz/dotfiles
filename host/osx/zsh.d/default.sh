
BASE=$(cd $(dirname ${BASH_SOURCE-$0}) && pwd -P)/../../..

#-----------
# Shortcuts
#-----------

export SANDBOX=$HOME/Sandbox
export BIN=$SANDBOX/bin
export DOTFILES=$SANDBOX/dotfiles
export INSTALLS=$SANDBOX/installs
export REPOS=$SANDBOX/repos

export PYTHON=/usr/local/bin/python

#---------------
# Configuration
#---------------

export CLICOLOR=1

#--------
# Shared
#--------

source $BASE/host/shared/zsh.d/default.sh


