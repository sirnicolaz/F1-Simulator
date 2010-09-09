#!/bin/bash

echo "Compiling competition server"
cd src/ada/
make competition

echo "Compiling competition screen"
cd ../java
make competition

