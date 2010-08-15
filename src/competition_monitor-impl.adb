
with System;
with Ada.Text_IO;


with Competition_Monitor.Skel;
pragma Warnings (Off, Competition_Monitor.Skel);
with CORBA;

with Ada.Strings.Unbounded;
--with Sax.Readers; use Sax.Readers;
--with DOM.Readers; use DOM.Readers;
--with DOM.Core; use DOM.Core;
--with DOM.Core.Documents; use DOM.Core.Documents;
--with DOM.Core.Nodes; use DOM.Core.Nodes;

with Common;

package body Competition_Monitor.Impl is

   CompetitionHandler : StartStopHandler_POINT;
   GlobalStatistics : GLOBAL_STATS_HANDLER_POINT;
   CompetitorQty : INTEGER;

   protected body StartStopHandler is

      procedure Ready ( CompetitorID : in INTEGER) is
      begin
         ExpectedBoxes := ExpectedBoxes - 1;
      end Ready;
      --TODO: maybe not necessary
      procedure Stop( CompetitorID : in INTEGER) is
      begin
         null;
      end Stop;

      --Through this method the competition knows when to start the competitors
      entry WaitReady when ExpectedBoxes = 0 is
      begin
         null;
      end WaitReady;

      procedure Set_ExpectedBoxes( CompetitorQty : INTEGER) is
      begin
         ExpectedBoxes := CompetitorQty;
      end Set_ExpectedBoxes;

   end StartStopHandler;

   function Init( CompetitorQty_In : INTEGER;
                 GlobalStatistics_In : GLOBAL_STATS_HANDLER_POINT ) return STARTSTOPHANDLER_POINT is

   begin
      CompetitorQty := CompetitorQty_In;

      arrayComputer := new OBC(1..CompetitorQty);
      arrayStats := new compStatsArray(1..CompetitorQty);
      arrayComp := new compArray(1..CompetitorQty);
      CompetitionHandler := new STARTSTOPHANDLER;
      CompetitionHandler.Set_ExpectedBoxes(CompetitorQty);

      GlobalStatistics := GlobalStatistics_In;

      return CompetitionHandler;
   end Init;

   protected body INFO_STRING is
      entry getSector (index : INTEGER; sectorString : out Unbounded_String.Unbounded_String ) when true is -- ritorna le info sul settore relativo al giro, se disponibili
      begin
         if index = 1 then
            if sector1 = Unbounded_String.Null_Unbounded_String then
               Updated := false;
               requeue Wait;
            else
               sectorString := sector1;
            end if;
         elsif index = 2 then
            if sector2 = Unbounded_String.Null_Unbounded_String then
               Updated := false;
               requeue Wait;
            else
               sectorString := sector2;
            end if;
         else
            if sector3 = Unbounded_String.Null_Unbounded_String then
               Updated := false;
               requeue Wait;
            else
               sectorString := sector3;
            end if;
         end if;
      end getSector;
      entry Wait(index : INTEGER; sectorString : out Unbounded_String.Unbounded_String ) when Updated is
      begin

         requeue GetSector;
      end Wait;
      -- function getInfoSector (index : INTEGER) return Unbounded_String.Unbounded_String;
      procedure setSector(index : INTEGER; updXml : Unbounded_String.Unbounded_String) is
      begin
         if index = 1 then sector1 := updXml;
         elsif index = 2 then sector2 := updXml;
         else sector3 := updXml;
         end if;
         Updated := true;
      end setSector;
   end INFO_STRING;

   function getInfo(Self : access Object; lap : CORBA.Short; sector : CORBA.Short ; id : CORBA.Short) return CORBA.String is
      stringRet : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      class : CLASSIFICATION_TABLE_POINT := new CLASSIFICATION_TABLE(1..CompetitorQty);
      upd : FLOAT := 100.0;
      --global : GLOBAL_STATS_HANDLER_POINT;
      --temp : GENERIC_STATS_POINT := new GENERIC_STATS;

      index : INTEGER := 0;
   begin
      --global := new GLOBAL_STATS_HANDLER(new FLOAT'(upd), temp);
      class.all := GlobalStatistics.global.Test_Get_Classific;
      --return Corba.To_CORBA_String(Unbounded_String.To_String(stringRet));
--      Unbounded_String.Set_Unbounded_String(stringRet,
      arrayComp(Integer(id)).arrayInfo(Integer(Lap)).getSector(Integer(sector),stringRet);
      Unbounded_String.Append(stringRet,"<classific competitors="
                              &Integer'Image(class'Length)
                              &"><competitor id="
                              &Integer'Image(Get_CompetitorId(class(1)))
                              &" >0.0</compId>");

      for index in 0..class'length --loop per costruire la classifica dopo il primo concorrente
      loop
         Unbounded_String.Append(stringRet,"<competitor id="
                                 &Integer'Image(Get_CompetitorId(class(index)))
                                 &" >"
                                 &Float'Image(Get_Time(class(index))-Get_Time(class(index-1)))
                                 &"</compId>");
      end loop;
      Unbounded_String.Append(stringRet, "</classific></update>");
      return Corba.To_CORBA_String(Unbounded_String.To_String(stringRet));--file update.xml completo
      --ritorna le info relative all'utente id, del giro lap del settore sector (se non presenti va in wait, il settore è una risorsa protetta)
   end getInfo;

   procedure setInfo(lap : INTEGER; sector : INTEGER; id : INTEGER; updXml : Unbounded_String.Unbounded_String) is
   begin
      arrayComp(id).arrayInfo(lap).setSector(sector, updXml);
   end setInfo;

   procedure AddOBC(compIn : ONBOARDCOMPUTER.COMPUTER_POINT; indexIn : INTEGER) is
   begin
      arrayComputer(indexIn):= compIn;
   end AddOBC;


--   procedure AddComp (compStats_In : Common.COMP_STATS_POINT; indexIn : INTEGER) is
 --  begin
  --    arrayStats(IndexIn) := compStats_In;
   --end AddComp;


   function getClassific(Self : access Object; idComp_In : Corba.Short) return CORBA.STRING is
      class : CLASSIFICATION_TABLE_POINT := new CLASSIFICATION_TABLE(1..CompetitorQty);
      --upd : FLOAT := 100.0;
--      global : GLOBAL_STATS_HANDLER_POINT;
--      temp : GENERIC_STATS_POINT := new GENERIC_STATS;
      ret : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      retString : CORBA.String;
      index : INTEGER := 0;
      tempStats : Common.COMP_STATS;
      lap : INTEGER;
      sector : INTEGER;
      checkpoint : INTEGER;
      gasLevel : FLOAT;
      tyreUsury : FLOAT;
      time : FLOAT;
   begin
      --global := new GLOBAL_STATS_HANDLER(new FLOAT'(upd), temp);
      tempStats := arrayStats(Integer(idComp_In)).all;
      lap := Common.Get_Lap(tempStats);
      checkpoint := Common.Get_Checkpoint(tempStats);
      gasLevel := Common.Get_Gas(tempStats);
      tyreUsury := Common.Get_Tyre(tempStats);
      sector := Common.Get_Sector(tempStats);
      time := Common.Get_Time(tempStats);
      class.all := GlobalStatistics.global.Test_Get_Classific;
      Unbounded_String.Set_Unbounded_String(ret,"<?xml version=""1.0""?><update><gasLevel>"&Float'Image(gasLevel)
                                            &"<gasLevel><tyreUsury>"&Float'Image(tyreUsury)
                                            &"</tyreUsury><time>"
                                            &Float'Image(time)&"</time><lap>"
                                            &Integer'Image(lap)&"</lap><sector>"
                                            &Integer'Image(sector)&"</sector>"
                                           );
      Unbounded_String.Append(ret,"<classific competitors="
                              &Integer'Image(class'Length)
                              &"><competitor id="
                              &Integer'Image(Get_CompetitorId(class(1)))
                              &" >0.0</compId>");
      --        <competitor id="
      --                                              &Integer'Image(Get_CompetitorId(class(2)))
      --                                              &" >"
      --                                              &Float'Image(Get_Time(class(2))-Get_Time(class(1)))
      --                                              &"</compId></classific>");
      for index in 0..class'length
      loop
         Unbounded_String.Append(ret,"<competitor id="
                                 &Integer'Image(Get_CompetitorId(class(index)))
                                 &" >"
                                 &Float'Image(Get_Time(class(index))-Get_Time(class(index-1)))
                                 &"</compId>");
      end loop;
      Unbounded_String.Append(ret, "</classific></update>");
      retString := Corba.To_CORBA_String(Unbounded_String.To_String(ret));
      return retString;
   end getClassific;

   procedure AddCompId (IdComp :  INTEGER) is
      --arr : INFO_POINT;
   begin
      arrayComp(IdComp).arrayInfo := new InfoArray(1..CompetitorQty);
      --inizializzazione dell'infoArray relativo al concorrente di ID = IDComp
   end AddCompId;


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
