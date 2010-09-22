po_cos_naming -file ior.txt &
sleep 2
POLYORB_DSA_NAME_SERVICE="$(cat ./ior.txt)"
export POLYORB_DSA_NAME_SERVICE
./obj/main
