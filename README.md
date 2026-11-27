<p align="center">
  <img width="550" alt="Environment"
       src="https://user-images.githubusercontent.com/1766968/167233497-e930f876-4074-4509-92ea-bd0b85244606.png">
</p>

# Overview

[Dotfile Management](#dotfile-management)  
   * [GNU Stow](#gnu-stow)

[Using This Repository](#using-this-repository)  
   * [Environment-Specific Configuration](#environment-specific-configuration)   
   * [Configuring Stow](#configuring-stow)  

[Tools & Configuration](#tools--configuration)  
   * [Terminals](#terminals)  
   * [Shell](#shell)  
   * [Editor](#editor)  
   * [Themes](#themes)  
   * [Color Scheme](#color-scheme)


# Dotfile Management

The developer community offers several [dotfile managers] and [other great ideas] for how
to manage dotfiles. While I'm biased toward my strategy, having _any_ system will level
up your productivity when bootstrapping a new machine.

Assuming I have a package manager installed (either [Homebrew] or a well-supported native
option), the first tools I install are:

* GNU Stow
* Git (if necessary)

[Stow] answers the question of how to expose this configuration to various tools after
cloning this repository. Familiarity with package managers and Git is assumed, but both
have excellent documentation for anyone just getting started.

I chose Stow based on these requirements:

1. **The tool should be easy to bootstrap on popular Unix-like operating systems**  
   As a GNU tool, Stow is consistently available with package managers. It's also 
   easy to [install from source][stow-installation] if necessary (it's just a Perl
   module).

2. **The learning curve for the tool should be shallow**  
   Stow follows the Unix philosophy of doing one thing and doing it well, so it's
   easy to master.

3. **Configuration for the tool should be optional, not required**  
   My Stow configuration is limited to [ignore lists][stow-ignore-lists] and
   [resource files][stow-resource-files], both of which are optional.

4. **The tool should support managing dotfiles for multiple hosts and environments**  
   I'll talk about how Stow can support this under
   [Environment-Specific Configuration](#environment-specific-configuration).

[dotfile managers]: https://github.com/topics/dotfile-manager
[homebrew]: https://brew.sh/
[other great ideas]: https://news.ycombinator.com/item?id=11070797

[stow-ignore-lists]: https://www.gnu.org/software/stow/manual/html_node/Types-And-Syntax-Of-Ignore-Lists.html
[stow-installation]: https://github.com/aspiers/stow/blob/master/INSTALL.md
[stow-resource-files]: https://www.gnu.org/software/stow/manual/html_node/Resource-Files.html
[stow]: https://www.gnu.org/software/stow/


## GNU Stow

Stow was created to solve a problem unrelated to dotfile management:

> Stow addresses the need to administer, upgrade, install, and remove files in
> independent software packages without confusing them with other files sharing the same
> file system space.

More specifically, it lets you install Perl into a directory like
`/usr/local/stow/perl` and create symlinks that make it appear as if its files were
installed under these directories:

```
/usr/local
├── bin                  # Executable binaries
├── lib                  # Libraries
└── man                  # Man(ual) pages
```

This aligns to the [Filesystem Hierarchy Standard] and makes it easier for other tools
to find the Perl installation (e.g., `man perlrun`).

If you wanted to uninstall a tool that was automatically installed in these directories,
you'd traditionally need to remove each file manually, assuming you knew which files
needed to be removed. You might've had access to a `make` target that did this for you
if you were lucky. Stow, however, can remove its symbolic links and completely uninstall
Perl with a single command.

Today it is less common to install software this way, given the wide availability of
mature package managers. Dotfile management is primarily about managing symlinks, however,
and Stow handles this well.

[filesystem hierarchy standard]: https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04s09.html

### Usage

Let's say we wanted to share a Git [global ignore] file across multiple development hosts. 
We'd first create an ignore file in the following directory structure below our home directory. 
Stow refers to some of these directories by logical names:

```
/Users/Andrew            # The "target" directory
└── dotfiles             # The "stow" directory
    └── git              # A "package" directory
        └── .config
            └── git
                └── ignore
```

The physical names of the stow and package directories are flexible. However, the name of
the stow directory will typically match the name of your Git repository, and I choose to
organize package directories by the tools I'm configuring.

Next, we can use a single Stow command to expose this file to Git. The `git` argument for
this command refers to the package directory and the `-v` option allows us to see what
Stow is doing:

```shell
~/dotfiles $ stow -v git
LINK: .config/git => ../dotfiles/git/.config/git
```

You can see that Stow creates one symlink to mirror the contents of the `git` package
directory within our target directory (two levels higher). This is exactly where Git
expects to find the global ignore file:

```
/Users/Andrew            # The "target" directory
└── .config
    └── git -> ../dotfiles/git/.config/git
```

Stow is powerful enough to work with existing directories in the target directory (e.g.,
`.config`) and even manages symlinks that overlap with other package directories.
This concept is referred to as tree folding, which you can read about in the
[documentation][stow-tree-folding].

Stow can create symlinks in any target directory using the `-t` option, including
grandparent or sibling directories. This gives us the flexibility to locate our dotfiles
directory somewhere else in the file system, including directories within other stow
directories (more on this below).

[global ignore]: https://git-scm.com/docs/gitignore

[stow-tree-folding]: https://www.gnu.org/software/stow/manual/stow.html#Installing-Packages


# Using This Repository

This repository uses a few [Git submodules] and they need to be initialized after
cloning:

```shell
~/dotfiles $ git submodule update --recursive --init
```

I also use a Stow [resource file][stow-resource-files] to implicitly set my target directory
for `stow` commands, which makes it easier to work with nested stow directories. Before
running any other commands in this repository, I effectively set up Stow using Stow:

```shell
~/dotfiles/local/home/macos $ stow -vt /Users/Andrew stow
LINK: .stowrc => dotfiles/local/home/macos/stow/.stowrc
```

If you're forking this repository, `.stowrc` should be modified to refer to your target
directory.

[git submodules]: https://git-scm.com/book/en/v2/Git-Tools-Submodules


## Environment-Specific Configuration

The directory structure of this repository resembles the following:

```
.
├── tool-a               #
├── tool-b               # Multiple package directories
├── tool-c               #
│
├── local
│   ├── home
│   │   ├── macos        # A nested stow directory for macOS packages
│   │   │   ├── tool-a
│   │   │   ├── tool-b
│   │   │   └── stow
│   │   └── ubuntu       # A nested stow directory for Ubuntu packages
│   │       ├── tool-a
│   │       └── stow
│   └── work
│       └── centos       # A nested stow directory for CentOS packages
│           ├── tool-a
│           └── stow
│
└── etc                  # An ignored directory for location-agnostic configuration
```

By using nested stow directories, I'm able to layer configurations based on my current
environment or host. I prefer to use separate directories for my personal work and my day
job, but any system can be used here.

Using Git as an example again, I maintain a global `.gitconfig` file that I use in all of
my environments and a host-specific file that my `.gitconfig` includes via the
[include.path][git-include-path] directive. I've named the latter `gitconfig.inc`.

Git expects this global file to be located in the home directory, so I've added it to the
Git package with the global ignore file that I introduced above:

```
.                        # The top-level stow directory
└── git                  # The package directory for git
    ├── .config
    │   └── git
    │       └── ignore   # The global ignore file I introduced earlier
    └── .gitconfig
```

The following command creates the appropriate link to my `.gitconfig`, in addition to
creating a link to the directory containing the global ignore file:

```shell
~/dotfiles $ stow -v git
LINK: .gitconfig => dotfiles/git/.gitconfig
LINK: .config/git => ../dotfiles/git/.config/git
```

Next, `gitconfig.inc` is located in a package under `local/home/macos`, and I've chosen
to symlink it in `.config/git` with Git's other configuration:

```
local/home/macos         # The nested stow directory
└── git                  # A macOS-specific package directory for git
    └── .config
        └── git
            └── gitconfig.inc
```

To create the appropriate link to this file, I `cd` to the nested stow directory and repeat the
`stow` command above. Remember that a Stow resource file implicitly sets the target
directory to my home directory:

```shell
~/dotfiles/local/home/macos $ stow -v git
UNLINK: .config/git
MKDIR: .config/git
LINK: .config/git/ignore => ../../dotfiles/git/.config/git/ignore
LINK: .config/git/gitconfig.inc => ../../dotfiles/local/home/macos/git/.config/git/gitconfig.inc
```

The resulting directory tree will look like this:

```
/Users/Andrew            # The "target" directory
└── .config
    └── git
        ├── ignore -> ../../dotfiles/git/.config/git/ignore
        └── gitconfig.inc -> ../../dotfiles/local/home/macos/git/.config/git/gitconfig.inc
```

You might notice that Stow replaces the `.config/git` symlink created in the first step
with a directory, and then symlinks the individual files from both the top-level
package and the nested package. This is automatic when Stow recognizes the original
symlink, which is made possible by including an empty `.stow` file in each stow directory
(see [Configuring Stow](#configuring-stow) below).

[git-include-path]: https://git-scm.com/docs/git-config#_includes

### Alternative Layout

Local configuration can also be organized under a single package:

```
local/home               # The nested stow directory
└── macos                # A package directory for all configuration used on macOS
    └── .config
        ├── git
        └── zsh
```

This reduces the installation of local configuration to a single command:

```shell
~/dotfiles/local/home $ stow -v macos
```

It's also possible to write a script that simplifies the process of stowing local
packages. I set up new environments so infrequently, however, that I don't mind running
`stow` for a small number of local packages.

### Encryption

Stow doesn't address the need to maintain private keys or other secrets. One option
is to encrypt them manually with PGP, commit them, and then decrypt them when setting up
a new host. However, this assumes that the PGP keys are manually copied to each host.

Stow's lack of support for encryption is a trade-off between simplicity and comprehensive
functionality (see my [requirements](#dotfile-management) at the start of this README).


## Configuring Stow

The following Stow-specific files are used in this repository:

* `./<package>/.stow-local-ignore`

  This [ignore list][stow-ignore-lists] is required when a package directory contains
  files that shouldn't be symlinked. It uses the Perl regular expression syntax.

* `./stow/.stow-global-ignore`

  This [ignore list][stow-ignore-lists] overrides Stow's built-in default ignore list for
  every package that doesn't define its own `.stow-local-ignore`. Stow it into the target
  directory alongside `.stowrc`.

* `./local/<stow-directory>/stow/.stowrc`

  This [resource file][stow-resource-files] makes it possible to define default
  command-line options (e.g., the target directory).

* `.stow`, `./local/<stow-directory>/.stow`

  These empty files help Stow work with [multiple stow directories][stow-multiple-directories].

[stow-multiple-directories]: https://www.gnu.org/software/stow/manual/html_node/Multiple-Stow-Directories.html


# Tools & Configuration


## Terminals

I use a few different emulators and multiplexers:

* [.config/alacritty/alacritty.yml]
* [.config/rex/init.lua]
* [.tmux.conf]
* [com.googlecode.iterm2.plist]

[.config/alacritty/alacritty.yml]: alacritty/.config/alacritty/alacritty.yml
[.config/rex/init.lua]: rex/.config/rex/init.lua
[.tmux.conf]: tmux/.tmux.conf
[com.googlecode.iterm2.plist]: etc/iterm2/com.googlecode.iterm2.plist


## Shell

My ZSH configuration is split between global and environment-specific scripts. Global
scripts run on every one of my machines. [Environment-specific
scripts](#environment-specific-configuration) are located under
each `local/<env>/<os>/zsh` directory.

| Usage                                             | Global Script | Local Script               |
| ------------------------------------------------- | ------------- | -------------------------- |
| Environment variables for all shells              | Not used      | [.zshenv]                  |
| Configuration for login shells (includes `$path`) | [.zprofile]   | [.config/zsh/zprofile.inc] |
| Configuration for interactive shells              | [.zshrc]      | [.config/zsh/zshrc.inc]    |
| Prezto configuration                              | [.zpreztorc]  | Not used                   |

See the Prezto [documentation][prezto-runcoms] and [chapter 2][zsh-startup-files] of the
Zsh guide for an explanation of these files.

[.config/zsh/zprofile.inc]: local/home/macos/zsh/.config/zsh/zprofile.inc
[.config/zsh/zshrc.inc]: local/home/macos/zsh/.config/zsh/zshrc.inc
[.zpreztorc]: zsh/.zpreztorc
[.zprofile]: zsh/.zprofile
[.zshenv]: local/home/macos/zsh/.zshenv
[.zshrc]: zsh/.zshrc

[prezto-runcoms]: https://github.com/adgoudz/prezto/blob/master/runcoms/README.md
[zsh-startup-files]: https://zsh.sourceforge.io/Guide/zshguide02.html


## Editor

My [Neovim][neovim] configuration is [backwards-compatible][nvim-from-vim] with Vim. My
configuration will also apply Neovim's defaults in Vim so that the editing behavior is
identical between the two.

* [.vimrc]
* [.config/nvim/init.vim]

If you're viewing `.vimrc` in Neovim, use `zo` and `zc` in normal mode to open and close
[folds][nvim-folds].

[.config/nvim/init.vim]: nvim/.config/nvim/init.vim
[neovim]: https://github.com/neovim/neovim
[nvim-folds]: https://neovim.io/doc/user/fold.html
[nvim-from-vim]: https://neovim.io/doc/user/nvim.html#nvim-from-vim


## Themes

My [powerlevel10k-like][powerlevel10k] theme is actually a combination of themes for
different tools:

| Tool          | Theming System | Configuration            |
| ------------- | -------------- | ------------------------ |
| **Neovim**    | [vim-airline]  | [.vimrc]                 |
| **Zsh**       | [starship]     | [.config/starship.toml]  |
| **tmux**      |                | [.tmux.conf]             |

[.config/starship.toml]: zsh/.config/starship.toml
[.vimrc]: vim/.vimrc
[powerlevel10k]: https://github.com/romkatv/powerlevel10k
[starship]: https://starship.rs/
[vim-airline]: https://github.com/vim-airline/vim-airline


## Color Scheme

<p align="center">
  <img width="400" alt="prompt-shadow"
       src="https://user-images.githubusercontent.com/1766968/168866981-feace42c-5634-4b88-a9e2-43519f7a7f85.png">
</p>

I use a custom 16-color scheme named Astra. It's modeled on [Base16], and inspired by
[Solarized] and [Tomorrow Night]. The scheme is configured in each of the following locations:

| Tool            | Configuration                                   |
| --------------- | ----------------------------------------------- |
| **Alacritty**   | [.config/alacritty/alacritty.yml]               |
| **Neovim**      | [.vim/colors/base16-astra.vim]                  |
| **Rex**         | [.config/rex/themes/astra]                      |
| **vim-airline** | [.vim/autoload/airline/themes/base16_astra.vim] |

[.config/rex/themes/astra]: rex/.config/rex/themes/astra
[.vim/autoload/airline/themes/base16_astra.vim]: vim/.vim/autoload/airline/themes/base16_astra.vim
[.vim/colors/base16-astra.vim]: vim/.vim/colors/base16-astra.vim

[base16]: https://github.com/chriskempson/base16
[solarized]: https://github.com/altercation/solarized
[tomorrow night]: https://base16.netlify.app/previews/base16-tomorrow-night.html

