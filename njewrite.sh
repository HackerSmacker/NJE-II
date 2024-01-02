#!/bin/sh
FROMNAME=$1
DESTNAME=`echo $2 | tr '[:upper:]' '[:lower:]'`
TEXT=$3

echo "\n[NJE] $FROMNAME: $TEXT" | write $DESTNAME
