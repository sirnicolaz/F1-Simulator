competition: competition_ada competition_java

competition_ada:
	@cd src/ada && make competition

competition_java:
	@cd src/java && make competition

box: box_ada box_java

box_ada:
	@cd src/ada && make box

box_java:
	@cd src/java && make box

tv:
	@cd src/java && make tv

clean:
	@cd src/ada && make deep
	@cd src/java && make deep

