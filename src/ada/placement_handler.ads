with Common;
use Common;

package Placement_Handler is

   procedure Initialize(Laps : Integer;
                        Competitors_In : Integer);

   --Whenever a competitor reaches the end of a lap, he will invoke this method
   --+ to add (the onboard computer will) himself to the PLACEMENT table of
   --+ that lap
   procedure Update_Classific(Competitor_ID : INTEGER;
                              CompletedLap : INTEGER;
                              Time : FLOAT);

   procedure Get_Lap_Placement(Last_Lap : INTEGER;
                                    Time_Instant : FLOAT;
                                    Placement_Competitor_IDs : out INTEGER_ARRAY_POINT;
                                    Placement_Times : out FLOAT_ARRAY_POINT;
                                    CompetitorIDs_PreviousClassific : out INTEGER_ARRAY_POINT;
                                    Times_PreviousClassific : out FLOAT_ARRAY_POINT;
                                    LappedCompetitors_ID : out INTEGER_ARRAY_POINT;
                                    LappedCompetitors_CurrentLap : out INTEGER_ARRAY_POINT);

   procedure Decrease_Placement_Size_From_Lap( Lap : Integer );

   -- stats_row : single row of the synch_ordered_PLACEMENT_table
   type STATS_ROW is private;
   type PLACEMENT_TABLE is array(POSITIVE range <>) of STATS_ROW;
   type PLACEMENT_TABLE_POINT is access PLACEMENT_TABLE;

   -- Resource used to maintain classific ordered and mutually-exclusive accessible
   -- synch_ordered_PLACEMENT_table : ordered table with all methods to insert, delete, .. in the PLACEMENT_table
   protected type SYNCH_ORDERED_PLACEMENT_TABLE is
      procedure Init_Table(NumRows : INTEGER);
      procedure Remove_Competitor;
      procedure Add_Row(Row_In : STATS_ROW;
                        Index_In : INTEGER);
      procedure Add_Row(Row_In : STATS_ROW);
      procedure Remove_Row(Index_In : INTEGER;
                           Row_Out : in out STATS_ROW);
      procedure Delete_Row(Index_In : INTEGER);
      procedure Shift_Down(Index_In : INTEGER);
      function Get_Row(Index_In : INTEGER) return STATS_ROW;
      function Find_RowIndex(CompetitorId_In : INTEGER) return INTEGER;
      procedure Is_Full(Full_Out : out BOOLEAN);
      function Get_Size return INTEGER;
   private
      Id : INTEGER;
      Statistics : PLACEMENT_TABLE_POINT;
      Full : BOOLEAN := false;
   end SYNCH_ORDERED_PLACEMENT_TABLE;

   -- SOPT is for Synch Ordered Placement Table
   type SOPT_POINT is access SYNCH_ORDERED_PLACEMENT_TABLE;
   type SOPT_ARRAY is array(POSITIVE range <>) of SOPT_POINT;
   type SOPT_ARRAY_POINT is access SOPT_ARRAY;

   -- SOPT_node : single node that represents one synch_ordered_PLACEMENT_table
   type SOPT_NODE is private;
   type SOPT_NODE_POINT is access SOPT_NODE;


   Placement_Tables : SOPT_ARRAY_POINT;
-----------------------------------------------------------

private

   type SOPT_NODE is record -- this is the table of PLACEMENT
      Index : INTEGER;
      IsLast : BOOLEAN;
      IsFirst : BOOLEAN;
      Previous : SOPT_NODE_POINT;
      This : SOPT_POINT;
      Next : SOPT_NODE_POINT;
   end record;

   type STATS_ROW is record
      Competitor_Id : INTEGER;
      Time : FLOAT;
   end record;

end Placement_Handler;
