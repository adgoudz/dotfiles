
SANDBOX=$HOME/Sandbox
DOTFILES=$SANDBOX/dotfiles

BREW_PREFIX=/usr/local

# Ensure that a non-login, non-interactive shell has a defined environment

if [[ ( $SHLVL -eq 1 && ! -o LOGIN ) && -s ${ZDOTDIR:-$HOME}/.zprofile ]]; then
  source ${ZDOTDIR:-$HOME}/.zprofile
fi
