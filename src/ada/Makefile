competition: corba
	gnatmake -d -P./default.gpr -XLIBRARY_TYPE=static -XBUILD=Production main_competition.adb

box: corba
	gnatmake -d -P./default.gpr -XLIBRARY_TYPE=static -XBUILD=Production main_box.adb

corba:
	$(shell idlac ../idl/radio.idl ../idl/init.idl;	rm corba.ads)

deep: clean
	rm -rf ../../obj/ada/*.o ../../obj/ada/*.ali ../../obj/ada/b~* ../../obj/ada/*~

clean:
	rm -rf ../../obj/ada/main_competition ../../obj/ada/main_box > /dev/null
