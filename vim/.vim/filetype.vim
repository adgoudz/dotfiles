if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    autocmd BufNewFile,BufRead *rc set ft=sh
augroup END
