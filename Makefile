SHELL := /bin/bash -O extglob
# alternatively use ln -s to symlink the files instead of copying them
OINST = cp -lr $(INSTFLAGS)
define INST
  $(OINST) -r $(1)/*(*|.[^.]|.??*) ~/
endef

all: vim bc bashrc w3m nano browserweiche lesspipe xmodmap mpv mutt imapfilter ssh git inputrc listadmin tmux kitty

kitty:
	$(call INST,kitty)
.PHONY: kitty

tmux:
	$(call INST,tmux)
	test -d ~/.tmux/plugins/tpm || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
.PHONY: tmux

nano:
	$(call INST,nano)
.PHONY: nano

w3m:
	$(call INST,w3m)
.PHONY: w3m

bashrc:
	$(call INST,bash)
.PHONY: bash

inputrc:
	$(call INST,readline)
.PHONY: readline

bc:
	$(call INST,bc)
.PHONY: bc

themes:
	mkdir -p ~/.vim/colors/
	curl -s https://raw.githubusercontent.com/sjl/badwolf/master/colors/badwolf.vim > ~/.vim/colors/badwolf.vim
	curl -s https://raw.githubusercontent.com/thomd/vim-wasabi-colorscheme/master/colors/wasabi256.vim > ~/.vim/colors/wasabi256.vim
.PHONY: themes
 
vimplugins:
	mkdir -p ~/.vim/autoload
	mkdir -p ~/.vim/bundle
	mkdir -p ~/.vim/after/ftplugin
	mkdir -p ~/.vim/syntax
	mkdir -p ~/.local/share/nvim/site/spell/
	curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	curl -fLo ~/.vim/syntax/haskell.vim https://raw.githubusercontent.com/sdiehl/haskell-vim-proto/master/vim/syntax/haskell.vim
	$(call INST,vim)
	$(OINST) privateconf/floo/.floorc.json ~/.floorc.json
.PHONY: vimplugins

vim: themes vimplugins
	mkdir -p ~/.vim
	mkdir -p ~/.vim/.backup ~/.vim/.swp ~/.vim/.undo
	$(call INST,vim)
	test -e ~/.vim/init.vim || ln -s ~/.vim/vimrc ~/.vim/init.vim
.PHONY: vim

browserweiche:
	$(call INST,browserweiche)
.PHONY: browserweiche

lesspipe:
	$(call INST,less)
.PHONY: lesspipe

xmodmap:
	$(call INST,xmodmap)
.PHONY: xmodmap

mpv:
	mkdir -p ~/.mpv/lua-settings/
	mkdir -p ~/.config/mpv/scripts
	mkdir -p ~/.config/mpv/bin
	$(call INST,mpv)
	chmod +x ~/.config/mpv/bin/delogo
.PHONY: mpv

mutt:
	mkdir -p ~/.mutt
	$(call INST,mutt)
	$(OINST) privateconf/mutt/.mutt/* ~/.mutt/
.PHONY: mutt

ssh:
	$(OINST) privateconf/ssh/.ssh/config ~/.ssh/config
.PHONY: ssh

imapfilter:
	mkdir -p ~/.imapfilter
	$(OINST) privateconf/imapfilter/.imapfilter/config.lua ~/.imapfilter/config.lua
.PHONY: imapfilter

listadmin:
	$(OINST) privateconf/listadmin/.listadmin.ini ~/.listadmin.ini
.PHONY: listadmin

git:
	$(call INST,git)
.PHONY: git

python:
	$(call INST,python)
.PHONY: python

### This files sets up a hook to run 'make INSTFLAGS='-f' after pull/merge
### This is not run by all!
hook:
	cp post-merge-hook .git/hooks/post-merge
