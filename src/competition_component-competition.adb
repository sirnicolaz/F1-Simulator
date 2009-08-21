-- The implementation body of class Competition
with Competition_component.CompetitionAdminWindow; use Competition_component.CompetitionAdminWindow;with CompetitionMonitorPanel; use CompetitionMonitorPanel;with Competitor_component.MonitorSystem; use Competitor_component.MonitorSystem;with Circuit_Component.Circuit; use Circuit_Component.Circuit;with Competition_component.Competitor; use Competition_component.Competitor;
package body Competition_component.Competition is
	procedure waitCompetitors(pThis : CompetitionObject) is
	begin
		null;
	end waitCompetitors;
	procedure configCircuit(pThis : CompetitionObject ; pclassificRefreshRate : int ; pcircuitInfo : String ; prtFilePath : string) is
	begin
		null;
	end configCircuit;
	procedure configMeteo(pThis : CompetitionObject ; pmeteo : String) is
	begin
		null;
	end configMeteo;
	procedure configRide(pThis : CompetitionObject ; plapsNum : int) is
	begin
		null;
	end configRide;
	procedure regCompetitor(pThis : CompetitionObject) is
	begin
		null;
	end regCompetitor;
	procedure __regViewer(pThis : CompetitionObject) is
	begin
		null;
	end __regViewer;
	procedure start(pThis : CompetitionObject) is
	begin
		null;
	end start;
	procedure stop(pThis : CompetitionObject) is
	begin
		null;
	end stop;
	function joinCompetition(pThis : CompetitionObject ; pconnectionInfo : String ; pcar : String ; pstrategy : String ; pcompetitorInfo : String) return int is
	begin
		null;
	end joinCompetition;
	function getCompetitorInfo(pThis : CompetitionObject ; pid : int) return CompetitorInfo is
	begin
		null;
	end getCompetitorInfo;
end Competition_component.Competition;