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
      ExpectedBoxes : INTEGER := 0;
   end StartStopHandler;

   type STARTSTOPHANDLER_POINT is access STARTSTOPHANDLER;

   function Ready(CompetitorID : INTEGER) return BOOLEAN;

   function Init( CompetitorQty_In : INTEGER;
                 Laps_In : INTEGER ) return STARTSTOPHANDLER_POINT;

   procedure Get_CompetitorInfo(lap : INTEGER; sector : INTEGER ; id : INTEGER; time : out FLOAT; updString : out Unbounded_String.Unbounded_String);
   type OBC is array (Positive range <>) of ONBOARDCOMPUTER.COMPUTER_POINT;
   type OBC_POINT is access OBC;
   procedure AddOBC(compIn : ONBOARDCOMPUTER.COMPUTER_POINT; indexIn : INTEGER);
--   procedure AddComp (compStats_In : Common.COMP_STATS_POINT; indexIn : INTEGER);
   --procedure AddCompId (IdComp :  INTEGER);

   --function getClassific(Self : access Object; idComp_In : Corba.Short) return CORBA.STRING; TODO per ora commentata, non serve, la classifica viene già ritornata ai box
   --eventualmente la riuseremo per le tv, un po modificata magari.

   --function getCompetitor(Self : access Object; competitorIdIn : CORBA.Short) return CORBA.STRING;
   --function getCompetitorTimeSector(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short) return CORBA.STRING;
   --function getCompetitorTimeLap(Self : access Object; competitorIdIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --function getCompetitorTimeCheck(Self : access Object; competitorIdIn : in CORBA.Short; checkpointIn : in CORBA.Short) return CORBA.STRING;
   --function getTyreUsury(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --function getMeanSpeed(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --function getTime(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --function getMeanGasConsumption(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --function getGas(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   procedure setBestSector(indexIn : INTEGER ; updXml : Unbounded_String.Unbounded_String);
   procedure setBestLap(updXml : Unbounded_String.Unbounded_String);
   function getBestLapInfo return STRING;
   function getBestSectorInfo(indexIn : INTEGER)return STRING;

   --This method return the information related to the competitors (current checkpoint,
   --+ lap and sector, speed ecc ) at a given time
   function Get_CompetitionInfo( TimeInstant : FLOAT) return Unbounded_String.Unbounded_String;

--  private
--     bestLap : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
--     bestSector1 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
--     bestSector2 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
--     bestSector3 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

end Competition_Monitor;
