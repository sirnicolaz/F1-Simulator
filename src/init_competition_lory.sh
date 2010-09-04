#!/bin/bash

echo "Init ada part...";
./main_competition > logXnicola.txt &
echo "Entering interface dir.."
cd ConfigurationInterface
echo "Initing configuration.."
java ConfigurationInterface_Test 
echo "Configuration Done"
read Q
killall -9 main_competition

