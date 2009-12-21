-- Per ora è insospesa l'implementazione della statistiche generiche, ovvero quelle destinate
-- a contenere le classifice sui tempi e giri migliori.
package Stats is

   type GENERIC_STATS is tagged private;
   --type COMPETITOR_STATS is new GENERIC_STATS with private;
   type GLOBAL_STATS is new GENERIC_STATS with private;

   type INT_ARRAY is array(POSITIVE range <>) of INTEGER;
   type INT_ARRAY_POINT is access INT_ARRAY;
   type FLOAT_ARRAY is array(POSITIVE range <>) of FLOAT;
   type FLOAT_ARRAY_POINT is access FLOAT_ARRAY;

   type INT_ARRAY_LIST is private;
   type FLOAT_ARRAY_LIST_NODE is private;


   type STATS_ROW is private;
   -- These functions is only for test purpose
   function Get_StatsRow(Competitor_Id_In : INTEGER;
                         Lap_Num_In : INTEGER;
                         Checkpoint_Num_In : INTEGER;
                         Time_In : FLOAT) return STATS_ROW;
   function Get_CompetitorId(Row : STATS_ROW) return INTEGER;
   function Get_Lap(Row : STATS_ROW) return INTEGER;
   function Get_CheckPoint(Row : STATS_ROW) return INTEGER;
   function Get_Time(Row : STATS_ROW) return FLOAT;
   -- end test functions ----------------------------

   function "<" (Left, Right : STATS_ROW) return BOOLEAN;

   type CLASSIFICATION_TABLE is array(POSITIVE range <>) of STATS_ROW;
   type CLASSIFICATION_TABLE_POINT is access CLASSIFICATION_TABLE;


   --TODO: non ha senso che sia una risorsa protetta dal momento che viene usata solo in questo
   --package da una risorsa a sua volta protetta. Quindi cambiare.
   -- Resource used to maintain statistics ordered and mutually-exclusive accessible
   protected type SYNCH_ORDERED_CLASSIFICATION_TABLE is
      procedure Init_Table(NumRows : INTEGER);
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
      function Test_Get_Classific return CLASSIFICATION_TABLE;
      entry Get_Classific(Garbage : INTEGER; Classific_Out : out CLASSIFICATION_TABLE);
   private
      Id : INTEGER;
      Statistics : CLASSIFICATION_TABLE_POINT;
      Full : BOOLEAN := false;
   end SYNCH_ORDERED_CLASSIFICATION_TABLE;


   type SOCT_POINT is access SYNCH_ORDERED_CLASSIFICATION_TABLE;

   type SOCT_NODE is private;
   type SOCT_NODE_POINT is access SOCT_NODE;

   function Get_BestLapNum(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return INTEGER;
   function Get_BestLapTime(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return FLOAT;
   function Get_BestSectorsTime(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return FLOAT_ARRAY;
   --procedure Update_Stats_Lap( StatsContainer : in out GENERIC_STATS;
   --                           BestLapNum_In : INTEGER;
   --                          BestLapTime_In : FLOAT);
   --procedure Update_Stats_Sector( StatsContainer : in out GENERIC_STATS;
   --                              BestSectorNum_In : INTEGER;
   --                              BestSectorTime_In : FLOAT);



   -- TEST SECTION ---------------------------------------
   function Get_PreviousNode( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_NODE_POINT;

   function Get_NextNode( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_NODE_POINT;

   function Get_NodeContent( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_POINT;

   function IsLast(SynchOrdStatTabNode : SOCT_NODE_POINT) return BOOLEAN;

   function IsFirst(SynchOrdStatTabNode : SOCT_NODE_POINT) return BOOLEAN;

   function Get_Index(SynchOrdStatTabNode : SOCT_NODE_POINT) return INTEGER;

   procedure Init_Node(SynchOrdStatTabNode : in out SOCT_NODE_POINT);


   procedure Set_Node(SynchOrdStatTabNode : in out SOCT_NODE_POINT; Value : SOCT_POINT );

   procedure Set_PreviousNode(SynchOrdStatTabNodePoint : in out SOCT_NODE_POINT ; Value : in out SOCT_NODE_POINT);

   procedure Set_NextNode(SynchOrdStatTabNodePoint : in out SOCT_NODE_POINT; Value : in out SOCT_NODE_POINT );
   -----------------------------------------------------------

   protected type SYNCH_GLOBAL_STATS is

      procedure Init_GlobalStats( Update_Interval_in : FLOAT );
      procedure Set_CompetitorsQty (CompetitorsQty : INTEGER);
      procedure Update_Stats(
                             CompetitorId_In : INTEGER;
                             Lap_In : INTEGER;
                             Checkpoint_In : INTEGER;
                             Time_In : FLOAT);
      function Test_Get_Classific return CLASSIFICATION_TABLE;
      entry Get_Classific(RequestedIndex : INTEGER; Classific_Out : out CLASSIFICATION_TABLE);
   private
      GlobStats : GLOBAL_STATS;
   end SYNCH_GLOBAL_STATS;


private

   type INT_ARRAY_LIST is record
      Previous : FLOAT_ARRAY_POINT;
      Next : FLOAT_ARRAY_POINT;
      This : FLOAT_ARRAY_POINT;
   end record;

   type FLOAT_ARRAY_LIST_NODE is record
      Previous : access FLOAT_ARRAY_LIST_NODE;
      This : FLOAT_ARRAY_POINT;
      Index : INTEGER;
   end record;

   type GENERIC_STATS is tagged record
      BestLap_Num : INT_ARRAY_POINT; -- Num of best time laps during the competition (each index represents a time instant)
      BestLap_Time : FLOAT_ARRAY_POINT; -- Time of best time laps during the competition (each index represents a time instant)
      BestSectors_Time : FLOAT_ARRAY_LIST_NODE; --Times of best sectors time. each element in the list contains times in a time instant)
   end record;

   type SOCT_NODE is record
      Index : INTEGER;
      IsLast : BOOLEAN;
      IsFirst : BOOLEAN;
      Previous : SOCT_NODE_POINT;
      This : SOCT_POINT;
      Next : SOCT_NODE_POINT;
   end record;

   type GLOBAL_STATS is new GENERIC_STATS with
      record
         BestLap_CompetitorId : INTEGER;
         BestTimePerSector_CompetitorId : INT_ARRAY_LIST;
         Statistics_Table : SOCT_NODE_POINT;
         Update_Interval : FLOAT;
      end record;

   type STATS_ROW is
      record
         Competitor_Id : INTEGER;
         Lap_Num : INTEGER;
         Checkpoint_Num : INTEGER;
         Time : FLOAT;
      end record;

end Stats;
