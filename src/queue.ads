with Common;

package Queue is

   --QUEUE_CELL Structure definition
   type QUEUE_CELL is limited private;
   type QUEUE_CELL_POINT is access QUEUE_CELL;

   --Functions to get the CompetitorID of a given cell
   function Get_CompetitorID(Cell_In : QUEUE_CELL_POINT) return INTEGER;
   --Functions to get the arrival time of a given cell
   function Get_ArrivalTime(Cell_In : QUEUE_CELL_POINT) return FLOAT;

   --Functions to get the flag "is active" of a given cell
   function Get_IsArrived(Cell_In : QUEUE_CELL_POINT) return BOOLEAN;

   -- QUEUE Structure definition. QUEUE is an array of QUEUE_CELL pointers.
   type QUEUE is array (POSITIVE range <>) of QUEUE_CELL_POINT;
   procedure Init_Queue(Queue_In : in out QUEUE);
   procedure Set_Competitors(Queue_In : in out QUEUE;
                             Competitors_List : Common.COMPETITORS_LIST;
                             Times : Common.FLOAT_LIST);
   procedure Add_Competitor2Queue(Queue_In : in out QUEUE;
                                  CompetitorID_In : INTEGER;
                             	  ArrivalTime_In : FLOAT;
                                  Position : INTEGER);
   procedure Set_Arrived(Queue_In : in out QUEUE;
                         CompetitorID_In : INTEGER;
                         IsArrived_In : BOOLEAN);

   -- Get Arrival time of a given competitor
   function Get_CompetitorArrivalTime(Queue_In : QUEUE;
                                      CompetitorID_In : INTEGER) return FLOAT;
   -- Get IsArrived of given position
   function Get_IsArrived(Queue_In : QUEUE;
                          Position : INTEGER) return BOOLEAN;

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
                                  ArrivalTime_In : FLOAT);

   --This procedure has to be used when a competitor is supposed to be
   --+ out of the competition.
   procedure Remove_CompetitorFromQueue(Queue_In : in out SORTED_QUEUE;
                                        CompetitorID_In : INTEGER);

private
   type QUEUE_CELL is record
      CompetitorID : INTEGER;
      ArrivalTime : FLOAT;
      IsArrived : BOOLEAN;
   end record;
end Queue;
