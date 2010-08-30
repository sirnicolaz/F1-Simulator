with OnBoardComputer;
use OnBoardComputer;
with Common;

--with Stats;
--use Stats;

with Ada.Strings.Unbounded;

package Competition_Monitor is

   function getBool return Boolean;
   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   protected type StartStopHandler is
      procedure Ready ( CompetitorID : in INTEGER);
      --TODO: maybe not necessary
      procedure Stop( CompetitorID : in INTEGER);

      procedure Set_ExpectedBoxes( CompetitorQty : INTEGER);

      --Through this method the competition knows when to start the competitors
      entry WaitReady;
   private
      ExpectedBoxes : INTEGER := -1;
   end StartStopHandler;

   type STARTSTOPHANDLER_POINT is access STARTSTOPHANDLER;

   function Ready(CompetitorID : INTEGER) return BOOLEAN;

   function Init( CompetitorQty_In : INTEGER;
                 Laps_In : INTEGER ) return STARTSTOPHANDLER_POINT;

   procedure Get_CompetitorInfo(lap : INTEGER; sector : INTEGER ; id : INTEGER; time : out FLOAT; updString : out Unbounded_String.Unbounded_String);
   type OBC is array (Positive range <>) of ONBOARDCOMPUTER.COMPUTER_POINT;
   type OBC_POINT is access OBC;
   procedure AddOBC(compIn : ONBOARDCOMPUTER.COMPUTER_POINT; indexIn : INTEGER);

  --This method return the information related to the competitors (current checkpoint,
   --+ lap and sector, speed ecc ) at a given time
   procedure Get_CompetitionInfo( TimeInstant : FLOAT;
                                 ClassificationTimes : out Common.FLOAT_ARRAY_POINT;
                                 XMLInfo : out Unbounded_String.Unbounded_String);

end Competition_Monitor;
