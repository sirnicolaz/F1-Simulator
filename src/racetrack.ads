-- The Declaration of class Racetrack
package Racetrack is
	type PrivateComponent is tagged private;
	type RacetrackObject is tagged null record;
	type Pointer is access all RacetrackObject'Class;

private
	type PrivateComponent is tagged null record;

end Racetrack;