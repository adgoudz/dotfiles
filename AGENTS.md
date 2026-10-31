# AGENTS.md

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). There is
no build or test suite: "deploying" means creating symlinks from `$HOME` into this repo.
See [README.md](README.md) for background and rationale.

## Layout

```
<tool>/                  # Top-level packages, shared across all hosts (git, zsh, tmux, vim, nvim, ...)
local/home/macos/        # Nested stow dir: personal macOS host
local/work/macos/        # Nested stow dir: work macOS host
  <tool>/                #   Host-specific packages
  stow/.stowrc           #   Sets the stow target (-t) to $HOME for that host
etc/                     # Location-agnostic config, not stowed (e.g., iTerm2 plist)
stow/.stow-global-ignore # Overrides Stow's default ignore list
```

A package mirrors `$HOME`: `git/.config/git/ignore` is linked as `~/.config/git/ignore`.

## Commands

```shell
git submodule update --recursive --init    # After cloning (zsh/.zprezto, tmux tpm)

# Run from the stow dir that owns the package (repo root or local/<env>/<os>)
stow -nv <package>     # Dry run — always do this first
stow -v <package>      # Link a package
stow -Rv <package>     # Restow after adding/removing files in a package
stow -Dv <package>     # Unlink a package
```

The target comes from `~/.stowrc` (itself stowed from `local/<env>/<os>/stow`). From the
repo root without it, pass `-t ~` explicitly.

## Where changes go

- **Shared config** goes in the top-level package (e.g., `zsh/.zshrc`, `git/.gitconfig`).
- **Host-specific config** goes in `local/<env>/<os>/<tool>/`, usually as an `*.inc` file
  that the shared config includes if present (`~/.config/zsh/zshrc.inc`,
  `~/.config/zsh/zprofile.inc`, `~/.config/git/gitconfig.inc`).
- Files in `$HOME` are symlinks into this repo, so edit the repo copy. A new file needs a
  restow unless its parent directory is already a folded symlink.

## Gotchas

- **Never commit secrets.** SSH keys, tokens, and `.npmrc` credentials stay untracked or
  are committed only as PGP-encrypted `*.gpg` files.
- Keep the empty `.stow` marker files at the repo root and in each `local/<env>/<os>/`.
  Stow needs them to unfold directories shared between top-level and nested packages.
- `.stow-local-ignore` uses Perl regexes and **replaces** Stow's defaults. Add one when a
  package holds files that shouldn't be linked (see `zsh/.stow-local-ignore`).
- `.vimrc` must stay Vim-compatible; Neovim's `init.vim` sources it. It uses folds.
- The Zsh prompt theme lives in the `zsh/.zprezto` submodule (fork: `adgoudz/prezto`), not
  in this repo. Commit changes there first, then bump the submodule.
- The "Astra" color scheme is duplicated across `alacritty/.config/alacritty/alacritty.yml`,
  `vim/.vim/colors/base16-astra.vim`, and
  `vim/.vim/autoload/airline/themes/base16_astra.vim`. Keep them in sync.

## Commits

Scope commits and prefix messages with individual Stow packages: `zsh: Add fzf bindings`,
`claude: Update settings.json`.
