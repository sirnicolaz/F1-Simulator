with Common;
use Common;

package CompetitionComputer is


   type COMPETITOR_STATS is record
      Checkpoint : INTEGER;
      -- Is this the last check-point in the sector?
      LastCheckInSect : BOOLEAN;
      -- Is this the first check-point in the sector?
      IsPitStop : BOOLEAN;
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

   type COMPETITOR_STATS_POINT is access COMPETITOR_STATS;

   --This resource represent the information related to a
   --+ specific checkpoint in a specific lap
   protected type SYNCH_COMPETITOR_STATS_HANDLER is
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
      entry Get_All( Result : out COMPETITOR_STATS) ;

      --Usable only when the resource is not initialised yet
      entry Initialise(Stats_In : in COMPETITOR_STATS);

   private
      Initialised : BOOLEAN := false;
      Statistic : COMPETITOR_STATS;
   end SYNCH_COMPETITOR_STATS_HANDLER;

   type SYNCH_COMPETITOR_STATS_HANDLER_ARRAY is array( INTEGER range <> ) of SYNCH_COMPETITOR_STATS_HANDLER;
   type STATS_ARRAY_OPTIMIZER is private;

   --Each array index corresponds to a competitor ID
   type ALL_COMPETITOR_STAT_COLLECTION is array(POSITIVE range <>) of access STATS_ARRAY_OPTIMIZER;


   type STATISTIC_COLLECTION_POINT is access ALL_COMPETITOR_STAT_COLLECTION;

   procedure Init_Stats(Competitor_Qty : INTEGER;
                        Laps : INTEGER;
                        Checkpoints_In : INTEGER);

   function Has_CompetitorFinished(Competitor_ID : INTEGER;
                                   Time : FLOAT) return BOOLEAN;


   function Is_CompetitorOut(Competitor_ID : INTEGER;
                             Time : FLOAT) return BOOLEAN;


   --Method to be used by the onboard computer to add new stats to the competitor id related array
   procedure Add_Stat(Competitor_ID : INTEGER;
                      Data : COMPETITOR_STATS);

   --Whenever a competitor reaches the end of a lap, he will invoke this method
   --+ to add (the onboard computer will) himself to the classification table of
   --+ that lap
   procedure Update_Classific(Competitor_ID : INTEGER;
                              CompletedLap : INTEGER;
                              Time : FLOAT);

   -- It returns a statistic related to a certain time
   procedure Get_StatsByTime(Competitor_ID : INTEGER;
                            Time : FLOAT;
                            Stats_In : out COMPETITOR_STATS_POINT);
   -- It sets the CompStats parameter with the statistics related to the given sector and lap
   procedure Get_StatsBySect(Competitor_ID : INTEGER;
                            Sector : INTEGER;
                            Lap : INTEGER;
                            Stats_In : out COMPETITOR_STATS_POINT);
   -- It sets the CompStats parameter with the statistics related to the given check-point and lap
   procedure Get_StatsByCheck(Competitor_ID : INTEGER;
                             Checkpoint : INTEGER;
                             Lap : INTEGER;
                              Stats_In : out COMPETITOR_STATS_POINT);

   procedure Get_BestLap(TimeInstant : FLOAT;
                         LapTime : out FLOAT;
                         LapNum : out INTEGER;
                         Competitor_ID : out INTEGER);

   procedure Get_BestSectorTimes(TimeInstant : FLOAT;
                                 Times : out FLOAT_ARRAY;
                                 Competitor_IDs : out INTEGER_ARRAY;
                                 Laps : out INTEGER_ARRAY);

   procedure Get_LapTime(Competitor_ID : INTEGER;
                         Lap : INTEGER;
                         Time : out FLOAT);

   procedure Get_LapClassific(Lap : INTEGER;
                              TimeInstant : FLOAT;
                              CompetitorID_InClassific : out INTEGER_ARRAY_POINT;
                              Times_InClassific : out FLOAT_ARRAY_POINT;
                              LappedCompetitors_ID : out INTEGER_ARRAY_POINT;
                              LappedCompetitors_CurrentLap : out INTEGER_ARRAY_POINT);

   --It returs the competitors who have been lapped at a certain time instant
   --+ (the lap it's necessary to optimize the retrieval: only the competitors
   --+ riding in a previous lap during the given instant will be kept in consideration).
   procedure Get_LappedCompetitors(TimeInstant : FLOAT;
                                  CurrentLap : INTEGER;
                                  Competitor_IDs : out INTEGER_ARRAY_POINT;
                                  Competitor_Lap : out INTEGER_ARRAY_POINT);

   -- stats_row : single row of the synch_ordered_classification_table
   type STATS_ROW is private;
   --     -- These functions are only for test purpose
   function Get_StatsRow(Competitor_Id_In : INTEGER;
                         Time_In : FLOAT) return STATS_ROW;

   function Get_CompetitorId(Row : STATS_ROW) return INTEGER;
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
  --                                competitorInfo_In : COMPETITOR_STATS);
   --create new classificationtable to update info of the competitor
   --function createNew return CLASSIFICATION_TABLE;
   --verify and eventually update the stats about best performance in the race
 --  function updateStats(competitorInfo_In : COMPETITOR_STATS) return boolean;

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


private

   --OPTIMEZER because of the LastAccessedPosition that allows to optimize the number of positions
   --+ of the array to visit in order to retrieve a certain information. This "optimization" relies
   --+ on the assumption that usually the accesses to the resource are close in a narrow interval
   type STATS_ARRAY_OPTIMIZER is record
      Competitor_Info : access SYNCH_COMPETITOR_STATS_HANDLER_ARRAY;
      LastAccessedPosition : INTEGER := 1;
      --This time will be updated as soon as the competitor get off the competition
      Retired_Time : FLOAT := -1.0;
      Competition_Finished : BOOLEAN := FALSE;
      --If the competitor has retired for any anomaly, the 2 following variables will
      --+ mark when the competitor went out.
      Last_Checkpoint : INTEGER := -1;
      Last_Lap : INTEGER := -1;
   end record;


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

end CompetitionComputer;
