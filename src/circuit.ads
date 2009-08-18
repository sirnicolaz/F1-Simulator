-- The Declaration of class Circuit
with Racetrack; use Racetrack;with Box; use Box;
package Circuit is
	type PrivateComponent is tagged private;
	type CircuitObject is tagged
		record
			a : RacetrackObject;
			a : BoxObject;
		end record;
	type Pointer is access all CircuitObject'Class;
	function getName(pThis : CircuitObject) return string;
	function getLocation(pThis : CircuitObject) return string;
	function setName(pThis : CircuitObject ; pname : string) return void;
	function setLocation(pThis : CircuitObject ; plocName : string) return void;
	function configure(pThis : CircuitObject) return boolean;

private
	type PrivateComponent is tagged
		record
			aname : string;
			alocation : string;
			aconfigurationFile : string;
		end record;

end Circuit;