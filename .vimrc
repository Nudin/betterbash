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

" Syntax-Highlight
if &t_Co > 2 || has("gui_running")
  syntax on
endif
set showmatch	" highlight matching [{()}]
colorscheme badwolf

" Enable Mouse
if has('mouse')
  set mouse=a
endif

" Indent
set autoindent
set si
set tabstop=4
set softtabstop=4
"set expandtab "???

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
if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif

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

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Tlist plugin
let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 1
nnoremap <C-l> :TlistToggle<CR>

