# .bashrc

# Source global definition
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
#========================================
#	Bash-behavior
#========================================
shopt -s cdspell hostcomplete histreedit histverify checkwinsize
if [ $BASH_VERSINFO -eq 4 ] ; then
        shopt -s autocd checkjobs dirspell globstar
fi
#CDPATH='$HOME' don't work well with autocd
#Configure history
HISTCONTROL=erasedups:ignorespace
export HISTSIZE=50000
export HISTFILESIZE=50000
# Configure hh
export HH_CONFIG=hicolor
bind '"\e\C-r": "\C-a hh \C-j"'
#load bash-completion on ubuntu, git-promt on arch
if uname -r | grep Ubuntu > /dev/null ; then
	export DISTRIBUTION=Ubuntu
	source /etc/bash_completion
elif uname -r | grep -e ARCH -e grsec > /dev/null ; then
    source /usr/share/git/completion/git-prompt.sh
	export DISTRIBUTION=Arch
elif uname -r | grep fc > /dev/null ; then
    export DISTRIBUTION=Fedora
fi
# bashmarks
if [ -f ~/.local/bin/bashmarks.sh ] ; then
   source ~/.local/bin/bashmarks.sh
fi

#start Mouse on konsole:
alias mouse_on="sudo szstemctl start gpm"

# Using this, aliases will work with sudo
alias sudo='sudo '

#========================================
#	ANSI-Colors for Bash
#========================================
 black='\e[30m'; 	red='\e[31m'
 green='\e[32m';	yellow='\e[33m'
 blue='\e[34m';		purple='\e[35m'
 cyan='\e[36m';		white='\e[37m'

 blackb='\e[40m'; 	redb='\e[41m'
 greenb='\e[42m';	yellowb='\e[43m'
 blueb='\e[44m';	purpleb='\e[45m'
 cyanb='\e[46m';	whiteb='\e[47m'

 bold='\e[1m';	boldoff='\e[21m'
 light='\e[2m';	lightoff='\e[22m'
 it='\e[3m';	itoff='\e[23m'
 ul='\e[4m';	uloff='\e[24m'
 inv='\e[7m';	invoff='\e[27m'

 reset='\e[0m'

# === to set Window-title ===
settitle() {
    printf "\033]0;$1\007"
}

#========================================
# 	Envoirements
#========================================
export BROWSER="$HOME/Code/browserweiche.sh"
# export JAVA_HOME="/usr/java/jdk1.6.0_03/bin/"
export EDITOR="nano"
export DIFFPROG=meld

#========================================
# Set default values for several commands
#========================================
# human readable sizes
alias du='du -h --max-depth=1'
alias df='df -h'
alias free="free -m"
# turn on color
alias ls='ls -h --color=always'
alias grep='grep --color=always'
alias fgrep='fgrep --color=always'
alias egrep='egrep --color=always'
alias tree='tree -C'

#eval $(dircolors -b)
#if  most 2>/dev/null ; then
#	alias man="man -P most"
#fi

# other
alias alsamixer='alsamixer -c 0'
alias ping='ping -c 4'
alias mplayer='mplayer -nolirc'
alias mpv='mpv --af=scaletempo'
export LESSOPEN="|$HOME/git/betterbash/mylesspipe.sh %s"
export LESS=' -R '
alias vi='vim'
alias iotop='sudo iotop'
alias dmesg='sudo dmesg'

#========================================
# 	Complex overwriting
#========================================
dir() { ls -1F $@ |grep /$; }
gpp() { if [ ${#} -ne 1 ] ; then g++ $*; else command g++ $1 -o ${1/.cpp/}; chmod +x ${1/.cpp/} ; fi ;}
alias g++='gpp'
alias nano='$HOME/.nano_starter'
alias bc='xmodmap -e "keycode 91 = period period" && bc -lq; xmodmap -e "keycode 91 = KP_Separator KP_Separator"'
export BC_ENV_ARGS=$HOME/.bc_starter
alias shred='echo "Zyclen:"; read n; shred -n $n -u'

#========================================
# 	own functions/commands
#========================================
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
alias p='mplayer'
alias q='exit'
alias s='sudo'
alias t='task'
alias v='vlc'
alias x='exit'
alias w='wget'
alias y='yum'
#-----------------------------
#	Softwaremanagement
#-----------------------------
if [ "$DISTRIBUTION" = "Arch" ] ; then
  alias inst="sudo \pacman --needed -S"
  alias upgrade="yaourt -Syua"
  alias pacman="sudo pacman"
elif [ "$DISTRIBUTION" = "Ubuntu" ] ; then
  alias inst="sudo apt-get install"
elif [ "$DISTRIBUTION" = "Fedora" ] ; then
  alias yumi="sudo nice yum install --color=auto"
  alias yumu="sudo nice yum update --skip-broken --color=auto"
  alias yumc="sudo nice yum clean all --color=auto"
  alias yum="sudo nice yum --color=auto"
fi
#-----------------------------
#	Show files & dict.
#-----------------------------
alias LS='ls -l --group-directories-first'
alias ll='ls -hl --color=always'
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
mkcd() { # Makes directory then moves into it
    mkdir -p -v $1
    cd $1
}
alias texte='cd $HOME/Eigene Texte'
alias downloads='cd $HOME/Downloads'
alias books='cd $HOME/E-Books'
alias images='cd $HOME/Bilder'
alias tv='cd $HOME/Videos/TV'
alias localhost='cd /var/www'

#-----------------------------
#	rename
#-----------------------------
bulkmv()
{

if [ "$1" = "-w" ] ; then
 for((i=2;i<=${#};i++)); do
   file=$( eval echo \${$i} ) 
   mv "$file" "$(echo $file | sed 's/^_*//; s/f_r/für/g; s/^___+//; s/__/ - /g; s/_/ /g')"
 done
else
 for((i=3;i<=${#};i++)); do
 local IFS="
"
 file=$( eval echo \${$i} )
  if [ "$1" = "-c" ] ; then
    mv "$file" "$(echo $file | eval $2)"
  elif [ "$1" = "-s" ] ; then
    mv "$file" $(echo $file | sed "s/$2/g")
  elif [ "$1" = "-ct" ] ; then
    mv "$file" "$(echo $file | head -c -$2)"
  elif [ "$1" = "-ch" ] ; then
    mv "$file" "$(echo $file | tail -c +$(expr $2 \+ 1))"
  fi
 done
fi
}

lowercase()  # move filenames to lowercase
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo $filename | tr A-Z a-z)
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
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}
#-----------------------------
#	Compression
#-----------------------------
compress()	# not tested enough
{
if [ $# -eq 0 ] ; then
 file='*'
 format=tar.gz
 tofile=${file}.$format
elif [ $# -eq 1 ] ; then
 file=$1
 format=tar.gz
 tofile=${file}.$format
elif [ $# -eq 2 ] ; then
 file=$1
 case $2 in
     *.tar.bz2)   format="tar.bz2";;
     *.tar.gz)    format="tar.gz" ;;
     *.bz2)       format="bz2"    ;;
     *.gz)        format="gz"     ;;
     *.rar)       format="rar"    ;;
     *.tar)       format="tar"    ;;
     *.tbz2)      format="tbz2"   ;;
     *.tgz)       format="tgz"    ;;
     *.zip)       format="zip"    ;;
#     *.Z)         format="Z"      ;;
     *.7z)        format="7z"     ;;
     *)           echo "Format nicht unterstützt"; return ;;
 esac
 format_sed=$(echo $format | sed 's/\./\\\./g')
 s=$(echo $2 | sed "s/\.\?$format//g")
 if [ "$s" = "" ] ; then
	tofile=${file}.$format
 else
	tofile=$2
 fi
fi
case $format in
   tar.bz2)   tar cfvj $tofile $file ;;
   tar.gz)    tar cfvz $tofile $file ;;
   bz2)       bzip2 -c $file > $tofile ;;
   rar)       rar a $tofile $file ;;
   gz)        gzip -c $file > $tofile ;;
   tar)       tar cfv $tofile $file ;;
   tbz2)      tar cfvj $tofile $file ;;
   tgz)       tar cfvz $tofile $file ;;
   zip)       zip -r $tofile $file ;;
   7z)        7za a $tofile $file ;;
esac
}
extract()      # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
#-----------------------------
#	Interaction
#-----------------------------
ask()          # See 'killps' for example of use.
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}
#-----------------------------
#	Processes
#-----------------------------
alias k9="kill -9"
alias ka="killall"
alias kfx="killall firefox xulrunner-bin firefox-bin"
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
killps()                 # Kill by process name.
{
    local pid pname sig="-TERM"   # Default signal.
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: killps [-SIGNAL] pattern"
        return;
    fi
    if [ $# = 2 ]; then sig=$1; shift; fi

    for pid in $(ps -A -o pid,comm | grep $1 | sed 's.^ ..g' | cut -d' ' -f1) ; do
        pname=$(ps p $pid -o comm | tail -1)
        pusr=$(ps p $pid -o user | tail -1)
        if ask "Kill process $pid <$pname> ($pusr) with signal $sig?"
            then kill $sig $pid
        fi
    done
}
#-----------------------------
#       Web
#-----------------------------
TEXTBROWSER=w3m
wp() { $TEXTBROWSER "http://de.wikipedia.org/w/index.php?title=Special:Search&search=$*" ; }
google() { $TEXTBROWSER "http://www.google.de/search?q=$*" ;}
frink_web() { $TEXTBROWSER "http://futureboy.us/fsp/frink.fsp?sourceid=Mozilla-search&fromVal=$*" ;}
dings() { $TEXTBROWSER "http://dict.tu-chemnitz.de/dings.cgi?lang=de&noframes=1&query=$*&optpro=1" ;}
myip ()
{
elinks -dump http://checkip.dyndns.org:8245/ | grep "Current IP Address" | cut -d":" -f2 | cut -d" " -f2
}
alias timeupdate='sudo ntpdate -u ptbtime1.ptb.de'

#-----------------------------
#	other
#-----------------------------
#alias fast264='mplayer -lavdopts skiploopfilter=all'
#alias superfast264='mplayer -lavdopts skipframe=nonref:skiploopfilter=all'
alias addon-sdk="cd /opt/addon-sdk && source bin/activate; cd -"
alias datum='date "+%d. %b %Y    %T"'
alias reload='source $HOME/.bashrc'
alias mx='chmod a+x'
repeat()       # Repeat n times command.
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do
        eval "$@";
    done
}
alias bart='fortune simpsons'
line() {  head -$1  | tail -1; }

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

mpf() {
pids=$(pidof firefox chromium plugin-container gtk-gnash npviewer.bin | tr \  ,)
#echo $pids
files="$(ls -lQ $(eval echo /proc/{$pids\,}/fd/*) 2>/dev/null \
	| grep '[^a-z]/tmp/'  | grep '(deleted)' \
	| cut -d\" -f2)"
#echo $files
#mplayer $files "$@"
\mpv --title="mpf" --af=scaletempo "$@" $files
#mpv "$@" $files
}
svg2pdf() { inkscape -z -D --file=$1 --export-pdf=${1/.svg/.pdf}; }

rot13() {
	if [ $# = 0 ] ; then
		tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]"
	else
		tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" < $1
	fi
}


spwd() {
        npwd=${PWD/$HOME/\/@}
        local IFS="/"
        set $npwd
        if test $# -le 3 ; then
                echo "${npwd/\/@/~}"
        else
                eval echo \"..\${$(($# - 1))/\/@/~}/\${$#}\"
        fi
}
## returns base pwd (last directory)
bpwd() {
	echo "${PWD##*/}"
}
# convert a file form iso-8859-1 to utf-8
iso2utf8() {
  name=${1%.*}
  ext=${1##*.}
  iconv -f iso-8859-1 -t utf-8 "$1" > "${name}.utf8.${ext}"
}

#========================================
# 	Tippos
#========================================
alias cd..="cd .."
alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'


#========================================
# 		PS1
#========================================
#Format the command line
# export PS1="[\\u|\\t \\W ]$ "
# Colorised:
#PS1='[\[\e[2;36m\]\u\[\e[0m\]|\[\e[2;32m\]\t\[\e[0m\] \[\e[33m\]\W\[\e[0m\] ]\[\e[2;31m\]$\[\e[0m\] '
PROMPT_COMMAND="exitstatus=\$?;$PROMPT_COMMAND" #;history -a; history -r
#export PS1='[\[\e[2;36m\]$(if [ $UID -eq 0 ] ; then echo \[\e[7m\]; fi)\u\[\e[31m\]$(usr="$(who -m | head -1 | grep $USER | cut -d \( -f2 | tr -d \))"; if [ "$usr" != ":0.0" -a "$usr" != ":0" -a "$usr" != "" ] ; then echo @\h; fi)\[\e[0m\]|\[\e[31m\]${exitstatus/0/\[\e[0m\]\[\e[2m\]0}\[\e[0m\]|\[\e[2;32m\]\t\[\e[0m\] \[\e[33m\]$(spwd)\[\e[0;35m\]$(__git_ps1 " %s" 2>/dev/null)\[\e[0m\] ]\[\e[2;31m\]\$\[\e[0m\] '
reset_='\['$reset'\]'
inv_='\['$inv'\]'
lightcyan_='\[\e[2;36m\]'
red_='\['$red'\]'
lightgreen_='\[\e[2;32m\]'
yellow_='\['$yellow'\]'
purple_='\['$purple'\]'
boldred_='\[\e[1;31m\]'
isssh() {
  usr="$(who -m | head -1 | grep $USER | cut -d \( -f2 | tr -d \))"
  [ "$usr" != ":0.0" -a "$usr" != ":0" -a "$usr" != "" ]
  }
PS1="[$lightcyan_\$(if [ \$UID -eq 0 ] ; then echo $inv_; fi)\u$reset_\
\$(if isssh ; then echo -e '@$boldred_\h$reset_'; fi)\
|\
$red_\${exitstatus/0/$reset_\\[\\e[2m\\]0}$reset_|\
$lightgreen_\t$reset_ \
$yellow_\$(spwd)$reset_\
$purple_\$(__git_ps1 \" %s\" 2>/dev/null)$reset_\
 ]$red_\$$reset_ "
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
# Experimentell, mit Anzeige der RAMs
# Anmerkung: das \[|\] ist ein Dirty-Hack
#PS1='\0337\e[0;$(($LINES - 3))r\e[$(($LINES - 2));0H $(echo -n \[; free -o; echo -n \[)\[\0338\][\[\e[2;36m\]\u\[\e[0m\]\[|\]\[\e[2;32m\]\t\[\e[0m\] \[\e[33m\]\W\[\e[0m\] ]\[\e[2;31m\]$\[\e[0m\] '


#========================================
# 	Run several stuff in background
#========================================
soffice()	{ command soffice "$@" & }
firefox()	{ command firefox "$@" & }
evince()	{ command evince "$@" & }
xpdf()	{ command xpdf "$@" & }
gedit()	{ command gedit "$@" & }
#pluma()	{ command pluma "$@" & }
eog()	{ command eog "$@" & }
eom()	{ command eom "$@" & }
giggle()	{ command giggle "$@" & }
chrome()	{ command google-chrome "$@" & }
incognito()	{ command google-chrome --incognito "$@" & }
#alias nautilus='nautilus . &'

#========================================
# 	Stuff for several Programms
#========================================
#	libtrash
# export LD_PRELOAD=/usr/local/lib/libtrash.so 
# alias trash_on="export TRASH_OFF=NO" 
# alias trash_off="export TRASH_OFF=YES"
# alias firefox="LD_PRELOAD= firefox"


#========================================
# 	OHTER STUFF
#========================================

# SSH zum CIP
STAUFEN="staufen.cip.physik.uni-muenchen.de"
UNIUSR="Michael.Schoenitzer"
alias staufenssh='ssh -l $UNIUSR $STAUFEN'
alias usmssh="ssh -l bachstud7 -X cranach.usm.uni-muenchen.de"
staufencp()
{
scp $1 $UNIUSR@$STAUFEN:${2:-.}
}
staufenget()
{
scp $UNIUSR@$STAUFEN:$1 ${2:-.}
}
alias staufencmd='ssh -f -X -l $UNIUSR $STAUFEN'


tabmerge() { for ((i=1;i<=$(cat $1 | wc -l);i++)); do  echo -n $(cat $1 | line $i); echo -en \"	\"; echo $(cat $2 | line $i); done }
# Für Skript, hier eigentlich fehl am Platz
printopt() { echo -e "$1\t$2" | fold -s -$(($COLUMNS-20)) | sed 's.^.\t\t.g' | tail -c +2 ; }


alias chromium='cgexec -g memory,cpuset:chrome /usr/bin/chromium'
