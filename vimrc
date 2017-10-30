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
set fillchars+=vert:\│ " nice line for vsplit

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
if has('nvim')  " neovimonly
  set inccommand=nosplit " live search and replace; neovim only
endif

" History
set history=50		" keep 50 lines of command line history
set laststatus=2

" Copy & Paste
set clipboard=unnamed
set pastetoggle=<F11>

" Split right & down
set splitright
set splitbelow

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
set scrolloff=5

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
set spellfile=~/.config/nvim/spell/mine.utf-8.add
map <F5> :setlocal spell! spelllang=en_us<CR>
map <F6> :setlocal spell! spelllang=de<CR>
map <BS> hx

" grey background after char 80
let &colorcolumn=join(range(81,999),",")
highlight ColorColumn ctermbg=234

" SETUP TERMINAL
if has('nvim')
  highlight TermCursor ctermfg=red guifg=red
  tnoremap <ESC><ESC> <C-\><C-n>

  command Vterm 80vsplit | terminal
  command Term 10split | terminal

  " Window navigation function
  " Make ctrl-h/j/k/l move between windows and auto-insert in terminals
  func! s:mapMoveToWindowInDirection(direction)
      func! s:maybeInsertMode(direction)
          stopinsert
          execute "wincmd" a:direction

          if &buftype == 'terminal'
              startinsert!
          endif
      endfunc

      execute "tnoremap" "<silent>" "<M-" . a:direction . ">"
                  \ "<C-\\><C-n>"
                  \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
      execute "nnoremap" "<silent>" "<M-" . a:direction . ">"
                  \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
  endfunc
  for dir in ["h", "j", "l", "k"]
      call s:mapMoveToWindowInDirection(dir)
  endfor
endif


"===== PLUGINS =====
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'        " Statusline
"Plug 'vim-airline/vim-airline'     " More powerfull alternative to airline
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'godlygeek/tabular'
Plug 'tpope/vim-fugitive'           " Git wrapper
Plug 'airblade/vim-gitgutter'       " Show changes to last commit in gutter
Plug 'simnalamburt/vim-mundo'       " Global tree-structure undo
Plug 'tpope/vim-sleuth'             " Set shiftwidth/expandtabs automatically
Plug 'guns/xterm-color-table.vim', { 'on':  'XtermColorTable' }
Plug 'vim-scripts/mru.vim'
Plug 'mattn/calendar-vim'
Plug 'Nudin/vimwiki', { 'branch': 'beta' }    " Wiki for Vim
Plug 'Floobits/floobits-neovim'
Plug 'majutsushi/tagbar'            " list functions, methods, structs... 
Plug 'aquach/vim-mediawiki-editor'  " Edit mediawikis
Plug 'scrooloose/nerdcommenter'     " Easy comment/uncoment lines
Plug 'dpelle/vim-LanguageTool'      " Check grammar with languagetool
Plug 'sbdchd/neoformat'             " Pretty formatting code
Plug 'jamessan/vim-gnupg'
Plug 'EinfachToll/DidYouMean'       " asks for the right file to open
Plug 'tpope/vim-obsession'          " autosave sessions
Plug 'mhinz/vim-startify'           " start page
Plug 'tpope/vim-repeat'
Plug 'vim-utils/vim-man'
Plug 'Nudin/ToggleClip'
"""" Language specific plugins
Plug 'vim-latex/vim-latex'
Plug 'rust-lang/rust.vim'
Plug 'Nudin/vim-sparql'
Plug 'neovimhaskell/haskell-vim'
Plug 'pbrisbin/vim-syntax-shakespeare'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
"""" Pluging not compatible with vim 7""""
if has('nvim') || v:version > 800
  Plug 'w0rp/ale'                     " Asynchronous Lint Engine
endif
if has('nvim')  " neovimonly
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }  " completion
  Plug 'eagletmt/neco-ghc'          " completion for haskell basing on deoplete
  Plug 'rliang/termedit.nvim'       " set a envvar in neovims term to not open nvim in nvim
endif
""" Colorschemes
Plug 'iCyMind/NeoSolarized'
Plug 'joshdick/onedark.vim'
Plug 'mhartington/oceanic-next'
Plug 'KeitaNakamura/neodark.vim'
call plug#end()

" lightline & obsession
set noshowmode   " disable -- insert -- text
let g:lightline = {
      \ 'active': {
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'clip', 'fileformat', 'fileencoding', 'filetype', 'obsession' ] ]
      \ },
      \ 'component': {
      \   'obsession': '%{ObsessionStatus("S", "")}',
      \   'clip': '%{ToggleClip#getstatus()}'
      \ },
      \ }


" mundo
nnoremap <leader>u :MundoToggle<CR>

" vimwiki
let g:vimwiki_list = [{
      \ 'path': '~/.vimwiki/',
      \              "template_path": "~/.vimwiki/templates",
      \               "css_name": "mystyle.css",
      \               'auto_toc': 1,
      \               'list_margin': 4},
      \               {}]
let g:vimwiki_use_mouse = 1
let g:vimwiki_listsyms = ' ▁▂▃▄▅▆▇✓'
let g:vimwiki_toc_header = 'Inhalt'
let g:GPGFilePattern = '*.\(gpg\|asc\|pgp\)\(.wiki\)\='
nmap <M--> <Plug>VimwikiDecrementListItem
vmap <M--> <Plug>VimwikiDecrementListItm
nmap <M-+> <Plug>VimwikiIncrementListItem
vmap <M-+> <Plug>VimwikiIncrementListItem
let g:vimwiki_additional_bullet_types = { '→':0 }

" Tlist plugin
let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
nnoremap <C-l> :TlistToggle<CR>

" tagbar
nmap <F8> :TagbarToggle<CR>
let g:tagbar_type_rust = {
    \ 'ctagstype' : 'rust',
    \ 'kinds' : [
        \'T:types,type definitions',
        \'f:functions,function definitions',
        \'g:enum,enumeration names',
        \'s:structure names',
        \'m:modules,module names',
        \'c:consts,static constants',
        \'t:traits,traits',
        \'i:impls,trait implementations',
    \]
    \}

" Grepper
nnoremap <leader>g :Grepper<cr>
nnoremap <leader>G :Grepper -cword -noprompt<cr>
let g:grepper               = {}
let g:grepper.tools         = ['rg', 'git', 'grep', 'ag', 'rg']
let g:grepper.simple_prompt = 1
