#!/bin/bash

appdir=$(dirname $(readlink -f $0))
die() {
	echo "$*"
	exit 1
}
mfile=${appdir}/../sw/ARM/bare-metal/cmr.axf.map
ifile=/tmp/cmr_map.txt

ofile=${appdir}/motor_vars.csv
tfile=${appdir}/motor_vars.bak
dos2unix -n $mfile $ifile
cp $ofile $tfile 
[ -s $ifile ] || die $ifile no good
[ -s $tfile ] || die $tfile no good
[ -s $ofile ] || die $ofile no good
var1=$1
var2=$2
[ "x" != "x$var1" ] || die var1 not set
[ "x" != "x$var2" ] || die var2 not set
addr1=$(awk '/'$var1'$/ { print $1 }' $ifile)
addr2=$(awk '/'$var2'$/ { print $1 }' $ifile)
[ "x" != "x$addr1" ] || die addr1 not set
[ "x" != "x$addr2" ] || die addr2 not set
 sed -i -e 's/^float_address1,.*$/float_address1,'0x${addr1}',string,/' $ofile
 sed -i -e 's/^float_address2,.*$/float_address2,'0x${addr2}',string,/' $ofile
 diff $tfile $ofile
rm $ifile
