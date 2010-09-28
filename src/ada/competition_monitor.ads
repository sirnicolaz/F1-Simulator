with Competitor_Computer;
use Competitor_Computer;
with Common;

--with Stats;
--use Stats;

with Ada.Strings.Unbounded;

package Competition_Monitor is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   protected type StartStopHandler is
      procedure Ready ( CompetitorID : in INTEGER);

      procedure Set_ExpectedBoxes( CompetitorQty : INTEGER);

      --Through this method the competition knows when to start the competitors
      entry WaitReady;
   private
      ExpectedBoxes : INTEGER := -1;
   end StartStopHandler;

   type STARTSTOPHANDLER_POINT is access STARTSTOPHANDLER;

   function Ready(CompetitorID : INTEGER) return BOOLEAN;

   procedure Set_Simulation_Speed( Simulation_Speed_In : Float );

   function Init( CompetitorQty_In : INTEGER;
                 Laps_In : INTEGER ) return STARTSTOPHANDLER_POINT;

   procedure Add_Onboard_Computer(Computer_In : Competitor_Computer.COMPUTER_POINT;
                                  Competitor_ID_In : INTEGER);

  --This method return the information related to the competitors (current checkpoint,
   --+ lap and sector, speed ecc ) at a given time
   procedure Get_CompetitionInfo( TimeInstant : FLOAT;
                                 ClassificationTimes : out Common.FLOAT_ARRAY_POINT;
                                 XMLInfo : out Unbounded_String.Unbounded_String);

   procedure Get_CompetitorInfo(lap : INTEGER; sector : INTEGER ; id : INTEGER; time : out FLOAT; metres : out FLOAT; updString : out Unbounded_String.Unbounded_String);

   procedure Get_CompetitionConfiguration(XmlInfo : out Unbounded_String.Unbounded_String;
                                          CircuitLength : out FLOAT);

   function Get_CompetitorConfiguration( Id : INTEGER ) return Unbounded_String.Unbounded_String;

end Competition_Monitor;
