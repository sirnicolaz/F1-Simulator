#!/bin/bash

echo "Init monitor...";
cd TvScreen
java configurationScreen  > logXrisoluzione.txt &
echo "Configuration Done"
read Q
killall -9 configurationScreen

