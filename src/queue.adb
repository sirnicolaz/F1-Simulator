with GNAT.Heap_Sort;
use GNAT.Heap_Sort;
with Ada.Text_IO; use Ada.Text_IO;

package body Queue is

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
      if(Position <= Queue_In'LENGTH) then
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

   procedure Init_Queue(Queue_In : in out SORTED_QUEUE) is
   begin
      for Index in Queue_In'RANGE loop
         Queue_In(Index) := new QUEUE_CELL'(0,0.0,false);
      end loop;
   end;


   procedure Add_Competitor2Queue(Queue_In : in out SORTED_QUEUE;
                                  CompetitorID_In : INTEGER;
                             	  ArrivalTime_In : FLOAT;
                                  IsActive_In : BOOLEAN) is

      Position : INTEGER;

      function SortedQueue_Lt(Op1, Op2 : NATURAL) return BOOLEAN is
      begin
         if(Queue_In(Op1).ArrivalTime < Queue_In(Op2).ArrivalTime) then
            return true;
         else
            return false;
         end if;
      end;

      procedure SortedQueue_Xchg(Op1, Op2 : NATURAL) is
         TmpCell : QUEUE_CELL_POINT;
      begin
         TmpCell := Queue_In(Op1);
         Queue_In(Op1) := Queue_In(Op2);
         Queue_In(Op2) := TmpCell;
      end;

      XchgPoint : access procedure(Op1, Op2 : NATURAL) := SortedQueue_Xchg'Access;
      LtPoint : access function(Op1, Op2 : NATURAL) return BOOLEAN := SortedQueue_Lt'Access;
      begin
      Position := Get_Position(Queue_In,CompetitorID_In);
      if(Position = 0) then
         FindFreePos_Loop:
         for Index in Queue_In'Range loop
            Position := Position + 1;
            exit FindFreePos_Loop when Queue_In(Index).CompetitorID = 0;
         end loop FindFreePos_Loop;

      end if;

      Add_Competitor2Queue(Queue_In,CompetitorID_In,ArrivalTime_In,IsActive_In,Position);
      Sort(NATURAL(Queue_In'LENGTH),XchgPoint, LtPoint);
   end;

end Queue;
