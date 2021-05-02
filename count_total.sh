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

total=0;
find data -not -path '*/\.*' | $SORT | while read in;
do
  if [ -f "$in" ]; then
    count=$($WC -l "$in" | $CUT -d' ' -f1);
    total=$((total + count));
    echo -n "[*] $in -               " | $CUT -z -b1-22
    echo -n "$count                  " | $CUT -z -b1-10
    echo    "(total: $total)";
  fi;
done

