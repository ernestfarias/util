#!/usr/bin/env bash

function Ask_timeout {
timelimit=10
echo -e "$1 ?\n $timelimit seconds for Default(yes). (yes/no)?: \c"
value=""
read -t $timelimit value
#if value is null or yes continue
if [ -z "$value" ] || [ "yes" == $value ]
then
echo -e "\n Yes: CONTINUE!!!"
else
echo -e "\n Cancel: your choose $value ,not yes"
echo -e "\n Quitting..."
exit 0
fi
}


Ask_timeout "que queres"

