# alternatively use ln -s to symlink the files instead of copying them
INST = cp -l

clonevimplugin = test -e ~/.vim/bundle/$(1) || git clone $(2) ~/.vim/bundle/$(1)

all: vim bc bashrc w3m nano browserweiche lesspipe xmodmap mpv mutt imapfilter ssh

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
	mkdir -p ~/.vim/ftplugin
	mkdir -p ~/.local/share/nvim/site/spell/
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
	$(call clonevimplugin,calendar,https://github.com/mattn/calendar-vim.git)
	$(call clonevimplugin,vimwiki,https://github.com/vimwiki/vimwiki.git)
	$(call clonevimplugin,floobits-neovim,https://github.com/Floobits/floobits-neovim.git)
	$(call clonevimplugin,ale,https://github.com/w0rp/ale.git)
	$(INST) vimwiki.vim ~/.vim/ftplugin/vimwiki.vim
	$(INST) haskell.vim ~/.vim/ftplugin/haskell.vim
	$(INST) dewp.utf-8.spl ~/.local/share/nvim/site/spell/dewp.utf-8.spl

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
	mkdir -p ~/.mpv/lua-settings/
	$(INST) mpv/config ~/.mpv/config
	$(INST) mpv/input.conf ~/.mpv/input.conf
	$(INST) mpv/lua-settings/osc.conf ~/.mpv/lua-settings/osc.conf

mutt:
	mkdir -p ~/.mutt
	$(INST) privateconf/.muttrc ~/.muttrc
	$(INST) privateconf/.mutt/* ~/.mutt/

ssh:
	$(INST) privateconf/.ssh/config ~/.ssh/config

imapfilter:
	$(INST) privateconf/.imapfilter/config.lua ~/.imapfilter/config.lua
