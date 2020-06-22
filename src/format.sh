#!/bin/bash

# this is trash but better than last one
# credit to: mute from #bash irc chat

_date="$(date +"%x" | sed 's/\///g')"

function format_weekly() {
	awk 'FNR == 1 { p = $1; d=0 } $1!=p { d++; p = $1; } d>=7 { exit; } 1 { print $0; }' \
		*.csv > bgl-$_date-weekly.txt
}

function format_monthly() {
	# pass days in month to awk
	MONTH="$(echo $(cal) | awk '{print $(NF)}')"

	awk -v month="${MONTH}" \
		'FNR == 1 { p = $1; d=0 } $1!=p { d++; p = $1; } d>=month { exit; } 1 { print $0; }' \
		*.csv > bgl-$_date-monthly.txt
}

for accu in /media/*/ACCU-CHEK; do
	pulled="$(find $accu -name '*.csv')" 

	cp $pulled .
	sed -i '1,3d;/^$/d;$d;s/X//;s/; ; ; ; ; ; ;//;s/;mmol\/l//;s/\./ /;s/:/\./' $pulled
done

while true; do
	read -p "Pick a timeframe || 1: Week, 2: Month$(echo $'\n> ')" timeframe

	if [[ $timeframe == 1 ]]; then
		format_weekly; break
	elif [[ $timeframe == 2 ]]; then
		format_monthly; break
	else
		printf "ERROR: Invalid timeframe"
	fi
done

rm $pulled

new="$(find . -cmin 1 -name '*.txt')"

sed -i 's/\(.\{11\}\)//;s/ /\./g;s/^;//g' $new

if [[ $timeframe == 1 ]]; then 
	exec ./scatter $new "bgl-$_date-weekly.pdf" 2>/dev/null
elif [[ $timeframe == 2 ]]; then
	exec ./scatter $new "bgl-$_date-monthly.pdf" 2>/dev/null
fi
