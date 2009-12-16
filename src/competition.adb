package body Competition is

   procedure Configure_Circuit( ClassificRefreshRate_In : FLOAT;
                               CircuitName_In : STRING;
                               CircuitLocation_In : STRING;
                               RaceConfigFile_In : STRING ) is
   begin
        Circuit_Point:=Get_Racetrack(RaceConfigFile_In);
   end Configure_Circuit;


   procedure Configure_Ride( LapsQty_In : INTEGER )
   is
   begin
        Laps_Qty := LapsQty_In;
   end Configure_Ride;

   -- Initialize the competitor
   function Join(CompetitorFileDescriptor_In : STRING) return INTEGER is
   begin
	Init_Competitor(CompetitorFileDescriptor_In,Get_Iterator(Circuit_Point));
        return 1;
   end;

   -- Box call this method to signal they are ready to start
   procedure BoxOk( CompetitorId_In : INTEGER) is
   begin
      null;
   end BoxOK;

   -- Each competitor task is started
   procedure Start_Race is
   begin
      null;
   end Start_Race;


end Competition;
