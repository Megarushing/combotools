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

if ! command -v guniq &> /dev/null
then
    UNIQ=uniq
else
	UNIQ=guniq
fi

out=brute_wordlist.txt

echo "" > $out
find data -type f -not -path '*/\.*' | $SORT | while read path;
do
  if [ -f "$path" ]; then
    echo "Parsing: $path" | $TEE -a debug.log
    cat $path | $CUT -s -f2- -d":" >> $out
  fi;
done

echo "Sorting passwords by usage..." | $TEE -a debug.log
$SORT $out | $UNIQ -c | $SORT -nr > temp
echo "Cleaning up..." | $TEE -a debug.log
cat temp | sed -e 's/^[[:space:]]*//' | $CUT -s -f2- -d" " > $out
rm temp

