box: corba
	javac -d ../../obj/java/ GUI/Box/BoxAdminWindow.java

competition: corba tv
	javac -d ../../obj/java/ GUI/Competition/StartCompetition.java 

tv: corba
	javac -d ../../obj/java/ GUI/TV/screenTv.java

corba:
	$(shell idlj ../idl/init.idl; idlj ../idl/radio.idl)

deep:
	rm -rf ../../obj/java/GUI ../../obj/java/corba ../../obj/java/temp/*
