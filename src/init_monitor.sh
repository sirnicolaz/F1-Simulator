#!/bin/bash

echo "Init monitor...";
cd TvScreen
java configurationScreen 
echo "Configuration Done"
read Q
killall -9 configurationScreen

