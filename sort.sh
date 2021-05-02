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

# data folder sorting
echo "[*] sorting breaches..." | $TEE -a debug.log
find data -not -path '*/\.*' | $SORT | while read path;
do
	if [ -f $path ]; then
		echo "[*] sorting $path" | $TEE -a debug.log
		$SORT $path -u -o $path\_
		mv $path\_ $path
	fi
done
