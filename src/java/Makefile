box: corba
	javac -d ../../obj/java/ GUI/Box/BoxAdminWindow.java

competition: tv corba
	javac -d ../../obj/java/ GUI/Competition/StartCompetition.java 

tv: corba
	javac -d ../../obj/java/ GUI/TV/screenTv.java

corba:
	idlj ../idl/radio.idl ../idl/init.idl

deep: clean
	rm ../../obj/java/*.class ../../obj/java/_*

clean:
	rm ../../obj/java/screenTv ../../obj/java/BoxAdminWindow ../../obj/java/StartCompetition
