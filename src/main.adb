with System;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
with Ada.Calendar;
with Competitor;
use Competitor;
--with Stats;
--use Stats;
--with RegistrationHandler.Impl;
--use RegistrationHandler.Impl;
--with Competition;
--use Competition;
--with OnBoardComputer;
--use OnBoardComputer;
with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes; use DOM.Core.Nodes;
with DOM.Core.Attrs; use DOM.Core.Attrs;
with Ada.IO_Exceptions;


procedure Main is
      xml_file : STRING := "obj/car_driver.xml";
      --parametri
      Input : File_Input;
      Reader : Tree_Reader;
      Doc : Document;
      carDriver_XML : Node_List;
      carDriver_Length : INTEGER;
      --   carDriver_Out : CAR_DRIVER_ACCESS;
      --carDriver : CAR_DRIVER_ACCESS;
   tempCar : COMPETITOR.STRATEGY_CAR;
  -- taskTemp : COMPETITOR.TASKCOMPETITOR := new COMPETITOR.TASKCOMPETITOR;

   procedure Try_OpenFile is
      begin

         Open(xml_file,Input);

         Set_Feature(Reader,Validation_Feature,False);
         Set_Feature(Reader,Namespace_Feature,False);

         Parse(Reader,Input);

         Doc := Get_Tree(Reader);
         carDriver_XML := Get_Elements_By_Tag_Name(Doc,"car_driver");
         carDriver_Length := Length(carDriver_XML);
      exception
         when ADA.IO_EXCEPTIONS.NAME_ERROR => Doc := null;
      end Try_OpenFile;


   procedure Configure_Strategy_File(Car_In : in out STRATEGY_CAR;
                                        xml_file : DOCUMENT) is -- metodo per la configurazione della strategia a partire da un file

      pitstopGasolineLevel_In : FLOAT;
         pitstopLaps_In : INTEGER;
         pitstopCondition_In : BOOLEAN;
         trim_In : INTEGER;
         pitstop_In : BOOLEAN;
         strategy_XML : Node_List;
         Current_Node : Node;




         --Car_Temp : CAR;
         --Car_Current : CAR;

         function Get_Feature_Node(Node_In : NODE;
                                   FeatureName_In : STRING) return NODE is
            Child_Nodes_In : NODE_LIST;
            Current_Node : NODE;
         begin

            Child_Nodes_In := Child_Nodes(Node_In);
            for Index in 1..Length(Child_Nodes_In) loop
               Current_Node := Item(Child_Nodes_In,Index-1);
               if Node_Name(Current_Node) = FeatureName_In then
                  return Current_Node;
               end if;
            end loop;

            return null;
      end Get_Feature_Node;
        begin

         --If there is a conf file, use it to auto-init;

         --if Document_In /= null then

         strategy_XML := Get_Elements_By_Tag_Name(xml_file,"strategy_car");

         Current_Node := Item(strategy_XML, 0);

         strategy_XML := Child_Nodes(Current_Node);
         pitstopGasolineLevel_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"pitstopGasolineLevel"))));
         pitstopLaps_In := Integer'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"pitstopLaps"))));
         pitstopCondition_In := Boolean'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"pitstopCondition"))));
         trim_In := Integer'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"trim"))));
         pitstop_In := Boolean'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"pitstop"))));

         --Racetrack_In(Index) := CheckpointSynch_Current;


         --end if;
         -- scrittura parametri
         Configure_Strategy(Car_In,
                            pitstopGasolineLevel_In ,
                            pitstopLaps_In,
                            pitstopCondition_In,
                            trim_In,
                            pitstop_In);
end Configure_Strategy_File;

begin

   Ada.Text_IO.Put_Line("init car...");
   Try_OpenFile;
   Configure_Strategy_File(tempCar,Doc);
   Ada.Text_IO.Put_Line("end init car...");


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
                              StatisticsRefreshFrequency_In => 100.0
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
