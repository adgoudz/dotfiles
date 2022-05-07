
# Development path

if [[ -n $PYENV_ROOT && -z $PYENV_SHELL ]]; then
    # PYENV_SHELL is set by the command below
    eval "$($BREW_PREFIX/bin/pyenv init -)"

    if [[ -n $PYENV_VIRTUALENV_INSTALLED ]]; then
        eval "$($BREW_PREFIX/bin/pyenv virtualenv-init -)"
    fi
fi

# vim: ft=zsh

