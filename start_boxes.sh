#!/bin/bash

BOX_QTY=$1

cd obj;

#Init all the asked boxes
echo "Initializing boxes..."

for (( i=1; i<=$BOX_QTY; i++ ))
do
	cd ada;
	./main_box $i > ../temp/box_$i.log &
	cd ../;
	./init_box.sh $! $i &
	echo "Box $i done."
done

