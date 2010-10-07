#!/bin/bash

#Init all the asked boxes
echo "Initializing boxe admin panel..."

cd java;

java GUI.Box.PreBoxConfigurationWindow $2 

echo "Done"

echo "Killing box..."
kill $1
echo "Done"
