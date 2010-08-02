
with System;
with Ada.Text_IO;


with Competition_Monitor.Skel;
pragma Warnings (Off, Competition_Monitor.Skel);
with CORBA;
with Stats;
use Stats;

with Ada.Strings.Unbounded;
--with Sax.Readers; use Sax.Readers;
--with DOM.Readers; use DOM.Readers;
--with DOM.Core; use DOM.Core;
--with DOM.Core.Documents; use DOM.Core.Documents;
--with DOM.Core.Nodes; use DOM.Core.Nodes;

with Common;

package body Competition_Monitor.Impl is
   function getClassific(Self : access Object) return CORBA.STRING is
      class : CLASSIFICATION_TABLE_POINT := new CLASSIFICATION_TABLE(1..25);
      upd : FLOAT := 100.0;
      global : GLOBAL_STATS_HANDLER_POINT;
      temp : GENERIC_STATS_POINT := new GENERIC_STATS;
      ret : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      retString : CORBA.String;
   begin
      global := new GLOBAL_STATS_HANDLER(new FLOAT'(upd), temp);
      class.all := global.global.Test_Get_Classific;
      Ada.Text_IO.Put_Line("classifica : Id = "&Integer'Image(Get_CompetitorId(class(1)))&
                           ", lap = "&Integer'Image(Get_Lap(class(1)))&
                           ", checkpoint = "&Integer'Image(Get_CheckPoint(class(1)))&", time = "
                           &Float'Image(Get_Time(class(1))));
      Unbounded_String.Set_Unbounded_String(ret,"Id = "&Integer'Image(Get_CompetitorId(class(1)))&
                                                  ", lap = "&Integer'Image(Get_Lap(class(1)))&
                                                  ", checkpoint = "&Integer'Image(Get_CheckPoint(class(1)))&
                                                  ", time = "&Float'Image(Get_Time(class(1))));
      retString := Corba.To_CORBA_String(Unbounded_String.To_String(ret));
      return retString;
   end getClassific;

   function getBestLap(Self : access Object) return CORBA.STRING is
      retString : CORBA.String;
      ret : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      temp : GENERIC_STATS_POINT := new GENERIC_STATS;
      num : INTEGER;
      id : INTEGER;
      time : FLOAT;
   begin
      num := Stats.Get_BestLapNum(temp.all);
      time := Stats.Get_BestLapTime(temp.all);
      id := Stats.Get_BestLapId(temp.all);
      Unbounded_String.Set_Unbounded_String(ret,"Best Lap = "&Integer'Image(num)&" , time = "&Float'Image(time)&" , Id Competitor = "&Integer'Image(id));
      retString := Corba.To_CORBA_String(Unbounded_String.To_String(ret));
      return retString;
   end getBestLap;

   function getBestSector(Self : access Object; indexIn : CORBA.Short) return CORBA.String is
            retString : CORBA.String;
      temp : GENERIC_STATS_POINT := new GENERIC_STATS;
      num : INTEGER;
      id : INTEGER;
      time : FLOAT;
      ret : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin
      num := Stats.Get_BestSectorsLap(temp.all,Integer(indexIn));
      time := Stats.Get_BestSectorsTime(temp.all,Integer(indexIn));
      id := Stats.Get_BestSectorsId(temp.all,Integer(indexIn));
      Unbounded_String.Set_Unbounded_String(ret ,"Sector : "&Integer'Image(Integer(indexIn))&" , Best Time : "&Float'Image(time)&" , Id Competitor : "&Integer'Image(id)&" in lap "&Integer'Image(num));
      retString := Corba.To_CORBA_String(Unbounded_String.To_String(ret));
      return retString;
   end getBestSector;

   function getCompetitor(Self : access Object; competitorIdIn : CORBA.Short) return CORBA.STRING;
   function getCompetitorTimeSector(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short) return CORBA.STRING is
  upd : FLOAT := 100.0;
   global : GLOBAL_STATS_HANDLER_POINT;
   temp : GENERIC_STATS_POINT := new GENERIC_STATS;
   begin
      global := new GLOBAL_STATS_HANDLER(new FLOAT'(upd), temp);



   end getCompetitor;

   function getCompetitorTimeLap(Self : access Object; competitorIdIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   function getCompetitorTimeCheck(Self : access Object; competitorIdIn : in CORBA.Short; checkpointIn : in CORBA.Short) return CORBA.STRING;
   function getTyreUsury(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   function getMeanSpeed(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   function getTime(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   function getMeanGasConsumption(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
   function getGas(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;

end Competition_Monitor.Impl;
