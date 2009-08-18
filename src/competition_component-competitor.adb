-- The implementation body of class Competitor
with Competitor_component.Strategy; use Competitor_component.Strategy;with Competitor_component.CompetitorRadio; use Competitor_component.CompetitorRadio;with Competitor_component.OnboardComputer; use Competitor_component.OnboardComputer;with Competitor_component.Car; use Competitor_component.Car;
package body Competition_component.Competitor is
	procedure configureCar(pThis : CompetitorObject) is
	begin
		null;
	end configureCar;
	procedure configureStrategy(pThis : CompetitorObject) is
	begin
		null;
	end configureStrategy;
	function getId(pThis : CompetitorObject) return string is
	begin
		null;
	end getId;
	procedure pitStop(pThis : CompetitorObject) is
	begin
		null;
	end pitStop;
	function getCar(pThis : CompetitorObject) return Car is
	begin
		null;
	end getCar;
end Competition_component.Competitor;