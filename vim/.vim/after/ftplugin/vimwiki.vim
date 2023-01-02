nmap <space> <Plug>VimwikiSplitLink
nmap <leader><space> <Plug>VimwikiVSplitLink
nmap <M-space> <Plug>VimwikiVSplitLink

hi SpellBad cterm=undercurl
hi vimwikiLink cterm=undercurl ctermfg=blue

if expand('%:p') =~ "/\.vimwiki/"
	set titlestring=VimWiki
	:command! W w | Git pull --autostash | execute "Git commit -a -m 'update'" | Git push | GitGutter
	:command! WQ w | Git pull --autostash | execute "Git commit -a -m 'update'" | Git push | q
endif

let g:gitgutter_sign_column_always = 1

set nowrap

setlocal colorcolumn = ""

" UltiSnips#ExpandSnippet usually on <C-T> – doesn't work in vimwiki
inoremap  <C-S>       <C-R>=UltiSnips#ExpandSnippet()<CR>
