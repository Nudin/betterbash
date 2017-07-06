set expandtab
let g:gitgutter_sign_column_always = 1

" Disable haskell-vim omnifunc – recomended by neco-ghc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

let g:necoghc_enable_detailed_browse = 1


