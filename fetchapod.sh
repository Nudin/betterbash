#!/bin/bash
# Todo:
# (U)rxvt fixen
# Andere Terminal supporten
# Andere Nachrichtenkanäle supporten
## conkey
## root-tail
# Verallgemeinern
# Profile, etc (in Instaler) inculden
# veröffentlichen
# mehr

APOD_DIR=/home/$USER/apod
gnote=1
w3m=0
links=1
term=terminator
gnotefile="71a2ba1e-fa32-4ea1-9275-57f5e976a9ca.note"

line() {  head -$1  | tail -1; }

# Test if we have an different date
if [ "$1" = "" ]; then
    date=$(date -d'5 hours ago' +'%y%m%d')
else
    date=$1
fi
tempfile="$APOD_DIR/apod_$date.html"

# Check if already up to date
test2=$(ls $APOD_DIR | fgrep "apod_$date." | wc -l)
if [  "$test2" = "0" -o "$2" = "force" ]; then				###

rm $APOD_DIR/apod_*

# Download
curl --silent http://antwrp.gsfc.nasa.gov/apod/ap$date.html > $tempfile

ext=$(cat $tempfile | awk '/[Ii][Mm][Gg] [Ss][Rr][Cc]/' | sed -e 's/<IMG SRC=\"/http:\/\/antwrp.gsfc.nasa.gov\/apod\//g' | awk ' {split($0,arr,"\"") ; print $1}' | awk ' {print(substr ($1,length($1)-3,3)) }')
# ext=$(cat $tempfile | awk  '/[Ii][Mm][Gg] [Ss][Rr][Cc]/'| sed -e 's/<IMG SRC=\"/http:\/\/antwrp.gsfc.nasa.gov\/apod\//g' | awk ' {print(substr ($0,length($0)-3 ,3 ))}')
src=$(cat $tempfile | awk '/[Ii][Mm][Gg] [Ss][Rr][Cc]/' | sed -e 's/<IMG SRC=\"/http:\/\/antwrp.gsfc.nasa.gov\/apod\//g' | awk ' {split($0,arr,"\"") ; print $1}' | awk ' {print(substr ($1,1,length($1)-5))}' )
#src=$(cat $tempfile | awk  '/[Ii][Mm][Gg] [Ss][Rr][Cc]/'| sed -e 's/<IMG SRC=\"/http:\/\/antwrp.gsfc.nasa.gov\/apod\//g' | awk ' {print(substr ($0,1,length($0)-5))}')
img=$(echo $src.$ext)

dest=$APOD_DIR/apod_$date.$ext

curl --silent $img > $dest

Xdim=$(wmctrl -d | head -1 | cut -d' ' -f5 | tr 'x' '/' | sed 's/$/*100/g' | \bc -l | cut -d. -f1)	#Display-Verhältniss*10
picdim=$(identify $dest | cut -d' ' -f 3 | tr 'x' '/' | sed 's/$/*100/g' | \bc -l | cut -d. -f1)	#Bild-Verhältniss*10
picdimx=$(identify $dest | cut -d' ' -f 3 | cut -dx -f1)
picdimy=$(identify $dest | cut -d' ' -f 3 | cut -dx -f2)

if [ $Xdim -eq $picdim ] ; then
	# Get the average colors of the image
	identify -verbose $dest | grep mean > $APOD_DIR/mean.tmp
	if [ $(cat $APOD_DIR/mean.tmp | wc -l ) -eq 1 ] ; then # Gray
	  red=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  red=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  green=$red
	  blue=$red
	else
  	  red=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | line 1 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  red=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | line 1 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  green=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | line 2 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  green=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | line 2 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  blue=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | line 3 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  blue=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | line 3 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	fi
	rm $APOD_DIR/mean.tmp

elif [ $Xdim -gt $picdim ] ; then	# Höher als der Bildschirm
	echo gt
	identify -verbose -crop 10x$picdimy+0+0 $dest | grep mean > $APOD_DIR/mean.tmp
	identify -verbose -crop 10x$picdimy+0+$(expr $picdimx "-" 10) $dest | grep mean > $APOD_DIR/mean2.tmp
	if [ $(cat $APOD_DIR/mean.tmp | wc -l ) -eq 1 ] ; then # Gray
#	  red=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  red=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
	  green=$red
	  blue=$red
	  red2=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean2.tmp | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  red2=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean2.tmp | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
          green2=$red2
          blue2=$red2
	else # RGB-Bild
  	  red=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | line 1 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  red=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | line 1 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  green=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | line 2 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  green=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | line 2 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  blue=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | line 3 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  blue=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | line 3 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)

	  red2=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean2.tmp | line 1 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  red2=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean2.tmp | line 1 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  green2=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean2.tmp | line 2 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  green2=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean2.tmp | line 2 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  blue2=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean2.tmp | line 3 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  blue2=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean2.tmp | line 3 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	fi
	rm $APOD_DIR/mean.tmp
	rm $APOD_DIR/mean2.tmp

elif [ $Xdim -lt $picdim ] ; then	# Breiter als der Bildschirm
	identify -verbose -crop ${picdimx}x10+0+0 $dest | grep mean > $APOD_DIR/mean.tmp # Oberer-Rand
	identify -verbose -crop ${picdimx}x10+0+$(expr $picdimy "-" 10) $dest | grep mean > $APOD_DIR/mean2.tmp #Unterer Rand
	if [ $(cat $APOD_DIR/mean.tmp | wc -l ) -eq 1 ] ; then # Gray
#	  red=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  red=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
	  green=$red
	  blue=$red
#	  red2=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean2.tmp | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  red2=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean2.tmp | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
	  green2=$red2
	  blue2=$red2
	else # RGB-Bild
#	  red=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | line 1 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
  	  red=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | line 1 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  green=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | line 2 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  green=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | line 2 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  blue=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean.tmp | line 3 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  blue=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean.tmp | line 3 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))

#	  red2=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean2.tmp | line 1 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  red2=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean2.tmp | line 1 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  green2=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean2.tmp | line 2 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  green2=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean2.tmp | line 2 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
#	  blue2=$(echo "obase=16; $(printf "%.0f\n" $(cat $APOD_DIR/mean2.tmp | line 3 | tr -s ' ' | cut -d' ' -f3 | tr . ,))" | \bc)
	  blue2=$(printf "%02x" $(printf "%02.0f\n" $(cat $APOD_DIR/mean2.tmp | line 3 | tr -s ' ' | cut -d' ' -f3 | tr . ,)))
	fi
	rm $APOD_DIR/mean.tmp
	rm $APOD_DIR/mean2.tmp
fi

kde=$(ps -A | grep 'kde'| wc -l)
gnome=$(ps -A | grep 'gnome' | wc -l)
if [ "$kde" != "0" ]; then
	dcop kdesktop KBackgroundIface 'setWallpaper(QString,int)' $dest 6
	echo "background image updated"
fi

if [ "$gnome" != "0" ]; then
	gconftool-2 --type=string --set /desktop/gnome/background/picture_options scaled
	gconftool-2 --type=string --set /desktop/gnome/background/picture_filename  $dest
	gconftool-2 --type=string --set /desktop/gnome/background/primary_color \#$red$green$blue
	if [ $Xdim -eq $picdim ] ; then
		gconftool-2 --type=string --set /desktop/gnome/background/color_shading_type solid
	elif [ $Xdim -gt $picdim ] ; then
		echo horizontal
		gconftool-2 --type=string --set /desktop/gnome/background/secondary_color \#${red2}${green2}${blue2}
		gconftool-2 --type=string --set /desktop/gnome/background/color_shading_type horizontal-gradient
	elif [ $Xdim -lt $picdim ] ; then
		echo vertical
		gconftool-2 --type=string --set /desktop/gnome/background/secondary_color \#${red2}${green2}${blue2}
		gconftool-2 --type=string --set /desktop/gnome/background/color_shading_type vertical-gradient
	fi
	echo "background image updated"
fi

else
 echo "Already up to date"
 if [ $(wmctrl -l | grep APOD | wc -l ) -ne 0 ] ; then exit; fi
fi

#### Now lets show the text ###

#Gnote - not working if gnote is already running... :(
if [ $gnote -eq 1 ] ; then
	cat $APOD_DIR/notea > /home/michi/.gnote/$gnotefile # old: $HOME/Desktop/apod_description.html
	cat $tempfile | sed -n '/<b> Explanation:/,/<p> <center>/ p' | sed -n '2,$ p' | sed -e '$d' | sed -e '$d' | tr '\n' '$' | sed 's/\$\$/§/g' | tr '$' ' ' | tr '§' '\n'  >> /home/michi/.gnote/$gnotefile
	cat $APOD_DIR/noteb >> /home/michi/.gnote/$gnotefile
fi
#W3M
if [ $w3m -eq 1 ] ; then
	echo -e '<HTML>\n <HEAD><TITLE>APOD</TITLE></HEAD>\n <BODY>' > $APOD_DIR/apod_description.html
	curl --silent http://antwrp.gsfc.nasa.gov/apod/ap$date.html | sed -n '/<b> Explanation:/,/<p> <center>/ p' | sed -n '2,$ p' | sed -e '$d' | sed -e '$d' >> $APOD_DIR/apod_description.html
	echo -e '</BODY> </HTML>' >>  $APOD_DIR/apod_description.html
#	gnome-terminal -t APOD --geometry=100x10 --profile=test -e "w3m $APOD_DIR/apod_description.html"
	terminator -b -p widget -T APOD -e "w3m $APOD_DIR/apod_description.html" &
        while [ $(wmctrl -l | grep APOD | wc -l ) -eq 0 ] ; do sleep 0.3; done
	wmctrl -F -r APOD -e '0,900,900,600,200'		# Größe und Position setzten
        wmctrl -F -r APOD -b add,skip_taskbar	# Nicht in die Taskleiste
        wmctrl -F -r APOD -b add,below		# In Hintergrund & auf alle Desktops
        wmctrl -F -r APOD -b add,sticky		# Auf alle Desktops
fi
#links
if [ $links -eq 1 ] ; then
	linksconfig='set terminal.xterm.transparency = 1 set document.colors.use_document_colors = 1 set ui.show_title_bar = 0 set ui.show_status_bar = 0 set ui.leds.enable = 0 set document.browse.links.active_link.enable_color = 1'
        echo -e '<HTML>\n <HEAD><TITLE>APOD</TITLE></HEAD>\n <BODY>' > $APOD_DIR/apod_description.html
	curl --silent http://antwrp.gsfc.nasa.gov/apod/ap$date.html | sed -n '/<b> Explanation:/,/<p> <center>/ p' | sed -n '2,$ p' | sed -e '$d' | sed -e '$d' >> $APOD_DIR/apod_description.html
        echo -e '</BODY> </HTML>' >>  $APOD_DIR/apod_description.html
	if [ "$term" = "gnome" ] ; then
		gnome-terminal -t APOD --geometry=100x10 --profile=test -e "links -eval "$linksconfig" $APOD_DIR/apod_description.html"
	elif [ "$term" = "terminator" ] ; then
		terminator -b -p widget -T APOD -e "links -eval \"$linksconfig\" $APOD_DIR/apod_description.html" &
	elif [ "$term" = "urxvt" ] ; then
		urxvt -title APOD -e links -eval "$linksconfig" $APOD_DIR/apod_description.html &
	elif [ "$term" = "rxvt" ] ; then
		rxvt ++scrollBar --inheritPixmap -title APOD -e links -eval "$linksconfig" $APOD_DIR/apod_description.html &
	else
		echo "Sorry, not yet implemetated: $term"
	fi
        while [ $(wmctrl -l | grep APOD | wc -l ) -eq 0 ] ; do sleep 0.3; done
	if [ "$term" = "urxvt" ] ; then F=""; else F="-F" ; fi	# Fix for urxterm
        wmctrl $F -r APOD -e '0,900,900,600,200'                # Größe und Position setzten
        wmctrl $F -r APOD -b add,skip_taskbar	# Nicht in die Taskleiste
        wmctrl $F -r APOD -b add,below		# In Hintergrund & auf alle Desktops
        wmctrl $F -r APOD -b add,sticky		# Auf alle Desktops
fi

