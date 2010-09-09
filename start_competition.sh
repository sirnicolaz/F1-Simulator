#!/bin/bash

ADAOBJDIR="./obj/ada";
JAVAOBJDIR="./obj/java"

cd $ADAOBJDIR;

echo "Init ada part...";
./main_competition > ../temp/logConGui.txt &

echo "Entering interface dir.."
cd ../../$JAVAOBJDIR
echo "Initing configuration.."
java GUI.Competition.StartCompetition > ../temp/logConGuiJava.txt & 
echo "Configuration Done"
read Q
killall -9 main_competition

