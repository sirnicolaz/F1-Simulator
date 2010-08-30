with System;
with Ada.Text_IO;

with Ada.Strings.Unbounded;

with Common;
use Common;

with CompetitionComputer;
use CompetitionComputer;

package body Competition_Monitor is

   CompetitionHandler : StartStopHandler_POINT := new StartStopHandler;
   --GlobalStatistics : GLOBAL_STATS_HANDLER_POINT;
   CompetitorQty : INTEGER;
   Laps : INTEGER;
   IsConfigured : BOOLEAN := false;

   --per avere gli onboardcomputer di ogni concorrente
   arrayComputer : access OBC;

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

      --CompetitionHandler := new STARTSTOPHANDLER;
      CompetitionHandler.Set_ExpectedBoxes(CompetitorQty);

      --GlobalStatistics := GlobalStatistics_In;

      IsConfigured := true;

      return CompetitionHandler;
   end Init;

   procedure AddOBC(compIn : ONBOARDCOMPUTER.COMPUTER_POINT; indexIn : INTEGER) is
   begin
      arrayComputer(indexIn):= compIn;
   end AddOBC;

   procedure Get_CompetitorInfo(lap : INTEGER; sector : INTEGER ; id : INTEGER; time : out FLOAT; updString : out Unbounded_String.Unbounded_String) is
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

   end Get_CompetitorInfo;

   pragma Warnings(off);
   function getClassific(idComp_In : INTEGER) return STRING is
      --class : CLASSIFICATION_TABLE_POINT := new CLASSIFICATION_TABLE(1..CompetitorQty);
      --upd : FLOAT := 100.0;
--      global : GLOBAL_STATS_HANDLER_POINT;
--      temp : GENERIC_STATS_POINT := new GENERIC_STATS;
      ret : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      --retString : CORBA.String;
      index : INTEGER := 0;
      tempStats : COMPETITOR_STATS;
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

--   procedure AddComp (compStats_In : Common.COMPETITOR_STATS_POINT; indexIn : INTEGER) is
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

   procedure Get_CompetitionInfo( TimeInstant : FLOAT;
                                 ClassificationTimes : out FLOAT_ARRAY_POINT;
                                 XMLInfo : out Unbounded_String.Unbounded_String) is
      Tmp_Stats : COMPETITOR_STATS_POINT := new COMPETITOR_STATS;
      Tmp_StatsString : Common.Unbounded_String.Unbounded_String := Common.Unbounded_String.Null_Unbounded_String;
      Tmp_CompLocation : access STRING;

      Tmp_BestLapTime : FLOAT;
      Tmp_BestLapNum : INTEGER;
      Tmp_BestLapCompetitor : INTEGER;
      Tmp_BestSectorTimes : FLOAT_ARRAY(1..3);
      Tmp_BestSectorCompetitors : INTEGER_ARRAY(1..3);
      Tmp_BestSectorLaps : INTEGER_ARRAY(1..3);

      HighestCompletedLap : INTEGER := -1;
      CompetitorID_InClassific : INTEGER_ARRAY_POINT;
      LappedCompetitors_ID : INTEGER_ARRAY_POINT;
      LappedCompetitors_CurrentLap : INTEGER_ARRAY_POINT;
   begin
      CompetitionHandler.WaitReady;
      Ada.Text_IO.Put_Line("A TV is really asking");
      Tmp_StatsString := Common.Unbounded_String.To_Unbounded_String
        ("<?xml version=""1.0""?>" &
         "<competitionStatus time=""" & FLOAT'IMAGE(TimeInstant) & """><competitors>");
      for Index in arrayComputer'RANGE loop
         Ada.Text_IO.Put_Line("Asking stat for pc " & INTEGER'IMAGE(Index));
         CompetitionComputer.Get_StatsByTime(Competitor_ID => OnboardComputer.Get_ID(arrayComputer(Index)),
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
         if(Tmp_Stats.Lap-1 > HighestCompletedLap ) then
            HighestCompletedLap := Tmp_Stats.Lap-1;
         end if;

      end loop;

      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String("</competitors>");

      --Retrieving best performances
      CompetitionComputer.Get_BestLap(TimeInstant,
                        LapTime       => Tmp_BestLapTime,
                        LapNum        => Tmp_BestLapNum,
                        Competitor_ID => Tmp_BestLapCompetitor);

      CompetitionComputer.Get_BestSectorTimes(TimeInstant,
                                Times          => Tmp_BestSectorTimes,
                                Competitor_IDs => Tmp_BestSectorCompetitors,
                                Laps => Tmp_BestSectorLaps);

      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
        ("<bestTimes>" &
         "<lap num=""" & Common.IntegerToString(Tmp_BestLapNum) & """></lap>" &
         "<time>" & FLOAT'IMAGE(Tmp_BestLapTime) & "</time>" & --TODO perform a better conversion to string
         "<competitorId>" & Common.IntegerToString(Tmp_BestLapCompetitor) & "</competitorId>" &
         "<sectors>"
        );

      for i in 1..3 loop
         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
           ("<sector num=""" & Common.IntegerToString(i) & """>" &
            "<time>" & FLOAT'IMAGE(Tmp_BestSectorTimes(i)) & "</time>" &
            "<competitorId>" & Common.IntegerToString(Tmp_BestSectorCompetitors(i)) & "</competitorId>" &
            "<lap>" & Common.IntegerToString(Tmp_BestSectorLaps(i)) & "</lap>" &
            "</sector>"
           );
      end loop;


      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
        ("</sectors>" &
         "</bestTimes>"
        );

      if(HighestCompletedLap /= -1) then

         CompetitionComputer.Get_LapClassific(HighestCompletedLap,
                                TimeInstant,
                                CompetitorID_InClassific,
                                ClassificationTimes,
                                LappedCompetitors_ID,
                                LappedCompetitors_CurrentLap);

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
           ("<classification>");

         for Index in 1..CompetitorID_InClassific.all'LENGTH loop

            Ada.Text_IO.Put_Line("Creating classific");
            Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
              ("<competitor id=""" & Common.IntegerToString(CompetitorID_InClassific(Index)) & """>" &
               "<lap>" & Common.IntegerToString(HighestCompletedLap) & "</lap>" &
               "</competitor>");
         end loop;

         if(LappedCompetitors_ID /= null) then
            for Index in 1..LappedCompetitors_ID.all'LENGTH loop
               Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
                 ("<competitor id=""" & Common.IntegerToString(LappedCompetitors_ID(Index)) & """>" &
                  "<lap>" & Common.IntegerToString(LappedCompetitors_CurrentLap(Index)) & "</lap>" &
                  "</competitor>");
            end loop;
         end if;


         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
           ("</classification>");

      end if;

      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
        ("</competitionStatus>");

      XMLInfo := Tmp_StatsString;

   end Get_CompetitionInfo;


end Competition_Monitor;
