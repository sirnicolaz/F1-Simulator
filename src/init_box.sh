#!/bin/bash

#Init all the asked boxes
echo "Initializing boxe admin panel..."

cd BoxGui

java BoxAdminWindow $2 

echo "Done"

echo "Killing box..."
kill $1
echo "Done"
