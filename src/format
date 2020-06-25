#!/bin/bash

pull_clean_csv() {
	# test should be safe as machine is read only by default 
	if [[ $(ls /media/*/ACCU-CHEK 2> /dev/null | wc -l) == 9 ]]; then
		for accu in /media/*/ACCU-CHEK; do
			find $accu -name '*.csv' -exec cp {} . \;

			# work on the most recently pulled .csv
			find . -cmin 1 -name '*.csv' -exec \
			sed -i '1,3d;/^$/d;$d;s/X//;s/; ; ; ; ; ; ;//;s/;mmol\/l//;s/\./ /;s/:/\./' {} \;
		done
	else
		printf "ERROR: Cannot locate machine, make sure it's plugged in\n"
		exit 1
	fi
}

format_time_frame() {
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
}

format_weekly() {
	# credit to: mute from #bash irc chat
	awk 'FNR == 1 { p = $1; d=0 } $1!=p { d++; p = $1; } d>=7 { exit; } 1 { print $0; }' \
		*.csv > bgl-"$(date +"%x" | sed 's/\///g')"-weekly.txt
}

format_monthly() {
	# pass shell variable to awk, last column in cal = days in current month
	MONTH="$(echo $(cal) | awk '{print $(NF)}')"
	awk -v month="${MONTH}" \
		'FNR == 1 { p = $1; d=0 } $1!=p { d++; p = $1; } d>=month { exit; } 1 { print $0; }' \
		*.csv > bgl-"$(date +"%x" | sed 's/\///g')"-monthly.txt
}

final_format() {
	find . -cmin 1 -name '*.txt' -exec sed -i 's/\(.\{11\}\)//;s/ /\./g;s/^;//g' {} \;
	find . -cmin 1 -name '*.csv' -delete
}

plot() {
	if [[ $timeframe == 1 ]]; then 
		exec ./scatter "$(find . -cmin 1 -name '*.txt')" \
		 	"bgl-"$(date +"%x" | sed 's/\///g')"-weekly.pdf" 2> /dev/null
	elif [[ $timeframe == 2 ]]; then
		exec ./scatter "$(find . -cmin 1 -name '*.txt')" \
		 	"bgl-"$(date +"%x" | sed 's/\///g')"-monthly.pdf" 2> /dev/null
	fi
}

pull_clean_csv
format_time_frame
final_format
plot
