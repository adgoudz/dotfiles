
# Directory shortcuts

alias sandbox='cd $SANDBOX'
alias dotfiles='cd $DOTFILES'

alias bin='cd $SANDBOX/bin'
alias installs='cd $SANDBOX/installs'
alias repos='cd $SANDBOX/repos'
alias sessions='cd $SANDBOX/share/sessions'
alias src='cd $SANDBOX/src'

alias userbase='cd $PYTHON_USER_BASE'
alias userbase3='cd $PYTHON3_USER_BASE'
alias venvs='cd $VIRTUALENVS_ROOT'

# Command defaults

alias pwd='pwd -P'
alias cwd='cd $(pwd -P)'

alias vim='nvim'

# Command shortcuts

alias lla='ls -lAh'
alias llt='ls -lhtr'
alias lld='find . -maxdepth 1 -type d ! -name \.\* -print0 | xargs -0 ls -ld'
alias ll.='ls -lhd .*'

alias fgrep='find . ! -path "./_*" ! -path "./.git*" ! -type l ! -type d -print0 | xargs -0 grep --color=auto'
alias egrep='printenv | grep'
alias agrep='alias | grep'

function g_() {
    alias | grep "git $1"
}

alias gla='git log --topo-order --graph -20 --pretty=format:"${_git_log_oneline_format}"'
alias glcl='git log --graph --cherry-mark --no-merges --left-only'
alias glcr='git log --graph --cherry-mark --no-merges --right-only'
alias gcol="git checkout '@{-1}'"

# Miscellaneous shortcuts

alias path='echo -e ${PATH//:/\\n}'

alias zshrc='source ~/.zshrc'

