box:
	javac -d ../../obj/java/ GUI/Box/PreBoxConfigurationWindow.java

competition: tv
	javac -d ../../obj/java/ GUI/Competition/CompetitionConfigurationWindow.java 

tv: corba
	javac -d ../../obj/java/ GUI/TV/TvConfigurationWindow.java

corba:
	@idlj ../idl/init.idl
	@idlj ../idl/radio.idl

deep:
	rm -rf ../../obj/java/GUI ../../obj/java/broker ../../obj/java/temp/*
