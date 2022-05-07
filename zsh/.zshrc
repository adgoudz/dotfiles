
setopt shwordsplit
setopt extendedglob
setopt nullglob
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

# Shell configuration

export CLICOLOR=1

# Command configuration

export MANPATH=$BREW_PREFIX/share/man:
export INFOPATH=$BREW_PREFIX/share/info:

# Agent configuration

export GPG_TTY=$(tty)

# Source local configuration

if [[ -e "$HOME/.config/zsh/zshrc.inc" ]]; then
    include "$HOME/.config/zsh/zshrc.inc"
fi

# Source shared configuration

include "include/aliases.zsh"
include "include/bindings.zsh"

# Initialize plugins

if [[ -e "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
    include "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

if [[ -o interactive ]]; then
    if [[ -e "${ZDOTDIR:-$HOME}/.config/fzf/fzf.zsh" ]]; then
        include "${ZDOTDIR:-$HOME}/.config/fzf/fzf.zsh"
    fi

    if [[ -e "$BREW_PREFIX/etc/profile.d/z.sh" ]]; then
        include "$BREW_PREFIX/etc/profile.d/z.sh"
    fi
fi

