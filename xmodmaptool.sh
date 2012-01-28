
### Read out all available KEYSYMNAMEs ###

name()
 {
  less /usr/include/X11/keysymdef.h | grep ^\#define | tr -s ' ' | awk -F' ' '{ print $2 }' | line $1 | tail -c +4
 }
num()
 {
  less /usr/include/X11/keysymdef.h | grep ^\#define | tr -s ' ' | awk -F' ' '{ print $3 }' | cut -dx -f2 | line $1
 }
char()
 {
  n=$(num $1)
  if [ "$(echo $n | head -c 2 )" = "00" ] ; then
     /usr/bin/printf "\x$(echo $n | tail -c +3)"
  else
     /usr/bin/printf "\u$n"
  fi
 }

for ((i=1;i<2009;i++)) do
  echo -e "$(num $i)\t$(char $i)\t$(name $i)"
done > xmodmap_keysym


### View keyboardlayout printable ###

xmodmap -pke > /tmp/keysym1
for i in $(echo $(xmodmap -pke) | sed 's/keycode //g' | tr -d [0-9] | tr -d = | tr -s ' ') ; do
  j=$(less xmodmap_keysym | grep "\W$i$" | cut -f2 )

  j=$(echo "$j" | tr -d [:cntrl:] ) # Just show printable chars
  if [ "$j" != "" ] ; then
    less /tmp/keysym1 | sed "s/$i/$j/g" > /tmp/keysym2
    if [ $? -eq 0 ] ; then 
	mv /tmp/keysym2 /tmp/keysym1
    else
	rm /tmp/keysym2
    fi
  else
	echo -e "Skipping: $i\t=>\t$j"
  fi
done
less /tmp/keysym1



