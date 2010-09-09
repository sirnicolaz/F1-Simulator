with Competition_Monitor;
use Competition_Monitor;

with Common;

with Stats;

with OnBoardComputer;

with Ada.Text_IO;
procedure Competition_Monitor_Tester is

   Radio : Competition_Monitor_Radio.Ref;

begin

   GenStats_Test := new Stats.GENERIC_STATS;

   GlobStats_Test := new Stats.GLOBAL_STATS_HANDLER
     (new FLOAT'(ClassificRefreshTime),GenStats_Test);

   StartStop_Test := Competition_Monitor.Init(Competitors,50,GlobStats_Test);

   Test_Req := new Requester;

   Tmp_OnboardComp := new OnboardComputer.COMPUTER;
   Tmp_OnboardComp.Init_Computer(CompetitorId_In => 1,
                                 tempGlobal      => GlobStats_Test);


end Competition_Monitor_Tester;
