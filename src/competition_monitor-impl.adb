
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
   procedure AddOBC(compIn : ONBOARDCOMPUTER.COMPUTER_POINT; indexIn : INTEGER) is
   begin
      arrayComputer(indexIn):= compIn;
   end AddOBC;


   procedure AddComp (compStats_In : Common.COMP_STATS_POINT; indexIn : INTEGER) is
   begin
      arrayStats(IndexIn) := compStats_In;
   end AddComp;


   function getClassific(Self : access Object) return CORBA.STRING is
      class : CLASSIFICATION_TABLE_POINT := new CLASSIFICATION_TABLE(1..10);
      upd : FLOAT := 100.0;
      global : GLOBAL_STATS_HANDLER_POINT;
      temp : GENERIC_STATS_POINT := new GENERIC_STATS;
      ret : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      retString : CORBA.String;
   begin
      global := new GLOBAL_STATS_HANDLER(new FLOAT'(upd), temp);
      class.all := global.global.Test_Get_Classific;
      Ada.Text_IO.Put_Line("<update><gasLevel><gasLevel><tyreUsury><lap>"
                           --&&"</tyreUsury><meanSpeed>"
                           --&&"270</meanSpead><meanGasConsumption>"
                           --&&"14</meanGasConsumption><time>"
                           --&&"1984.42</time>	<lap>"
                           &Integer'Image(Get_Lap(class(1)))&"</lap>"
                           --<sector>"&&"2</sector>
                           );

      Ada.Text_IO.Put_Line("<classific competitors="&Integer'Image(class'Length)&"><competitor id="
                           &Integer'Image(Get_CompetitorId(class(1)))&
                           " >0.0</compId><competitor id="&Integer'Image(Get_CompetitorId(class(2)))&" >"
                           &Float'Image(Get_Time(class(2))-Get_Time(class(1)))&"</compId></classific>");
      Unbounded_String.Set_Unbounded_String(ret,"<classific competitors="
                                            &Integer'Image(class'Length)
                                            &"><competitor id="
                                            &Integer'Image(Get_CompetitorId(class(1)))
                                            &" >0.0</compId><competitor id="
                                            &Integer'Image(Get_CompetitorId(class(2)))
                                            &" >"
                                            &Float'Image(Get_Time(class(2))-Get_Time(class(1)))
                                            &"</compId></classific>");
--                                              "Id = "&Integer'Image(Get_CompetitorId(class(1)))&
--                                                    ", lap = "&Integer'Image(Get_Lap(class(1)))&
--                                                    ", checkpoint = "&Integer'Image(Get_CheckPoint(class(1)))&
--                                                    ", time = "&Float'Image(Get_Time(class(1))));
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
      Unbounded_String.Set_Unbounded_String(ret,"<bestlap><num>"
                                            &Integer'Image(num)
                                            &"</num><idComp>"
                                            &Integer'Image(id)
                                            &"</idComp><time>"
                                            &Float'Image(time)
                                            &"</time></bestlap>"
                                           );
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
      Unbounded_String.Set_Unbounded_String(ret ,"<bestsector><numSector>"
                                            &Integer'Image(Integer(indexIn))
                                            &"</numSector><numLap>"
                                            &Integer'Image(num)
                                            &"</numLap><idComp>"
                                            &Integer'Image(id)
                                            &"</idComp><time>"
                                            &Float'Image(time)
                                            &"</time></bestsector>"
                                            );
      retString := Corba.To_CORBA_String(Unbounded_String.To_String(ret));
      return retString;
   end getBestSector;

   function getCompetitor(Self : access Object; competitorIdIn : CORBA.Short) return CORBA.STRING is
   begin
      return CORBA.To_CORBA_String("getCompetitor");
   end getCompetitor;

   function getCompetitorTimeSector(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short) return CORBA.STRING is
  upd : FLOAT := 100.0;
   global : GLOBAL_STATS_HANDLER_POINT;
   temp : GENERIC_STATS_POINT := new GENERIC_STATS;
   begin
      global := new GLOBAL_STATS_HANDLER(new FLOAT'(upd), temp);
return CORBA.To_CORBA_String("getCompetitorTimeSector");


   end getCompetitorTimeSector;

--     function getCompetitorTimeLap(Self : access Object; competitorIdIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
--     function getCompetitorTimeCheck(Self : access Object; competitorIdIn : in CORBA.Short; checkpointIn : in CORBA.Short) return CORBA.STRING;
--     function getTyreUsury(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
--     function getMeanSpeed(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
--     function getTime(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
--     function getMeanGasConsumption(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;
--     function getGas(Self : access Object; competitorIdIn : in CORBA.Short; sectorIn : in CORBA.Short; lapIn : in CORBA.Short) return CORBA.STRING;

end Competition_Monitor.Impl;
