with Competition_Monitor_Radio.Skel;
pragma Warnings (Off, Competition_Monitor_Radio.Skel);
with CORBA;

with Stats;
with Competition_Monitor;

package body Competition_Monitor_Radio.impl is

   function Ready( Self : access Object;
                  CompetitorID : Corba.SHORT) return BOOLEAN is
   begin
      return Competition_Monitor.Ready(INTEGER(CompetitorID));
   end Ready;

   function getInfo(Self : access Object; lap : CORBA.Short; sector : CORBA.Short ; id : CORBA.Short) return CORBA.String is
   begin
      return CORBA.To_CORBA_String
        (Competition_Monitor.getInfo(lap    => INTEGER(lap),
                                         sector => INTEGER(sector),
                                         id     => INTEGER(id)));
   end getInfo;

   function getBestLap(Self : access Object) return CORBA.STRING is
   begin
      return CORBA.To_CORBA_String(COmpetition_Monitor.getBestLap);
   end getBestLap;

   function getBestSector(Self : access Object; index : CORBA.Short) return CORBA.String is
   begin
      return CORBA.To_CORBA_String(Competition_Monitor.getBestSector(INTEGER(index)));
   end getBestSector;

   --function getClassific(Self : access Object; idComp_In : Corba.Short) return CORBA.STRING is
   --begin

   --end getClassific;

   --     function getCompetitorTimeLap(Self : access Object; competitorIdIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --     function getCompetitorTimeCheck(Self : access Object; competitorIdIn : in CORBA.Short; checkpointIn : in CORBA.Short) return CORBA.STRING;
   --     function getTyreUsury(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --     function getMeanSpeed(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --     function getTime(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --     function getMeanGasConsumption(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   --     function getGas(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;

end Competition_Monitor_Radio.impl;
