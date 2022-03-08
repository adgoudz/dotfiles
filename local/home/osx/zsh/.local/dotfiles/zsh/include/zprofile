
# Development configuration

export PIPSI_HOME=$VIRTUALENVS_ROOT

if command -v pyenv &>/dev/null; then
    export PYENV_ROOT=$HOME/.local/pyenv
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1

    if command -v pyenv-virtualenv-init &>/dev/null; then
        PYENV_VIRTUALENV_INSTALLED=1
    fi
fi

export NODE_ENV=development

# Development path (added in reverse)

path=($BREW_PREFIX/opt/ruby/bin $path)
path=($BREW_PREFIX/lib/ruby/gems/3.1.0/bin $path)
path=($HOME/.local/share/gem/ruby/3.1.0/bin $path)
path=($HOME/.local/bin $path)

# vim: ft=zsh

