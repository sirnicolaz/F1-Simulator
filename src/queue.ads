package Queue is

   --QUEUE_CELL Structure definition
   type QUEUE_CELL is limited private;
   type QUEUE_CELL_POINT is access QUEUE_CELL;

   --Functions to get the CompetitorID of a given cell
   function Get_CompetitorID(Cell_In : QUEUE_CELL_POINT) return INTEGER;
   --Functions to get the arrival time of a given cell
   function Get_ArrivalTime(Cell_In : QUEUE_CELL_POINT) return FLOAT;
   --Functions to get the flag "is active" of a given cell
   function Get_IsActive(Cell_In : QUEUE_CELL_POINT) return BOOLEAN;

   -- QUEUE Structure definition. QUEUE is an array of QUEUE_CELL pointers.
   type QUEUE is array (POSITIVE range <>) of QUEUE_CELL_POINT;
   procedure Init_Queue(Queue_In : in out QUEUE);
   procedure Add_Competitor2Queue(Queue_In : in out QUEUE;
                                  CompetitorID_In : INTEGER;
                             	  ArrivalTime_In : FLOAT;
                                  IsActive_In : BOOLEAN;
                                  Position : INTEGER);
   -- Get Arrival time on a given position of the queue
   function Get_ArrivalTime(Queue_In : QUEUE;
                            Position : INTEGER) return FLOAT;
   -- Get the position of the first cell containing the given arrival time
   function Get_Position(Queue_In : QUEUE;
                         ArrivalTime_In : FLOAT) return INTEGER;
   -- Get the position in queue of the given Competitor
   function Get_Position(Queue_In : QUEUE;
                         CompetitorID_In : INTEGER) return INTEGER;

   -- SORTED_QUEUE Structure definition. It's the same as QUEUE, but with methods defined to maintain the queue sorted by arrival time.
   subtype SORTED_QUEUE is QUEUE;
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
