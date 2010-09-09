POLYORBCFLAGS=`polyorb-config --cflags`
XMLADACFLAGS=`xmlada-config --cflags`

POLYORBLIBS=`polyorb-config --libs`
XMLADALIBS=`xmlada-config --libs`

default: competition box

competition: corba
	gnatmake main_competition.adb -D../../obj/ada -j2 -x -d $(POLYORBCFLAGS) $(XMLADACFLAGS) -largs $(POLYORBLIBS) $(XMLADALIBS) 

box: corba
	gnatmake main_box.adb -D../../obj/ada -j2 -x -d $(POLYORBCFLAGS) $(XMLADACFLAGS) -largs $(POLYORBLIBS) $(XMLADALIBS) 

corba:
	$(shell idlac ../idl/init.idl; idlac ../idl/radio.idl)

deep: clean
	rm -rf ../../obj/ada/*.o ../../obj/ada/*.ali ../../obj/ada/b~* ../../obj/ada/*~ ../../obj/ada/temp/*

clean:
	rm -rf ../../obj/ada/main_competition ../../obj/ada/main_box 
