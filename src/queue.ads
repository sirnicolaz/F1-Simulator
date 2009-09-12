with GNAT.Heap_Sort;
use GNAT.Heap_Sort;

package Queue is

   type QUEUE_CELL is limited private;
   type QUEUE_CELL_POINT is access QUEUE_CELL;
   function Get_CompetitorID(Cell_In : QUEUE_CELL_POINT) return INTEGER;
   function Get_ArrivalTime(Cell_In : QUEUE_CELL_POINT) return FLOAT;
   function Get_IsActive(Cell_In : QUEUE_CELL_POINT) return BOOLEAN;

   type QUEUE is array (POSITIVE range <>) of QUEUE_CELL_POINT;
   procedure Add_Competitor2Queue(Queue_In : in out QUEUE;
                                  CompetitorID_In : INTEGER;
                             	  ArrivalTime_In : FLOAT;
                                  IsActive_In : BOOLEAN;
                                  Position : INTEGER);
   function Get_ArrivalTime(Queue_In : QUEUE;
                            Position : INTEGER) return FLOAT;
   function Get_Position(Queue_In : QUEUE;
                         ArrivalTime_In : FLOAT) return INTEGER;
   function Get_Position(Queue_In : QUEUE;
                         CompetitorID_In : INTEGER) return INTEGER;

   subtype SORTED_QUEUE is QUEUE;
   procedure Init_Queue(Queue_In : in out SORTED_QUEUE);
   procedure Add_Competitor2Queue(Queue_In : in out SORTED_QUEUE;
                                  CompetitorID_In : INTEGER;
                             	  ArrivalTime_In : FLOAT;
                                  IsActive_In : BOOLEAN);

private
   type QUEUE_CELL is record
      CompetitorID : INTEGER;
      ArrivalTime : FLOAT;
      IsActive : BOOLEAN;
   end record;

end Queue;
