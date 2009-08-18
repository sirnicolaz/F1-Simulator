-- The Declaration of class Competition
with Competition_component.AdminWindow; use Competition_component.AdminWindow;with ControlPanel; use ControlPanel;with Circuit_Component.Circuit; use Circuit_Component.Circuit;with Competition_component.Competitor; use Competition_component.Competitor;
package Competition_component.Competition is
	type PrivateComponent is tagged private;
	type CompetitionObject is tagged
		record
			a : AdminWindowObject;
			a : ControlPanelObject;
			a : CircuitObject;
			a : CompetitorObject;
		end record;
	type Pointer is access all CompetitionObject'Class;
	procedure waitCompetitors(pThis : CompetitionObject);
	procedure configCircuit(pThis : CompetitionObject ; pclassificRefreshRate : int ; pcircuitInfo : String ; prtFilePath : string);
	procedure configMeteo(pThis : CompetitionObject ; pmeteo : String);
	procedure configRide(pThis : CompetitionObject ; plapsNum : int);
	procedure regCompetitor(pThis : CompetitionObject);
	procedure regViewer(pThis : CompetitionObject);
	procedure start(pThis : CompetitionObject);
	procedure stop(pThis : CompetitionObject);

private
	type PrivateComponent is tagged
		record
			aclassificationRefreshRate : float;
		end record;

end Competition_component.Competition;