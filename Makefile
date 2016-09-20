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
	mkdir -p ~/.vim/autoload
	mkdir -p ~/.vim/bundle
	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim	
	test -e ~/.vim/bundle/lightline || git clone https://github.com/itchyny/lightline.vim ~/.vim/bundle/lightline
	test -e ~/.vim/bundle/nerdtree || git clone git://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
	test -e ~/.vim/bundle/tabular || git clone git://github.com/godlygeek/tabular.git ~/.vim/bundle/tabular
	test -e ~/.vim/bundle/flake8 || git clone https://github.com/nvie/vim-flake8.git ~/.vim/bundle/flake8
	test -e ~/.vim/bundle/fugitive || git clone git://github.com/tpope/vim-fugitive.git ~/.vim/bundle/fugitive
	test -e ~/.vim/bundle/gitgutter || git clone git://github.com/airblade/vim-gitgutter.git ~/.vim/bundle/gitgutter
	test -e ~/.vim/bundle/mundo || git clone https://github.com/simnalamburt/vim-mundo.git ~/.vim/bundle/mundo
	test -e ~/.vim/bundle/sleuth || git clone git://github.com/tpope/vim-sleuth.git ~/.vim/bundle/sleuth
	test -e ~/.vim/bundle/xterm-color-table || git clone https://github.com/guns/xterm-color-table.vim.git ~/.vim/bundle/xterm-color-table

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
