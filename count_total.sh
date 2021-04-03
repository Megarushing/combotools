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

total=0;
find data | $SORT | while read in;
do
  if [ -f "$in" ]; then
    count=$($WC -l $in | $CUT -d' ' -f1);
    total=$((total + count));
    echo -n "[*] $in -               " | $CUT -z -b1-22
    echo -n "$count                  " | $CUT -z -b1-10
    echo    "(total: $total)";
  fi;
done

##############################################################
# after importing zoosk: 1'338'362'568

##############################################################
