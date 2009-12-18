with System;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
--with Competitor;
--use Competitor;
with Stats;
use Stats;

procedure Main is

   Stat_Node_1 : SOST_NODE_POINT := new SOST_NODE;
   Stat_Node_2 : SOST_NODE_POINT := new SOST_NODE;
   Stat_Node_3 : SOST_NODE_POINT := new SOST_NODE;

   SOST_Point_1 : SOST_POINT := new SYNCH_ORDERED_STATS_TABLE;
   SOST_Point_2 : SOST_POINT := new SYNCH_ORDERED_STATS_TABLE;
   SOST_Point_3 : SOST_POINT := new SYNCH_ORDERED_STATS_TABLE;

   Test_Row : STATS_ROW;
   Test_Node : SOST_NODE_POINT;
begin
   Init_Node(SynchOrdStatTabNode => Stat_Node_1);
   Set_Node(Stat_Node_1, SOST_Point_1);
   Init_Node(SynchOrdStatTabNode => Stat_Node_2);
   Set_Node(Stat_Node_2, SOST_Point_2);
   Set_PreviousNode(Stat_Node_2, Stat_Node_1);
   Init_Node(SynchOrdStatTabNode => Stat_Node_3);
   Set_Node(Stat_Node_3, SOST_Point_3);
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
   Put(INTEGER'IMAGE(Get_Index(Stat_node_1)));

   Put("Finished");

end Main;
