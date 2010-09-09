with Ada.Text_IO;

with Common;
with CompetitionComputer;

--pragma Warnings (Off); -- TODO: delete
package body Competition is

   -- type Monitor_POINT is access MONITOR --to implement (Lory)

   -- This method is supposed to be called when either all the
   --+competitors are registered or the administrator manually
   --+starts the competition
   procedure Ready(Competition_In : SYNCH_COMPETITION_POINT;
                   Wait_All : BOOLEAN) is
   begin

      Ada.Text_IO.Put_Line("Waiting for ready...");

      if( Wait_All ) then
            Competition_In.Wait;
      end if;

      Ada.Text_IO.Put_Line("Ready!");


      Competition_In.Start;

   end Ready;

   protected body SYNCH_COMPETITION is

      entry Register_NewCompetitor(CompetitorDescriptor : in STRING;
                                   Box_CorbaLOC : in STRING;
                                   Given_Id : out INTEGER;
                                   Laps_Out : out INTEGER;
                                   CircuitLength_Out : out FLOAT;
                                   Monitor_CorbaLoc_Out : out Unbounded_String.Unbounded_String) when Registrations_Open is
         ID : INTEGER;
         Driver : CAR_AND_DRIVER_ACCESS;

         --Generic state boolean
         Result : BOOLEAN := false;

         --TODO: remove after testing new method
         CompetitorDescriptor_File : Ada.Text_IO.FILE_TYPE;
         File_Name : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      begin

         -- In this case, either the maximum number of competitor has been reached
         --+ or the administrator has manually started the race
         --+ so no further joining is possible
         if ( Stop_Joining = true ) then

            Ada.Text_IO.Put_Line("Stop joining");
            Given_Id := -1;
         else

            --Find an available ID for the competitor
            ID := Next_ID;
            Next_ID := Next_ID + 1;

            -- Creating the file where the CompetitorDescriptor will be saved
            Ada.Text_IO.Put_Line("Saving file...");
            File_Name := Unbounded_String.To_Unbounded_String("Competitor-"& Common.IntegerToString(ID) & ".xml");

            --Handler the saving failure
            Result := Common.SaveToFile(FileName => Unbounded_String.To_String(File_Name),
                              Content  => CompetitorDescriptor,
                              Path     => "");
            --TODO: remove after testing
            --Ada.Text_IO.Create(CompetitorDescriptor_File, Ada.Text_IO.Out_File, Unbounded_String.To_String(File_Name));
            --Ada.Text_IO.Put(CompetitorDescriptor_File, CompetitorDescriptor);
            --Ada.Text_IO.Close(CompetitorDescriptor_File);
            --Instantiate a new CAR_DRIVER to initialise the TASKCOMPETITOR
            Ada.Text_IO.Put_Line("Init competitor...");
            Driver := Init_Competitor(Unbounded_String.To_String(File_Name),
                                      Circuit.Get_Iterator(Track),
                                      ID,
                                      Laps,
                                      Box_CorbaLOC);
            --Initialise the task competitor
            Ada.Text_IO.Put_Line("Init task...");
            Competitors.all(ID) := new TASKCOMPETITOR(Driver);
            Ada.Text_IO.Put_Line("End");
            Given_ID := ID;

            Comp_List(ID) := ID;

            Laps_Out := Laps;
            CircuitLength_Out := Circuit_Length;
            Monitor_CorbaLoc_Out := Monitor_CorbaLoc;

            Ada.Text_IO.Put_Line("Competitor ID : " & INTEGER'IMAGE(Given_ID));
            Ada.Text_IO.Put_Line("Name : " & Unbounded_String.To_String(Competitor.Get_FirstName(Competitor_In => Driver)));

            --TODO fix
            if ( Next_ID = Competitors'LENGTH + 1 ) then
               Stop_Joining := true;
            end if;

         end if;

      end;

      procedure Start is
      begin

         Ada.Text_IO.Put_Line("Wating box ready");

         Stop_Joining := true;

         --This method (Start) is called only when noone needs
         --+ to call the competition anymore, because all the competitor
         --+ supposed to ride are registered. So this WaitReady
         --+ is not blocking any request.
         pragma Warnings(off);
         Monitor.WaitReady;
         pragma Warnings(On);

         Ada.Text_IO.Put_Line("Box ready!");

         Set_Competitors(Track,Comp_List.all);


         --We are aware of what we are doing here and
         --+ the Start is not a blocking action.
         Ada.Text_IO.Put_Line("Starting competitors");
         pragma Warnings (Off);
         for Index in 1..Next_Id-1 loop
            Competitors.all(Index).Start;
         end loop;
         pragma Warnings (On);

         Ada.Text_IO.Put_Line("Competition started!!!!!!!!!");
         -- TODO: wait the end of the competition:
         --+ either all the competitors are arrived or
         --+ retired. Use the global statistic for this.

      end Start;

      entry Wait when Configured = true and Stop_Joining = true is
      begin
         null;
      end Wait;

      procedure Configure( MaxCompetitors : in POSITIVE;
                          Name_in : in STRING;
                          Laps_in : in INTEGER;
                          Circuit_File : in STRING) is

         Track_Iterator : RACETRACK_ITERATOR;
         Track_Length : FLOAT := 0.0;
         --Starter : access Competition_Monitor.impl.MonitorStarter;
      begin
         Ada.Text_IO.Put_Line("Configuring competition (inside)");
         Laps := Laps_In;

         Name := Unbounded_String.To_Unbounded_String(Name_In);

         Ada.Text_IO.Put_Line("Getting racetrack file: " & Circuit_File);
         Circuit.Set_MaxCompetitorsQty(MaxCompetitors);
         Track := Circuit.Get_Racetrack(Circuit_File);
         Circuit_Length := Circuit.RaceTrack_Length;
         Checkpoint_Qty := Circuit.Checkpoints_Qty;

         Ada.Text_IO.Put_Line("Initilizing competitor array");
         Competitor.Set_Laps(Laps_In);
         Competitors := new CompetitorTask_Array(1..MaxCompetitors);

         CompetitionComputer.Init_Stats(Competitor_Qty => MaxCompetitors,
                          Laps           => Laps_In,
                          Checkpoints_In => Checkpoint_Qty);

         Ada.Text_IO.Put_Line("Checkpoints " & INTEGER'IMAGE(Checkpoint_Qty));

         Registrations_Open := True;

         CompetitionComputer.Init_StaticInformation(Laps_In ,
                                                    MaxCompetitors,
                                                    Unbounded_string.To_Unbounded_String(Name_In),
                                                    Circuit_Length);

         Ada.Text_IO.Put_Line("initializing monitor");
         Monitor := Competition_Monitor.Init(MaxCompetitors,
                                             Laps_In);

         --NEW: moved to init.adb procedure
         --Starter := new Competition_Monitor.impl.MonitorStarter;

         Configured := True;

         Comp_List := new Common.COMPETITOR_LIST(1..MaxCompetitors);
      end Configure;

      procedure Set_MonitorCorbaLOC ( Monitor_COrbaLoc_In : Unbounded_String.Unbounded_String) is
      begin
         Monitor_CorbaLoc := Monitor_CorbaLoc_In;
      end Set_MonitorCOrbaLOC;

      function Get_Laps return INTEGER is
      begin
         return Laps;
      end Get_Laps;

      function Get_CircuitLength return FLOAT is
      begin
         return Circuit_Length;
      end Get_CircuitLength;

      function Get_MonitorCorbaLOC return STRING is
      begin
         return Unbounded_String.To_String(Monitor_CorbaLoc);
      end Get_MonitorCorbaLOC;

      function AreRegistrationsOpen return BOOLEAN is
      begin
         return Registrations_Open;
      end AreRegistrationsOpen;

   end SYNCH_COMPETITION;

end Competition;
