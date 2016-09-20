# alternatively use ln -s to symlink the files instead of copying them
INST = cp -rf

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
	git clone https://github.com/itchyny/lightline.vim ~/.vim/bundle/lightline
	git clone git://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
	git clone git://github.com/godlygeek/tabular.git ~/.vim/bundle/tabular
	git clone https://github.com/nvie/vim-flake8.git ~/.vim/bundle/flake8
	git clone git://github.com/tpope/vim-fugitive.git ~/.vim/bundle/fugitive
	git clone git://github.com/airblade/vim-gitgutter.git ~/.vim/bundle/gitgutter
	git clone https://github.com/simnalamburt/vim-mundo.git ~/.vim/bundle/mundo
	git clone git://github.com/tpope/vim-sleuth.git ~/.vim/bundle/sleuth
	git clone https://github.com/guns/xterm-color-table.vim.git ~/.vim/bundle/xterm-color-table

vim: themes vimplugins
	$(INST) .vimrc ~/.vimrc

browserweiche:
	$(INST) browserweiche.sh ~/.browserweiche.sh

lesspipe:
	$(INST) lesspipe.sh ~/.lesspipe.sh

xmodmap:
	$(INST) Xmodmap ~/.Xmodmap

mpv:
	$(INST) mpv ~/.mpv
