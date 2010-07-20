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

   -- type Monitor_POINT is access MONITOR --to implement (Lory)

   protected body SYNCH_COMPETITION is

      procedure Join( Driver_Config : STRING;
                     Box_CorbaLOC : STRING) is
      begin
         null;
      end Join;


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

      end Configure;

   end SYNCH_COMPETITION;

end Competition;
