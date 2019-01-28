#!/bin/bash
if ps -A | \grep -c xulrunner ; then
    firefox4 $*
elif ps -A | \grep -cs chrome ; then
    google-chrome $*
elif ps -A | \grep -c firefox ; then
     firefox $*
else
     google-chrome $*
fi

