with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Command_Line;

with MonitorSystem.Skel;
pragma Warnings (Off, MonitorSystem.Skel);

package body MonitorSystem.Impl is

   procedure Init_Monitor(CompetitorQty_In : INTEGER; RefreshInterval : FLOAT) is
   begin
      GlobalStatistics := new Stats.SYNCH_GLOBAL_STATS;
      GlobalStatistics.Init_GlobalStats(RefreshInterval);
      GlobalStatistics.Set_CompetitorsQty(CompetitorQty_In);
      Computers := new COMPETITORS_COMPUTERS(1..CompetitorQty_In);
   end Init_Monitor;

   procedure Add_Computer(Computer_In : OnboardComputer.COMPUTER_POINT) is
   begin
      Computers(Computer_In.Get_Id) := Computer_In;
   end Add_Computer;

   function GetCompetitorInfo (Self : access Object;
                               CompetitorId : CORBA.Short) return Corba.STRING is
      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);
   begin
      return CORBA.To_Corba_String("");
   end GetCompetitorInfo;

   function GetCompetitionInfo (Self : access Object) return Corba.STRING is
      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);
   begin
      return CORBA.To_Corba_String("");
   end GetCompetitionInfo;

   function GetEverything(Self : access Object;
                          CompetitorId : CORBA.Short) return Corba.STRING is
      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);
   begin
      return CORBA.To_Corba_String("");
   end GetEverything;


   function GetClassification (Self : access Object) return Corba.STRING is
      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);
   begin
      return CORBA.To_Corba_String("");
   end GetClassification;

   function GetStatsBySect(Self : access Object;
                           CompId : CORBA.Short;
                           Sector : CORBA.Short;
                           Lap : CORBA.Short) return CORBA.String is
      Out_Stats : OnboardComputer.COMP_STATS;
      ReturnedString : access STRING;
   begin
      Computers(INTEGER(CompId)).Get_StatsBySect(ReqID     => 666,
                                                               Sector    => INTEGER(Sector),
                                                               Lap       => INTEGER(Lap),
                                                 CompStats => Out_Stats);

      ReturnedString := new STRING'("Lap: " & INTEGER'IMAGE(OnboardComputer.Get_Lap(Out_Stats)) & ", Sector: " & INTEGER'IMAGE(OnboardComputer.Get_Sector(Out_Stats)) & ", Time: " & FLOAT'IMAGE(OnboardComputer.Get_Time(Out_Stats)));
      return CORBA.To_COrba_String(ReturnedString.all);
   end GetStatsBySect;

end MonitorSystem.Impl;
