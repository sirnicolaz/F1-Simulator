with CORBA;
with PortableServer;
with OnBoardComputer;
USE OnBoardComputer;
with Common;

with Ada.Strings.Unbounded;


package Competition_Monitor.impl is
   type OBC is array (Positive range <>) of ONBOARDCOMPUTER.COMPUTER_POINT;
   type OBC_POINT is access OBC;
   type compStatsArray is array (Positive range <>) of Common.COMP_STATS_POINT;
   type COMP_POINT is access compStatsArray;

   procedure AddOBC(compIn : ONBOARDCOMPUTER.COMPUTER_POINT; indexIn : INTEGER);
   procedure AddComp (compStats_In : Common.COMP_STATS_POINT; indexIn : INTEGER);
   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;
   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;
   function getClassific(Self : access Object; idComp_In : Corba.Short) return CORBA.STRING;
   function getBestLap(Self : access Object) return CORBA.STRING;
   function getBestSector(Self : access Object; indexIn : CORBA.Short)return CORBA.String;
   function getCompetitor(Self : access Object; competitorIdIn : CORBA.Short) return CORBA.STRING;
   function getCompetitorTimeSector(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short) return CORBA.STRING;
--     function getCompetitorTimeLap(Self : access Object; competitorIdIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
--     function getCompetitorTimeCheck(Self : access Object; competitorIdIn : in CORBA.Short; checkpointIn : in CORBA.Short) return CORBA.STRING;
--     function getTyreUsury(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
--     function getMeanSpeed(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
--     function getTime(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
--     function getMeanGasConsumption(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
--     function getGas(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;

private
   arrayComputer : OBC(1..10);
   arrayStats : compStatsArray(1..10);
end Competition_Monitor.impl;
