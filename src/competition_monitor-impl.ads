with CORBA;
with PortableServer;

with Ada.Strings.Unbounded;


package Competition_Monitor.impl is
   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;
   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;
   function getClassific(Self : access Object) return CORBA.STRING;
   function getBestLap(Self : access Object) return CORBA.STRING;
   function getBestSector(Self : access Object; indexIn : CORBA.Short)return CORBA.String;
   function getCompetitor(Self : access Object; competitorIdIn : CORBA.Short) return CORBA.STRING;
   function getCompetitorTimeSector(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short) return CORBA.STRING;
   function getCompetitorTimeLap(Self : access Object; competitorIdIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   function getCompetitorTimeCheck(Self : access Object; competitorIdIn : in CORBA.Short; checkpointIn : in CORBA.Short) return CORBA.STRING;
   function getTyreUsury(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   function getMeanSpeed(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   function getTime(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   function getMeanGasConsumption(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   function getGas(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
end Competition_Monitor.impl;
