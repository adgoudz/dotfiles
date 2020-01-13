
fzf_executable=$(command -v fzf)
fzf_dirname=$(cd $(dirname $fzf_executable)/$(dirname $(readlink $fzf_executable)) && pwd -P)

# Auto-completion
source $fzf_dirname/../shell/completion.bash 2> /dev/null

# Key bindings
source $fzf_dirname/../shell/key-bindings.bash
