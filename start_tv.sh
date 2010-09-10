#!/bin/bash

echo "Init monitor...";
cd obj/java
java GUI.TV.configurationScreen  > ../temp/logTv.txt &
echo "Configuration Done"
read Q
killall -9 configurationScreen

