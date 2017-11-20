:autocmd!

""""""""""
" plugins

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

" Point plugins to configuration
set runtimepath+=$DOTFILES

call pathogen#infect()

:Helptags

""""""""""
" Editing

set encoding=utf-8

set backspace=indent,eol,start

set shiftwidth=4
set tabstop=4

set expandtab
set smarttab

set autoindent
set smartindent

set colorcolumn=79

""""""""""""
" Searching

set ignorecase
set smartcase

set hlsearch
set incsearch

"""""""""""
" Behavior

set term=screen-256color
set t_Co=16

set noerrorbells
set shortmess+=I
" set tags+=~/.ctags

set viminfo='10,%
set path+=**1/lib;$REPOS

set dir-=.
set dir-=/var/tmp
set dir-=/tmp.
set dir-=~/tmp

set dir+=~/.vim/tmp

set wildignore+=*/var/*,*/_build/*,*.pyc

set swapsync=
set maxmem=2000000
set maxmemtot=2000000

filetype plugin indent on

autocmd BufEnter *md set ft=markdown
autocmd BufEnter *rc set ft=sh
autocmd BufEnter *vimrc set ft=vim

" Disable for performance
if version >= 704
  set regexpengine=1
endif

"""""""""""
" Mappings

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
nnoremap <C-W>h     2<C-W>h
nnoremap <leader>wh 2<C-W>h
nnoremap <C-J>      <C-W>j
nnoremap <C-W>l     2<C-W>l
nnoremap <leader>wl 2<C-w>l
nnoremap <C-K>      <C-W>k
nnoremap <C-L>      <C-W>l

" Tab switching
nnoremap <silent> [5~ :tabp<CR>
nnoremap <silent> OH :tabp<CR>
nnoremap <silent> [6~ :tabn<CR>
nnoremap <silent> OF :tabn<CR>

" Buffer switching
nnoremap [ :bN!<CR>
nnoremap ] :bn!<CR>

" Options
nnoremap <silent> <leader>noh :nohlsearch<CR>
nnoremap <silent> <leader>ln :set nu!<CR>
nnoremap <silent> <leader>nw :set nowrap!<CR>

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
set laststatus=2

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
