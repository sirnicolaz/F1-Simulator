with Common;
use Common;

package Stats is


   type COMP_STATS is record
      Checkpoint : INTEGER;
      -- Is this the last check-point in the sector?
      LastCheckInSect : BOOLEAN;
      -- Is this the first check-point in the sector?
      FirstCheckInSect : BOOLEAN;
      Sector : INTEGER;
      Lap : INTEGER;
      Time : FLOAT;
      GasLevel : FLOAT;
      TyreUsury : PERCENTAGE;
      BestLapNum : INTEGER;
      BestLaptime : FLOAT;
      BestSectorTimes : FLOAT_ARRAY(1..3);
      MaxSpeed : FLOAT;
      PathLength : FLOAT;
   end record;

   type COMP_STATS_POINT is access COMP_STATS;

   --This resource represent the information related to a
   --+ specific checkpoint in a specific lap
   protected type SYNCH_COMP_STATS_HANDLER is
      entry Get_Time( Result : out FLOAT );
      entry Get_Checkpoint (Result : out INTEGER);
      entry Get_Lap (Result : out INTEGER);
      entry Get_Sector (Result : out INTEGER);
      entry Get_BestLapNum (Result : out INTEGER);
      entry Get_BestLapTime (Result : out FLOAT);
      entry Get_BestSectorTime( SectorNum : INTEGER; Result : out FLOAT);
      entry Get_MaxSpeed (Result : out FLOAT);
      entry Get_IsLastCheckInSector (Result : out BOOLEAN) ;
      entry Get_IsFirstCheckInSector (Result : out BOOLEAN) ;
      entry Get_PathLength (Result : out FLOAT) ;
      entry Get_GasLevel (Result : out FLOAT) ;
      entry Get_TyreUsury (Result : out PERCENTAGE) ;
      entry Get_All( Result : out COMP_STATS) ;

      --Usable only when the resource is not initialised yet
      entry Initialise(Stats_In : in COMP_STATS);

   private
      Initialised : BOOLEAN := false;
      Statistic : COMP_STATS;
   end SYNCH_COMP_STATS_HANDLER;

   type SYNCH_COMP_STATS_HANDLER_ARRAY is array( INTEGER range <> ) of SYNCH_COMP_STATS_HANDLER;
   type STATS_ARRAY_OPTIMIZER is private;

   --Each array index corresponds to a competitor ID
   type ALL_COMPETITOR_STAT_COLLECTION is array(POSITIVE range <>) of access STATS_ARRAY_OPTIMIZER;


   type STATISTIC_COLLECTION_POINT is access ALL_COMPETITOR_STAT_COLLECTION;

   procedure Init_Stats(Competitor_Qty : INTEGER;
                        Laps : INTEGER;
                        Checkpoints_In : INTEGER);

   --Method to be used by the onboard computer to add new stats to the competitor id related array
   procedure Add_Stat(Competitor_ID : INTEGER;
                      Data : COMP_STATS);

   --Whenever a competitor reaches the end of a lap, he will invoke this method
   --+ to add (the onboard computer will) himself to the classification table of
   --+ that lap
   procedure Update_Classific(Competitor_ID : INTEGER;
                              CompletedLap : INTEGER;
                              Time : FLOAT);

   -- It returns a statistic related to a certain time
   procedure Get_StatsByTime(Competitor_ID : INTEGER;
                            Time : FLOAT;
                            Stats_In : out COMP_STATS_POINT);
   -- It sets the CompStats parameter with the statistics related to the given sector and lap
   procedure Get_StatsBySect(Competitor_ID : INTEGER;
                            Sector : INTEGER;
                            Lap : INTEGER;
                            Stats_In : out COMP_STATS_POINT);
   -- It sets the CompStats parameter with the statistics related to the given check-point and lap
   procedure Get_StatsByCheck(Competitor_ID : INTEGER;
                             Checkpoint : INTEGER;
                             Lap : INTEGER;
                              Stats_In : out COMP_STATS_POINT);



  type GENERIC_STATS is record
      bestLap : INTEGER;
      bestSector : FLOAT_ARRAY(1..3);
   end record;

   type GENERIC_STATS_POINT is access GENERIC_STATS;

   -- global_stats : collection of synch_ordered_classification_table
   type GLOBAL_STATS(sgs_In : access GENERIC_STATS; updatePeriod_In : access FLOAT) is private;
   type GLOBAL_STATS_POINT is access GLOBAL_STATS;

   -- stats_row : single row of the synch_ordered_classification_table
   type STATS_ROW is private;
   --     -- These functions are only for test purpose
   function Get_StatsRow(Competitor_Id_In : INTEGER;
                         Lap_Num_In : INTEGER;
                         Time_In : FLOAT) return STATS_ROW;

   function Get_CompetitorId(Row : STATS_ROW) return INTEGER;
   function Get_Lap(Row : STATS_ROW) return INTEGER;
   function Get_Time(Row : STATS_ROW) return FLOAT;
   -- end test functions ----------------------------

   function "<" (Left, Right : STATS_ROW) return BOOLEAN;

   -- classification_table : table in synch_ordered_classification_table
   type CLASSIFICATION_TABLE is array(POSITIVE range <>) of STATS_ROW;
   type CLASSIFICATION_TABLE_POINT is access CLASSIFICATION_TABLE;

--   function getClassification(global_In : in GLOBAL_STATS_HANDLER_POINT ) return CLASSIFICATION_TABLE;--return the last classific available

   -- return the last classificationtable complete
   -- updated the calssificationtable with the info of the competitor

   --procedure updateClassification(global_In : in GLOBAL_STATS_HANDLER_POINT; competitorID_In : INTEGER;
  --                                competitorInfo_In : COMP_STATS);
   --create new classificationtable to update info of the competitor
   --function createNew return CLASSIFICATION_TABLE;
   --verify and eventually update the stats about best performance in the race
 --  function updateStats(competitorInfo_In : COMP_STATS) return boolean;

   --TODO: non ha senso che sia una risorsa protetta dal momento che viene usata solo in questo
   --package da una risorsa a sua volta protetta. Quindi cambiare.
   -- Resource used to maintain statistics ordered and mutually-exclusive accessible
   -- synch_ordered_classification_table : ordered table with all methods to insert, delete, .. in the classification_table
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

   -- SOCT is for Synch Ordered Classification Table
   type SOCT_POINT is access SYNCH_ORDERED_CLASSIFICATION_TABLE;
   type SOCT_ARRAY is array(POSITIVE range <>) of SOCT_POINT;
   type SOCT_ARRAY_POINT is access SOCT_ARRAY;

   -- soct_node : single node which represent one synch_ordered_classification_table
   type SOCT_NODE is private;
   type SOCT_NODE_POINT is access SOCT_NODE;

   --function Get_BestLapNum(StatsContainer : GENERIC_STATS) return INTEGER;
   --function Get_BestLapTime(StatsContainer : GENERIC_STATS) return FLOAT;
   --funCtion Get_BestLapId(StatsContainer : GENERIC_STATS) return INTEGER;
   --function Get_BestSectorsTime(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return FLOAT;--_ARRAY;
   --function Get_BestSectorsLap(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return INTEGER;
   --function Get_BestSectorsId(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return INTEGER;

   -- FUNCTION OF SOCT_NODE -- TEST ---------------------------------------
   function Get_PreviousNode( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_NODE_POINT;

   function Get_NextNode( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_NODE_POINT;

   function Get_NodeContent( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_POINT;

   function IsLast(SynchOrdStatTabNode : SOCT_NODE_POINT) return BOOLEAN;

   function IsFirst(SynchOrdStatTabNode : SOCT_NODE_POINT) return BOOLEAN;

   function Get_Index(SynchOrdStatTabNode : SOCT_NODE_POINT) return INTEGER;

   procedure Init_Node(SynchOrdStatTabNode : in out SOCT_NODE_POINT); -- inizializza un nodo


   procedure Set_Node(SynchOrdStatTabNode : in out SOCT_NODE_POINT; Value : SOCT_POINT );

   procedure Set_PreviousNode(SynchOrdStatTabNodePoint : in out SOCT_NODE_POINT ; Value : in out SOCT_NODE_POINT);

   procedure Set_NextNode(SynchOrdStatTabNodePoint : in out SOCT_NODE_POINT; Value : in out SOCT_NODE_POINT );
   -----------------------------------------------------------

   protected type SYNCH_GLOBAL_STATS(sgs_In : access GENERIC_STATS; updatePeriod_In : access FLOAT) is
      procedure Init_GlobalStats(genStats_In : in GENERIC_STATS_POINT; CompetitorsQty : in INTEGER ; Update_Interval_in : FLOAT);
      procedure Set_CompetitorsQty (CompetitorsQty : INTEGER);
      function Get_CompetitorsQty return INTEGER;
      procedure Update_Stats(
                             CompetitorId_In : INTEGER;
                             Lap_In : INTEGER;
                             Checkpoint_In : INTEGER;
                             Time_In : FLOAT);
      function Test_Get_Classific return CLASSIFICATION_TABLE;
      entry Get_Classific(RequestedIndex : INTEGER; Classific_Out : out CLASSIFICATION_TABLE);
   private
      GlobStats : GLOBAL_STATS_POINT := new GLOBAL_STATS(sgs_In, updatePeriod_In);
end SYNCH_GLOBAL_STATS;


private

   --OPTIMEZER because of the LastAccessedPosition that allows to optimize the number of positions
   --+ of the array to visit in order to retrieve a certain information. This "optimization" relies
   --+ on the assumption that usually the accesses to the resource are close in a narrow interval
   type STATS_ARRAY_OPTIMIZER is record
      Competitor_Info : access SYNCH_COMP_STATS_HANDLER_ARRAY;
      LastAccessedPosition : INTEGER := 1;
   end record;


   type SOCT_NODE is record -- this is the table of classification
      Index : INTEGER;
      IsLast : BOOLEAN;
      IsFirst : BOOLEAN;
      Previous : SOCT_NODE_POINT;
      This : SOCT_POINT;
      Next : SOCT_NODE_POINT;
   end record;


   type GLOBAL_STATS(sgs_In : access GENERIC_STATS; updatePeriod_In : access FLOAT) is record
      lastClassificUpdate : SOCT_NODE_POINT;--SOCT_POINT; --access to SYNCH_ORDERED_CLASSIFICATION_TABLE
--        bestLapCompID : INTEGER;
--        bestTimePerSectorCompID : INTEGER;
      firstTableFree : INTEGER := 0;--prima tabella libera
      genStats : GENERIC_STATS;
      competitorNum : INTEGER;
      Update_Interval : FLOAT;
   end record;



   type STATS_ROW is record
      Competitor_Id : INTEGER;
      Lap_Num : INTEGER;
      Time : FLOAT;
   end record;

end Stats;


--     type GENERIC_STATS is tagged private;
--     --type COMPETITOR_STATS is new GENERIC_STATS with private;
--     type GLOBAL_STATS is new GENERIC_STATS with private;
--
--  --  --     type INT_ARRAY is array(POSITIVE range <>) of INTEGER;
--  --  --     type INT_ARRAY_POINT is access INT_ARRAY;
--  --  --     type FLOAT_ARRAY is array(POSITIVE range <>) of FLOAT;
--  --  --     type FLOAT_ARRAY_POINT is access FLOAT_ARRAY;
--  --  --
--  --  --     type INT_ARRAY_LIST is private;
--  --  --     type FLOAT_ARRAY_LIST_NODE is private;
--
--
--     type STATS_ROW is private;
--     -- These functions are only for test purpose
--     function Get_StatsRow(Competitor_Id_In : INTEGER;
--                           Lap_Num_In : INTEGER;
--                           Checkpoint_Num_In : INTEGER;
--                           Time_In : FLOAT) return STATS_ROW;
--     function Get_CompetitorId(Row : STATS_ROW) return INTEGER;
--     function Get_Lap(Row : STATS_ROW) return INTEGER;
--     function Get_CheckPoint(Row : STATS_ROW) return INTEGER;
--     function Get_Time(Row : STATS_ROW) return FLOAT;
--     -- end test functions ----------------------------
--
--     function "<" (Left, Right : STATS_ROW) return BOOLEAN;
--
--     type CLASSIFICATION_TABLE is array(POSITIVE range <>) of STATS_ROW;
--     type CLASSIFICATION_TABLE_POINT is access CLASSIFICATION_TABLE;
--
--
--     --TODO: non ha senso che sia una risorsa protetta dal momento che viene usata solo in questo
--     --package da una risorsa a sua volta protetta. Quindi cambiare.
--     -- Resource used to maintain statistics ordered and mutually-exclusive accessible
--     protected type SYNCH_ORDERED_CLASSIFICATION_TABLE is
--        procedure Init_Table(NumRows : INTEGER);
--        procedure Add_Row(Row_In : STATS_ROW;
--                          Index_In : INTEGER);
--        procedure Add_Row(Row_In : STATS_ROW);
--        procedure Remove_Row(Index_In : INTEGER;
--                             Row_Out : in out STATS_ROW);
--        procedure Delete_Row(Index_In : INTEGER);
--        procedure Shift_Down(Index_In : INTEGER);
--        function Get_Row(Index_In : INTEGER) return STATS_ROW;
--        function Find_RowIndex(CompetitorId_In : INTEGER) return INTEGER;
--        procedure Is_Full(Full_Out : out BOOLEAN);
--        function Get_Size return INTEGER;
--        function Test_Get_Classific return CLASSIFICATION_TABLE;
--        entry Get_Classific(Garbage : INTEGER; Classific_Out : out CLASSIFICATION_TABLE);
--     private
--        Id : INTEGER;
--        Statistics : CLASSIFICATION_TABLE_POINT;
--        Full : BOOLEAN := false;
--     end SYNCH_ORDERED_CLASSIFICATION_TABLE;
--
--
--     type SOCT_POINT is access SYNCH_ORDERED_CLASSIFICATION_TABLE;
--
--     type SOCT_NODE is private;
--     type SOCT_NODE_POINT is access SOCT_NODE;
--
--     function Get_BestLapNum(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return INTEGER;
--     function Get_BestLapTime(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return FLOAT;
--     function Get_BestSectorsTime(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return FLOAT_ARRAY;
--     --procedure Update_Stats_Lap( StatsContainer : in out GENERIC_STATS;
--     --                           BestLapNum_In : INTEGER;
--     --                          BestLapTime_In : FLOAT);
--     --procedure Update_Stats_Sector( StatsContainer : in out GENERIC_STATS;
--     --                              BestSectorNum_In : INTEGER;
--     --                              BestSectorTime_In : FLOAT);
--
--
--
--     -- TEST SECTION ---------------------------------------
--     function Get_PreviousNode( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_NODE_POINT;
--
--     function Get_NextNode( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_NODE_POINT;
--
--     function Get_NodeContent( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_POINT;
--
--     function IsLast(SynchOrdStatTabNode : SOCT_NODE_POINT) return BOOLEAN;
--
--     function IsFirst(SynchOrdStatTabNode : SOCT_NODE_POINT) return BOOLEAN;
--
--     function Get_Index(SynchOrdStatTabNode : SOCT_NODE_POINT) return INTEGER;
--
--     procedure Init_Node(SynchOrdStatTabNode : in out SOCT_NODE_POINT);
--
--
--     procedure Set_Node(SynchOrdStatTabNode : in out SOCT_NODE_POINT; Value : SOCT_POINT );
--
--     procedure Set_PreviousNode(SynchOrdStatTabNodePoint : in out SOCT_NODE_POINT ; Value : in out SOCT_NODE_POINT);
--
--     procedure Set_NextNode(SynchOrdStatTabNodePoint : in out SOCT_NODE_POINT; Value : in out SOCT_NODE_POINT );
--     -----------------------------------------------------------
--
--     protected type SYNCH_GLOBAL_STATS is
--
--        procedure Init_GlobalStats( Update_Interval_in : FLOAT );
--        procedure Set_CompetitorsQty (CompetitorsQty : INTEGER);
--        procedure Update_Stats(
--                               CompetitorId_In : INTEGER;
--                               Lap_In : INTEGER;
--                               Checkpoint_In : INTEGER;
--                               Time_In : FLOAT);
--        function Test_Get_Classific return CLASSIFICATION_TABLE;
--        entry Get_Classific(RequestedIndex : INTEGER; Classific_Out : out CLASSIFICATION_TABLE);
--     private
--        GlobStats : GLOBAL_STATS;
--     end SYNCH_GLOBAL_STATS;
--
--     type S_GLOB_STATS_POINT is access SYNCH_GLOBAL_STATS;
--
--  private
--
--     type INT_ARRAY_LIST is record
--        Previous : FLOAT_ARRAY_POINT;
--        Next : FLOAT_ARRAY_POINT;
--        This : FLOAT_ARRAY_POINT;
--     end record;
--
--     type FLOAT_ARRAY_LIST_NODE is record
--        Previous : access FLOAT_ARRAY_LIST_NODE;
--        This : FLOAT_ARRAY_POINT;
--        Index : INTEGER;
--     end record;
--
--     type GENERIC_STATS is tagged record
--        BestLap_Num : INT_ARRAY_POINT; -- Num of best time lap during the competition (each index represents a time instant)
--        BestLap_Time : FLOAT_ARRAY_POINT; -- Time of best time lap during the competition (each index represents a time instant)
--        BestSectors_Time : FLOAT_ARRAY_LIST_NODE; --Times of best sector time. each element in the list contains the best)
--     end record;
--
--     type SOCT_NODE is record
--        Index : INTEGER;
--        IsLast : BOOLEAN;
--        IsFirst : BOOLEAN;
--        Previous : SOCT_NODE_POINT;
--        This : SOCT_POINT;
--        Next : SOCT_NODE_POINT;
--     end record;
--
--     type GLOBAL_STATS is new GENERIC_STATS with
--        record
--           BestLap_CompetitorId : INTEGER;
--           BestTimePerSector_CompetitorId : INT_ARRAY_LIST;
--           Statistics_Table : SOCT_NODE_POINT;
--           Update_Interval : FLOAT;
--        end record;
--
--     type STATS_ROW is
--        record
--           Competitor_Id : INTEGER;
--           Lap_Num : INTEGER;
--           Checkpoint_Num : INTEGER;
--           Time : FLOAT;
--        end record;
--
--  end Stats;
