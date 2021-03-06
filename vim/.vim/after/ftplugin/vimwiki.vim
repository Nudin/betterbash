nmap <space> <Plug>VimwikiSplitLink
nmap <leader><space> <Plug>VimwikiVSplitLink
nmap <M-space> <Plug>VimwikiVSplitLink

hi SpellBad cterm=undercurl
hi vimwikiLink cterm=undercurl ctermfg=blue

set titlestring=VimWiki

:command! W w | Git pull --autostash | execute "Git commit -a -m 'update'" | Git push | GitGutter
:command! WQ w | Git pull --autostash | execute "Git commit -a -m 'update'" | Git push | q

let g:gitgutter_sign_column_always = 1

set nowrap

setlocal colorcolumn = ""
