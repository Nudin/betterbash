# alternatively use ln -s to symlink the files instead of copying them
INST = cp -rf

all: vim bc bashrc w3m nano browserweiche lesspipe xmodmap mpv

nano:
	$(INST) nano/.nanorc ~/.nanorc
	$(INST) -r nano/syntaxhighlighting /.nano

w3m:
	$(INST) w3m/keymap_hardexit ~/.w3m/keymap_hardexit

bashrc:
	$(INST) .bashrc ~/.bashrc

bc:
	$(INST) .bcrc ~/.bcrc

themes:
	mkdir -p ~/.vim/colors/
	wget -nv https://raw.githubusercontent.com/sjl/badwolf/master/colors/badwolf.vim -O ~/.vim/colors/badwolf.vim 

vim: themes
	$(INST) .vimrc ~/.vimrc

browserweiche:
	$(INST) browserweiche.sh ~/.browserweiche.sh

lesspipe:
	$(INST) lesspipe.sh ~/.lesspipe.sh

xmodmap:
	$(INST) xmodmap ~/.Xmodmap

mpv:
	$(INST) mpv ~/.mpv
