with Ada.Text_IO;

with Common;

package body Competition is

   -- type Monitor_POINT is access MONITOR --to implement (Lory)

   -- This method is supposed to be called when either all the
   --+competitors are registered or the administrator manually
   --+starts the competition
   procedure Ready(Competition_In : SYNCH_COMPETITION_POINT;
                   Wait_All : BOOLEAN) is
   begin

      if( Wait_All ) then
            Competition_In.Wait;
      end if;

      Competition_In.Start;

   end Ready;

   protected body SYNCH_COMPETITION is

      entry Register_NewCompetitor(CompetitorDescriptor : in STRING;
                                       Box_CorbaLOC : in STRING;
                                       Given_Id : out INTEGER) when Registrations_Open is
         ID : INTEGER;
         Driver : CAR_DRIVER_ACCESS;

         CompetitorDescriptor_File : Ada.Text_IO.FILE_TYPE;
         File_Name : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      begin

         --Find an available ID for the competitor
         ID := Next_ID;
         Next_ID := Next_ID + 1;

         -- Creating the file where the CompetitorDescriptor will be saved
         Ada.Text_IO.Put_Line("Saving file...");
         File_Name := Unbounded_String.To_Unbounded_String("Competitor-"& Common.IntegerToString(ID) & ".xml");
         Ada.Text_IO.Create(CompetitorDescriptor_File, Ada.Text_IO.Out_File, Unbounded_String.To_String(File_Name));
         Ada.Text_IO.Put(CompetitorDescriptor_File, CompetitorDescriptor);
         Ada.Text_IO.Close(CompetitorDescriptor_File);
         --Instantiate a new CAR_DRIVER to initialise the TASKCOMPETITOR
         Ada.Text_IO.Put_Line("Init competitor...");
         Driver := Init_Competitor(Unbounded_String.To_String(File_Name),Circuit.Get_Iterator(Track),ID);
         --Initialise the task competitor
         Ada.Text_IO.Put_Line("Init task...");
         Competitors.all(1) := new TASKCOMPETITOR(Driver);
         Ada.Text_IO.Put_Line("End");
         Given_ID := ID;

         if ( ID = Competitors'LENGTH + 1 ) then
            Registrations_Open := false;
         end if;
      end;

      procedure Start is
      begin
         Registrations_Open := false;

         -- Monitor.Wait_Ok;

         for Index in Competitors'RANGE loop
            Competitors.all(Index).Start;
         end loop;
      end Start;

      entry Wait when Registrations_Open = false is
      begin
         null;
      end Wait;

      procedure Configure( MaxCompetitors : in POSITIVE;
                          ClassificRefreshTime_in : in FLOAT;
                          Name_in : in STRING;
                          Laps_in : in INTEGER;
                          Circuit_File : in STRING) is
      begin
         Laps := Laps_In;
         Name := Unbounded_String.To_Unbounded_String(Name_In);
         ClassificRefreshTime := ClassificRefreshTime_In;

         Competitors := new CompetitorTask_Array(1..MaxCompetitors);

         Track := Circuit.Get_Racetrack(Circuit_File);

         Registrations_Open := True;
      end Configure;

      function AreRegistrationsOpen return BOOLEAN is
      begin
         return Registrations_Open;
      end AreRegistrationsOpen;

   end SYNCH_COMPETITION;

end Competition;
