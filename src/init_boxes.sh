#!/bin/bash

BOX_QTY=$1

#Init all the asked boxes
echo "Initializing boxes..."

for (( i=1; i<=$BOX_QTY; i++ ))
do
	./main_box $i > box_$i.log &
	./init_box.sh $! $i &
	echo "Box $i done."
done

