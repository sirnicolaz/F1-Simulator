#!/bin/bash

echo "Init ada part...";
./main_competition > logConGui.txt&
echo "Entering interface dir.."
cd JavaGui
echo "Initing configuration.."
java StartCompetition 
echo "Configuration Done"
read Q
killall -9 main_competition

