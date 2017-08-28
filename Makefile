# alternatively use ln -s to symlink the files instead of copying them
INST = cp -l $(INSTFLAGS)

clonevimplugin = test -e ~/.vim/bundle/$(1) || git clone $(2) ~/.vim/bundle/$(1)

all: vim bc bashrc w3m nano browserweiche lesspipe xmodmap mpv mutt imapfilter ssh git

nano:
	$(INST) nano/.nanorc ~/.nanorc
	$(INST) nano/.nano_starter ~/.nano_starter
	mkdir -p ~/.nano
	$(INST) -r nano/syntaxhighlighting/* ~/.nano
.PHONY: nano

w3m:
	$(INST) w3m/keymap_hardexit ~/.w3m/keymap_hardexit
.PHONY: w3m

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
	mkdir -p ~/.vim/after/ftplugin
	mkdir -p ~/.vim/syntax
	mkdir -p ~/.local/share/nvim/site/spell/
	curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	curl -fLo ~/.vim/syntax/haskell.vim https://raw.githubusercontent.com/sdiehl/haskell-vim-proto/master/vim/syntax/haskell.vim
	$(INST) vimwiki.vim ~/.vim/after/ftplugin/vimwiki.vim
	$(INST) haskell.vim ~/.vim/after/ftplugin/haskell.vim
	$(INST) dewp.utf-8.spl ~/.local/share/nvim/site/spell/dewp.utf-8.spl
	$(INST) privateconf/.floorc.json ~/.floorc.json

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
	mkdir -p ~/.config/mpv/scripts
	mkdir -p ~/.config/mpv/bin
	$(INST) mpv/config ~/.mpv/config
	$(INST) mpv/input.conf ~/.mpv/input.conf
	$(INST) mpv/lua-settings/osc.conf ~/.mpv/lua-settings/osc.conf
	$(INST) mpv/scripts/* ~/.config/mpv/scripts
	$(INST) mpv/delogo ~/.config/mpv/bin/delogo
	chmod +x ~/.config/mpv/bin/delogo
.PHONY: mpv

mutt:
	mkdir -p ~/.mutt
	$(INST) privateconf/.muttrc ~/.muttrc
	$(INST) privateconf/.mutt/* ~/.mutt/

ssh:
	$(INST) privateconf/.ssh/config ~/.ssh/config

imapfilter:
	$(INST) privateconf/.imapfilter/config.lua ~/.imapfilter/config.lua

git:
	$(INST) .gitconfig ~/.gitconfig

### This files sets up a hook to run 'make INSTFLAGS='-f' after pull/merge
### This is not run by all!
hook:
	cp post-merge-hook .git/hooks/post-merge
