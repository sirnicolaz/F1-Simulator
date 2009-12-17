package body Stats is

   function Get_LapNum(StatsContainer : GENERIC_STATS ) return INTEGER is
   begin
      return StatsContainer.BestLap_Num;
   end Get_LapNum;

end Stats;
