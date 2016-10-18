# alternatively use ln -s to symlink the files instead of copying them
INST = cp -rf

clonevimplugin = test -e ~/.vim/bundle/$(1) || git clone $(2) ~/.vim/bundle/$(1)

all: vim bc bashrc w3m nano browserweiche lesspipe xmodmap mpv

nano:
	$(INST) nano/.nanorc ~/.nanorc
	$(INST) nano/.nano_starter ~/.nano_starter
	mkdir -p ~/.nano
	$(INST) -r nano/syntaxhighlighting/* ~/.nano

w3m:
	$(INST) w3m/keymap_hardexit ~/.w3m/keymap_hardexit

bashrc:
	$(INST) .bashrc ~/.bashrc

bc:
	$(INST) .bcrc ~/.bcrc

themes:
	mkdir -p ~/.vim/colors/
	wget -nv https://raw.githubusercontent.com/sjl/badwolf/master/colors/badwolf.vim -O ~/.vim/colors/badwolf.vim 
	wget -nv  https://raw.githubusercontent.com/thomd/vim-wasabi-colorscheme/master/colors/wasabi256.vim -O ~/.vim/colors/wasabi256.vim
 
vimplugins:
	mkdir -p ~/.vim/autoload
	mkdir -p ~/.vim/bundle
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim	
	$(call clonevimplugin,lightline,https://github.com/itchyny/lightline.vim)
	$(call clonevimplugin,nerdtree,git://github.com/scrooloose/nerdtree.git)
	$(call clonevimplugin,tabular,git://github.com/godlygeek/tabular.git)
	$(call clonevimplugin,flake8,https://github.com/nvie/vim-flake8.git)
	$(call clonevimplugin,fugitive,git://github.com/tpope/vim-fugitive.git)
	$(call clonevimplugin,gitgutter,git://github.com/airblade/vim-gitgutter.git)
	$(call clonevimplugin,mundo,https://github.com/simnalamburt/vim-mundo.git)
	$(call clonevimplugin,sleuth,git://github.com/tpope/vim-sleuth.git)
	$(call clonevimplugin,rust,git://github.com/rust-lang/rust.vim.git)
	$(call clonevimplugin,xterm-color-table,https://github.com/guns/xterm-color-table.vim.git)
	$(call clonevimplugin,mru,https://github.com/vim-scripts/mru.vim.git)
	$(call clonevimplugin,YouCompleteMe,https://github.com/Valloric/YouCompleteMe)
	cd ~/.vim/bundle/YouCompleteMe; git submodule update --init --recursive
	~/.vim/bundle/YouCompleteMe/install.py --racer-completer

vim: themes vimplugins
	mkdir -p ~/.vim
	mkdir -p ~/.vim/.backup ~/.vim/.swp ~/.vim/.undo
	$(INST) vimrc ~/.vim/vimrc
	test -e ~/.vim/init.vim || ln -s ~/.vim/vimrc ~/.vim/init.vim

browserweiche:
	$(INST) browserweiche.sh ~/.browserweiche.sh

lesspipe:
	$(INST) lesspipe.sh ~/.lesspipe.sh

xmodmap:
	$(INST) Xmodmap ~/.Xmodmap

mpv:
	$(INST) mpv ~/.mpv
