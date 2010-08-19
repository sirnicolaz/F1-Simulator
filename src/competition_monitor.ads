with OnBoardComputer;
USE OnBoardComputer;
with Common;

with Stats;
use Stats;

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
                 Laps_In : INTEGER;
                 GlobalStatistics_In : GLOBAL_STATS_HANDLER_POINT ) return STARTSTOPHANDLER_POINT;

   protected type INFO_STRING is -- tipo protetto con le stringhe che poi verranno ritornate (file update.xml)
      entry getSector (index : INTEGER; sectorString : out Unbounded_String.Unbounded_String );--ritorna la stringa sul relativo settore
      entry Wait(index : INTEGER; sectorString : out Unbounded_String.Unbounded_String );--funzione di wait (se non è disponibile la info sul settore)
      -- function getInfoSector (index : INTEGER) return Unbounded_String.Unbounded_String;
      procedure setSector(index : INTEGER; updXml : Unbounded_String.Unbounded_String);--settaggio della stringa del settore;
   private
      sector1 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      sector2 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      sector3 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Updated : Boolean := false;
   end INFO_STRING;

   type INFO_STRING_POINT is access INFO_STRING; -- NEW
   --array di lap
   type infoArray is array (INTEGER range <>) of INFO_STRING_POINT;--new
   type INFO_ARRAY_POINT is access infoArray;

   --struttura dati con dentro l'array, ne esiste uno per ogni concorrente (rappresentato dall'array arrayComp(IDCONCORRENTE))
   type INFO_POINT is record
      arrayInfo : INFO_ARRAY_POINT;
   end record;

   function getInfo(lap : INTEGER; sector : INTEGER ; id : INTEGER) return STRING;
   procedure setInfo(lap : INTEGER; sector : INTEGER; id : INTEGER; updXml : Unbounded_String.Unbounded_String);--metodo per settare le informazioni
   type OBC is array (Positive range <>) of ONBOARDCOMPUTER.COMPUTER_POINT;
   type OBC_POINT is access OBC;
   type compStatsArray is array (Positive range <>) of Common.COMP_STATS_POINT;
   type COMP_POINT is access compStatsArray;


   type compArray is array (Positive range<>) of INFO_POINT;
   type C_POINT is access compArray;

   procedure AddOBC(compIn : ONBOARDCOMPUTER.COMPUTER_POINT; indexIn : INTEGER);
--   procedure AddComp (compStats_In : Common.COMP_STATS_POINT; indexIn : INTEGER);
   procedure AddCompId (IdComp :  INTEGER);

   --function getClassific(Self : access Object; idComp_In : Corba.Short) return CORBA.STRING; TODO per ora commentata, non serve, la classifica viene già ritornata ai box
   --eventualmente la riuseremo per le tv, un po modificata magari.
   function getBestLap return STRING;
   function getBestSector(indexIn : INTEGER)return STRING;
   --function getCompetitor(Self : access Object; competitorIdIn : CORBA.Short) return CORBA.STRING;
   --function getCompetitorTimeSector(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short) return CORBA.STRING;
   --function getCompetitorTimeLap(Self : access Object; competitorIdIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --function getCompetitorTimeCheck(Self : access Object; competitorIdIn : in CORBA.Short; checkpointIn : in CORBA.Short) return CORBA.STRING;
   --function getTyreUsury(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --function getMeanSpeed(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --function getTime(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --function getMeanGasConsumption(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --function getGas(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;



private
   arrayComputer : access OBC;--(1..10);--per avere gli onboardcomputer di ogni concorrente
   arrayStats : access compStatsArray;--(1..10); --per avere le statistiche
   arrayComp : access compArray; --(1..10);--per avere l'array con i dati relativi a ogni concorrente (l'id del concorrente è l'indice dell'array)
   --TODO : correggere gli indici degli array per ora fissati a 10 e poi a max competitors.

end Competition_Monitor;
