if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    autocmd BufNewFile,BufRead vimrc set ft=vim
    autocmd BufNewFile,BufRead *rc set ft=sh
augroup END
