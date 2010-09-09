#!/bin/bash

echo "Compiling competition server"
cd src/ada/
idlac ../idl/radio.idl;
idlac ../idl/init.idl;
rm corba.ads
make box

echo "Compiling competition screen"
cd ../java
idlj ../idl/radio.idl;
idlj ../idl/init.idl;
make box

