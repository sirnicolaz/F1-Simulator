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

with Common;

package body Competition is

   -- type Monitor_POINT is access MONITOR --to implement (Lory)

   protected body SYNCH_COMPETITION is

      procedure Register_NewCompetitor(CompetitorDescriptor : in STRING;
                                       Box_CorbaLOC : in STRING;
                                       Given_Id : out INTEGER) is
         ID : INTEGER;
         Driver : CAR_DRIVER_ACCESS;

         CompetitorDescriptor_File : Ada.Text_IO.FILE_TYPE;
         File_Name : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      begin

         --Find an available ID for the competitor
         ID := Next_ID;
         Next_ID := Next_ID + 1;

         -- Creating the file where the CompetitorDescriptor will be saved
         File_Name := Unbounded_String.To_Unbounded_String("Competitor-"& Common.IntegerToString(ID) & ".xml");
         Ada.Text_IO.Create(CompetitorDescriptor_File, Ada.Text_IO.Out_File, Unbounded_String.To_String(File_Name));

         --Instantiate a new CAR_DRIVER to initialise the TASKCOMPETITOR
         Driver := Init_Competitor(Unbounded_String.To_String(File_Name),Circuit.Get_Iterator(Track),ID);
         --Initialise the task competitor
         Competitors.all(1) := new TASKCOMPETITOR(Driver);
         Given_ID := ID;
      end;

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

         Done := True;
      end Configure;

   end SYNCH_COMPETITION;

end Competition;
