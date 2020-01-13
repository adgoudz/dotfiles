
fzf_executable=$(whence -p fzf)
fzf_dirname="$fzf_executable:P:h"

# Auto-completion
source $fzf_dirname/../shell/completion.zsh 2> /dev/null

# Key bindings
source $fzf_dirname/../shell/key-bindings.zsh
