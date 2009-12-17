package body Competition is


   -- array of competitors pointer subtype COMPETITOR_LIST is array OF
   type COMPETITOR_LIST is array( INTEGER range <> ) of INTEGER;
   type COMPETITOR_LIST_POINT is access COMPETITOR_LIST;
   Competitors : COMPETITOR_LIST_POINT;
   -- It handle the mutually exlusive assignment of the ids to the joining competitor and
   -- verifies the availability
   protected JOIN_UTILS is
      procedure Get_Id( Id_Out : out INTEGER );
      procedure Set_MaxCompetitors( MaxCompetitors_In : INTEGER );
      procedure Giveback_Id;
      procedure Block ( ReadyToStart_Out : out BOOLEAN );
      procedure Box_Ready( ReadyToStart_Out : out BOOLEAN);
   private
      Id : INTEGER := 0;
      JoinedCompetitors : INTEGER := 0;
      MaxCompetitors : INTEGER := 0;
      ReadyBoxes : INTEGER := 0;
   end JOIN_UTILS;

   protected body JOIN_UTILS is

      procedure Get_Id(Id_Out : out INTEGER) is
      begin
         if (JoinedCompetitors < MaxCompetitors ) then
            Id := Id + 1;
            JoinedCompetitors := JoinedCompetitors + 1 ;
            Id_Out := Id;
         else
            Id_Out := -1;
         end if;
      end Get_Id;

      procedure Set_MaxCompetitors( MaxCompetitors_In : INTEGER ) is
      begin
         MaxCompetitors := MaxCompetitors_In;
      end Set_MaxCompetitors;

      procedure Giveback_Id is
      begin
         if(Id > 0) then
            Id := Id - 1;
         end if;
      end Giveback_Id;

      procedure Block(ReadyToStart_Out : out BOOLEAN) is
      begin
         MaxCompetitors := JoinedCompetitors;
         if (ReadyBoxes = JoinedCompetitors) then
           ReadyToStart_Out := true;
         end if;
      end Block;

      procedure Box_Ready(ReadyToStart_Out : out BOOLEAN) is
      begin
         ReadyToStart_Out := false;
         ReadyBoxes := ReadyBoxes + 1;
         if (ReadyBoxes = JoinedCompetitors) then
           ReadyToStart_Out := true;
         end if;
      end;

   end JOIN_UTILS;

   -- Initialize Monitor System

   -- Method to set init the circuit
   procedure Configure_Circuit( ClassificRefreshRate_In : FLOAT;
                               CircuitName_In : STRING;
                               CircuitLocation_In : STRING;
                               RaceConfigFile_In : STRING ) is
   begin
        Circuit_Point:=Get_Racetrack(RaceConfigFile_In);
   end Configure_Circuit;

   -- Procedure that sets needed information for the competition. These informations need to be
   -- setted before the competitors start to join
   procedure Configure_Ride( LapsQty_In : INTEGER;
                             CompetitorsQty_In : INTEGER )
   is
   begin
      Laps_Qty := LapsQty_In;
      JOIN_UTILS.Set_MaxCompetitors(CompetitorsQty_In);
      Competitors := new COMPETITOR_LIST(1..CompetitorsQty_In);
      Ready := true;
   end Configure_Ride;

   -- Initialize the competitor
   -- returned values:
   --+	n > 0 = assigned id
   --+ -1 = max competitor qty reached
   --+ -2 = competition not ready
   function Join(CompetitorFileDescriptor_In : STRING) return INTEGER is
      Assigned_Id : INTEGER;
   begin
      if ( Ready = true ) then
         JOIN_UTILS.Get_Id(Assigned_Id);
         if( Assigned_Id /= -1 ) then
            -- TODO: Handle exception for initialization failure
            null;
            -- Add the competitor to the list
            -- Competitors.add(Init_Competitor(Assigned_Id,CompetitorFileDescriptor_In,Get_Iterator(Circuit_Point)));
         end if;
         return Assigned_Id;
      end if;
      return -2;
   end;

   procedure Start_CompetitorsTasks is
   begin
      for index in Competitors'RANGE loop
         if(Competitors(index) /= 0) then -- TODO: use "null" instead of "0" when Competitor package is ready
            -- comp.start
            null;
         end if;
      end loop;
   end Start_CompetitorsTasks;

   -- Box call this method to signal it's ready to start
   procedure BoxOk( CompetitorId_In : INTEGER ) is
      ReadyToStart : BOOLEAN;
   begin
      JOIN_UTILS.Box_Ready(ReadyToStart);
      if(ReadyToStart) then
         Start_CompetitorsTasks;
      end if;

   end BoxOK;

   -- Called if admin explicitally decides to start race before all expected competitors joined
   procedure Stop_Joining is
      ReadyToStart : BOOLEAN;
   begin
      JOIN_UTILS.Block(ReadyToStart);
      if(ReadyToStart) then
         Start_CompetitorsTasks;
      end if;
   end Stop_Joining;


end Competition;
