
# Development configuration

export NODE_ENV=development

# Development path (added in reverse)

path=($BREW_PREFIX/opt/ruby/bin $path)
path=($BREW_PREFIX/lib/ruby/gems/3.1.0/bin $path)
path=($HOME/.local/share/gem/ruby/3.1.0/bin $path)
path=($HOME/.local/bin $path)

# vim: ft=zsh

