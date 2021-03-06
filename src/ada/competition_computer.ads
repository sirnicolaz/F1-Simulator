with Common;
use Common;

with Placement_Handler;
use Placement_Handler;

package Competition_Computer is

   type COMPETITOR_MIN_INFO is private;

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
      Gas_Level : FLOAT;
      Tyre_Usury : PERCENTAGE;
      BestLapNum : INTEGER;
      BestLaptime : FLOAT;
      BestSectorTimes : FLOAT_ARRAY(1..3);
      Max_Speed : FLOAT;
      PathLength : FLOAT;
   end record;

   type COMPETITOR_STATS_POINT is access COMPETITOR_STATS;

   procedure Initialize_Static_Information(Laps_In : INTEGER;
                                    Competitors_In : INTEGER;
                                    Name_In : Unbounded_String.Unbounded_String;
                                    CircuitLength_In : FLOAT);

   procedure Get_StaticInformation(Laps_Out : out INTEGER;
                                   Competitors_Out : out  INTEGER;
                                   Name_Out : out Unbounded_String.Unbounded_String;
                                   CircuitLength_Out : out FLOAT);

   procedure Add_CompetitorMinInfo(Id : INTEGER;
                                   Name : Unbounded_String.Unbounded_String;
                                   Surname : Unbounded_String.Unbounded_String;
                                   Team : Unbounded_String.Unbounded_String);

   procedure Get_CompetitorMinInfo(Id : INTEGER;
                                   Name : out Unbounded_String.Unbounded_String;
                                   Surname : out Unbounded_String.Unbounded_String;
                                   Team : out Unbounded_String.Unbounded_String);


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

   procedure Initialize(Competitor_Qty : INTEGER;
                        Laps : INTEGER;
                        Checkpoints_In : INTEGER;
                        Name_In : Unbounded_String.Unbounded_String;
                        Circuit_Length : Float);

   function Has_CompetitorFinished(Competitor_ID : INTEGER;
                                   Time : FLOAT) return BOOLEAN;


   function Is_CompetitorOut(Competitor_ID : INTEGER;
                             Time : FLOAT) return BOOLEAN;

   --To remove the competitor from the system
   procedure CompetitorOut(Competitor_ID : INTEGER;
                           Lap : INTEGER;
                           Data : COMPETITOR_STATS);

   --Method to be used by the onboard computer to add new stats to the competitor id related array
   procedure Add_Stat(Competitor_ID : INTEGER;
                      Data : COMPETITOR_STATS);

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

   procedure Get_Lap_Placement(Lap : INTEGER;
                                    TimeInstant : FLOAT;
                                    CompetitorID_InClassific : out INTEGER_ARRAY_POINT;
                                    Times_InClassific : out FLOAT_ARRAY_POINT;
                                    CompetitorIDs_PreviousClassific : out INTEGER_ARRAY_POINT;
                                    Times_PreviousClassific : out FLOAT_ARRAY_POINT;
                                    LappedCompetitors_ID : out INTEGER_ARRAY_POINT;
                                    LappedCompetitors_CurrentLap : out INTEGER_ARRAY_POINT);

   --The function takes the the latest time instant that every car passed
   function Get_Latest_Time_Instant return Float;


private

   --OPTIMEZER because of the LastAccessedPosition that allows to optimize the number of positions
   --+ of the array to visit in order to retrieve a certain information. This "optimization" relies
   --+ on the assumption that usually the accesses to the resource are close in a narrow interval
   type STATS_ARRAY_OPTIMIZER is record
      Competitor_Info : access SYNCH_COMPETITOR_STATS_HANDLER_ARRAY;
      Last_Initialized_Index : INTEGER := 1; --LastAccessedPosition
      --This time will be updated as soon as the competitor get off the competition
      Retired_Time : FLOAT := -1.0;
      Competition_Finished : BOOLEAN := FALSE;
      --If the competitor has retired for any anomaly, the 2 following variables will
      --+ mark when the competitor went out.
      Last_Checkpoint : INTEGER := -1;
      Last_Lap : INTEGER := -1;
   end record;

   type COMPETITOR_MIN_INFO is record
      Name : Unbounded_String.Unbounded_String;
      Surname : Unbounded_String.Unbounded_String;
      Team : Unbounded_String.Unbounded_String;
   end record;

end Competition_Computer;

