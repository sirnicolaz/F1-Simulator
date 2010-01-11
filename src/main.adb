with System;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
with Ada.Calendar;
with Competition;
use Competition;
--with Stats;
--use Stats;
--with RegistrationHandler.Impl;
--use RegistrationHandler.Impl;
--with Competition;
--use Competition;
with OnBoardComputer;
use OnBoardComputer;

procedure Main is
   --Stats Test
--     Stat_Node_1 : SOCT_NODE_POINT := new SOCT_NODE;
--     Stat_Node_2 : SOCT_NODE_POINT := new SOCT_NODE;
--     Stat_Node_3 : SOCT_NODE_POINT := new SOCT_NODE;
--
--     SOCT_Point_1 : SOCT_POINT := new SYNCH_ORDERED_CLASSIFICATION_TABLE;
--     SOCT_Point_2 : SOCT_POINT := new SYNCH_ORDERED_CLASSIFICATION_TABLE;
--     SOCT_Point_3 : SOCT_POINT := new SYNCH_ORDERED_CLASSIFICATION_TABLE;
--
--     Test_Row : STATS_ROW;
--     Test_Node : SOCT_NODE_POINT;
--
--     Test_Stats : SYNCH_GLOBAL_STATS;
--     Test_Classific : CLASSIFICATION_TABLE(1..3);

   --Competition Test
--     RadioAddress_Out : STRING(1..100);
--     MonitorSystemAddress : STRING(1..100);

   --Onboard Computer test
     TestComputer : COMPUTER_POINT := new COMPUTER;
--
--     task type Consumer is
--        entry Init(MyComputer_In : COMPUTER_POINT; Id_In : INTEGER; DelayTime_In : Duration);
--     end Consumer;
--
--     TestConsumer1 : Consumer;
--     TestConsumer2 : Consumer;
--     TestConsumer3 : Consumer;
--     TestConsumer4 : Consumer;
--     TestConsumer5 : Consumer;
--
--     task body Consumer is
--        MyComputer : COMPUTER_POINT;
--        Id : INTEGER;
--        Stats : COMP_STATS;
--        Lap : INTEGER := 1;
--        Sector : INTEGER := 1;
--        DelayTime : Duration;
--     begin
--        accept Init(MyComputer_In : COMPUTER_POINT; Id_In : INTEGER; DelayTime_In : Duration) do
--           MyComputer := MyComputer_In;
--           Id := Id_In;
--           DelayTime := DelayTime_In;
--        end Init;
--        Put_Line("Computer started in consumer" & INTEGER'IMAGE(Id));
--        while true loop
--           MyComputer.Get_StatsBySect(ReqID => Id,
--                                      Sector    => Sector,
--                                      Lap       => Lap,
--                                      CompStats => Stats);
--           Sector := Sector + 1;
--           if Sector = 4 then
--              Sector := 1;
--              Lap := Lap + 1;
--           end if;
--
--           Put_Line("ID: " & INTEGER'IMAGE(Id) & ", Time in lap " & INTEGER'IMAGE(Get_Lap(Stats)) & ", sector " & INTEGER'IMAGE(Get_Sector(Stats)) & " is " & FLOAT'IMAGE(Get_Time(Stats)));
--           delay DelayTime;
--        end loop;
--
--     end Consumer;
--
     task type Producer is
        entry Init(MyComputer_In : COMPUTER_POINT);
     end Producer;

     TestProducer : Producer;

    task body Producer is
       MyComputer : COMPUTER_POINT;
       Stats : COMP_STATS;
        Lap : INTEGER := 1;
        Sector : INTEGER := 1;
        Check : INTEGER := 1;
        Time : FLOAT := 1.0;
     begin
        accept Init(MyComputer_In : COMPUTER_POINT) do
           MyComputer := MyComputer_In;
        end Init;
        Put_Line("Computer started in producer");
        while true loop
           Set_Checkpoint(Stats_In      => Stats,
                          Checkpoint_In => Check);
           Set_Sector(Stats_In  => Stats,
                      Sector_In => Sector);
           Set_Lap(Stats_In => Stats,
                   Lap_In   => Lap);
           Set_Time(Stats_In => Stats,
                    Time_In  => Time);
           MyComputer.Add_Data(Stats);
           Check := Check + 1;
           if Check mod 5 = 0 then
              Sector := Sector +1;
           end if;
           if Sector = 4 then
              Sector := 1;
              Check := 1;
              Lap := Lap + 1;
           end if;
           Time := Time + 0.2;
           Put_Line("Data added by producer: Check " & INTEGER'IMAGE(Get_Checkpoint(Stats)) & ", Sector " & INTEGER'IMAGE(Get_Sector(Stats)) & " Lap " & INTEGER'IMAGE(Get_Lap(Stats)) & ", Time " & FLOAT'IMAGE(Get_Time(Stats)));
             delay 2.2;
        end loop;
     end Producer;

   -- Competition Test 2 (Obr)

   MarlonId : INTEGER;
   NicoleId : INTEGER;

begin

   --Stats test
--     Init_Node(SynchOrdStatTabNode => Stat_Node_1);
--     Set_Node(Stat_Node_1, SOCT_Point_1);
--     Init_Node(SynchOrdStatTabNode => Stat_Node_2);
--     Set_Node(Stat_Node_2, SOCT_Point_2);
--     Set_PreviousNode(Stat_Node_2, Stat_Node_1);
--     Init_Node(SynchOrdStatTabNode => Stat_Node_3);
--     Set_Node(Stat_Node_3, SOCT_Point_3);
--     Set_PreviousNode(Stat_Node_3, Stat_Node_2);
--
--     Get_NodeContent(Stat_Node_1).Init_Table(3);
--     Test_Row := Get_StatsRow(666,1,2,3.0);
--     Get_NodeContent(Stat_Node_1).Add_Row(Test_Row);
--     Test_Row := Get_StatsRow(667,1,2,4.0);
--     Get_NodeContent(Stat_Node_1).Add_Row(Test_Row);
--
--     Get_NodeContent(Stat_Node_2).Init_Table(3);
--     Test_Row := Get_StatsRow(566,1,2,3.0);
--     Get_NodeContent(Stat_Node_2).Add_Row(Test_Row);
--     Test_Row := Get_StatsRow(567,1,2,4.0);
--     Get_NodeContent(Stat_Node_2).Add_Row(Test_Row);
--
--
--     Get_NodeContent(Stat_Node_3).Init_Table(3);
--     Test_Row := Get_StatsRow(466,1,2,3.0);
--     Get_NodeContent(Stat_Node_3).Add_Row(Test_Row);
--     Test_Row := Get_StatsRow(467,1,2,4.0);
--     Get_NodeContent(Stat_Node_3).Add_Row(Test_Row);
--
--     if (not IsLast(Stat_Node_1)) then
--        Test_Node := Get_NextNode(Stat_Node_1);
--        Put(INTEGER'IMAGE(Get_CompetitorId(Get_NodeContent(Test_Node).Get_Row(1))));
--     end if;
--     Put_Line(INTEGER'IMAGE(Get_Index(Stat_node_1)));
--
--     Put_Line("New");
--
--     Test_Stats.Init_GlobalStats(10.0);
--     Test_Stats.Set_CompetitorsQty(3);
--     Test_Stats.Update_Stats(1,1,1,11.0);
--     Test_Stats.Update_Stats(2,1,1,17.0);
--     Test_Stats.Update_Stats(3,1,1,19.0);
--
--     Test_Stats.Update_Stats(1,1,1,24.0);
--     Test_Stats.Update_Stats(2,1,1,21.0);
--     Test_Stats.Update_Stats(3,1,1,29.0);
--
--     Test_Stats.Get_Classific(1,Test_Classific);
--     Put_Line(INTEGER'IMAGE(Get_CompetitorId(Test_Classific(1))));
--
--     Test_Stats.Get_Classific(2,Test_Classific);
--     Put_Line(INTEGER'IMAGE(Get_CompetitorId(Test_Classific(3))));

   -- COmpetition test

--     Join(CompetitorDescriptor_In => "Ciao",
--          Address_In              => "Nessuno",
--          RadioAddress_out        => RadioAddress_out,
--          CompId_out              => 12,
--          MonitorSystemAddress    => MonitorSystemAddress);
--
--     Put_Line("Main laps" & POSITIVE'IMAGE(Competition.Laps_Qty));
--     Competition.Configure_Ride(LapsQty_In                 => 666,
--                                CompetitorsQty_In          => 2,
--                                StatisticsRefreshFrequency => 100.0);
--     Put_Line("Main laps" & POSITIVE'IMAGE(Competition.Laps_Qty));
--
--     Join(CompetitorDescriptor_In => "Ciao",
--          Address_In              => "Nessuno",
--          RadioAddress_out        => RadioAddress_out,
--          CompId_out              => 12,
--          MonitorSystemAddress    => MonitorSystemAddress);
--     Put("Finished");

   --Onboard computer test
   TestComputer.Init_Computer(1);
--     TestConsumer1.Init(TestComputer,1,0.7);
--     TestConsumer2.Init(TestComputer,2,0.7);
--     TestConsumer3.Init(TestComputer,3,0.7);
--     TestConsumer4.Init(TestComputer,4,0.7);
--     TestConsumer5.Init(TestComputer,5,0.7);
--     Put_Line("Consumer started");
   TestProducer.Init(TestComputer);
--     Put_Line("Producer started");

   -- Competition test 2 (Orb)
   Competition.Configure_Ride(LapsQty_In                 => 5,
                              CompetitorsQty_In          => 2,
                              StatisticsRefreshFrequency => 100.0
                             );
   Competition.Add_Computer2Monitor(TestComputer);
   --Put_Line("TEST " & Competition.Get_Stats(1));
   --Competition.Start_Monitor;
   MarlonId := Competition.Join("Marlon Brando");
   Put_Line("Competitor Marlon Brando joined with id = " & INTEGER'IMAGE(MarlonId));
   Competition.BoxOk(MarlonId);
   NicoleId := Competition.Join("Nicole Kidman");
   Put_Line("Competitor Nicole Kidman joined with id = " & INTEGER'IMAGE(NicoleId));
   Competition.BoxOk(NicoleId);
end Main;
