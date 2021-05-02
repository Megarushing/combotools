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

