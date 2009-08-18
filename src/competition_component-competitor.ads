-- The Declaration of class Competitor
with Competitor_component.Strategy; use Competitor_component.Strategy;with Competitor_component.CompetitorRadio; use Competitor_component.CompetitorRadio;with Competitor_component.OnboardComputer; use Competitor_component.OnboardComputer;with Competitor_component.Car; use Competitor_component.Car;
package Competition_component.Competitor is
	type PrivateComponent is tagged private;
	type CompetitorObject is tagged
		record
			a : CompetitorRadioObject;
			a : OnboardComputerObject;
		end record;
	type Pointer is access all CompetitorObject'Class;
	procedure configureCar(pThis : CompetitorObject);
	procedure configureStrategy(pThis : CompetitorObject);
	function getId(pThis : CompetitorObject) return string;
	procedure pitStop(pThis : CompetitorObject);
	function getCar(pThis : CompetitorObject) return Car;

private
	type PrivateComponent is tagged
		record
			aid : String;
			ateam : String;
			afirstName : String;
			alastName : String;
			a : StrategyObject;
			a : CarObject;
		end record;

end Competition_component.Competitor;