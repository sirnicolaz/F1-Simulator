competition: corba
	gnatmake -j2 -x -d -P./default.gpr -XLIBRARY_TYPE=static -XBUILD=Production `polyorb-config --cflags` `xmlada-config --cflags` -largs `polyorb-config --libs` `xmlada-config --libs` main_competition.adb

box: corba
	gnatmake -j2 -x -d -P./default.gpr -XLIBRARY_TYPE=static -XBUILD=Production `polyorb-config --cflags` `xmlada-config --cflags` -largs `polyorb-config --libs` `xmlada-config --libs` main_box.adb

corba:
	$(shell idlac ../idl/init.idl; idlac ../idl/radio.idl)

deep: clean
	rm -rf ../../obj/ada/*.o ../../obj/ada/*.ali ../../obj/ada/b~* ../../obj/ada/*~ ../../obj/ada/temp/*

clean:
	rm -rf ../../obj/ada/main_competition ../../obj/ada/main_box 
