#!/bin/bash
#attempts to trap signints and stop the script
trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

#if osx coreutils tools are found use them for compatibility
if ! command -v gsort &> /dev/null
then
    SORT=sort
else
	SORT=gsort
fi

if ! command -v gdate &> /dev/null
then
    DATE=date
else
	DATE=gdate
fi

if ! command -v gdu &> /dev/null
then
    DU=du
else
	DU=gdu
fi

if ! command -v gtee &> /dev/null
then
    TEE=tee
else
	TEE=gtee
fi

if ! command -v gcut &> /dev/null
then
    CUT=cut
else
	CUT=gcut
fi

if ! command -v gwc &> /dev/null
then
    WC=wc
else
	WC=gwc
fi

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
