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
highlight TermCursor ctermfg=red guifg=red
tnoremap <Leader><ESC> <C-\><C-n>

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


"===== PLUGINS =====
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'godlygeek/tabular'
Plug 'tpope/vim-fugitive'           " Git wrapper
Plug 'airblade/vim-gitgutter'       " Show changes to last commit in gutter
Plug 'simnalamburt/vim-mundo'       " Global tree-structure undo
Plug 'tpope/vim-sleuth'             " Set shiftwidth/expandtabs automatically
Plug 'rust-lang/rust.vim'
Plug 'guns/xterm-color-table.vim', { 'on':  'XtermColorTable' }
Plug 'vim-scripts/mru.vim'
Plug 'mattn/calendar-vim'
Plug 'Nudin/vimwiki', { 'branch': 'dev' }    " Wiki for Vim
Plug 'Floobits/floobits-neovim'
Plug 'majutsushi/tagbar'
Plug 'aquach/vim-mediawiki-editor'  " Edit mediawikis
" == Pluging not compatible with vim 7
if has('nvim') || v:version > 800
  Plug 'w0rp/ale'                     " Asynchronous Lint Engine
endif
if has('nvim')  " neovimonly
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }  " completion
  Plug 'eagletmt/neco-ghc'          " completion for haskell basing on deoplete
  Plug 'rliang/termedit.nvim'
endif
call plug#end()

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
let g:vimwiki_listsyms = ' ▁▂▃▄▅▆▇✓' " ' ○◐●✓'
let g:vimwiki_toc_header = 'Inhalt'
let g:GPGFilePattern = '*.\(gpg\|asc\|pgp\)\(.wiki\)\='

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

