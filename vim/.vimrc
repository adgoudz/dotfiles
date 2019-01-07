:autocmd!

""""""""""
" Plugins

let g:ctrlp_extensions = ['buffertag']
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_clear_cache_on_exit = 1

let g:NERDSpaceDelims = 1
let g:NERDTreeChDirMode = 2
let g:NERDTreeRespectWildIgnore = 1

let g:tagbar_width = 32
let g:tagbar_map_togglefold = 'za'
let g:tagbar_map_jump = 'o'

let g:snipMate = {}
let g:snipMate.snippet_version = 1

" Turn off bad whitesapce highlighting before plugin loads
autocmd BufWinEnter,WinEnter,FileType * let b:bad_whitespace_show = 0

" Erase bad whitespace on save
autocmd BufWritePre * :EraseBadWhitespace

set runtimepath+=$DOTFILES  " Point plugins to configuration

call pathogen#infect()
:helptags

"""""""""""
" Behavior

filetype plugin indent on

set nocompatible

" Eliminate timeouts for key codes
set timeout          " Default
set timeoutlen=1000  " Default
set ttimeoutlen=1    " Defaults to timeoutlen

set noerrorbells
set shortmess+=I  " Turn off intro screen

set viminfo='10,%  " Remember marks, buffer list

set path+=$REPOS

set dir=~/.vim/tmp  " Swap file directory

set wildignore+=*/var/*,*/_build/*,*.pyc

set sessionoptions-=options

set ttyfast
set swapsync=
set maxmem=2000000
set maxmemtot=2000000

""""""""""
" Editing

set encoding=utf-8

set backspace=indent,eol,start

set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=4     " Tab width
set shiftwidth=4  " Indentation width
set shiftround    " Indent to next multiple of 'shiftwidth'

set complete-=i

" Keep some space between the cursor and the window edge
set scrolloff=1
set sidescrolloff=5

set nrformats-=octal  " Influences C-{X,A}

""""""""""""
" Searching

set ignorecase
set smartcase

set hlsearch
set incsearch

"""""""""""
" Mappings

" Support xterm modifiers under tmux (mapped keys only)
if &term =~ '^screen'
    set <xRight>=[1;*C
    set <xLeft>=[1;*D
endif

" Line navigation
noremap H ^
noremap L $

" Line editing
nnoremap K vwhd

" Move lines
nnoremap { :m+==
nnoremap } :m-2==
inoremap { :m+==gi
inoremap } :m-2==gi
vnoremap { :m'>+gv=gv
vnoremap } :m-2gv=gv

" Macros
nnoremap <Space> @q

" Window navigation
nnoremap <C-H>      <C-W>h
nnoremap <C-J>      <C-W>j
nnoremap <C-K>      <C-W>k
nnoremap <C-L>      <C-W>l
nnoremap <C-W>h     2<C-W>h
nnoremap <leader>wh 2<C-W>h
nnoremap <C-W>l     2<C-W>l
nnoremap <leader>wl 2<C-w>l

" Tab switching
nnoremap <silent> <A-Left> :tabp<CR>
nnoremap <silent> <Home> :tabp<CR>
nnoremap <silent> <A-Right> :tabn<CR>
nnoremap <silent> <End> :tabn<CR>

" Buffer switching
nnoremap <C-Left> :bN!<CR>
nnoremap <C-Right> :bn!<CR>

" Options
nnoremap <silent> <leader>ln :set nu!<CR>
nnoremap <silent> <leader>nw :set nowrap!<CR>
nnoremap <silent> <leader>ls :set list!<CR>
nnoremap <silent> <leader>noh :nohlsearch<CR>

" Plugins
nmap <silent> <leader>tb :TagbarToggle<CR>
nmap <silent> <leader>nt :NERDTreeToggle<CR>
nmap <silent> <leader>nf :NERDTreeFind<CR>
nmap <silent> <leader>ew :EraseBadWhitespace<CR>

nmap <silent> <leader>al :Align<CR>

"""""""""""""
" Appearance

set ruler
set number
set wildmenu
set laststatus=2  " Always show the status line
set colorcolumn=79

set listchars=tab:».,trail:·,extends:>,precedes:<,nbsp:+  " See :set list!

syntax on

set background=dark
colorscheme solarized

" Powerline (if available)
:silent !command -v powerline > /dev/null

:if v:shell_error == 0
    python3 from powerline.vim import setup as powerline_setup

    python3 powerline_setup()
    python3 del powerline_setup
:endif

