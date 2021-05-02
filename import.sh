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

# bootstraps file structure for current tree
filenames="0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v x y z symbols"

for i in $filenames
	do for f in $(find data -type d | sed "s/$/\/$i/")
		do if ! [[ -e $f ]]; 
			then touch $f
		fi
	done
done

#script start
N=16 #number of simultaneous processes
ls ./inputbreach |$SORT| sed 's/^/.\/inputbreach\//' | while read inputfile;
do
echo "[*] Checking breach $inputfile checksum..." | $TEE -a debug.log
shasum="$(sha256sum "$inputfile" | $CUT -d' ' -f1)"
	if [ "$(cat imported.log | grep "$shasum" | $WC -l)" == "0" ]; then
		cat imported.log | grep "$shasum" | $TEE -a debug.log

		# importing to data folder
		find data -not -path '*/\.*' | $SORT | (while read path
		do
			((i=i%N)); ((i++==0)) && wait
			(
			if [ -f $path ]; then
				filter=$(echo "$path" | sed 's/^.*data//' | sed 's#/##g' | sed 's/symbols$//g' )
				if [ "$(echo "$path" | grep "symbols$")" == "" ]; then
					echo "Filter: $filter	Path: $path" | $TEE -a debug.log
					grep -ai "^$filter\w*\b" "$inputfile" | LC_CTYPE=C sed 's/\r//g' | grep -a @ >> $path | $TEE -a debug.log
				else
					echo "Filter: $filter[symbol]	Path: $path" | $TEE -a debug.log
					grep -ai "^$filter\w*\b" "$inputfile" | grep -aiv "^$filter[a-zA-Z0-9]\w*\b" | LC_CTYPE=C sed 's/\r//g' | grep -a @ >> $path | $TEE -a debug.log
				fi
			fi
			) & #parallelization - each data file will spawn a separate process
		done && wait) #for all imports to be done

		echo "[*] Logging sha256sum into imported.log..." | $TEE -a debug.log
		echo "$($DATE --rfc-3339=date): $(sha256sum "$inputfile")	$($DU -h "$inputfile"|$CUT -d'	' -f1)" | $TEE -a imported.log | $TEE -a debug.log
		echo "------------------------------------------" | $TEE -a debug.log

		echo "[*] Removing breach file $inputfile..." | $TEE -a debug.log
		rm "$inputfile" | $TEE -a debug.log
	else
		echo "[*] This breach is already imported." | $TEE -a debug.log
		cat imported.log | grep "$shasum" | $TEE -a debug.log
		echo "[*] Removing breach file $inputfile..." | $TEE -a debug.log
		rm "$inputfile" | $TEE -a debug.log
		echo "------------------------------------" | $TEE -a debug.log
	fi
done

./sort.sh
