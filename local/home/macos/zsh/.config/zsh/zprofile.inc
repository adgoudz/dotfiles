
# Development configuration

export NODE_ENV=development

# Development path (added in reverse)

path=("$HOME/Library/Application Support/Coursier/bin" "$path[@]")

path=($HOME/.local/bin "$path[@]")
path=($HOME/.asdf/shims "$path[@]")

# vim: ft=zsh

