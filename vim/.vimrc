
augroup vimrc
  autocmd!
augroup END

"
" Implementation-specific Options {{{
"

if !has('nvim')
  let g:plugdir='~/.vim/plugged'

  set nocompatible                " Turn off compatibility mode

  set backupdir=~/.vim/backup
  set undodir=~/.vim/undo
  set directory=~/.vim/swap
  set history=10000               " Save the maximum number of commands in history
  set sessionoptions-=options     " Exclude options from saved sessions
  set tags=./tags;,tags           " Search for tags files recursively from the current file's directora
  set viminfo+=!                  " Save uppercase global variables

  set belloff=all
  set nofsync                     " Don't flush on each write
  set ttimeout                    " Time out on key codes in addition to mappings
  set ttimeoutlen=50              " Time in ms to wait for a key code sequence to complete (defaults to timeoutlen/1000)
  set ttyfast

  set background=dark             " Use dark foreground colors
  set laststatus=2                " Always display status line
  set shortmess+=F                " Don't show file info when editing
  set showcmd                     " Show partial commands in status line
  set sidescroll=1                " Scroll horizontally rather than re-centering on cursor
  set tabpagemax=50
  set wildmenu

  set autoindent                  " Copy indent when inserting new line
  set backspace=indent,eol,start  " Backspace over autoindent, line breaks, start of insert
  set complete-=i                 " Exclude current/included files from completion
  set nrformats=bin,hex           " Exclude octal numbers from C-[XA] operations
  set smarttab                    " Tab inserts shiftwidth at beginning of line, tabstop elsewhere

  set formatoptions=t             " Format text
  set formatoptions=c             " Format comments
  set formatoptions=q             " Allow formatting of comments with gq
  set formatoptions=j             " Remove comment leaders when joining lines

  set display=lastline            " Handle long lines and message scrolling
  set hlsearch                    " Highlight all search matches
  set incsearch                   " Highlight searches while typing

  " Removed in nvim
  set maxmem=2000000              " Max limit
  set maxmemtot=2000000           " Max limit

  " Create directories if needed
  for s:f in ['undo', 'swap']
    if !isdirectory(expand('~/.vim/' . s:f))
      exe mkdir(expand('~/.vim/' . s:f), 'p')
    endif
  endfor

  " Ignored from nvim
  " - encoding (uses $LANG)
  " - csscopeverbose
  " - langremap
  " - langnoremap
  " - listchars
  " - ruler (superceded by powerline)
  " - softtabstop (vim already defaults to 0)
else
  let g:plugdir=stdpath('data') . '/plugged'

  set backupdir-=.  " Don't use current directory
  set noautoread    " Don't reload files when changed outside of nvim

  set guicursor=    " Don't use bars for cursors
endif

" }}}
"
" Universal Options {{{
"

let maplocalleader='<space>'

let g:base16colorspace=16
colorscheme base16-astra

" Always restore the current working directory of a session to the
" directory of the session file, and not the directory that was used
" when the session was last updated. This causes the correct directory
" to be reported by tmux for proper persistence of [n]vim panes.
set sessionoptions-=curdir
set sessionoptions+=sesdir

set wildignore+=.git,*.pyc  " Ignore these patterns during wildcard expansion
set path+=$SANDBOX/repos  " Add path for resolution with gf
set backup                " Back up before writing

set colorcolumn=90        " Display right margin
set number                " Show line numbers
set ruler                 " Show the line and column number of the cursor position in the status line
set scrolloff=5           " Minimum number of lines to keep above/below cursor
set sidescrolloff=5       " Minimum number of lines to keep to the left/right of cursor
set shortmess+=I          " Don't show intro screen
set wildmode=full         " List all matches and complete first match in wildmenu

set listchars=tab:».,trail:·,extends:>,precedes:<,nbsp:+  " Used with list mode

set ignorecase            " Ignore case in search patterns
set smartcase             " Override ignorecase when patterns contain uppercase chars

set expandtab             " Use spaces instead of tabs
set tabstop=4             " This many spaces to one tab
set shiftwidth=4          " Default to tabstop for <<, >>, and smarttab
set shiftround            " Round indents to multiple of shiftwidth

set nowrap
set nojoinspaces          " Use only one space when joining lines
set smartindent           " Indent properly around braces
set textwidth=89

set formatoptions+=l      " Don't format existing long lines
set formatoptions+=1      " Don't break after single characters
set formatoptions+=n      " Format numbered lists (requires autoindent)
set formatoptions+=r      " Insert comment leader after <Enter>

" }}}
"
" Initialization {{{
"

" Backupdir is never auto-created
if !isdirectory(&backupdir)
  call mkdir(&backupdir, 'p')
endif

" Plugins
call plug#begin(g:plugdir)
Plug 'vim-airline/vim-airline'

Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'

Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'
Plug 'qpkorr/vim-bufkill'
Plug 'ntpeters/vim-better-whitespace'

Plug 'christoomey/vim-tmux-navigator'
call plug#end()

" }}}
"
" Plugin Options {{{
"

let g:airline_theme = 'base16_astra'
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1

let g:airline#extensions#ctrlp#color_template = 'normal'

let g:airline#extensions#obsession#indicator_text = 'ﴖ'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1        " Tab number only
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#fnamemod = ':t'        " Never include file paths
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

let g:airline#extensions#wordcount#enabled = 0

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.linenr = ' '
let g:airline_symbols.maxlinenr = ''

" Disable bold accents
call airline#parts#define_accent('mode', 'none')
call airline#parts#define_accent('linenr', 'none')
call airline#parts#define_accent('maxlinenr', 'none')
call airline#parts#define_accent('terminal', 'none')

" Use the ,+ style of the modified flag
call airline#parts#define_raw('file', '%f%M')

" Redefine this section to use less whitespace (and disable bold)
call airline#parts#define('linenr', {'raw': '%{g:airline_symbols.linenr}%l'})

function! s:AirlineInit()
  let l:spc = g:airline_symbols.space

  " Exclude left-padding in statusline fragments
  if airline#util#winwidth() > 79
    let g:airline_section_z = airline#section#create(['windowswap', 'obsession', '%p%%'.l:spc, 'linenr', 'maxlinenr', l:spc.' %v'])
  else
    let g:airline_section_z = airline#section#create(['%p%%'.l:spc, 'linenr',  ':%v'])
  endif
endfunction

augroup vimrc
  autocmd User AirlineAfterInit call s:AirlineInit()
augroup END

let g:strip_whitespace_on_save = 1
let g:strip_whitespace_confirm= 0

let g:ctrlp_extensions = ['buffertag', 'dir']
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_show_hidden = 1
let g:ctrlp_switch_buffer = 0        " Don't jump to an already-open file

let g:NERDSpaceDelims = 1
let g:NERDTreeRespectWildIgnore = 1

let g:tagbar_width = 32              " Decrease from 40
let g:tagbar_map_togglefold = 'za'   " Unmap 'o' for toggling folds
let g:tagbar_map_jump = 'o'          " And instead map it to jump to tags

let g:tmux_navigator_disable_when_zoomed = 1

"
" Left to configure:
"   * nerdcommenter
"   * better-whitespace
"   * bufkill

" }}}
"
" Auto-Commands {{{
"

" TODO

" }}}
"
" Mappings {{{
"

" Support xterm modifiers under tmux (vim only)
if !has('nvim') && &term =~ '^screen'
  set <xRight>=[1;*C
  set <xLeft>=[1;*D
endif

" View the highlightgroup for the character under the cursor
map <F10> :echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<' . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<' . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'<CR>

" Source or edit ~/.vimrc
nnoremap <silent> <leader>ev :vsplit $MYVIMRC<CR>
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>

" Open a terminal
nnoremap <C-W>t :terminal<CR>

" Make it easy to escape insert mode (and write)
inoremap <silent> jk <Esc>:w<CR>
tnoremap jk <C-\><C-n>

" Line navigation
noremap H ^
noremap L $

" Kill up to next word
nnoremap K vwhd

" Moving lines
nnoremap <silent> <M-{> :m .+1<CR>==
nnoremap <silent> <M-}> :m .-2<CR>==
inoremap <silent> <M-{> <Esc>:m .+1\<CR>==gi
inoremap <silent> <M-}> <Esc>:m .-2\<CR>==gi
vnoremap <silent> <M-{> :m '>+1<CR>gv=gv
vnoremap <silent> <M-}> :m .-2<CR>gv=gv

" Window navigation
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

nnoremap <silent> <M-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <M-j> :TmuxNavigateDown<CR>
nnoremap <silent> <M-k> :TmuxNavigateUp<CR>
nnoremap <silent> <M-l> :TmuxNavigateRight<CR>
nnoremap <silent> <M-\> :TmuxNavigatePrevious<CR>

" Tab switching
nnoremap <silent> <C-Left> :tabp<CR>
nnoremap <silent> <C-Right> :tabn<CR>
nnoremap <silent> <Home> :tabp<CR>
nnoremap <silent> <End> :tabn<CR>

" Buffer switching
nnoremap <silent> <M-Left> :bN!<CR>
nnoremap <silent> <M-b> :bN!<CR>
nnoremap <silent> <M-Right> :bn!<CR>
nnoremap <silent> <M-f> :bn!<CR>

" Macros
nnoremap <Space> @q

" Options
nnoremap <silent> <leader>nu :set nu!<CR>
nnoremap <silent> <leader>nw :set nowrap!<CR>
nnoremap <silent> <leader>ls :set list!<CR>
nnoremap <silent> <leader>noh :nohlsearch<CR>

" Plugins
nmap <silent> <leader>tb :TagbarToggle<CR>
nmap <silent> <leader>nt :NERDTreeToggle<CR>
nmap <silent> <leader>nf :NERDTreeFind<CR>
nmap <silent> <leader>ob :Obsession<CR>
nmap <silent> <leader>ws :StripWhitespace<CR>
nmap <silent> <leader>ts :ToggleWhitespace<CR>

" }}}
"
" Abbreviations {{{
"

iabbrev -- —

" }}}
"
