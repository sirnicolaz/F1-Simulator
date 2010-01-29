with CORBA.Impl;
use CORBA.Impl;
with CORBA.Object;
with CORBA.ORB;

with PortableServer.POA.Helper;
with PortableServer.POAManager;

with PolyORB.CORBA_P.CORBALOC;

with PolyORB.Setup.Thread_Per_Request_Server;
pragma Warnings (Off, PolyORB.Setup.Thread_Per_Request_Server);

with Ada.Text_IO;

package body Competition is

   task body CompetitionTask is
      --FIELDs
      Ready : BOOLEAN := false;
      Circuit_Point : RACETRACK_POINT;
      Laps_Qty : INTEGER := 0;
      Competitors_Qty : INTEGER := 0;
      JoinedCompetitors : INTEGER := 0;
      MonitorIOR : access STRING;
      Ready2Start : BOOLEAN := false;
      StatisticsRefreshFrequency : FLOAT;
   begin
         --attesa iscrizione concorrenti da parte dei box (o stop dell'amministratore)
      loop
         accept JoinCompetition(CompetitorFileDescriptor_In : STRING; Id_Out : out INTEGER)
         do
            Id_Out := Join(CompetitorFileDescriptor_In);
            TempId := Id_Out;
         end JoinCompetition;
         exit when TempId = -1;
      end loop;

      --attesa ok dei box
      while ( not Ready2Start ) loop
         accept BoxReady(Competitor_Id : in INTEGER) do
            BoxOk(Competitor_Id);
         end BoxReady;
      end loop;
      --inizio gara


   end CompetitionTask;

   -- array of competitors pointer subtype COMPETITOR_LIST is array OF
   type COMPETITOR_LIST is array( INTEGER range <> ) of INTEGER;
   type COMPETITOR_LIST_POINT is access COMPETITOR_LIST;
   Competitors : COMPETITOR_LIST_POINT;

  -- task body MonitorTask is
--   begin

   --task RegistrationHandlerTask;

   -- It handles the mutually exlusive assignment of the ids to the joining competitor and
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
         if (ReadyBoxes = MaxCompetitors) then
           ReadyToStart_Out := true;
         end if;
      end;

   end JOIN_UTILS;

   -- Initialize Monitor System


   -- Method to set init the circuit
   procedure Configure_Circuit( ClassificRefreshRate_In : FLOAT;
                               CircuitName_In : STRING;
                               CircuitLocation_In : STRING;
                               RaceConfigFile_In : STRING) is
   begin
        Circuit_Point:=Get_Racetrack(RaceConfigFile_In);
   end Configure_Circuit;

   -- Procedure that sets needed information for the competition. These informations need to be
   -- setted before the competitors start to join
   procedure Configure_Ride( LapsQty_In : INTEGER;
                            CompetitorsQty_In : INTEGER;
                            StatisticsRefreshFrequency_In : FLOAT)
   is
--      use PortableServer.POA.GOA;
--      use PolyORB.CORBA_P.Server_Tools;
   begin
--        Ada.Text_IO.Put_Line("Configuring...");
--        Ada.Text_IO.Put_Line("Init CORBA...");
--        CORBA.ORB.Initialize ("ORB");
--        Ada.Text_IO.Put_Line("CORBA initialized.");
--        declare
--           use CORBA.Impl;
--           ServersGroup : constant PortableServer.POA.GOA.Ref;
--
--           Policies : CORBA.Policy.PolicyList;
--
--           Ref : CORBA.Object.Ref;
--           Ref2 : CORBA.Object.Ref;
--           Group : CORBA.Object.Ref;
--
--           ServersGroup := PortableServe.POA.GOA.To_Ref
--             (PortableServer.POA.Create_POA
--                (Get_Root_POA,
--                 CORBA.To_CORBA_STRING("RootGOA"),
--                 PortableServer.POA.Get_The_POAManager(Get_Root_POA),
--                 Policies));
--
--           MonitorSys : constant CORBA.Impl.Object_Ptr := new MonitorSystem.Impl.Object;
--           MonitorSys2 : constant CORBA.Impl.Object_Ptr := new MonitorSystem.Impl.Object;
--
--           MonitorID1 : constant PortableServer.ObjectId := Servant_To_Id(ServersGroup,PortableServer.Servant(MonitorSys));
--           MonitorID2 : constant PortableServer.ObjectId := Servant_To_Id(ServersGroup,PortableServer.Servant(MonitorSys2));
--        begin
--           Ada.Text_IO.Put_Line("Init system...");
--              -- Init monitor system
--              MonitorSystem.Impl.Init_Monitor(CompetitorsQty_In,StatisticsRefreshFrequency);
--              --  Retrieve Root POA
--              --Root_POA := PortableServer.POA.Helper.To_Local_Ref
--              --  (CORBA.ORB.Resolve_Initial_References
--              --     (CORBA.ORB.To_CORBA_String ("RootPOA")));
--              --            Ada.Text_IO.Put_Line(CORBA.ORB.To_CORBA_String(Root_POA));
--
--           Initiate_Servant(PortableServer.Servant(MonitorSys), Ref);
--           Initiate_Servant(PortableServer.Servant(MonitorSys2), Ref2);
--
--           --CORBA.ORB.String_To_Object
--
--           PortableServer.POAManager.Activate
--                (PortableServer.POA.Get_The_POAManager (Root_POA));
--
--              --  Set up new object
--
--              Ref := PortableServer.POA.Servant_To_Reference(Root_POA, PortableServer.Servant (MonitorSys));
--
--              Ref2 := PortableServer.POA.Servant_To_Reference
--                (Root_POA, PortableServer.Servant (MonitorSys2));
--
--              MonitorIOR := new STRING'("'" & CORBA.To_Standard_String (CORBA.Object.Object_To_String (Ref)) & "'");
--              Ada.Text_IO.Put_Line("'" & CORBA.To_Standard_String (CORBA.Object.Object_To_String (Ref2)));
--              Ada.Text_IO.Put_Line(MonitorIOR.all);
--        end;
      Laps_Qty := LapsQty_In;
      JOIN_UTILS.Set_MaxCompetitors(CompetitorsQty_In);
      StatisticsRefreshFrequency := StatisticsRefreshFrequency_In;
      Competitors := new COMPETITOR_LIST(1..CompetitorsQty_In);
      Ready := true;
   end Configure_Ride;

      procedure Start_Monitor is
   begin
      CORBA.ORB.Run;
   end Start_Monitor;

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
            Ada.Text_IO.Put_Line("Competitor " & CompetitorFileDescriptor_In & " joined.");
            -- TODO: Handle exception for initialization failure
            -- Add the competitor to the list
            -- Competitors.add(Init_Competitor(Assigned_Id,CompetitorFileDescriptor_In,Get_Iterator(Circuit_Point)));
         end if;
         return Assigned_Id;
      end if;
      Ada.Text_IO.Put_Line("Not ready. Retry in a few minutes.");
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
   begin
      JOIN_UTILS.Box_Ready(Ready2Start);
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(CompetitorId_In) & " ready.");
      if(Ready2Start) then
         Ada.Text_IO.Put_Line("Competition can start.");
         --Start_CompetitorsTasks;
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


   function Get_MonitorAddress return STRING is
   begin
      return MonitorIOR.all;
   end Get_MonitorAddress;

   procedure BeginCompetition is
      -- riferimento a competizione

      -- instanziazione task monitorsystem
      task Monitor;
      task body Monitor is
      begin
         begin
            Ada.Text_IO.Put_Line("Configuring...");
            Ada.Text_IO.Put_Line("Init CORBA...");
            CORBA.ORB.Initialize ("ORB");
            Ada.Text_IO.Put_Line("CORBA initialized.");
            declare
               use CORBA.Impl;
               Root_POA : PortableServer.POA.Local_Ref;
               Ref : CORBA.Object.Ref;

               MonitorSys : constant CORBA.Impl.Object_Ptr := new MonitorSystem.Impl.Object;
            begin
               Ada.Text_IO.Put_Line("Init system...");
               -- Init monitor system
               MonitorSystem.Impl.Init_Monitor(Competitors'LENGTH,StatisticsRefreshFrequency);
               --  Retrieve Root POA
               Root_POA := PortableServer.POA.Helper.To_Local_Ref
                 (CORBA.ORB.Resolve_Initial_References
                    (CORBA.ORB.To_CORBA_String ("RootPOA")));

               PortableServer.POAManager.Activate
                 (PortableServer.POA.Get_The_POAManager (Root_POA));

               --  Set up new object

               Ref := PortableServer.POA.Servant_To_Reference(Root_POA, PortableServer.Servant (MonitorSys));

               MonitorIOR := new STRING'("'" & CORBA.To_Standard_String (CORBA.Object.Object_To_String (Ref)) & "'");
               Ada.Text_IO.Put_Line(MonitorIOR.all);

               CORBA.ORB.Run;
            end;
         end;
      end Monitor;

      -- instanziazione task registration handler
      task RegistrationHandler;
      task body RegistrationHandler is
      begin
         begin
            Ada.Text_IO.Put_Line("Configuring registration handler...");
            CORBA.ORB.Initialize ("ORB");
            Ada.Text_IO.Put_Line("CORBA initialized.");
            declare
               Root_POA : PortableServer.POA.Local_Ref;
               Ref : CORBA.Object.Ref;

               RegistrationHand : constant CORBA.Impl.Object_Ptr := new RegistrationHandler.Impl.Object;
            begin
               Ada.Text_IO.Put_Line("Init system...");
               --  Retrieve Root POA
               Root_POA := PortableServer.POA.Helper.To_Local_Ref
                 (CORBA.ORB.Resolve_Initial_References
                    (CORBA.ORB.To_CORBA_String ("RootPOA")));

               PortableServer.POAManager.Activate
                 (PortableServer.POA.Get_The_POAManager (Root_POA));

               --  Set up new object

               Ref := PortableServer.POA.Servant_To_Reference(Root_POA, PortableServer.Servant (MonitorSys));

               RegistrationHandlerIOR := new STRING'("'" & CORBA.To_Standard_String (CORBA.Object.Object_To_String (Ref)) & "'");
               Ada.Text_IO.Put_Line(RegistrationHandlerIOR.all);

               CORBA.ORB.Run;
            end;
         end;
      end RegistrationHandler;

      --dichiarazione task di avvio
      task StartHandler is
         entry JoinCompetition(
                               CompetitorFileDescriptor_In : STRING;
                               Id_Out : out INTEGER);
         entry BoxReady(Competitor_Id : in INTEGER);
      end StartHandler;
      --begin
      task body StartHandler is
         TempId : INTEGER;
      begin

      end StartHandler;

   begin
      Ada.Text_IO.Put_Line("Starting Competition");
   end BeginCompetition;


   ---Begin test methods implementation---
   procedure Add_Computer2Monitor(ComputerPoint_In : OnboardComputer.COMPUTER_POINT) is
   begin
      MonitorSystem.Impl.Add_Computer(ComputerPoint_In);
   end Add_Computer2Monitor;

end Competition;
