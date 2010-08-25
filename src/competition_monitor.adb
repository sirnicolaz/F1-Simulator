with System;
with Ada.Text_IO;

with Ada.Strings.Unbounded;
--with Sax.Readers; use Sax.Readers;
--with DOM.Readers; use DOM.Readers;
--with DOM.Core; use DOM.Core;
--with DOM.Core.Documents; use DOM.Core.Documents;
--with DOM.Core.Nodes; use DOM.Core.Nodes;

with Common;

package body Competition_Monitor is

   CompetitionHandler : StartStopHandler_POINT;
   --GlobalStatistics : GLOBAL_STATS_HANDLER_POINT;
   CompetitorQty : INTEGER;
   Laps : INTEGER;
   IsConfigured : BOOLEAN := false;

   --per avere gli onboardcomputer di ogni concorrente
   arrayComputer : access OBC;
   --per avere le statistiche
   --arrayStats : access compStatsArray;
   --per avere l'array con i dati relativi a ogni concorrente (l'id del concorrente è l'indice dell'array)
   --arrayComp : access compArray;

   function getBool return Boolean is
   begin
      return IsConfigured;
   end getBool;

   protected body StartStopHandler is

      --TODO: use that CompetitorID to recognize the caller
      procedure Ready ( CompetitorID : in INTEGER) is
      begin
         ExpectedBoxes := ExpectedBoxes - 1;
         Ada.Text_IO.Put_Line(Common.IntegerToString(ExpectedBoxes) & " boxes left");
      end Ready;
      --TODO: maybe not necessary
      procedure Stop( CompetitorID : in INTEGER) is
      begin
         null;
      end Stop;

      --Through this method the competition knows when to start the competitors
      entry WaitReady when ExpectedBoxes = 0 is
      begin
         Ada.Text_IO.Put_Line("READY!!!!!");
         null;
      end WaitReady;

      procedure Set_ExpectedBoxes( CompetitorQty : INTEGER) is
      begin
         ExpectedBoxes := CompetitorQty;
      end Set_ExpectedBoxes;

   end StartStopHandler;

   function Ready(CompetitorID : INTEGER) return BOOLEAN is
   begin
      --Verify that the monitor is initialised and the competitor
      --+ onboard computer is added (everything should already be
      --+ fine automatically once the box invokes this method, but
      --+ just for bug tracing we inserted this control)
      if(arrayComputer(INTEGER(CompetitorID)) = null) then
         Ada.Text_IO.Put_Line("Onboard computer null");
      else
         Ada.Text_IO.Put_Line("Onboard computer ok");
      end if;

      if( arrayComputer(INTEGER(CompetitorID)) /= null and  IsConfigured = true) then
         CompetitionHandler.Ready(INTEGER(CompetitorID));
         return true;
      end if;
      return false;
   end Ready;

   function Init( CompetitorQty_In : INTEGER;
                 Laps_In : INTEGER) return STARTSTOPHANDLER_POINT is

   begin
      CompetitorQty := CompetitorQty_In;
      Laps := Laps_In;

      arrayComputer := new OBC(1..CompetitorQty);
      --arrayStats := new compStatsArray(1..CompetitorQty);
      --arrayComp := new compArray(1..CompetitorQty);

      --Init the INFO_ARRAY_POINT
      --for Index in 1..CompetitorQty loop
      --   arrayComp(Index) := new INFO_ARRAY(0..Laps-1);
      --   for Indez in 0..Laps-1 loop
      --      arrayComp(Index).all(Indez) := new INFO_STRING;
      --   end loop;
      --end loop;


      CompetitionHandler := new STARTSTOPHANDLER;
      CompetitionHandler.Set_ExpectedBoxes(CompetitorQty);

      --GlobalStatistics := GlobalStatistics_In;

      IsConfigured := true;

      return CompetitionHandler;
   end Init;



--     protected body INFO_STRING is
--         -- ritorna le info sul settore relativo al giro, se disponibili
--        entry getSector (index : INTEGER; sectorString : out Unbounded_String.Unbounded_String; time : out FLOAT ) when true is
--        begin
--           Ada.Text_IO.Put_Line("in getSector");
--           if index = 1 then
--              if sector1 = Unbounded_String.Null_Unbounded_String then
--                 Ada.Text_IO.Put_Line("in getSector,settore 1 NULL");
--                 Updated := false;
--                 requeue Wait;
--              else
--                 sectorString := sector1;
--                 time := sector1_time;
--              end if;
--           elsif index = 2 then
--              if sector2 = Unbounded_String.Null_Unbounded_String then
--                 Ada.Text_IO.Put_Line("in getSector,settore 2 NULL");
--                 Updated := false;
--                 requeue Wait;
--              else
--                 sectorString := sector2;
--                 time := sector2_time;
--              end if;
--           else
--              if sector3 = Unbounded_String.Null_Unbounded_String then
--                 Ada.Text_IO.Put_Line("in getSector,settore 3 NULL");
--                 Updated := false;
--                 requeue Wait;
--              else
--                 sectorString := sector3;
--                 time := sector3_time;
--              end if;
--           end if;
--        end getSector;
--        entry Wait(index : INTEGER; sectorString : out Unbounded_String.Unbounded_String; time : out FLOAT ) when Updated  is
--        begin
--  --Ada.Text_IO.Put_Line("in wait");
--           requeue GetSector;
--        end Wait;
--        -- function getInfoSector (index : INTEGER) return Unbounded_String.Unbounded_String;
--        procedure setSector(index : INTEGER; updXml : Unbounded_String.Unbounded_String; time : FLOAT) is
--        begin
--           Ada.Text_IO.Put_Line("Setting sector " & Common.IntegerToString(index));
--           if index = 1 then
--              sector1 := updXml;
--              sector1_time := time;
--           elsif index = 2 then
--              sector2 := updXml;
--              sector2_time := time;
--           else
--              sector3 := updXml;
--              sector3_time := time;
--           end if;
--           Updated := true;
--        end setSector;
--     end INFO_STRING;


--     procedure setInfo(lap : INTEGER; sector : INTEGER; id : INTEGER; updXml : Unbounded_String.Unbounded_String; time : FLOAT) is
--     begin
--  --        if arrayComp = null then
--  --           arrayComp := new CompArray(1..CompetitorQty);--TODO : stronzata
--  --           Ada.Text_IO.Put_Line("arrayComp init");
--  --        end if;
--  --         if arrayComp = null then
--  --           Ada.Text_IO.Put_Line("arrayComp NULL");
--  --        end if;
--
--  --         if arrayComp(id).arrayInfo = null then
--  --           Ada.Text_IO.Put_Line("arrayInfo NULL");
--  --        end if;
--  --Ada.Text_IO.Put_Line(Unbounded_String.To_String(updXml));
--        Ada.Text_IO.Put_Line("Competitor " & Common.IntegerToString(id) & " is addin info of lap " & Common.IntegerToString(lap));
--        arrayComp(id).all(lap).setSector(sector, updXml,time);
--     end setInfo;

   procedure AddOBC(compIn : ONBOARDCOMPUTER.COMPUTER_POINT; indexIn : INTEGER) is
   begin
      arrayComputer(indexIn):= compIn;
      --AddCompId(indexIn);
   end AddOBC;

   --procedure AddCompId (IdComp :  INTEGER) is
      --arr : INFO_POINT;
   --begin
      --arrayComp(IdComp).arrayInfo := new InfoArray(0..Laps);
      --inizializzazione dell'infoArray relativo al concorrente di ID = IDComp
   --end AddCompId;

   procedure getInfo(lap : INTEGER; sector : INTEGER ; id : INTEGER; time : out FLOAT; updString : out Unbounded_String.Unbounded_String) is
      ComputerIndex : INTEGER := 1;
   begin

      while OnBoardComputer.Get_Id(arrayComputer(ComputerIndex)) /= id loop
         ComputerIndex := ComputerIndex + 1;
      end loop;

      OnboardCOmputer.Get_BoxInfo(arrayComputer(ComputerIndex),
                                  lap,
                                  sector,
                                  updString,
                                  time);

   end getInfo;

   pragma Warnings(off);
   function getClassific(idComp_In : INTEGER) return STRING is
      --class : CLASSIFICATION_TABLE_POINT := new CLASSIFICATION_TABLE(1..CompetitorQty);
      --upd : FLOAT := 100.0;
--      global : GLOBAL_STATS_HANDLER_POINT;
--      temp : GENERIC_STATS_POINT := new GENERIC_STATS;
      ret : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      --retString : CORBA.String;
      index : INTEGER := 0;
      tempStats : COMP_STATS;
      lap : INTEGER;
      sector : INTEGER;
      checkpoint : INTEGER;
      gasLevel : FLOAT;
      tyreUsury : FLOAT;
      time : FLOAT;
   begin
--        --global := new GLOBAL_STATS_HANDLER(new FLOAT'(upd), temp);
--        tempStats := arrayStats(Integer(idComp_In)).all;
--        lap := Common.Get_Lap(tempStats);
--        checkpoint := Common.Get_Checkpoint(tempStats);
--        gasLevel := Common.Get_Gas(tempStats);
--        tyreUsury := Common.Get_Tyre(tempStats);
--        sector := Common.Get_Sector(tempStats);
--        time := Common.Get_Time(tempStats);
--        class.all := GlobalStatistics.global.Test_Get_Classific;
--        Unbounded_String.Set_Unbounded_String(ret,"<?xml version=""1.0""?><update><gasLevel>"&Float'Image(gasLevel)
--                                              &"<gasLevel><tyreUsury>"&Float'Image(tyreUsury)
--                                              &"</tyreUsury><time>"
--                                              &Float'Image(time)&"</time><lap>"
--                                              &Integer'Image(lap)&"</lap><sector>"
--                                              &Integer'Image(sector)&"</sector>"
--                                             );
--        Unbounded_String.Append(ret,"<classific competitors="
--                                &Integer'Image(class'Length)
--                                &"><competitor id="
--                                &Integer'Image(Get_CompetitorId(class(1)))
--                                &" >0.0</compId>");
--        --        <competitor id="
--        --                                              &Integer'Image(Get_CompetitorId(class(2)))
--        --                                              &" >"
--        --                                              &Float'Image(Get_Time(class(2))-Get_Time(class(1)))
--        --                                              &"</compId></classific>");
--        for index in 0..class'length
--        loop
--           Unbounded_String.Append(ret,"<competitor id="
--                                   &Integer'Image(Get_CompetitorId(class(index)))
--                                   &" >"
--                                   &Float'Image(Get_Time(class(index))-Get_Time(class(index-1)))
--                                   &"</compId>");
--        end loop;
--        Unbounded_String.Append(ret, "</classific></update>");
--        --retString := Corba.To_CORBA_String(Unbounded_String.To_String(ret));
--        --return retString;
      return "";
   end getClassific;
   pragma Warnings(on);

--     function getBestLap(id_In : INTEGER; lap : INTEGER) return STRING is
--        --retString : CORBA.String;
--  --        ret : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
--  --       -- temp : GENERIC_STATS_POINT := new GENERIC_STATS;
--  --        num : INTEGER;
--  --        id : INTEGER;
--  --        time : FLOAT;
--     begin
--  --        num := Stats.Get_BestLapNum(temp.all);
--  --        time := Stats.Get_BestLapTime(temp.all);
--  --        id := Stats.Get_BestLapId(temp.all);
--  --        Unbounded_String.Set_Unbounded_String(ret,"<bestlap><num>"
--  --                                              &Integer'Image(num)
--  --                                              &"</num><idComp>"
--  --                                              &Integer'Image(id)
--  --                                              &"</idComp><time>"
--  --                                              &Float'Image(time)
--  --                                              &"</time></bestlap>"
--  --                                             );
--  --        --retString := Corba.To_CORBA_String(Unbounded_String.To_String(ret));
--        --return retString;
--    --    return Corba.To_CORBA_String(Unbounded_String.To_String(arrayComp(id_In).getBestLapInfo));
--     return arrayComp(id_In).all(lap).getBestLapInfo;
--     end getBestLap;
--
--     function getBestSector(id_In : INTEGER; indexIn : INTEGER; lap : INTEGER) return STRING is
--        --retString : CORBA.String;
--        --temp : GENERIC_STATS_POINT := new GENERIC_STATS;
--  --        num : INTEGER;
--  --        id : INTEGER;
--  --        time : FLOAT;
--  --        ret : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
--     begin
--  --        num := Stats.Get_BestSectorsLap(temp.all,Integer(indexIn));
--  --        time := Stats.Get_BestSectorsTime(temp.all,Integer(indexIn));
--  --        id := Stats.Get_BestSectorsId(temp.all,Integer(indexIn));
--  --        Unbounded_String.Set_Unbounded_String(ret ,"<bestsector><numSector>"
--  --                                              &Integer'Image(Integer(indexIn))
--  --                                              &"</numSector><numLap>"
--  --                                              &Integer'Image(num)
--  --                                              &"</numLap><idComp>"
--  --                                              &Integer'Image(id)
--  --                                              &"</idComp><time>"
--  --                                              &Float'Image(time)
--  --                                              &"</time></bestsector>"
--  --                                             );
--        --retString := Corba.To_CORBA_String(Unbounded_String.To_String(ret));
--        --return retString;
--        return arrayComp(id_In).all(lap).getBestSectorInfo(indexIn);
--
--     end getBestSector;

   function getCompetitor(competitorIdIn : INTEGER) return STRING is
   begin
      return "getCompetitor";
   end getCompetitor;

   function getCompetitorTimeSector(competitorIdIn : in INTEGER; sectorIn : in INTEGER) return STRING is
      upd : FLOAT := 100.0;
      --global : GLOBAL_STATS_HANDLER_POINT;
      --temp : GENERIC_STATS_POINT := new GENERIC_STATS;
   begin
      --global := new GLOBAL_STATS_HANDLER(new FLOAT'(upd), temp);
      --return CORBA.To_CORBA_String("getCompetitorTimeSector");
      return "";

   end getCompetitorTimeSector;

--   procedure AddComp (compStats_In : Common.COMP_STATS_POINT; indexIn : INTEGER) is
 --  begin
  --    arrayStats(IndexIn) := compStats_In;
   --end AddComp;


         procedure setBestSector(indexIn : INTEGER; updXml : Unbounded_String.Unbounded_String) is
      begin
        Ada.Text_IO.Put_Line("Setting best sector : " & Common.IntegerToString(indexIn));
        -- if indexIn = 1 then Competition_Monitor.bestSector1 := updXml;
        -- elsif indexIn = 2 then Competition_Monitor.bestSector2 := updXml;
        -- else Competition_Monitor.bestSector3 := updXml;
        -- end if;
         -- Updated := true;
      end setBestSector;

      procedure setBestLap(updXml : Unbounded_String.Unbounded_String) is
      begin
         Ada.Text_IO.Put_Line("Setting best Lap ");
         --bestLap := updXml;
         -- Updated := true;
      end setBestLap;
      function getBestLapInfo return STRING is
      begin
         --if Competition_Monitor.bestLap = Unbounded_String.Null_Unbounded_String then return "<warning>informazione sul miglior giro non disponibile</warning>";
         --else return Unbounded_String.To_String(Competition_Monitor.bestLap);
         --  end if;
         return "";
      end getBestLapInfo;

   function getBestSectorInfo(indexIn : INTEGER )return STRING is
   begin
--           if indexIn = 1 then
--              if Competition_Monitor.bestSector1 = Unbounded_String.Null_Unbounded_String then return "<warning>informazione sul miglior primo settore non disponibile</warning>";
--              else return Unbounded_String.To_String(Competition_Monitor.bestSector1);
--              end if;
--           elsif indexIn = 2 then
--              if Competition_Monitor.bestSector2 = Unbounded_String.Null_Unbounded_String then return "<warning>informazione sul miglior secondo settore non disponibile</warning>";
--              else return Unbounded_String.To_String(Competition_Monitor.bestSector2);
--              end if;
--           else
--              if Competition_Monitor.bestSector3 = Unbounded_String.Null_Unbounded_String then return "<warning>informazione sul miglior terzo settore non disponibile</warning>";
--              else return Unbounded_String.To_String(Competition_Monitor.bestSector3);
--              end if;
--           end if;
      return "";
   end getBestSectorInfo;

   function Get_Info( TimeInstant : FLOAT) return STRING is
      Tmp_Stats : COMP_STATS_POINT := new COMP_STATS;
      Tmp_StatsString : Common.Unbounded_String.Unbounded_String := Common.Unbounded_String.Null_Unbounded_String;
      Tmp_CompLocation : access STRING;
   begin
      Tmp_StatsString := Common.Unbounded_String.To_Unbounded_String
        ("<?xml version=""1.0""?>" &
         "<competitionStatus time=""" & FLOAT'IMAGE(TimeInstant) & """>");
      for Index in arrayComputer'RANGE loop
         OnboardComputer.Get_StatsByTime(Computer_In => arrayComputer(Index),
                                         Time        => TimeInstant,
                                         Stats_In    => Tmp_Stats);

         -- In this case the competitor is arriving to the checkpoint
         if( Tmp_Stats.Time < TimeInstant ) then
            Tmp_CompLocation := new STRING(1..8);
            Tmp_CompLocation.all := "arriving";
            --In this case the competitor is exaclty on the checkpoint
         elsif( Tmp_Stats.Time = TimeInstant) then
            Tmp_CompLocation := new STRING(1..4);
            Tmp_CompLocation.all := "over";
            -- Otherwise the competitor has just left the checkpoint and he's
            --+ not arrived to the following one yet
         else
            Tmp_CompLocation := new STRING(1..6);
            Tmp_CompLocation.all := "passed";
         end if;

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
           ("<competitor id=""" & Common.IntegerToString(OnboardComputer.Get_Id(arrayComputer(Index))) & """>" &
            "<checkpoint compPosition=""" & Tmp_CompLocation.all & """ >" & Common.IntegerToString(Tmp_Stats.Checkpoint) & "</checkpoint>" &
            "<lap>" & Common.IntegerToString(Tmp_Stats.Lap) & "</lap>" &
            "<sector>" & Common.IntegerToString(Tmp_Stats.Sector) & "</sector>" &
            "</competitor>");
      end loop;

      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
        ("</competitionStatus>");

      return Common.Unbounded_String.To_String(Tmp_StatsString);

   end Get_Info;


end Competition_Monitor;
