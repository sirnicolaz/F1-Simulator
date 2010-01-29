with Circuit;
use Circuit;

--with Competitor;
--use Competitor;

with Stats;
use Stats;

with MonitorSystem.Impl;
use MonitorSystem.Impl;

with RegistrationHandler.Impl;
use RegistrationHandler.Impl;

with CORBA.Impl;

with OnboardComputer;

package Competition is

   task type CompetitionTask is
      -- entries
      entry ConfigureCompetition()
      entry JoinCompetition(
                            CompetitorFileDescriptor_In : STRING;
                            Id_Out : out INTEGER);
      entry BoxReady(Competitor_Id : in INTEGER);
   end CompetitionTask;

--   task MonitorTask;
--   task RegistrationHandlerTask;

   procedure Configure_Circuit( ClassificRefreshRate_In : FLOAT;
                               CircuitName_In : STRING;
                               CircuitLocation_In : STRING;
                               RaceConfigFile_In : STRING );

   procedure Configure_Ride(
                            LapsQty_In : INTEGER;
                            CompetitorsQty_In : INTEGER;
                            StatisticsRefreshFrequency_In : FLOAT);

   function Get_MonitorAddress return STRING;

   -- Initialize the competitor
   function Join(CompetitorFileDescriptor_In : STRING) return INTEGER;
   -- Box call this method to signal they are ready to start
   procedure BoxOk( CompetitorId_In : INTEGER);
   -- Each competitor task is started
   procedure Stop_Joining;



   ---Begin test methods specification---
   procedure Add_Computer2Monitor(ComputerPoint_In : OnboardComputer.COMPUTER_POINT);
   procedure Start_Monitor;
end Competition;
