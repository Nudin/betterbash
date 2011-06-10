#!/bin/bash
### Propmt String Compiler ##
# Version: 0.1
# Copyright: Michael Schönitzer
# License: Gnu General Public License Version 3 or higher (GPLv3)
#
# You can write youre wished prompt string in a better readable way and
# then generate the valid prompt string with this script.

 black='\\[\\e[30m\\]';        red='\\[\\e[31m\\]'
 green='\\[\\e[32m\\]';        yellow='\\[\\e[33m\\]'
 blue='\\[\\e[34m\\]';         purple='\\[\\e[35m\\]'
 cyan='\\[\\e[36m\\]';         white='\\[\\e[37m\\]'

 blackb='\\[\\e[40m\\]';       redb='\\[\\e[41m\\]'
 greenb='\\[\\e[42m\\]';       yellowb='\\[\\e[43m\\]'
 blueb='\\[\\e[44m\\]';        purpleb='\\[\\e[45m\\]'
 cyanb='\\[\\e[46m\\]';        whiteb='\\[\\e[47m\\]'

 bold='\\[\\e[1m\\]';  boldoff='\\[\\e[21m\\]'
 light='\\[\\e[2m\\]'; lightoff='\\[\\e[22m\\]'
 it='\\[\\e[3m\\]';    itoff='\\[\\e[23m\\]'
 ul='\\[\\e[4m\\]';    uloff='\\[\\e[24m\\]'
 inv='\\[\\e[7m\\]';   invoff='\\[\\e[27m\\]'

 reset='\\[\\e[0m\\]'


if [ $# -ne 1 -o ! -f "$1" ] ; then
 echo -e "$red$bold Error: Bitte Datei angeben $reset"
fi

generatedPS=$(cat $1 |
	# Fontcolors
	## Syntax: #<color>
	sed "s/#black/$black/g" |
	sed "s/#red/$red/g" |
	sed "s/#green/$green/g" |
	sed "s/#yellow/$yellow/g" |
	sed "s/#blue/$blue/g" |
	sed "s/#purple/$purple/g" |
	sed "s/#cyan/$cyan/g" |
	sed "s/#white/$white/g" |

	# Backgroundcolors
	## Syntax: #bg:<color>
	sed "s/#bg:black/$blackb/g" |
	sed "s/#bg:red/$redb/g" |
	sed "s/#bg:green/$greenb/g" |
	sed "s/#bg:yellow/$yellowb/g" |
	sed "s/#bg:blue/$blueb/g" |
	sed "s/#bg:purple/$purpleb/g" |
	sed "s/#bg:cyan/$cyanb/g" |
	sed "s/#bg:white/$whiteb/g" |

	# Fontstyles
	## Syntax: #<style>
	sed "s/#bold/$bold/g" |
	sed "s/#light/$light/g" |
	sed "s/#it/$it/g" |
	sed "s/#ul/$ul/g" |
	sed "s/#inv/$inv/g" |

	# Disable fontstyles
	## Syntax: #-<style>
	sed "s/#-bold/$boldoff/g" |
	sed "s/#-light/$lightoff/g" |
	sed "s/#-it/$itoff/g" |
	sed "s/#-ul/$uloff/g" |
	sed "s/#-inv/$invoff/g" |

	# Disable all
	## Syntax: #-- OR #reset
	sed "s/#--/$reset/g" |
	sed "s/#reset/$reset/g" |

	sed 's/^ //g' |			# Remove spaces at begining
	sed 's/\([^\]\) \+/\1/g' |	# Remove spaces in lines
	sed 's/\\ / /g' |		# Extract saved spaces

	sed 's/\\g/$(__git_ps1 " %s")/g' |	# Git PS
	sed 's/\\g/$(__git_ps1 " %s")/g' |	# alt

	tr -d '\n' |		# Remove newlines
	sed 's/\\n/\n/g'	# Extract saved lines
)
echo "$generatedPS"

#echo -e "$generatedPS" 1>&2


## To fix/add: ##
# - read from stdin
# - interactive mode
# - preview
# - commands for \.-stuf?
# - command for $? and similar?
# - tricks like moving, etc
# - colornames <-> systemscolors
# - …
