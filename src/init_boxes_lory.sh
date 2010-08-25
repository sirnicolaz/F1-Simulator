#!/bin/bash

BOX_QTY=$1

#Init all the asked boxes
echo "Initializing boxes..."
echo ""
for (( i=1; i<=$BOX_QTY; i++ ))
do
	./main_box $i > box_$i.log &
	echo "Box $i done."
done

echo "Boxes waiting for configuration..."

cd BoxGui

for (( i=1; i<=$BOX_QTY; i++ ))
do
	java BoxAdminWindow $i
	echo "Box $i configured"

done

echo "Done"

read Q

echo "Killing boxes..."
killall -9 main_box
echo "Done"
