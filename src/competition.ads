with Circuit;
use Circuit;

with Competitor;
use Competitor;

with OnboardComputer;

with Ada.Strings;
with Ada.Strings.Unbounded;


package Competition is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   type CompetitorTask_Array is array(POSITIVE range <>) of access Competitor.TASKCOMPETITOR;

   protected type SYNCH_COMPETITION is

      entry Register_NewCompetitor(CompetitorDescriptor : in STRING;
                                       Box_CorbaLOC : in STRING;
                                       Given_Id : out INTEGER);

      procedure Configure( MaxCompetitors : in POSITIVE;
                          ClassificRefreshTime_in : in FLOAT;
                          Name_in : in STRING;
                          Laps_in : in INTEGER;
                          Circuit_File : in STRING);

      function AreRegistrationsOpen return BOOLEAN;

      entry Wait;

      procedure Start;
   private
      Track : Circuit.RACETRACK_POINT;
      ClassificRefreshTime : FLOAT;
      Name : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Laps : INTEGER;
      Competitors : access CompetitorTask_Array;
      -- The ID to assign to the next competitor that will apply for joining
      --+ the competition
      Next_ID : INTEGER := 1;
      Registrations_Open : BOOLEAN := False;

   end SYNCH_COMPETITION;

   type SYNCH_COMPETITION_POINT is access SYNCH_COMPETITION;

   procedure Ready(Competition_In : SYNCH_COMPETITION_POINT;
                   Wait_All : BOOLEAN);
end Competition;
