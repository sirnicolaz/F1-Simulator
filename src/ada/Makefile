POLYORBCFLAGS=`polyorb-config --cflags`
XMLADACFLAGS=`xmlada-config --cflags`

POLYORBLIBS=`polyorb-config --libs`
XMLADALIBS=`xmlada-config --libs`

default: competition box

competition: corba
	gnatmake -j2 -x -d $(POLYORBCFLAGS) $(XMLADACFLAGS) -largs $(POLYORBLIBS) $(XMLADALIBS) -margs -PF1_Simulator.gpr main_competition.adb 

box: corba
	gnatmake -j2 -x -d $(POLYORBCFLAGS) $(XMLADACFLAGS) -largs $(POLYORBLIBS) $(XMLADALIBS) -margs -PF1_Simulator.gpr main_box.adb 

corba:
	$(shell idlac ../idl/init.idl; idlac ../idl/radio.idl)

deep: clean
	rm -rf ../../obj/ada/*.o ../../obj/ada/*.ali ../../obj/ada/b~* ../../obj/ada/*~ ../../obj/ada/temp/*

clean:
	rm -rf ../../obj/ada/main_competition ../../obj/ada/main_box 

