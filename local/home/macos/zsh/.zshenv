
export SANDBOX=$HOME/Sandbox

DOTFILES=$SANDBOX/dotfiles

export BREW_PREFIX=/opt/homebrew

# Make our preferred shell known to other processes
export SHELL=$BREW_PREFIX/bin/zsh

# Ensure that a non-login, non-interactive shell has a defined environment
if [[ ( $SHLVL -eq 1 && ! -o LOGIN ) && -s ${ZDOTDIR:-$HOME}/.zprofile ]]; then
  source ${ZDOTDIR:-$HOME}/.zprofile
fi

