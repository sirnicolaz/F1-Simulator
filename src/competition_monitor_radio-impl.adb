with Competition_Monitor_Radio.Skel;
pragma Warnings (Off, Competition_Monitor_Radio.Skel);

--with Stats;
with Competition_Monitor;

with Common;
with Ada.Text_IO;

with Ada.Strings.Unbounded;

package body Competition_Monitor_Radio.impl is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   function Ready( Self : access Object;
                  CompetitorID : Corba.SHORT) return BOOLEAN is
   begin
      Ada.Text_IO.Put_Line("Ready box " & COmmon.IntegerToString(INTEGER(CompetitorID)));
      return Competition_Monitor.Ready(INTEGER(CompetitorID));
   end Ready;

   procedure Get_CompetitorInfo(Self : access Object; lap : CORBA.Short; sector : CORBA.Short ; id : CORBA.Short; time : out CORBA.FLOAT; Returns : out CORBA.STRING) is
      ReturnStr : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      ReturnTime : FLOAT;
   begin
      Ada.Text_IO.Put_Line("Asking for info: lap " & INTEGER'IMAGE(INTEGER(lap)) &
                           ", sector " & INTEGER'IMAGE(INTEGER(sector)));
      Competition_Monitor.Get_CompetitorInfo(lap       => INTEGER(lap),
                                  sector    => INTEGER(sector),
                                  id        => INTEGER(id),
                                  time      => ReturnTime,
                                  updString => ReturnStr);
      Ada.Text_IO.Put_Line("Converting for info");
      Returns := CORBA.To_CORBA_String(Unbounded_String.To_String(ReturnStr));
      time := CORBA.Float(ReturnTime);
   end Get_CompetitorInfo;

   function Get_CompetitionInfo(Self : access Object; timeInstant : CORBA.FLOAT) return CORBA.STRING is
      Tmp_String : Unbounded_String.Unbounded_String;
   begin
      Ada.Text_IO.Put_Line("A screen is asking");
      Tmp_String := Competition_Monitor.Get_CompetitionInfo(FLOAT(timeInstant));
      return CORBA.To_CORBA_String(Unbounded_String.To_String(Tmp_String));
   end Get_CompetitionInfo;

   function getBestLap(Self : access Object) return CORBA.STRING is
   begin
      return CORBA.To_CORBA_String(COmpetition_Monitor.getBestLapInfo);
   end getBestLap;

   function getBestSector(Self : access Object; index : CORBA.Short) return CORBA.String is
   begin
      return CORBA.To_CORBA_String(Competition_Monitor.getBestSectorInfo(INTEGER(index)));
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
