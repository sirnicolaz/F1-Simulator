-- The Declaration of class Competition
with Competition_component.CompetitionAdminWindow; use Competition_component.CompetitionAdminWindow;with CompetitionMonitorPanel; use CompetitionMonitorPanel;with Competitor_component.MonitorSystem; use Competitor_component.MonitorSystem;with Circuit_Component.Circuit; use Circuit_Component.Circuit;with Competition_component.Competitor; use Competition_component.Competitor;
package Competition_component.Competition is
	type PrivateComponent is tagged private;
	type CompetitionObject is tagged
		record
			a : CompetitionAdminWindowObject;
			a : CompetitionMonitorPanelObject;
			a : MonitorSystemObject;
			a : CircuitObject;
			a : CompetitorObject;
		end record;
	type Pointer is access all CompetitionObject'Class;
	procedure waitCompetitors(pThis : CompetitionObject);
	procedure configCircuit(pThis : CompetitionObject ; pclassificRefreshRate : int ; pcircuitInfo : String ; prtFilePath : string);
	procedure configMeteo(pThis : CompetitionObject ; pmeteo : String);
	procedure configRide(pThis : CompetitionObject ; plapsNum : int);
	procedure regCompetitor(pThis : CompetitionObject);
	procedure __regViewer(pThis : CompetitionObject);
	procedure start(pThis : CompetitionObject);
	procedure stop(pThis : CompetitionObject);
	function joinCompetition(pThis : CompetitionObject ; pconnectionInfo : String ; pcar : String ; pstrategy : String ; pcompetitorInfo : String) return int;
	function getCompetitorInfo(pThis : CompetitionObject ; pid : int) return CompetitorInfo;

private
	type PrivateComponent is tagged
		record
			aclassificationRefreshRate : float;
		end record;

end Competition_component.Competition;