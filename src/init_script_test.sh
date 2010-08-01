#!/bin/bash
echo "Starting"
./main_box &
cd Box/
java BoxInterface_Test
echo "Done. Press Q and Enter to quit"
read Q
killall -9 main_box
echo "Quit"
