#!/bin/bash
# VERSION 0.1
# PROBABLY BUGY!?
#set -x

# Ask user for Key (1-26)
insertkey()
   {
   ABC=({A..Z})
   abc=({a..z})
   
   read -s -p "Bitte Schlüßel (1-26) eingeben: " -n 2 i; echo 1>&2
   
   echo $i | grep -vq -e '^[0-1]\?[0-9]$' -e '^[0-2][0-5]$' && \
   				echo "Ungültiger Schlüssel" && exit
   return $i
   }

# Encrypt string in $* using ROTn
crypt()
   {
   insertkey
   i=$?
   (((j=i-1)))
   s=${abc[$i]};	S=${ABC[$i]}
   e=${abc[$j]};	E=${ABC[$j]}
   echo $* | tr "a-mn-zA-MN-Z" "$s-za-${e}$S-ZA-$E"
   }

# Decrypt string in $* using ROTn
decrypt()
   {
   insertkey
   i=$?
   #i=$1
   (((j=i-1)))
   s=${abc[$i]};	S=${ABC[$i]}
   e=${abc[$j]};	E=${ABC[$j]}
   echo $* | tr "$s-za-$e$S-ZA-$E" "a-mn-zA-MN-Z"
   }

### Start of Script ###

# User wants to add new task
if [ "$1" = "add" ] ; then
   cypher=$(eval crypt "\$$#")
   echo Verschlüsselt:
   echo "$cypher"
   task add +crypted "[C] $cypher"
#User wants to read taskdescription
elif [ "$2" = "show" ] ; then 
   cypher=$(task "$1" | grep Description | head -1 | tail -c +17)
   dec=$(decrypt "$cypher")
   echo -e "---\n$dec"
#User wants to read full taskinfo
elif [ "$2" = "info" ] ; then
   cypher=$(task "$1" | grep Description | head -1 | tail -c +17)
   dec=$(decrypt "$cypher")
   task info $1 | sed "s/\[C\] $cypher/$dec/g"
# only for tests
else
   cypher=$(crypt "test")
   echo "$cypher"
   decrypt "$cypher"
fi

