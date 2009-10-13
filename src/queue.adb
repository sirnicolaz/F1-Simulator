with GNAT.Heap_Sort;
use GNAT.Heap_Sort;
with Ada.Text_IO; use Ada.Text_IO;

package body Queue is

   procedure Init_Queue(Queue_In : in out QUEUE) is
   begin
      for Index in Queue_In'RANGE loop
         Queue_In(Index) := new QUEUE_CELL'(0,0.0,false);
      end loop;
   end;


   function Get_CompetitorID(Cell_In : QUEUE_CELL_POINT) return INTEGER is
   begin
      return Cell_In.CompetitorID;
   end;

   function Get_ArrivalTime(Cell_In : QUEUE_CELL_POINT) return FLOAT is
   begin
      return Cell_In.ArrivalTime;
   end;

   function Get_IsActive(Cell_In : QUEUE_CELL_POINT) return BOOLEAN is
   begin
      return Cell_In.IsActive;
   end;

   procedure Add_Competitor2Queue(Queue_In : in out QUEUE;
                                  CompetitorID_In : INTEGER;
                             	  ArrivalTime_In : FLOAT;
                                  IsActive_In : BOOLEAN;
                                  Position : INTEGER) is
   begin
      if(Position <= Queue_In'LENGTH) then
         Queue_In(Position) := new QUEUE_CELL'(CompetitorID_In, ArrivalTime_In, IsActive_In);
      end if;
   end;

   function Get_ArrivalTime(Queue_In : QUEUE;
                            Position : INTEGER) return FLOAT is
   begin
      if(Position <= Queue_In'LENGTH and Position > 0) then
         return Queue_In(Position).ArrivalTime;
      else
         return -1.0;
      end if;
   end;

   function Get_Position(Queue_In : QUEUE;
                         ArrivalTime_In : FLOAT) return INTEGER is
   Index : INTEGER := 1;
   begin
      while Index <= Queue_In'LENGTH loop
         if(Queue_In(Index).ArrivalTime = ArrivalTime_In) then
            return Index;
         end if;
         Index := Index + 1;
      end loop;
      return 0;
   end;

   function Get_Position(Queue_In : QUEUE;
                         CompetitorID_In : INTEGER) return INTEGER is
   Index : INTEGER := 1;
   begin
      while Index <= Queue_In'LENGTH loop
         if(Queue_In(Index).CompetitorID = CompetitorID_In) then
            return Index;
         end if;
         Index := Index + 1;
      end loop;
      return 0;
   end;

   procedure Add_Competitor2Queue(Queue_In : in out SORTED_QUEUE;
                                  CompetitorID_In : INTEGER;
                             	  ArrivalTime_In : FLOAT;
                                  IsActive_In : BOOLEAN) is

      Position_Old : INTEGER;
      Position_New : INTEGER := 1;

      begin
      Position_Old := Get_Position(Queue_In,CompetitorID_In);
      if(Position_Old = 0) then
         FindFreePos_Loop:
         for Index in Queue_In'Range loop
            Position_Old := Position_Old + 1;
            exit FindFreePos_Loop when Queue_In(Index).CompetitorID = 0;
         end loop FindFreePos_Loop;
         Add_Competitor2Queue(Queue_In,CompetitorID_In,ArrivalTime_In,IsActive_In,Position_Old);
      end if;

      for Index in Queue_In'Range loop
         if Queue_In(Index).ArrivalTime >= ArrivalTime_In then
            if Index <= Position_Old then
               Position_New := Index;
            else
               Position_New := Index -1;
            end if;
         elsif Queue_In'LENGTH = Index then
            Position_New := Index;
         end if;
         exit when Queue_In(Index).ArrivalTime >= ArrivalTime_In;
      end loop;

      if Position_Old > Position_New then
         for ShiftIndex in reverse Position_New+1..Position_Old loop
                     Queue_In(ShiftIndex) := Queue_In(ShiftIndex-1);
               end loop;
      elsif Position_Old < Position_New then
         for ShiftIndex in Position_Old..Position_New-1 loop
                  Queue_In(ShiftIndex) := Queue_In(ShiftIndex+1);
         end loop;
      end if;
      Add_Competitor2Queue(Queue_In,CompetitorID_In,ArrivalTime_In,IsActive_In,Position_New);
   end;

end Queue;
