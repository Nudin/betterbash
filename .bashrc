# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
#========================================
#	PATH
#========================================
PATH=$PATH:/usr/games

#========================================
#	Bash-behavior
#========================================
shopt -s cdspell hostcomplete histreedit histverify
if [ $BASH_VERSINFO -eq 4 ] ; then
        shopt -s autocd checkjobs dirspell globstar
fi
CDPATH='$HOME'


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


#========================================
# 	Envoirements
#========================================
export BROWSER="$HOME/Code/browserweiche.sh"
# export JAVA_HOME="/usr/java/jdk1.6.0_03/bin/"
export EDITOR="nano"


#========================================
# Set default values for several commands
#========================================
alias du='du -h --max-depth=1'
alias df='df -h'
alias ls='ls -h --color=auto'
alias grep='grep --color=auto'
alias free="free -m"
alias man="man -P most"
alias pidof='/sbin/pidof'
alias alsamixer='alsamixer -c 0'
alias ping='ping -c 4'
alias dir='dir --color=auto'
#dir() { ls -1F $@ |grep /$; }
alias vdir='vdir --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias tree='tree -C'
alias rm='mv --target-directory=$HOME/.local/share/Trash/files'

#========================================
# 	Complex overwriting
#========================================
alias nano='$HOME/.nano_starter'
alias bc='xmodmap -e "keycode 91 = period period" && bc -lq $HOME/.bc_starter; xmodmap -e "keycode 91 = KP_Delete KP_Separator"'


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
alias h='htop'
alias k='kill'
alias l='less'
alias m='man'
alias n='nano'
alias q='exit'
alias s='sudo'
alias v='vlc'
alias x='exit'
#alias w='wget'
alias y='yum'
#-----------------------------
#	Softwaremanagement
#-----------------------------
alias yumi="sudo yum install --color=auto"
alias yumu="sudo yum update --skip-broken --color=auto"
alias yumc="sudo yum clean all --color=auto"
alias yum="sudo yum --color=auto"
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
function mkcd { # Makes directory then moves into it
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
#	find
#-----------------------------
# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe()
{ find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

# Find a pattern in a set of files and highlight them:
# (needs a recent version of egrep)
function fstr()
{
    OPTIND=1
    local case=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
        i) case="-i " ;;
        *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
    xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more

}
alias findbig='find . -type f -exec ls -s {} \; | sort -h -r | head -5'
#-----------------------------
#	rename
#-----------------------------
function lowercase()  # move filenames to lowercase
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

function swichfiles()  # Swap 2 filenames around, if they exist
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
compress()	# UNTESTET !!!
{
if [ $# -eq 0] ; then
 file='*'
 format=tar.gz
 tofile=${file}.$format
elif [ $# -eq 1] ; then
 file=$1
 format=tar.gz
 tofile=${file}.$format
elif [ $# -eq 2] ; then
 file=$1
 case $2 in
     *.tar.bz2)   format="tar.bz2";;
     *.tar.gz)    format="tar.gz" ;;
     *.bz2)       format="bz2"    ;;
     *.rar)       format="rar"    ;;
     *.gz)        format="gz"     ;;
     *.tar)       format="tar"    ;;
     *.tbz2)      format="tbz2"   ;;
     *.tgz)       format="tgz"    ;;
     *.zip)       format="zip"    ;;
#     *.Z)         format="Z"      ;;
     *.7z)        format="7z"     ;;
     *)           echo "Format nicht unterstützt"; return ;;
 esac
 format_sed=$(echo $format | sed 's/\./\\\./g')
 if [ "$(echo $2 | sed \"s/\.\?$format//g\")" = "" ] ; then
	tofile=${file}.$format
 else
	tofile=$2
 fi
fi
case $format in
   *.tar.bz2)   tar cfvj $tofile $file ;;
   *.tar.gz)    tar cfvz $tofile $file ;;
   *.bz2)       bzip2 -c $file > $tofile ;;
   *.rar)       rar a $tofile $file ;;
   *.gz)        gzip -c $file > $tofile ;;
   *.tar)       tar cfv $tofile $file ;;
   *.tbz2)      tar cfvj $tofile $file ;;
   *.tgz)       tar cfvz $tofile $file ;;
   *.zip)       zip -r $tofile $file ;;
   *.7z)        7za a $tofile $file ;;
esac
}
function extract()      # Handy Extract Program.
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
function ask()          # See 'killps' for example of use.
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
alias kfx="killall firefox"
function my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }
function killps()                 # Kill by process name.
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
#	other
#-----------------------------
alias datum='date "+%d. %b %Y    %T"'
alias reload='source $HOME/.bashrc'
alias mx='chmod a+x'
function repeat()       # Repeat n times command.
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do  # --> C-like syntax
        eval "$@";
    done
}
alias path='echo -e ${PATH//:/\\n}'
alias moto4lin="sudo chmod 777 /dev/ttyACM0; echo AT+MODE=8 > /dev/ttyACM0; sudo moto4lin"
alias Bart='fortune simpsons'
alias bart='fortune simpsons'
line() {  head -$1  | tail -1; }

alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias avidemux2="avidemux2_gtk"
#	(un)mountig floppys
# alias mount_floppy="sudo mount -t vfat /dev/fd0 /media/floppy"
# alias umount_floppy="sudo umount /media/floppy/"

#	(un)mountig zip
# alias mount_zip="sudo /sbin/modprobe ppa; sudo mount -t vfat /dev/sde4 /media/zip/"
# alias umount_zip="sudo umount /media/zip/"

alias 'playflash=vlc $(ls -1t /tmp/Fl* | head -1)'
alias 'pf=vlc $(ls -1t /tmp/Fl* | head -1)'

function rot13() {
	if [ $# = 0 ] ; then
		tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]"
	else
		tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" < $1
	fi
}

function spwd() {
	IFS="/"
	set $PWD
	if test $# -le 3 ; then
		echo "$PWD"
	else
		eval echo \"..\${$(($# - 1))}/\${$#}\"
	fi
}
## returns base pwd (last directory)
function bpwd() {
	echo "${PWD##*/}"
}
myip ()
{
elinks -dump http://checkip.dyndns.org:8245/ | grep "Current IP Address" | cut -d":" -f2 | cut -d" " -f2
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
PS1='[\[\e[2;36m\]\u\[\e[0m\]|\[\e[2;32m\]\t\[\e[0m\] \[\e[33m\]$(spwd)\[\e[0m\] ]\[\e[2;31m\]$\[\e[0m\] '
# Experimentell, mit Anzeige der RAMs
# Anmerkung: das \[|\] ist ein Dirty-Hack
#PS1='\0337\e[0;$(($LINES - 3))r\e[$(($LINES - 2));0H $(echo -n \[; free -o; echo -n \[)\[\0338\][\[\e[2;36m\]\u\[\e[0m\]\[|\]\[\e[2;32m\]\t\[\e[0m\] \[\e[33m\]\W\[\e[0m\] ]\[\e[2;31m\]$\[\e[0m\] '


#start Mouse on konsole:
alias mouse_on="sudo  /sbin/service gpm start"

alias mount_all='sudo mount -a'
alias umount_media='sudo umount /media/Medien'


#========================================
# 	Run several stuff in background
#========================================
function soffice() { command soffice "$@" & }
function firefox() { command firefox "$@" & }
function evince() { command evince "$@" & }
function xpdf() { command xpdf "$@" & }
function gedit() { command gedit "$@" & }
function eog() { command eog "$@" & }
alias nautilus='nautilus . &'

#========================================
# 	Stuff for several Programms
#========================================
#	BOINC
#alias boinc='boinc_client --dir $HOME/.BOINC'
#alias boinc_client='boinc_client --dir $HOME/.BOINC'
#alias boincmgr='cd $HOME/.BOINC;boincmgr'

#	libtrash
# export LD_PRELOAD=/usr/local/lib/libtrash.so 
# alias trash_on="export TRASH_OFF=NO" 
# alias trash_off="export TRASH_OFF=YES"
# alias firefox="LD_PRELOAD= firefox"

#	Jrman
#export PATH=$PATH:/usr/local/jrman-0_4/bin
#export JRMAN_HOME=/usr/local/jrman-0_4

#	Tor
tor()
{
sudo /sbin/service privoxy start
sudo /sbin/service tor start
}


#========================================
# 	OHTER STUFF
#========================================

# SSH zum CIP
STAUFEN="staufen.cip.physik.uni-muenchen.de"
UNIUSR="Michael.Schoenitzer"
alias staufenssh='ssh -l $UNIUSR $STAUFEN'
staufencp()
{
scp $1 $UNIUSR@$STAUFEN:$2
}

# SSH for Fedora:
#export CVS_RSH=ssh
#export CVSROOT=:ext:michael@i18n.redhat.com:/usr/local/CVS


tabmerge() { for ((i=1;i<=$(less $1 | wc -l);i++)); do  echo -n $(less $1 | line $i); echo -en \"	\"; echo $(less $2 | line $i); done }
# Für Skript, hier eigentlich fehl am Platz
printopt() { echo -e "$1\t$2" | fold -s -$(($COLUMNS-20)) | sed 's.^.\t\t.g' | tail -c +2 ; }

