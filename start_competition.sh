#!/bin/bash

ADAOBJDIR="./obj/ada";
JAVAOBJDIR="./obj/java"

cd $ADAOBJDIR;

echo "Init ada part...";
./main_competition > ../temp/competition.log &

echo "Entering interface dir.."
cd ../../$JAVAOBJDIR
echo "Initing configuration.."
java GUI.Competition.CompetitionConfigurationWindow 

killall -9 main_competition

