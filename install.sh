#!/bin/bash

DOTFILES=Sandbox/dotfiles

ln -sf $DOTFILES/bashrc ~/.bashrc
ln -sf $DOTFILES/vimrc ~/.vimrc
ln -sf $DOTFILES/gitignore ~/.gitignore
ln -sf $DOTFILES/zshrc ~/.zshrc
ln -sf $DOTFILES/tmux.conf ~/.tmux.conf

ln -sf $DOTFILES/local/gitconfig ~/.gitconfig
ln -sf $DOTFILES/local/zshrc.env ~/.zshrc.env
ln -sf $DOTFILES/local/zshrc.aliases ~/.zshrc.aliases
ln -sf $DOTFILES/local/zshrc.functions ~/.zshrc.functions

mkdir ~/.ssh &> /dev/null
ln -sf ~/$DOTFILES/ssh_config ~/.ssh/config

ln -Fsf $DOTFILES/atom ~/.atom

# Install oh-my-zsh

if [[ ! -e ~/.oh-my-zsh ]]; then
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

# Configure pip

PIP_HOME=~/Library/Application\ Support/pip

mkdir "$PIP_HOME" &> /dev/null
ln -sf ~/$DOTFILES/pip.conf "$PIP_HOME"/

# Install powerline

PYTHON3_USER_BASE=$(/usr/local/bin/python3 -m site --user-base)

mkdir -p $PYTHON3_USER_BASE
cd $PYTHON3_USER_BASE  # This is where pip will install editable eggs
pip3 install --user --editable 'git+https://github.com/adgoudz/powerline@adgoudz#egg=powerline-status'

mkdir ~/.config &> /dev/null
ln -Fsf ~/$DOTFILES/powerline ~/.config/powerline

ln -sf ../src/powerline-status/scripts/powerline $PYTHON3_USER_BASE/bin/

