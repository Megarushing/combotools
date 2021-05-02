#!/bin/bash
#attempts to trap signints and stop the script
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT
#if osx coreutils tools are found use them for compatibility
#this replaces sort with gsort, date with gdate and so on...
for c in "sort" "date" "du" "tee" "cut" "wc" "uniq"
	do if command -v g$c &> /dev/null
	then
    	eval $(echo $c | tr '[:lower:]' '[:upper:]')=g$c
	else
		eval $(echo $c | tr '[:lower:]' '[:upper:]')=$c
	fi
done

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ "$1" != "" ]; then
	letter1=$(echo ${1} | $CUT -b1)
	if [[ $letter1 == [a-zA-Z0-9] ]]; then
		if [ -f "$dir/data/$letter1" ]; then
			grep -ai "^$1" "$dir/data/$letter1"
		else
			letter2=$(echo ${1} | $CUT -b2)
			if [[ $letter2 == [a-zA-Z0-9] ]]; then
				if [ -f "$dir/data/$letter1/$letter2" ]; then
					grep -ai "^$1" "$dir/data/$letter1/$letter2"
				else
					letter3=$(echo ${1} | $CUT -b3)
					if [[ $letter3 == [a-zA-Z0-9] ]]; then
						if [ -f "$dir/data/$letter1/$letter2/$letter3" ]; then
							grep -ai "^$1" "$dir/data/$letter1/$letter2/$letter3"
						fi
					else
						if [ -f "$dir/data/$letter1/$letter2/symbols" ]; then
							grep -ai "^$1" "$dir/data/$letter1/$letter2/symbols"
						fi
					fi
				fi
			else
				if [ -f "$dir/data/$letter1/symbols" ]; then
					grep -ai "^$1" "$dir/data/$letter1/symbols"
				fi
			fi
		fi
	else
		if [ -f "$dir/data/symbols" ]; then
			grep -ai "^$1" "$dir/data/symbols"
		fi
	fi
else
	echo "[*] Example: ./query name@domain.com"
fi
