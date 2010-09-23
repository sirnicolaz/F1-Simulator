with Common;
use Common;

package Classification_Handler is

   procedure Initialize(Laps : Integer;
                        Competitors_In : Integer);

   --Whenever a competitor reaches the end of a lap, he will invoke this method
   --+ to add (the onboard computer will) himself to the classification table of
   --+ that lap
   procedure Update_Classific(Competitor_ID : INTEGER;
                              CompletedLap : INTEGER;
                              Time : FLOAT);

   procedure Get_LapClassific(Lap : INTEGER;
                              TimeInstant : FLOAT;
                              CompetitorID_InClassific : out INTEGER_ARRAY_POINT;
                              Times_InClassific : out FLOAT_ARRAY_POINT;
                              CompetitorIDs_PreviousClassific : out INTEGER_ARRAY_POINT;
                              Times_PreviousClassific : out FLOAT_ARRAY_POINT;
                              LappedCompetitors_ID : out INTEGER_ARRAY_POINT;
                              LappedCompetitors_CurrentLap : out INTEGER_ARRAY_POINT);

   procedure Decrease_Classification_Size_From_Lap( Lap : Integer );

   -- stats_row : single row of the synch_ordered_classification_table
   type STATS_ROW is private;
   type CLASSIFICATION_TABLE is array(POSITIVE range <>) of STATS_ROW;
   type CLASSIFICATION_TABLE_POINT is access CLASSIFICATION_TABLE;

   -- Resource used to maintain classific ordered and mutually-exclusive accessible
   -- synch_ordered_classification_table : ordered table with all methods to insert, delete, .. in the classification_table
   protected type SYNCH_ORDERED_CLASSIFICATION_TABLE is
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
      Statistics : CLASSIFICATION_TABLE_POINT;
      Full : BOOLEAN := false;
   end SYNCH_ORDERED_CLASSIFICATION_TABLE;

   -- SOCT is for Synch Ordered Classification Table
   type SOCT_POINT is access SYNCH_ORDERED_CLASSIFICATION_TABLE;
   type SOCT_ARRAY is array(POSITIVE range <>) of SOCT_POINT;
   type SOCT_ARRAY_POINT is access SOCT_ARRAY;

   -- soct_node : single node that represents one synch_ordered_classification_table
   type SOCT_NODE is private;
   type SOCT_NODE_POINT is access SOCT_NODE;


   Classification_Tables : SOCT_ARRAY_POINT;
-----------------------------------------------------------

private

   type SOCT_NODE is record -- this is the table of classification
      Index : INTEGER;
      IsLast : BOOLEAN;
      IsFirst : BOOLEAN;
      Previous : SOCT_NODE_POINT;
      This : SOCT_POINT;
      Next : SOCT_NODE_POINT;
   end record;

   type STATS_ROW is record
      Competitor_Id : INTEGER;
      Time : FLOAT;
   end record;

end Classification_Handler;
