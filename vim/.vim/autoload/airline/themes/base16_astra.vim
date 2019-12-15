
let g:airline#themes#base16_astra#palette = {}

" GUI color definitions
let s:gui00 = "#1d1d1d"
let s:gui01 = "#282a2e"
let s:gui02 = "#373b41"
let s:gui03 = "#839496"
let s:gui04 = "#b4b7b4"
let s:gui05 = "#bfd0d2"
let s:gui06 = "#fdf6e3"
let s:gui07 = "#ffffff"
let s:gui08 = "#cc6666"
let s:gui09 = "#de935f"
let s:gui0A = "#f0c674"
let s:gui0B = "#b5bd68"
let s:gui0C = "#8abeb7"
let s:gui0D = "#81a2be"
let s:gui0E = "#b294bb"
let s:gui0F = "#9867aa"

" Terminal color definitions
let s:cterm00 = 00
let s:cterm03 = 08
let s:cterm05 = 07
let s:cterm07 = 15
let s:cterm08 = 01
let s:cterm0A = 03
let s:cterm0B = 02
let s:cterm0C = 06
let s:cterm0D = 04
let s:cterm0E = 05
if exists("base16colorspace") && base16colorspace == "256"
  let s:cterm01 = 18
  let s:cterm02 = 19
  let s:cterm04 = 20
  let s:cterm0F = 21
  let s:cterm09 = 16
  let s:cterm06 = 17
else
  let s:cterm01 = 10
  let s:cterm02 = 11
  let s:cterm04 = 12
  let s:cterm0F = 13
  let s:cterm09 = 09
  let s:cterm06 = 14
endif

let s:normal_a = [ s:gui07, s:gui0D, s:cterm07, s:cterm0D ]
let s:normal_b = [ s:gui04, s:gui01, s:cterm04, s:cterm01 ]
let s:normal_c = [ s:gui04, s:gui00, s:cterm04, s:cterm00 ]
let g:airline#themes#base16_astra#palette.normal = airline#themes#generate_color_map(s:normal_a, s:normal_b, s:normal_c)

let s:insert_a = [ s:gui07, s:gui0B, s:cterm07, s:cterm0B ]
let s:insert_b = [ s:gui04, s:gui02, s:cterm04, s:cterm02 ]
let s:insert_c = [ s:gui04, s:gui01, s:cterm04, s:cterm01 ]
let g:airline#themes#base16_astra#palette.insert = airline#themes#generate_color_map(s:insert_a, s:insert_b, s:insert_c)

let s:replace_a = [ s:gui07, s:gui0E, s:cterm07, s:cterm0E ]
let s:replace_b = [ s:gui04, s:gui02, s:cterm04, s:cterm02 ]
let s:replace_c = [ s:gui04, s:gui01, s:cterm04, s:cterm01 ]
let g:airline#themes#base16_astra#palette.replace = airline#themes#generate_color_map(s:replace_a, s:replace_b, s:replace_c)

let s:visual_a = [ s:gui07, s:gui0C, s:cterm07, s:cterm0C ]
let s:visual_b = [ s:gui04, s:gui02, s:cterm04, s:cterm02 ]
let s:visual_c = [ s:gui04, s:gui01, s:cterm04, s:cterm01 ]
let g:airline#themes#base16_astra#palette.visual = airline#themes#generate_color_map(s:visual_a, s:visual_b, s:visual_c)

let s:inactive_a = [ s:gui03, s:gui01, s:cterm03, s:cterm01 ]
let s:inactive_b = [ s:gui03, s:gui01, s:cterm03, s:cterm01 ]
let s:inactive_c = [ s:gui03, s:gui01, s:cterm03, s:cterm01 ]
let g:airline#themes#base16_astra#palette.inactive = airline#themes#generate_color_map(s:inactive_a, s:inactive_b, s:inactive_c)

let s:paste = {
    \ 'airline_a': [ s:gui00, s:gui07, s:cterm00, s:cterm07 ],
    \ 'airline_z': [ s:gui00, s:gui07, s:cterm00, s:cterm07 ]
    \ }

let g:airline#themes#base16_astra#palette.normal_paste = s:paste
let g:airline#themes#base16_astra#palette.insert_paste = s:paste
let g:airline#themes#base16_astra#palette.replace_paste = s:paste
let g:airline#themes#base16_astra#palette.visual_paste = s:paste

let g:airline#themes#base16_astra#palette.accents = {}
let g:airline#themes#base16_astra#palette.accents.red =    [ s:gui08 , '' , s:cterm08  , '' ]
let g:airline#themes#base16_astra#palette.accents.green =  [ s:gui0B , '' , s:cterm0B  , '' ]
let g:airline#themes#base16_astra#palette.accents.blue =   [ s:gui0D , '' , s:cterm0D  , '' ]
let g:airline#themes#base16_astra#palette.accents.yellow = [ s:gui0A , '' , s:cterm0A  , '' ]
let g:airline#themes#base16_astra#palette.accents.orange = [ s:gui09 , '' , s:cterm09  , '' ]
let g:airline#themes#base16_astra#palette.accents.purple = [ s:gui0E , '' , s:cterm0E  , '' ]

