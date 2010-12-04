#!/bin/bash

declare -a doc_names
declare -a doc_arguments
declare -a doc_description
doc_names[0]="MBash"
doc_arguments[0]="-"
doc_description[0]="Some cool tools for bash-scripting. This toolkit was written completly in bash. Written by Michael Schönitzer. Work ongoing, stay tuned."

nl="
"

doc_names[$(echo ${#doc_names[*]})]="doc_add"
doc_arguments[$(echo ${#doc_arguments[*]})]="name arguments description"
doc_description[$(echo ${#doc_description[*]})]="Add a function to the internal doc"
doc_add()
 {
 doc_names[$(echo ${#doc_names[*]})]="$1"
 doc_arguments[$(echo ${#doc_arguments[*]})]="$2"
 doc_description[$(echo ${#doc_description[*]})]="$3"
 }

doc_add "printopt" "argument description" "Prints the description of an argument out nice formated."
printopt()
 {
 echo -e "$1\t$2" | fold -s -$(($COLUMNS-20)) | sed 's.^.\t\t.g' | tail -c +2 ;
 }

doc_add "line" "number" "Reads stdin and gives out the line numbered"
line()
 {
 head -$1  | tail -1;
 }

doc_add "doc_print" "-" "Print's out the auto-generated doc."
doc_print()
  {
  for((i=0;i<${#doc_names[*]};i++)); do
  	printopt "Name\t" "${doc_names[$i]}"
	printopt "Arguments:" "${doc_arguments[$i]}"
	printopt "Description:" "${doc_description[$i]}"
  	echo -e "======"
  done
  }

doc_add "def" "name arguments code description" "Defines a function"
def()
 {
 name=$1
 echo @: "$@"
 echo Star: $*
 echo raute $#
 echo '==='

 aray=("$@")
 for((i=1;i<$(($#-2));i++)) ; do
	args="${args} ${aray[$i]}"
 done
 code=${aray[$(($#-2))]}
 description=${aray[$(($#-1))]}

 echo "Args: $args"
 echo "Code: $code"

 doc_names[$(echo ${#doc_names[*]})]="$name"
 doc_arguments[$(echo ${#doc_arguments[*]})]="$args"
 doc_description[$(echo ${#doc_description[*]})]="$description"

 arginizer=""
 getopts_string=""
 getopts_case=""
 defnull=""
 if [ '$args' != '-' ] ; then
 i=1
 for arg in $args ; do
	# Bolean-Arguments
	if [ "$(echo $arg | head -c 1)" = "-" ] ; then
		defnull="${defnull}$(echo $arg | cut -d: -f2)=0;"
		getopts_string="${getopts_string}$(echo $arg | cut -d: -f1 | tail -c 2)"
		getopts_case="${getopts_case}$(echo $arg | cut -d: -f1 | tail -c 2)) $(echo $arg | cut -d: -f2)=1;;"
	else	# Named Arguments
		arginizer="${arginizer}; $nl export $arg=\$$i"
		echo $arg
		i=$(($i+1))
	fi
 done
 fi
 arginizer="${defnull}$nl while getopts \"$getopts_string\" optionname; do case \"\$optionname\" in $getopts_case esac; done;$nl shift \$((\$OPTIND-1)) ; unset var OPTIND ${arginizer}"


 help="
	if [ \"\$1\" = \"-h\" ] ; then
	echo -e \"\t$name $args\"
	echo $description; return ; fi;"

 code="{ "${help}${nl}${arginizer}$(echo -e "$code" | tr '\n' ';' | cut -d\{ -f2)
# code=$(echo "$code" | sed 's.;[ \t]*;.;.g' )
 echo "new Code: $code"
 eval "function $name $code"
 }
