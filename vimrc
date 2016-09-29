"Pathogen
filetype off " Pathogen needs to run before plugin indent on
call pathogen#infect()
call pathogen#helptags() " generate helptags for everything in 'runtimepath'

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

filetype plugin indent on

" UI Config
set number
set title
set confirm
set showcmd
set ruler
set cursorline
set wildmenu " Autocompletion
set updatetime=250  " Decrease updatetime from 4s to 250ms

" Syntax-Highlight
syntax on
set showmatch	" highlight matching [{()}]
colorscheme badwolf

if !has('gui_running')
  set t_Co=256
endif

" Enable Mouse
if has('mouse')
  set mouse=a
endif

" Indent
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab

" Search
set incsearch
set ignorecase
set smartcase
set hlsearch

" History
set history=50		" keep 50 lines of command line history
set laststatus=2

" Copy & Paste
set clipboard=unnamed
set pastetoggle=<F11>

" backup files
set undodir=~/.vim/.undo//,.,/tmp
set backupdir=~/.vim/.backup//,.,/tmp
set directory=~/.vim/.swp//,.,/tmp
set backup		" keep a backup file (restore to previous version)
set undofile	" keep an undo file (undo changes after closing)

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set whichwrap=b,s,<,>,[,]

" Fold
set foldenable
set foldmethod=indent
set foldlevelstart=10
set foldnestmax=10

" at least 10 lines of context above/below cursor
set scrolloff=10

" Scroll text without cursor
noremap <C-j> j<C-e>
noremap <C-k> k<C-y>

" Add empty line without insertmode
nnoremap <M-o> O<Esc>j
nnoremap ø O<Esc>j
nnoremap <C-o> o<Esc>k

" Save
:command W w
:command Q q
:command Wq wq
:command WQ wq

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

let mapleader=","
" save session
nnoremap <leader>s :mksession<CR>

" spellchecking
silent! set spell spelllang=en,de,dewp
map <F5> :setlocal spell! spelllang=en_us<CR>
map <F6> :setlocal spell! spelllang=de<CR>
map <BS> hx

" grey background after char 80
let &colorcolumn=join(range(81,999),",")
highlight ColorColumn ctermbg=234

"===== PLUGINS =====
" gundo/mundo
"nnoremap <leader>u :GundoToggle<CR>
nnoremap <leader>u :MundoToggle<CR>

" Tlist plugin
let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
nnoremap <C-l> :TlistToggle<CR>

" Flake8
let g:flake8_show_in_gutter=0
let g:flake8_show_in_file=1
if has('nvim')
  function! Flake8_toggle()
    let g:flake8_show_quickfix=1
    call Flake8()
    let g:flake8_show_quickfix=0
  endfunction
  let g:flake8_show_quickfix=0
  augroup autoflake
    autocmd BufWritePost *.py call Flake8()
    autocmd BufReadPost *.py call Flake8()
    "autocmd TextChanged,TextChangedI <buffer> silent call Flake8()
    autocmd FileType python :autocmd! autoflake InsertEnter,InsertLeave,TextChanged <buffer> silent call Flake8() 
    autocmd FileType python map <buffer> <F8> :call Flake8_toggle()<CR>
  augroup END
endif
