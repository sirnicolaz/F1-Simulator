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

    -- tipo protetto con le stringhe che poi verranno ritornate (file update.xml)
--     protected type INFO_STRING is
--        --ritorna la stringa sul relativo settore
--        entry getSector (index : INTEGER; sectorString : out Unbounded_String.Unbounded_String; time : out FLOAT );
--
--        --funzione di wait (se non è disponibile la info sul settore)
--        entry Wait(index : INTEGER; sectorString : out Unbounded_String.Unbounded_String; time : out FLOAT );
--
--        -- function getInfoSector (index : INTEGER) return Unbounded_String.Unbounded_String;
--        procedure setSector(index : INTEGER; updXml : Unbounded_String.Unbounded_String; time : FLOAT);--settaggio della stringa del settore;
--     private
--        sector1 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
--        sector1_time : FLOAT;
--        sector2 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
--        sector2_time : FLOAT;
--        sector3 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
--        sector3_time : FLOAT;
--        Updated : Boolean := false;
--     end INFO_STRING;
--     type INFO_STRING_POINT is access INFO_STRING; -- NEW
--     --array di lap
--     type INFO_ARRAY is array (INTEGER range <>) of INFO_STRING_POINT;--new
--     type INFO_ARRAY_POINT is access INFO_ARRAY;

   --function getBestLap(id_In : INTEGER ; lap : INTEGER) return STRING;
   --function getBestSector(id_In : INTEGER; indexIn : INTEGER; lap : INTEGER)return STRING;

   procedure getInfo(lap : INTEGER; sector : INTEGER ; id : INTEGER; time : out FLOAT; updString : out Unbounded_String.Unbounded_String);
--   procedure setInfo(lap : INTEGER; sector : INTEGER; id : INTEGER; updXml : Unbounded_String.Unbounded_String; time :  FLOAT);--metodo per settare le informazioni
   type OBC is array (Positive range <>) of ONBOARDCOMPUTER.COMPUTER_POINT;
   type OBC_POINT is access OBC;
--     type compStatsArray is array (Positive range <>) of Common.COMP_STATS_POINT;
--     type COMP_POINT is access compStatsArray;
--
--
--     type compArray is array (Positive range<>) of INFO_ARRAY_POINT;
--     type C_POINT is access compArray;

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
   function Get_Info( TimeInstant : FLOAT) return STRING;

--  private
--     bestLap : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
--     bestSector1 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
--     bestSector2 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
--     bestSector3 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

end Competition_Monitor;
