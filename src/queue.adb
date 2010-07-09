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

   --The queue is initialised with the list of partecipating competitor IDs.
   --+The Competitors_List is an array of INTEGER (the Competitor IDs).
   --WARNING: no check on the Competitors_List size. It might happen that
   --+the method tries to initialise a position of the queue with a NULL value.
   procedure Set_Competitors(Queue_In : in out QUEUE;
                             Competitors_List : Common.COMPETITORS_LIST;
                             Times : Common.FLOAT_LIST) is
   begin

      for Index in Queue_In'RANGE loop
         if (Index > Times'LAST) then
            Queue_In(Index).CompetitorID := Competitors_List(Index);
            Queue_In(Index).ArrivalTime := Times(Index);
         else
            Queue_In(Index).CompetitorID := -1;
         end if;

      end loop;
   end Set_Competitors;

   function Get_CompetitorID(Cell_In : QUEUE_CELL_POINT) return INTEGER is
   begin
      return Cell_In.CompetitorID;
   end;

   function Get_ArrivalTime(Cell_In : QUEUE_CELL_POINT) return FLOAT is
   begin
      return Cell_In.ArrivalTime;
   end;

   -- Get Arrival time of a given competitor
   function Get_CompetitorArrivalTime(Queue_In : QUEUE;
                                      CompetitorID_In : INTEGER) return FLOAT is
      Position : INTEGER;
   begin
      Position := Get_Position(Queue_In,CompetitorID_In);
      return Get_ArrivalTime(Queue_In(Position));
   end Get_CompetitorArrivalTime;

   function Get_IsArrived(Cell_In : QUEUE_CELL_POINT) return BOOLEAN is
   begin
      return Cell_In.IsArrived;
   end;

   procedure Add_Competitor2Queue(Queue_In : in out QUEUE;
                                  CompetitorID_In : INTEGER;
                                  ArrivalTime_In : FLOAT;
                                  Position : INTEGER) is
   begin
      if(Position <= Queue_In'LENGTH) then
         Queue_In(Position) := new QUEUE_CELL'(CompetitorID_In, ArrivalTime_In,FALSE);
      end if;
   end;

   function Get_IsArrived(Queue_In : QUEUE;
                          Position : INTEGER) return BOOLEAN is
   begin
      return Queue_In(Position).IsArrived;
   end Get_IsArrived;


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

   procedure Set_Arrived(Queue_In : in out QUEUE;
                         CompetitorID_In : INTEGER;
                         IsArrived_In : BOOLEAN) is
      Position : INTEGER := -1;
   begin
      Position := Get_Position(Queue_In,CompetitorID_In);
      if Position > -1 then
         Queue_In(Position).IsArrived := IsArrived_In;
      end if;
   end Set_Arrived;

   procedure Add_Competitor2Queue(Queue_In : in out SORTED_QUEUE;
                                  CompetitorID_In : INTEGER;
                             	  ArrivalTime_In : FLOAT) is

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
         Add_Competitor2Queue(Queue_In,CompetitorID_In,ArrivalTime_In,Position_Old);
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
      Add_Competitor2Queue(Queue_In,CompetitorID_In,ArrivalTime_In,Position_New);
   end;

end Queue;
