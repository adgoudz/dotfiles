
#-------------
# Development
#-------------

export PYTHON=/usr/local/bin/python2
export PYTHON_USER_BASE=$($PYTHON -m site --user-base)

export PYTHON3=/usr/local/bin/python3
export PYTHON3_USER_BASE=$($PYTHON3 -m site --user-base)

export PYTHONDONTWRITEBYTECODE=1

export VIRTUALENVS_ROOT=$HOME/.local/share/virtualenvs
export PIPSI_HOME=$VIRTUALENVS_ROOT
export WORKON_HOME=$VIRTUALENVS_ROOT

export PYENV_ROOT=$HOME/.local/pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

export NODE_ENV=development

#------
# Path
#------

# Front of path (added in reverse)
pathmunge $BIN

# Back of path (added in order)
pathmunge /usr/local/bin after
pathmunge /usr/bin after
pathmunge /bin after
pathmunge /usr/sbin after
pathmunge /sbin after

