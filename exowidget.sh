#!/bin/bash

sleep 20
/home/michi/Code/exoplanets/exo.sh -s > /tmp/exoplantes;
#root-tail --reload 5 "/home/michi/Code/exoplanets/exo.sh > /tmp/exoplantes" -f -g 100x40+1160+40 -font 7x14 /tmp/exoplantes
# We have /home/michi/Code/exoplanets/exo.sh in our crontab
conky -f "DejaVu Sans:size=8" -a top_left -x 1200 -y 10 -d -u 3600 -t "$(cat /tmp/exoplantes)"
