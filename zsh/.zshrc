
setopt shwordsplit
setopt extendedglob
setopt nullglob
setopt histfindnodups
setopt histignorealldups
setopt appendhistory
setopt sharehistory
setopt autocd
setopt autopushd
setopt pushdignoredups

unsetopt caseglob

# Initialize the completion system

autoload -U compinit
compinit

# Set a safe umask

umask 022

# Autoload custom functions

if [[ $fpath != *$DOTFILES/zsh/functions* ]]; then
    fpath=($DOTFILES/zsh/functions $fpath)
fi

autoload -U ${fpath[1]}/*(:t)

# Command configuration

export MANPATH=$BREW_PREFIX/share/man:
export INFOPATH=$BREW_PREFIX/share/info:

# Shell configuration

export CLICOLOR=1

# Agent configuration

export GPG_TTY=$(tty)

# Source shared configuration

if [[ -e "${ZDOTDIR:-$HOME}/.zinclude" ]]; then
    include "${ZDOTDIR:-$HOME}/.zinclude/zshrc"
fi

include "include/aliases.zsh"
include "include/bindings.zsh"

