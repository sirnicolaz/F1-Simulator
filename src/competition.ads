with Circuit;
use Circuit;

with Competitor;
use Competitor;

package Competition is

   --FIELDS
   Circuit_Point : RACETRACK_POINT;
   Laps_Qty : INTEGER := 0;
   -- array of competitors pointer subtype COMPETITOR_LIST is array OF

   procedure Configure_Circuit( ClassificRefreshRate_In : FLOAT;
                               CircuitName_In : STRING;
                               CircuitLocation_In : STRING;
                               RaceConfigFile_In : STRING );

   procedure Configure_Ride( LapsQty_In : INTEGER );
   -- Initialize the competitor
   function Join(CompetitorFileDescriptor_In : STRING) return INTEGER;
   -- Box call this method to signal they are ready to start
   procedure BoxOk( CompetitorId_In : INTEGER);
   -- Each competitor task is started
   procedure Start_Race;

end Competition;
