# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definition
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

#========================================
#	Bash-behavior
#========================================
shopt -s cdspell hostcomplete histreedit histverify checkwinsize
if [ $BASH_VERSINFO -ge 4 ] ; then
        shopt -s autocd checkjobs dirspell globstar
fi

#Configure history
export HISTCONTROL=erasedups:ignorespace
export HISTSIZE=50000
export HISTFILESIZE=50000

# Edit PATH
export PATH=$PATH:~/.cabal/bin/

#========================================
# 	Environment
#========================================
export TERM=xterm-256color
export BROWSER="$HOME/.browserweiche.sh"
export DIFFPROG=meld
export GPG_TTY=$(tty)
# Set editor
if hash nvim 2> /dev/null; then
  if [[ "$EDITOR" =~ termedit.py ]] ; then
    alias nvim="$EDITOR"
  fi
  export EDITOR="nvim"
  alias vim='nvim'
else
  export EDITOR="vim"
fi
alias vi='vim'

if [ -f "$HOME/.bcrc" ] ; then
  export BC_ENV_ARGS=$HOME/.bcrc
fi

# tcl-tk theme
if [ -f ~/.local/share/tkthemes ] ; then
  export TCLLIBPATH=~/.local/share/tkthemes
fi

# configure less
if [ -f "$HOME/.lesspipe.sh" ] ; then
  export LESSOPEN="|$HOME/.lesspipe.sh %s"
fi
export LESS=' -R '

# Autostart ssh-agent
if [ "${SSH_AUTH_SOCK}" == "" ]; then
  eval "$(ssh-agent)"
fi

# Find DISTRIBUTION name
if uname -r | grep Ubuntu > /dev/null ; then
	export DISTRIBUTION=Ubuntu
elif uname -r | grep -e ARCH -e grsec > /dev/null ; then
	export DISTRIBUTION=Arch
elif uname -r | grep fc > /dev/null ; then
    export DISTRIBUTION=Fedora
fi

source_if_existent() {
  if [ -f "$1" ] ; then
    source "$1"
  fi
}

source_if_existent /etc/bash_completion
source_if_existent /usr/share/git/completion/git-prompt.sh
source_if_existent ~/.git-aliases

# Set up fzf
source_if_existent /usr/share/fzf/key-bindings.bash
source_if_existent /usr/share/fzf/completion.bash
source_if_existent ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"

bind -x '"\C-p": vim $(fzf);'

# set up broot
source_if_existent /home/michi/.config/broot/launcher/bash/br

# Using this, aliases will work with sudo
alias sudo='sudo '

#========================================
#	ANSI-Colors for Bash
#========================================
black='\e[30m';         red='\e[31m'
green='\e[32m';         yellow='\e[33m'
blue='\e[34m';          purple='\e[35m'
cyan='\e[36m';          white='\e[37m'

blackb='\e[40m';        redb='\e[41m'
greenb='\e[42m';        yellowb='\e[43m'
blueb='\e[44m';         purpleb='\e[45m'
cyanb='\e[46m';         whiteb='\e[47m'

bold='\e[1m';           boldoff='\e[21m'
light='\e[2m';          lightoff='\e[22m'
it='\e[3m';             itoff='\e[23m'
ul='\e[4m';             uloff='\e[24m'
inv='\e[7m';            invoff='\e[27m'

reset='\e[0m'

# === to set Window-title ===
settitle() {
    printf "\033]0;$1\007"
}
settitle "$(hostname):$PWD"

#========================================
# Set default values for several commands
#========================================
# human readable sizes
alias du='du -h --max-depth=1'
alias df='df -h'
alias free="free -m"
# turn on color and make grep silent
alias ls='ls -h --color=auto'
alias grep='grep -s --color=auto'
alias fgrep='fgrep -s  --color=auto'
alias egrep='egrep -s --color=auto'
alias tree='tree -C'
if hash colour-valgrind 2> /dev/null; then
  alias valgrind="colour-valgrind"
fi
# start with sudo
alias iotop='sudo iotop'
alias dmesg='sudo dmesg'
alias route='sudo route -n'
# other
alias alsamixer='alsamixer -c 0'
alias ping='LANG=en ping -c 6 -i 0.2'
alias sshfs="sshfs -o uid=$(id -u) -o gid=$(id -g)"
alias gdb="gdb -q"
mpv() { command mpv --af=scaletempo "$@" 2>&1 | grep -v 'libva info'; }
dir() { ls -1F "$@" |grep /$; }
gpp() { if [ ${#} -ne 1 ] ; then g++ "$@"; else command g++ "$1" -o "${1/.cpp/}"; chmod +x "${1/.cpp/}" ; fi ;}
if [ -f "$HOME/.nano_starter" ] ; then
  alias nano='$HOME/.nano_starter'
fi

alias bc='xmodmap -e "keycode 91 = period period" && bc -lq; xmodmap -e "keycode 91 = KP_Separator KP_Separator"'
# When starting mutt, set terminal title to mutt
alias mutt='echo -e "\e]0;mutt\a";neomutt'

#========================================
# 	Handy commands
#========================================
alias hl="grep --color=yes -e '^' -e "
alias datum='date "+%d. %b %Y    %T"'
alias reload='source $HOME/.bashrc'
alias mx='chmod a+x'
line() {  head "-$1"  | tail -1; }
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias vimwiki="vim ~/.vimwiki/index.wiki"
alias vimrc="vim ~/.vim/vimrc"
alias g++='gpp'

#-----------------------------
#	Onekeys
#-----------------------------
alias c='clear'
alias d='date'
alias e='echo'
alias f='find'
alias g='wget'
alias h='htop'
alias k='kill'
alias l='less'
alias m='man'
alias n='nano'
alias p='mpv'
alias s='sudo'
alias t='task'
alias v='vlc'
alias x='exit'
alias y='yum'
#-----------------------------
#	Softwaremanagement
#-----------------------------
if [ "$DISTRIBUTION" = "Arch" ] ; then
  alias pacman="sudo pacman"
elif [ "$DISTRIBUTION" = "Ubuntu" ] ; then
  alias apt-get="sudo apt-get"
fi
#-----------------------------
#	Show files & dict.
#-----------------------------
alias LS='ls -l --group-directories-first'
alias ll='ls -hl --color=auto'
alias la='ls -Al'          # show hidden files
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last
alias lm='ls -al |more'    # pipe through 'more'
alias lr='ls -lR'          # recursive ls
alias lw='ll | wc -l'
alias bigest='\du -chs *|sort -hr|head -11'

#-----------------------------
#	cd
#-----------------------------
# Makes directory then moves into it
mkcd() {
    mkdir -p -v "$@"
    cd "$1"
}

#-----------------------------
#	rename files
#-----------------------------
lowercase()  # move filenames to lowercase
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname=${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo "$filename" | tr "[:upper:]" "[:lower:]")
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}

swichfiles()  # Swap 2 filenames around, if they exist
{
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e "$1" ] && echo "swap: $1 does not exist" && return 1
    [ ! -e "$2" ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}


#-----------------------------
#	Processes
#-----------------------------
alias k9="kill -9"
alias ka="killall"
alias kfx="killall firefox xulrunner-bin firefox-bin"
my_ps() { ps "$@" -u "$USER" -o pid,%cpu,%mem,bsdtime,command ; }

#-----------------------------
#       Web
#-----------------------------
TEXTBROWSER=w3m
wp() { $TEXTBROWSER "http://de.wikipedia.org/w/index.php?title=Special:Search&search=$*" ; }
google() { $TEXTBROWSER "http://www.google.de/search?q=$*" ;}
frink_web() { $TEXTBROWSER "http://futureboy.us/fsp/frink.fsp?sourceid=Mozilla-search&fromVal=$*" ;}
dings() { $TEXTBROWSER "http://dict.tu-chemnitz.de/dings.cgi?lang=de&noframes=1&query=$*&optpro=1" ;}

myip () { curl http://api.ipify.org/; echo; }
alias timeupdate='sudo ntpdate -u ptbtime1.ptb.de'

#-----------------------------
#	other
#-----------------------------
# color man
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;33;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[36;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;31;5;2;146m' \
    man "$@"
}

svg2pdf() { inkscape -z -D --file=$1 --export-pdf=${1/.svg/.pdf}; }

rot13() {
	if [ $# = 0 ] ; then
		tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]"
	else
		tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" < $1
	fi
}

# convert a file form iso-8859-1 to utf-8
iso2utf8() {
  name=${1%.*}
  ext=${1##*.}
  iconv -f iso-8859-1 -t utf-8 "$1" > "${name}.utf8.${ext}"
}

wttr()
{
    curl -H "Accept-Language: ${LANG%_*}" wttr.in/"${1:-Munich}"
}

#========================================
# 	Tippos
#========================================
alias cd..="cd .."
alias xs='cd'
alias vf='cd'
alias kk='ll'
alias dgb="gdb -q"
alias gbd="gdb -q"


#========================================
# 	PS1
#========================================
__MY_PROMPT() {
  local exitcode=$?

  local reset_='\['$reset'\]'
  local inv_='\['$inv'\]'
  local lightcyan_='\[\e[2;36m\]'
  local red_='\['$red'\]'
  local lightgreen_='\[\e[2;32m\]'
  local yellow_='\['$yellow'\]'
  local purple_='\['$purple'\]'
  local boldred_='\[\e[1;31m\]'
  local light_='\[\e[2m\]'

  if [ $UID -eq 0 ] ; then invifroot_="$inv_"; fi
  local user="$lightcyan_$invifroot_\u$reset_"
  local time="$lightgreen_\t$reset_"
  local dir="$yellow_\w$reset_"
  local git="$purple_\$(__git_ps1 \" %s\" 2>/dev/null)$reset_"
  local dollar="$red_\$$reset_"
  if [ "$SESSION_TYPE" == "remote/ssh" ]; then
    host="@$boldred_\h$reset_"
  fi
  if [ $exitcode -eq 0 ] ; then
    exitstatuscolor="$light_$exitcode$reset_"
  else
    exitstatuscolor="$red_$exitcode$reset_"
  fi
  PS1="${reset_}[$user$host|$exitstatuscolor|$time $dir$git ]$dollar "
}
PROMPT_DIRTRIM=2

# Test if user is loged in via ssh
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
# many other tests omitted
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=
export GIT_PS1_SHOWUPSTREAM=verbose
export GIT_PS1_SHOWCOLORHINTS=1 # Doesn't work in my PS1 for some reason

#========================================
# 	Run several stuff in background
#========================================
soffice()   { command soffice "$@" & }
firefox()   { command firefox "$@" & }
evince()    { command evince "$@" & }
xpdf()      { command xpdf "$@" & }
gedit()     { command gedit "$@" & }
pluma()     { command pluma "$@" & }
eog()       { command eog "$@" & }
eom()       { command eom "$@" & }
giggle()    { command giggle "$@" 2> /dev/null & }
incognito() { command chromium --incognito "$@" & }

#========================================
# 	KEY BINDINGS
#========================================
bind '"^[7" complete-into-braces'
bind '"^[[21~" "\16ls -l\n"'
bind '"^[[24~" "\16htop\n"'

#========================================
# 	OHTER STUFF
#========================================
alias chromium='cgexec -g memory,cpuset:chrome /usr/bin/chromium'

# if a file .bashrc.<hostname> exists, source it, this way I can create
# host-specific configuration and overwrites
if [ -f "${HOME}/.bashrc.${HOSTNAME}" ] ; then
        source "${HOME}/.bashrc.${HOSTNAME}"
fi

# Must be last, since sourced scripts my add themself as prefix
PROMPT_COMMAND="__MY_PROMPT;${PROMPT_COMMAND}"
