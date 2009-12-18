with System;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
--with Competitor;
--use Competitor;
with Stats;
use Stats;

procedure Main is

   Stat_Node_1 : SOCT_NODE_POINT := new SOCT_NODE;
   Stat_Node_2 : SOCT_NODE_POINT := new SOCT_NODE;
   Stat_Node_3 : SOCT_NODE_POINT := new SOCT_NODE;

   SOCT_Point_1 : SOCT_POINT := new SYNCH_ORDERED_CLASSIFICATION_TABLE;
   SOCT_Point_2 : SOCT_POINT := new SYNCH_ORDERED_CLASSIFICATION_TABLE;
   SOCT_Point_3 : SOCT_POINT := new SYNCH_ORDERED_CLASSIFICATION_TABLE;

   Test_Row : STATS_ROW;
   Test_Node : SOCT_NODE_POINT;

   Test_Stats : SYNCH_GLOBAL_STATS;
   Test_Classific : CLASSIFICATION_TABLE(1..3);
begin
   Init_Node(SynchOrdStatTabNode => Stat_Node_1);
   Set_Node(Stat_Node_1, SOCT_Point_1);
   Init_Node(SynchOrdStatTabNode => Stat_Node_2);
   Set_Node(Stat_Node_2, SOCT_Point_2);
   Set_PreviousNode(Stat_Node_2, Stat_Node_1);
   Init_Node(SynchOrdStatTabNode => Stat_Node_3);
   Set_Node(Stat_Node_3, SOCT_Point_3);
   Set_PreviousNode(Stat_Node_3, Stat_Node_2);

   Get_NodeContent(Stat_Node_1).Init_Table(3);
   Test_Row := Get_StatsRow(666,1,2,3.0);
   Get_NodeContent(Stat_Node_1).Add_Row(Test_Row);
   Test_Row := Get_StatsRow(667,1,2,4.0);
   Get_NodeContent(Stat_Node_1).Add_Row(Test_Row);

   Get_NodeContent(Stat_Node_2).Init_Table(3);
   Test_Row := Get_StatsRow(566,1,2,3.0);
   Get_NodeContent(Stat_Node_2).Add_Row(Test_Row);
   Test_Row := Get_StatsRow(567,1,2,4.0);
   Get_NodeContent(Stat_Node_2).Add_Row(Test_Row);


   Get_NodeContent(Stat_Node_3).Init_Table(3);
   Test_Row := Get_StatsRow(466,1,2,3.0);
   Get_NodeContent(Stat_Node_3).Add_Row(Test_Row);
   Test_Row := Get_StatsRow(467,1,2,4.0);
   Get_NodeContent(Stat_Node_3).Add_Row(Test_Row);

   if (not IsLast(Stat_Node_1)) then
      Test_Node := Get_NextNode(Stat_Node_1);
      Put(INTEGER'IMAGE(Get_CompetitorId(Get_NodeContent(Test_Node).Get_Row(1))));
   end if;
   Put_Line(INTEGER'IMAGE(Get_Index(Stat_node_1)));

   Put_Line("New");

   Test_Stats.Init_GlobalStats(10.0);
   Test_Stats.Set_CompetitorsQty(3);
   Test_Stats.Update_Stats(1,1,1,11.0);
   Test_Stats.Update_Stats(2,1,1,17.0);
   Test_Stats.Update_Stats(3,1,1,19.0);

   Test_Stats.Update_Stats(1,1,1,24.0);
   Test_Stats.Update_Stats(2,1,1,21.0);
   Test_Stats.Update_Stats(3,1,1,29.0);

   Test_Stats.Get_Classific(1,Test_Classific);
   Put_Line(INTEGER'IMAGE(Get_CompetitorId(Test_Classific(1))));

   Test_Stats.Get_Classific(2,Test_Classific);
   Put_Line(INTEGER'IMAGE(Get_CompetitorId(Test_Classific(3))));

   Put("Finished");

end Main;
