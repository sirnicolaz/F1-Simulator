package Classification_Handler is

  -- stats_row : single row of the synch_ordered_classification_table
   type STATS_ROW is private;
   --     -- These functions are only for test purpose
   function Get_StatsRow(Competitor_Id_In : INTEGER;
                         Time_In : FLOAT) return STATS_ROW;

   function Get_Competitor_Id ( Row : Stats_Row ) return Integer;
   function Get_Time ( Row : Stats_Row ) return Float;

   procedure Set_Competitor_Id ( Row : out Stats_Row;
                                 Competitor_Id : Integer );
   procedure Set_Time ( Row : out Stats_Row;
                        Time : Float );

   type CLASSIFICATION_TABLE is array(POSITIVE range <>) of STATS_ROW;
   type CLASSIFICATION_TABLE_POINT is access CLASSIFICATION_TABLE;

   --TODO: non ha senso che sia una risorsa protetta dal momento che viene usata solo in questo
   --package da una risorsa a sua volta protetta. Quindi cambiare.
   -- Resource used to maintain statistics ordered and mutually-exclusive accessible
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

   -- soct_node : single node which represent one synch_ordered_classification_table
   type SOCT_NODE is private;
   type SOCT_NODE_POINT is access SOCT_NODE;

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
