<p align="center">
  <img width="550" alt="Environment"
       src="https://user-images.githubusercontent.com/1766968/167233497-e930f876-4074-4509-92ea-bd0b85244606.png">
</p>

# Overview

This repository exists for personal reasons, but occasionally I'm asked how I configure
my development environment. I use this configuration to provide feature parity on
multiple Unix-like operating systems and quickly set up environments on new hosts.
Colloquially this is known as dotfile management.

This README covers how I manage these dotfiles and how they configure my environment:

[Dotfile Management](#dotfile-management)  
   * [GNU Stow](#gnu-stow)

[Using this Repository](#using-this-repository)  
   * [Environment-Specific Configuration](#environment-specific-configuration)   
   * [Configuring Stow](#configuring-stow)  

[Tools & Configuration](#tools--configuration)  
   * [Terminal](#terminal)  
   * [Shell](#shell)  
   * [Editor](#editor)  
   * [Themes](#themes)  
   * [Color Scheme](#color-scheme)  
   * [Other Tools](#other-tools)


# Dotfile Management

The open-source community offers no fewer than 50 [dotfile managers], and many of them
are worth checking out. [This Hacker News post] also has some great ideas. While I'm
biased toward the strategy described below, you should ultimately aim to maximize your
net productivity. [xkcd #1205] outlines my favorite approach to measuring this.

Assuming I have a package manager installed (either [Homebrew] or a well-supported native
option), the first tools I install are:

* GNU Stow
* Git (if necessary)

[Stow] answers the question of how to expose this configuration to various tools after
cloning this repository. Familiarity with package managers and Git is assumed, but both
have excellent documentation for anyone just getting started.

I chose Stow based on the following requirements:

1. **The tool should be easy to bootstrap on popular Unix-like operating systems**  
   As a GNU tool, Stow is consistently available with package managers. In the worst
   case, it's easy to [install it from source][stow-installation] (it's just a Perl
   module).

2. **The learning curve for the tool should be shallow**  
   Stow follows the Unix philosophy of doing one thing and doing it well, which makes it
   easy to master.

3. **Configuration for the tool should be optional, not required**  
   My Stow configuration is limited to [ignore lists][stow-ignore-lists] and
   [resource files][stow-resource-files], both of which are optional.

4. **The tool should support managing dotfiles for multiple hosts and environments**  
   I'll describe how Stow can support this under
   [Environment-Specific Configuration](#environment-specific-configuration).

[this hacker news post]: https://news.ycombinator.com/item?id=11070797
[dotfile managers]: https://github.com/topics/dotfile-manager
[xkcd #1205]: https://xkcd.com/1205/
[homebrew]: https://brew.sh/

[stow]: https://www.gnu.org/software/stow/
[stow-installation]: https://github.com/aspiers/stow/blob/master/INSTALL.md
[stow-ignore-lists]: https://www.gnu.org/software/stow/manual/html_node/Types-And-Syntax-Of-Ignore-Lists.html
[stow-resource-files]: https://www.gnu.org/software/stow/manual/html_node/Resource-Files.html


## GNU Stow

Stow was created to solve a problem unrelated to dotfile management:

> Stow addresses the need to administer, upgrade, install, and remove files in
> independent software packages without confusing them with other files sharing the same
> file system space.

More specifically, Stow allows you to install Perl into a directory like
`/usr/local/stow/perl`, and create symlinks to make it appear as if its files were
installed under these directories:

```
/usr/local
├── bin                  # Executable binaries
├── lib                  # Libraries
└── man                  # Man(ual) pages
```

This aligns to the [Filesystem Hierarchy Standard] and makes it easier for other tools
to find this new Perl installation (e.g., `man perlrun`).

If you wanted to uninstall a tool that was automatically installed in these directories,
you'd traditionally need to remove each file manually, assuming you knew which files
needed to be removed. If you were lucky, you might've had access to a `make` target that
did this for you. Stow, however, can remove its symbolic links and effectively uninstall
Perl wit a single command.

Today it is far less common to install software this way, given the wide availability of
mature package managers. However, dotfile management is primarily about managing
symlinks, and Stow handles this well.

[filesystem hierarchy standard]: https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch04s09.html

### Usage

As for how it works, let's say we wanted to share a Git [global ignore] file across
multiple development hosts. We'd first create an ignore file in the following directory
structure below our home directory. Stow refers to some of these directories by logical
names:

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

In other words, Stow creates one symlink to mirror the contents of the `git` package
directory within our target directory (two levels higher). This is exactly where Git
expects to find the global ignore file:

```
/Users/Andrew            # The "target" directory
└── .config
    └── git -> ../../dotfiles/git/.config/git
```

Stow is powerful enough to work with existing directories in the target directory (e.g.,
`.config`) and it even manages symlinks that overlap with other package directories.
This concept is referred to as tree folding, which is explained further in the
[documentation][stow-tree-folding].

Stow can create symlinks in any target directory by using the `-t` option, including
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
for `stow` commands and make it easier to work with nested stow directories. Before
running any other commands in this repository, I effectively set up Stow using Stow:

```shell
/Users/Andrew/dotfiles/local/home/macos $ stow -vt /Users/Andrew stow
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
│   │   ├── macos        # A nested stow directory for MacOS packages
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
`include.path` directive. I've named the latter file `gitconfig.inc`.

Git expects this global file to be located in the home directory, so I've added it to the
Git package with the global ignore file that I introduced in the previous section:

```
.                        # The top-level stow directory
└── git                  # The package directory for git
    ├── .config
    │   └── git
    │       └── ignore
    └── .gitconfig
```

The following command creates the appropriate link to my `.gitconfig`, in addition to
creating a link to the directory containing the global ignore file:

```shell
~/dotfiles $ stow -v git
LINK: .gitconfig => ../dotfiles/git/.gitconfig
LINK: .config/git => ../dotfiles/git/.config/git
```

Next, the include file is located in a package under `local/home/macos`, and I've chosen
to symlink it in `.config/git` with Git's other configuration:

```
local/home/macos         # The nested stow directory
└── git                  # A MacOS-specific package directory for git
    └── .config
        └── git
            └── gitconfig.inc
```

To create a link to this include file, I `cd` to the nested stow directory and repeat the
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

### Alternative Layout

Local configuration can also be organized under a single package:

```
local/home               # The nested stow directory
└── macos                # A package directory for all configuraton used on MacOS
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

Stow's lack of support for encryption is a trade-off between simplicity (see my
[requirements](#dotfile-management) at the start of this README) and comprehensive
functionality.


## Configuring Stow

The following Stow-specific files are used in this repository:

* `./<package>/.stow-local-ignore`

  This [ignore list][stow-ignore-lists] is required when a package directory contains
  files that shouldn't be symlinked. It uses the Perl regular expression syntax.

* `./local/<stow-directory>/stow/.stowrc`

  This [resource file][stow-resource-files] makes it possible to define default
  command-line options (e.g., the target directory).

* `.stow`, `./local/<stow-directory>/.stow`

  These empty files help Stow work with [multiple stow directories][stow-multiple-directories].

[stow-multiple-directories]: https://www.gnu.org/software/stow/manual/html_node/Multiple-Stow-Directories.html


# Tools & Configuration

The remainder of this README covers the tools and plugins I use most and their
corresponding configuration files. I install each tool with `brew` on both MacOS and
Linux-based hosts.

Nearly every configuration file in this repository was written from scratch and tailored
to my preferences.

## Terminal

[alacritty/alacritty](https://github.com/alacritty/alacritty)
Alacritty is the fastest terminal emulator I've ever used. It's also very simple, but
those who expect support for window tabs and other basic functionality may find it harder
to use.

[tmux/tmux](https://github.com/tmux/tmux)
Alacritty eschews tabs in favor of pairing the emulator with tmux, which multiplexes
a single terminal to simulate panes and windows. There is a learning curve for tmux, but
it's a game-changer for anyone who often develops in a terminal.

### Configuration

* [.config/alacritty/alacritty.yml](alacritty/.config/alacritty/alacritty.yml)
* [.tmux.conf](tmux/.tmux.conf)

### Plugins

[tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)  
TPM is the standard plugin manager for tmux. I currently use it for:

* [tmux-plugins/tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)  
  This lets you recreate an entire Tmux session after a restart, including windows,
  current directories, and even Neovim sessions (see vim-obsession under [Editor](#editor)).


## Shell

[zsh-users/zsh](https://github.com/zsh-users/zsh)  
Z Shell (Zsh) was quite possibly the gateway drug for today's generation of command-line
users. It provides a programming language like Bash with features like tab completion and
themeable prompts, transforming a command line into a powerful editor. The cool kids
might be using [fish], but I like Zsh for its active development community and its
similarities to Bash and other POSIX shells.

[sorin-ionescu/prezto](https://github.com/sorin-ionescu/prezto)  
One of the most popular projects on GitHub is a configuration and plugin manager called
Oh My Zsh (OMZ). I used OMZ for a few years before I ultimately dropped it for Prezto,
which was created after its author [couldn't convince][gh-377] the author of OMZ to
simplify the framework. While the Prezto community is significantly less active than
OMZ's, my command prompt loads faster with Prezto and it offers all of the basic features
of OMZ.

[fish]: https://github.com/fish-shell/fish-shell
[omz]: https://github.com/ohmyzsh/ohmyzsh
[gh-377]: https://github.com/ohmyzsh/ohmyzsh/issues/377

### Configuration

| Usage                                             | Global Script | Local Script               |
| ------------------------------------------------- | ------------- | -------------------------- |
| Environment variables for all shells              | Not used      | [.zshenv]                  |
| Configuration for login shells (includes `$path`) | [.zprofile]   | [.config/zsh/zprofile.inc] |
| Configuration for interactive shells              | [.zshrc]      | [.config/zsh/zshrc.inc]    |
| Prezto configuration                              | [.zpreztorc]  | Not used                   |

See the Prezto [documentation][prezto-runcoms] and [chapter 2](zsh-startup-files) of the
Zsh guide for an explanation of these files.

[.zprofile]: zsh/.zprofile
[.zshrc]: zsh/.zshrc
[.zpreztorc]: zsh/.zpreztorc
[.zshenv]: local/home/macos/zsh/.zshenv
[.config/zsh/zprofile.inc]: local/home/macos/zsh/.config/zsh/zprofile.inc
[.config/zsh/zshrc.inc]: local/home/macos/zsh/.config/zsh/zshrc.inc

[prezto-runcoms]: https://github.com/adgoudz/prezto/blob/master/runcoms/README.md
[zsh-startup-files]: https://zsh.sourceforge.io/Guide/zshguide02.html


## Editor

[neovim/neovim](https://github.com/neovim/neovim)  
Neovim began as a fork of [Vim] in 2014 with a faster plugin system, a built-in terminal
emulator, and several other features. I'll only use Vim if I'm on a host where I can't
install Neovim, but since this happens often when I log in to remote servers, my Neovim
configuration is [backwards-compatible][nvim-from-vim] with Vim. My configuration will
also apply Neovim's defaults in Vim so that the editing behavior is identical between the
two.

[vim]: https://github.com/vim/vim
[nvim-from-vim]: https://neovim.io/doc/user/nvim.html#nvim-from-vim

### Configuration

* [.vimrc](vim/.vimrc)
* [.config/nvim/init.vim](nvim/.config/nvim/init.vim)

If you're viewing `.vimrc` in Neovim, use `zo` and `zc` in normal mode to open and close
[folds][nvim-folds].

[nvim-folds]: https://neovim.io/doc/user/fold.html

### Plugins

[junegunn/vim-plug](https://github.com/junegunn/vim-plug)  
vim-plug is one of several good options for plugin management with support for both Neovim
and Vim. My preferred plugins are installed in my `.vimrc`, and the most important of
these are:

* [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)  
  This provides visual cues and context-specific information in Neovim's status line. See
  [Themes](#themes) below.

* [tpope/vim-obsession](https://github.com/tpope/vim-obsession)  
  This wraps Neovim's `:mksession` to transparently save windows, tabs, and buffers. By
  pairing this with tmux-resurrect, you can automatically restore your editors when you
  restore your tmux session.

* [christoomey/vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)  
  This works together with a set of tmux key bindings to enable moving between Neovim and
  tmux windows with the same keyboard shortcuts.


## Themes

<p align="center">
  <img width="500" alt="Theme in normal mode"
       src="https://user-images.githubusercontent.com/1766968/168869631-fec0eeb5-d281-4ea4-9298-c7a794e3b361.png">
  <img width="500" alt="Theme in command mode"
       src="https://user-images.githubusercontent.com/1766968/168869626-7eea3fd4-b707-4acd-8e00-90d3a6e34482.png">
  <img width="500" alt="Theme in insert mode"
       src="https://user-images.githubusercontent.com/1766968/168869629-99733048-1536-4907-99e7-86cc84dac4ba.png">
  <img width="500" alt="Theme in replace mode"
       src="https://user-images.githubusercontent.com/1766968/168869635-5dba7a33-d929-4c27-aeec-6f94f0fa5232.png">
  <img width="500" alt="Theme in visual-line mode"
       src="https://user-images.githubusercontent.com/1766968/168869639-afa23fd8-6b02-42cb-bf6e-03c997f22a4a.png">
</p>

I use custom themes for tmux, Zsh, and Neovim, inspired by [Powerline] (a collection of
status line plugins written in Python) and [powerlevel10k] (a Zsh theme). My theme for
Neovim was created for the vim-airline plugin and my prompt theme was created for
Prezto.

<p align="center">
  <img width="250" alt="prompt-shadow"
       src="https://user-images.githubusercontent.com/1766968/168869633-f11fbda4-e371-4859-9b56-b0e0bddbb0d5.png">
</p>

While Powerline and powerlevel10k are both powerful and extensible, I prefer not to use
them for a few reasons:

* Powerline [didn't support Neovim][gh-1287] at the time I switched from Vim. Powerline
  is also a heavyweight framework that depends on background Python processes, and I've
  found vim-airline to be faster and more reliable.

* powerlevel10k targets the Zsh prompt only. I prefer a minimal prompt theme, so the
  overhead of another large dependency isn't worth it.

[powerline]: https://github.com/powerline/powerline
[powerlevel10k]: https://github.com/romkatv/powerlevel10k
[gh-1287]: https://github.com/powerline/powerline/issues/1287

### Fonts

<p align="center">
  <img width="250" alt="JetBrains Mono Dark"
       src="https://user-images.githubusercontent.com/1766968/168935033-d7153211-1ed0-4a06-ada6-0875c8cc5eb9.png#gh-dark-mode-only">
  <img width="250" alt="JetBrains Mono Light"
       src="https://user-images.githubusercontent.com/1766968/168938169-424f50c8-cbb9-45cc-8e49-7aaeb88755a1.png#gh-light-mode-only">
</p>

The themes above use glyphs (icons) available with [Nerd Fonts], a collection of
well-known fonts patched with glyphs from Powerline, FontAwesome, and several other
icon-based fonts. I use [JetBrains Mono], however, any font from the collection should be
compatible.

[nerd fonts]: https://github.com/ryanoasis/nerd-fonts
[jetbrains mono]: https://github.com/JetBrains/JetBrainsMono

### Configuration

Each theme is self-contained in the following files:

| Tool          | Configuration                                                               |
| ------------- | --------------------------------------------------------------------------- |
| **tmux**      | [.tmux.conf]                                                                |
| **Zsh**       | [.zprezto/modules/prompt/functions/prompt_andrew_setup] (at adgoudz/prezto) |
| **Neovim**    | [.vimrc]                                                                    |

[.vimrc]: vim/.vimrc
[.tmux.conf]: tmux/.tmux.conf
[.zprezto/modules/prompt/functions/prompt_andrew_setup]: https://github.com/adgoudz/prezto/blob/master/modules/prompt/functions/prompt_andrew_setup


## Color Scheme

<p align="center">
  <img width="400" alt="prompt-shadow"
       src="https://user-images.githubusercontent.com/1766968/168866981-feace42c-5634-4b88-a9e2-43519f7a7f85.png">
</p>

I use a custom 16-color scheme modeled on [Base16] and inspired by [Solarized] and
[Tomorrow Night]. I've been calling it "Astra", and while I've adapted it to almost every
tool I use, I need to make time to share this work and submit the scheme to Base16.

The scheme is configured in each of the following:

| Tool            | Configuration                                   |
| --------------- | ----------------------------------------------- |
| **Alacritty**   | [.config/alacritty/alacritty.yml]               |
| **Neovim**      | [.vim/colors/base16-astra.vim]                  |
| **vim-airline** | [.vim/autoload/airline/themes/base16_astra.vim] |

[.config/alacritty/alacritty.yml]: alacritty/.config/alacritty/alacritty.yml
[.vim/colors/base16-astra.vim]: vim/.vim/colors/base16-astra.vim
[.vim/autoload/airline/themes/base16_astra.vim]: vim/.vim/autoload/airline/themes/base16_astra.vim

[base16]: https://github.com/chriskempson/base16
[solarized]: https://github.com/altercation/solarized
[tomorrow night]: https://base16.netlify.app/previews/base16-tomorrow-night.html


## Other Tools

* [junegunn/fzf](https://github.com/junegunn/fzf)  
  A fantastic fuzzy-finder for your file system and almost anything else you can think of.

* [burntsushi/ripgrep](https://github.com/BurntSushi/ripgrep)  
  An incredibly-fast regex search tool. Like `grep`, but fancier.

* [htop-dev/htop](https://github.com/htop-dev/htop)  
  An interactive process viewer. Like `top`, but fancier.

