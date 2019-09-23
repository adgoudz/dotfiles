
# Directory shortcuts

alias sandbox='cd $SANDBOX'
alias dotfiles='cd $DOTFILES'

alias bin='cd $SANDBOX/bin'
alias installs='cd $SANDBOX/installs'
alias repos='cd $SANDBOX/repos'

alias userbase='cd $PYTHON_USER_BASE'
alias userbase3='cd $PYTHON3_USER_BASE'
alias venvs='cd $VIRTUALENVS_ROOT'

# Command defaults

alias pwd='pwd -P'
alias cwd='cd $(pwd -P)'

# Command shortcuts

alias lla='ls -lAh'
alias llt='ls -lhtr'
alias lld='find . -maxdepth 1 -type d ! -name \.\* -print0 | xargs -0 ls -ld'
alias ll.='ls -lhd .*'

alias fgrep='find . ! -path "./_*" ! -path "./.git*" ! -type l ! -type d -print0 | xargs -0 grep --color=auto'
alias egrep='printenv | grep'
alias agrep='alias | grep'

alias gdc='gdca'  # oh-my-zsh
alias gla='git log --graph'
alias glcl='git log --graph --cherry-mark --no-merges --left-only'
alias glcr='git log --graph --cherry-mark --no-merges --right-only'
alias gcd='git checkout develop'  # git flow
alias gcol="git checkout '@{-1}'"
alias gbv='git branch --verbose'
alias gcpm='git cherry-pick master'
alias gsfe='git submodule foreach'

# Miscellaneous shortcuts

alias path='echo -e ${PATH//:/\\n}'

alias zshrc='source ~/.zshrc'

