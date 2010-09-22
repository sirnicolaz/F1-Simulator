echo starting demo ...
cd obj
make deep
make
cd ..
po_cos_naming -file ior.txt &
xterm -T "Distributed Erathostenes" -e ./run.sh &
read Q
killall po_cos_naming
echo ... ending demo
