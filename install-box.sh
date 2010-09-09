#!/bin/bash

echo "Compiling competition server"
cd src/ada/
make box

echo "Compiling competition screen"
cd ../java
make box

