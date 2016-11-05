#! /usr/bin/bash
#
# Random Passphrase Generator with Higher Entropy
# by asiago (linux@idunna.is)
#
# Based on the script I found here:
# https://systemreboot.net/post/simple-passphrase-generator-in-bash
# EFF wordlist available from here:
# https://www.eff.org/document/passphrase-wordlists

wordlist=~/eff_large_wordlist.txt
wordcount=5

function randomline {
    linecount=$1
    rnum=$(od -An -N 2 -t u2 < /dev/urandom)
    if [[ $rnum -lt $linecount ]]
    then
	echo $(expr $rnum + 1)
    else
	randomline $linecount
    fi
}

linecount=$(wc -l < $wordlist)
for i in $(seq 1 $wordcount)
do
    rline=$(randomline $linecount)
    rword=$(sed -n ${rline}p $wordlist | awk '{print $2}')
    wordsize=${#rword}
    randy=$[ $RANDOM % $wordsize + 1 ]
    randchar="$(tr '[:lower:]' '[:upper:]' <<< ${rword:$randy:1})"
    front=${rword:0:$randy}
    back=${rword:$randy+1:$wordsize}
    newword=$front$randchar$back
    printf "%s " $newword
done
printf "\n"
