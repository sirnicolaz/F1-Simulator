#!/bin/bash

echo "Init ada part...";
./init_competition &
echo "Entering interface dir.."
cd ConfigurationInterface
echo "Initing configuration.."
java ConfigurationInterface_Test 
echo "Configuration Done"
read Q
killall -9 init_competition

