competition: 
	gnatmake -d -P./default.gpr -XLIBRARY_TYPE=static -XBUILD=Production main_competition.adb

box:
	gnatmake -d -P./default.gpr -XLIBRARY_TYPE=static -XBUILD=Production main_box.adb

deep: clean
	rm -rf ../../obj/ada/*.o ../../obj/ada/*.ali ../../obj/ada/b~* ../../obj/ada/*~

clean:
	rm -rf ../../obj/ada/main_competition ../../obj/ada/main_box > /dev/null
