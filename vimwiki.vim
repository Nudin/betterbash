nmap <space> <Plug>VimwikiSplitLink
nmap <leader><space> <Plug>VimwikiVSplitLink
nmap <M-space> <Plug>VimwikiVSplitLink

hi SpellBad cterm=undercurl
hi vimwikiLink cterm=undercurl ctermfg=blue

set titlestring=VimWiki

:command! W w | execute "Gcommit -a -m 'update'" | Gpush | GitGutter
:command! WQ w | execute "Gcommit -a -m 'update'" | Gpush | q

let g:gitgutter_sign_column_always = 1
