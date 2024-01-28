#!/bin/sh
DEST=$1
IAM=`whoami`
DESTID=${DEST%@*}
DESTNOD=${DEST#*@}
NOW=`date`

echo "Sending note to $DESTID at $DESTNOD"
echo "End with period."

echo "OPTIONS: NOACK    LOG    SHORT     NOTEBOOK ALL CLASS A" >> $DESTID.note
echo "" >> $DESTID.note
echo "" >> $DESTID.note
echo "" >> $DESTID.note
echo "" >> $DESTID.note
echo "Date: $NOW" >> $DESTID.note
echo "From: $IAM at BSDSRV" >> $DESTID.note
echo "To:   $DESTID at $DESTNOD" >> $DESTID.note
echo "" >> $DESTID.note

while read LINE
do
echo $LINE >> $DESTID.note
if [ "$LINE" = "." ]; then
    break
fi
done

/usr/local/nje/bin/sendfile $DEST $DESTID.note
rm $DESTID.note
