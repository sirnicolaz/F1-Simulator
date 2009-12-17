package Stats is

   type GENERIC_STATS is tagged private;
   --type COMPETITOR_STATS is new GENERIC_STATS with private;
   type GLOBAL_STATS is new GENERIC_STATS with private;

   type BESTSECTORS_TIME is array(INTEGER range <> ) of FLOAT;
   type BESTSECTORS_TIME_POINT is access BESTSECTORS_TIME;

   type BESTSECTORS_TIME_COMPETITORSID is array( INTEGER range <> ) of INTEGER;
   type BESTSECTORS_TIME_COMPETITORSID_POINT is access BESTSECTORS_TIME_COMPETITORSID;

   function Get_LapNum(StatsContainer : GENERIC_STATS ) return INTEGER;

private

   type GENERIC_STATS is tagged record
      BestLap_Num : INTEGER; -- Num of best time lap
      BestLap_Time : FLOAT;
      BestSectors_Time : BESTSECTORS_TIME_POINT;
   end record;

   type GLOBAL_STATS is new GENERIC_STATS with
      record
         BestLap_CompetitorId : INTEGER;
         BestTimePerSector_CompetitorId : BESTSECTORS_TIME_COMPETITORSID_POINT;
         FirstTableFree : INTEGER; --maybe unuseful if table is freed each time it's completed
      end record;

end Stats;
