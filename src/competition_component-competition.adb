-- The implementation body of class Competition
with Competition_component.AdminWindow; use Competition_component.AdminWindow;with ControlPanel; use ControlPanel;with Circuit_Component.Circuit; use Circuit_Component.Circuit;with Competition_component.Competitor; use Competition_component.Competitor;
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
	procedure regViewer(pThis : CompetitionObject) is
	begin
		null;
	end regViewer;
	procedure start(pThis : CompetitionObject) is
	begin
		null;
	end start;
	procedure stop(pThis : CompetitionObject) is
	begin
		null;
	end stop;
end Competition_component.Competition;