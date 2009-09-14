with System;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
with Competitor;
use Competitor;
with Circuit;
use Circuit;
with Queue;

procedure Main is
   --Ferrari : CAR;
   --EngineString : STRING(1..20);
   Segment_1 : SEGMENT(3);
   Path_1_1 : PATH;

   TestQueue : Queue.QUEUE(1..5);
   SortQueueTest : Queue.SORTED_QUEUE(1..5);

begin
   --EngineString := "Ferrari Engine      ";
   --Set_Values(Ferrari, 310.10, 50.00 , 20.00 , EngineString);
   --Put("Ferrari MaxSpeed = ");
   --Put_Line(Float'Image(Get_MaxSpeed(Ferrari)));
   --Put("Engine = " & Get_Engine(Ferrari));

   Set_Values(Segment_1,1,FALSE,42.00);
   Path_1_1 := Get_Path(Segment_1,1);
   Put_Line("Path 1 in Segment 1 has length = " & Float'Image(Get_Length(Path_1_1)));

   Queue.Add_Competitor2Queue(TestQueue,5,6.0,false,1);
   Queue.Add_Competitor2Queue(TestQueue,6,1.0,false,2);
   Queue.Add_Competitor2Queue(TestQueue,7,7.1,false,3);
   Queue.Add_Competitor2Queue(TestQueue,8,3.2,false,4);
   Queue.Add_Competitor2Queue(TestQueue,9,4.2,false,5);
   Put("Competitor 7 is in position ");
   Put_Line(Integer'Image(Queue.Get_Position(TestQueue,9)));
   Put_Line("Queue filled");

   Queue.Init_Queue(SortQueueTest);

   for Index in TestQueue'Range loop
      Queue.Add_Competitor2Queue(SortQueueTest, Queue.Get_CompetitorID(TestQueue(Index)),Queue.Get_ArrivalTime(TestQueue(Index)),Queue.Get_IsActive(TestQueue(Index)));
      Put("Competitor " & INTEGER'Image(Queue.Get_CompetitorID(TestQueue(Index))) & " inserted in position ");
      Put_Line(Integer'Image(Queue.Get_Position(SortQueueTest,Queue.Get_CompetitorID(TestQueue(Index)))) & " with arrival time = " & FLOAT'Image(Queue.Get_ArrivalTime(TestQueue(Index))));
   end loop;

   Queue.Add_Competitor2Queue(SortQueueTest,9,6.0,false);
   Put_Line("--------------------------");

   for Index in SortQueueTest'RANGE loop
      Put("Position for competitor " & INTEGER'Image(Queue.Get_CompetitorID(SortQueueTest(Index))) & ": ");
      Put_Line(Integer'Image(Queue.Get_Position(SortQueueTest,Queue.Get_CompetitorID(SortQueueTest(Index)))) & " with arrival time = " & FLOAT'Image(Queue.Get_ArrivalTime(SortQueueTest(Index))));
   end loop;

   null;
end Main;
