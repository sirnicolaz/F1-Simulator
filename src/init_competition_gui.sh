#!/bin/bash

echo "Init ada part...";
./main_competition > logConGui.txt&
echo "Entering interface dir.."
cd StartCompetitionJava
echo "Initing configuration.."
java StartCompetition > logConGuiJava.txt & 
echo "Configuration Done"
read Q
killall -9 main_competition

