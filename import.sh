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
ls ./inputbreach |$SORT| sed 's/^/.\/inputbreach\//' | while read inputfile;
do
echo "[*] Checking breach $inputfile checksum..." | $TEE -a debug
shasum="$(sha256sum "$inputfile" | $CUT -d' ' -f1)"
	if [ "$(cat imported.log | grep "$shasum" | $WC -l)" == "0" ]; then
		cat imported.log | grep "$shasum" | $TEE -a debug

		# importing to data folder
		find data -not -path '*/\.*' | $SORT | while read path;
		do
			if [ -f $path ]; then
				filter=$(echo "$path" | sed 's/^.*data//' | sed 's#/##g' | sed 's/symbols$//g' )
				if [ "$(echo "$path" | grep "symbols$")" == "" ]; then
					echo "Filter: $filter	Path: $path" | $TEE -a debug
					grep -ai "^$filter\w*\b" $inputfile | LC_CTYPE=C sed 's/\r//g' | grep -a @ >> $path | $TEE -a debug
				else
					echo "Filter: $filter[symbol]	Path: $path" | $TEE -a debug
					grep -ai "^$filter\w*\b" $inputfile | grep -aiv "^$filter[a-zA-Z0-9]\w*\b" | LC_CTYPE=C sed 's/\r//g' | grep -a @ >> $path | $TEE -a debug
				fi
			fi
		done



		echo "[*] Logging sha256sum into imported.log..." | $TEE -a debug
		echo "$($DATE --rfc-3339=date): $(sha256sum "$inputfile")	$($DU -h "$inputfile"|$CUT -d'	' -f1)" | $TEE -a imported.log | $TEE -a debug
		echo "------------------------------------------" | $TEE -a debug

		echo "[*] Removing breach file $inputfile..." | $TEE -a debug
		rm "$inputfile" | $TEE -a debug
	else
		echo "[*] This breach is already imported." | $TEE -a debug
		cat imported.log | grep "$shasum" | $TEE -a debug
		echo "[*] Removing breach file $inputfile..." | $TEE -a debug
		rm "$inputfile" | $TEE -a debug
		echo "------------------------------------" | $TEE -a debug
	fi
done

#./sorter.sh
