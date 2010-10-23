with System;
with Ada.Text_IO;

with Ada.Strings.Unbounded;

with Common;
use Common;

with Competition_Computer;
use Competition_Computer;

package body Competition_Monitor is

   CompetitionHandler : StartStopHandler_Point := new StartStopHandler;
   CompetitorQty : Integer;
   Laps : Integer;
   IsConfigured : Boolean := false;

   type Onboard_Computer_List is Array (Positive range <>) of Competitor_Computer.COMPUTER_Point;
   type Onboard_Computer_List_Point is access Onboard_Computer_List;

   Onboard_Computers : Onboard_Computer_List_Point;

   function Init( CompetitorQty_In : Integer;
                 Laps_In : Integer) return STARTSTOPHANDLER_Point is

   begin

      CompetitorQty := CompetitorQty_In;
      Laps := Laps_In;
      Onboard_Computers := new Onboard_Computer_List(1..CompetitorQty);
      CompetitionHandler.Set_ExpectedBoxes(CompetitorQty);
      IsConfigured := true;

      return CompetitionHandler;
   end Init;

   protected body StartStopHandler is

      -- This method's inoked remotely (through "Ready" defined below) by the boxes to notify the competition system
      --+ that they're ready to start
      procedure Ready ( CompetitorID : in Integer) is
      begin

         ExpectedBoxes := ExpectedBoxes - 1;
	Ada.Text_IO.Put_Line(Integer'IMAGE(ExpectedBoxes) & " expected boxes");
      end Ready;

      --By invoking this method, the Competition will know when to start the competitors
      entry WaitReady when ExpectedBoxes = 0 is
      begin
         null;
      end WaitReady;

      procedure Set_ExpectedBoxes( CompetitorQty : Integer) is
      begin
         ExpectedBoxes := CompetitorQty;
      end Set_ExpectedBoxes;

   end StartStopHandler;

   function Ready(CompetitorID : Integer) return Boolean is
   begin
      --Verify that the monitor is initialised and that the competitor's
      --+ onboard computer is added (everything should already be
      --+ fine automatically once the box invokes this method, but
      --+ just for bug tracing we inserted this control)
      if( Onboard_Computers(Integer(CompetitorID)) /= null and  IsConfigured = true) then
         CompetitionHandler.Ready(Integer(CompetitorID));
         return true;
      end if;
      return false;
   end Ready;

   procedure Set_Simulation_Speed( Simulation_Speed_In : Float ) is
   begin
      Common.Simulation_Speed := Simulation_Speed_In;
   end Set_Simulation_Speed;

   procedure Add_Onboard_Computer(Computer_In : Competitor_Computer.COMPUTER_Point;
                                  Competitor_ID_In : Integer) is
   begin
      Onboard_Computers(Competitor_ID_In):= Computer_In;
   end Add_Onboard_Computer;

   procedure Get_CompetitorInfo(Lap : Integer;
                                Sector : Integer ;
                                Id : Integer;
                                Time : out Float;
                                Metres : out Float;
                                UpdString : out Unbounded_String.Unbounded_String) is
      ComputerIndex : Integer := 1;
   begin
      while Competitor_Computer.Get_Id(Onboard_Computers(ComputerIndex)) /= id loop
         ComputerIndex := ComputerIndex + 1;
      end loop;

      Competitor_Computer.Get_BoxInfo(Onboard_Computers(ComputerIndex),
                                  lap,
                                  sector,
                                  updString,
                                  time,
                                  metres);

   end Get_CompetitorInfo;

   --Given 2 Float Arrays with times e IDs of the competitors in classific, the function creates
   --+ 1 Array with the firs Array + the elements of the second one whose id is not in the first one.
   procedure Merge(IdArray1 : Integer_Array_Point;
		   TimeArray1 : Float_Array_Point;
		   IdArray2 : Integer_Array_Point;
		   TimeArray2 : Float_Array_Point;
		   IdArrayOut : out Integer_Array_Point;
                   TimeArrayOut : out Float_Array_Point) is

      MergedArraySize : Integer := 0;
      Copy : Boolean := false;

   begin
      if(IdArray1 /= null) then
         for Index in 1..IdArray1.all'LENGTH loop
            MergedArraySize := MergedArraySize + 1;
         end loop;
      end if;

      if(IdArray2 /= null) then
         for Index in 1..IdArray2.all'LENGTH loop
            Copy := TRUE;
            for Indez in 1..IdArray1.all'LENGTH loop

               if(IdArray1.all(Indez) = IdArray2.all(Index)) then
                  Copy := FALSE;
                  Ada.Text_IO.Put_Line("Copy false");
                  exit;
               end if;
            end loop;
            if(Copy = TRUE) then
               MergedArraySize := MergedArraySize + 1;
            else
               IdArray2.all(Index) := -1;
            end if;
         end loop;
      end if;

      IdArrayOut := new Integer_Array(1..MergedArraySize);
      TimeArrayOut := new Float_Array(1..MergedArraySize);

      if(IdArray1 /= null) then

         for Index in 1..IdArray1.all'LENGTH loop
            IdArrayOut.all(Index) := IdArray1.all(Index);
            TimeArrayOut.all(Index) := TimeArray1.all(Index);
         end loop;
      end if;


      if(IdArray1 /= null and IdArray2 /= null) then
         declare
            MergedArray_IndexCount : Integer := 0;
         begin
            for Index in 1..IdArray2.all'LENGTH loop
               if(IdArray2.all(Index) /= -1) then
                  IdArrayOut.all(IdArray1.all'LENGTH+1+MergedArray_IndexCount) := IdArray2.all(Index);
                  TimeArrayOut.all(IdArray1.all'LENGTH+1+MergedArray_IndexCount) := TimeArray2.all(Index);
                  MergedArray_IndexCount := MergedArray_IndexCount + 1;
               end if;
            end loop;
         end;
      elsif(IdArray1 = null and IdArray2 /= null) then

         for Index in 1..MergedArraySize loop
            if(IdArray2.all(Index) /= -1) then
               IdArrayOut.all(Index) := IdArray2.all(Index);
               TimeArrayOut.all(Index) := TimeArray2.all(Index);
            end if;
         end loop;
      end if;

   end Merge;

   function Contains(ID : Integer;
                       IdArray : Integer_Array_Point) return Boolean is
   begin
      if(IdArray /= null) then
         for Index in IdArray.all'RANGE loop
	    if(IdArray.all(Index) = ID) then
		return TRUE;
	    end if;
	end loop;
      end if;
      return FALSE;
   end Contains;

   procedure Get_CompetitionInfo( TimeInstant : Float;
                                 ClassificationTimes : out Float_Array_Point;
                                 XMLInfo : out Unbounded_String.Unbounded_String) is
      Tmp_Stats : COMPETITOR_STATS_Point := new COMPETITOR_STATS;
      Tmp_StatsString : Common.Unbounded_String.Unbounded_String := Common.Unbounded_String.Null_Unbounded_String;
      Tmp_CompLocation : access STRING;

      Tmp_BestLapTime : Float;
      Tmp_BestLapNum : Integer;
      Tmp_BestLapCompetitor : Integer;
      Tmp_BestSectorTimes : Float_Array(1..3);
      Tmp_BestSectorCompetitors : Integer_Array(1..3);
      Tmp_BestSectorLaps : Integer_Array(1..3);

      HighestCompletedLap : Integer := -1;
      CompetitorIDs_WithTimes : Integer_Array_Point;
      CompetitorID_InClassific : Integer_Array_Point;
      Times_InClassific : Float_Array_Point;
      CompetitorIDs_PreviousClassific : Integer_Array_Point;
      Times_PreviousClassific : Float_Array_Point;
      LappedCompetitors_ID : Integer_Array_Point;
      LappedCompetitors_CurrentLap : Integer_Array_Point;
   begin
      CompetitionHandler.WaitReady;

      -------------------------
      --Calculate race status--
      -------------------------
      -- The race status is the position of each competitor at the given time instant
      Tmp_StatsString := Common.Unbounded_String.To_Unbounded_String
        ("<?xml version=""1.0""?>" &
         "<competitionStatus time=""" & Float'IMAGE(TimeInstant) & """><competitors>");
      for Index in Onboard_Computers'RANGE loop

         Competition_Computer.Get_StatsByTime(Competitor_ID => Competitor_Computer.Get_ID(Onboard_Computers(Index)),
                               Time        => TimeInstant,
                               Stats_In    => Tmp_Stats);

         -- In this case the competitor is arriving to the checkPoint
         if( Tmp_Stats.Time < TimeInstant ) then
            Tmp_CompLocation := new STRING(1..6);
            Tmp_CompLocation.all := "passed";
            --In this case the competitor is exaclty on the checkPoint
         elsif( Tmp_Stats.Time = TimeInstant) then
            Tmp_CompLocation := new STRING(1..4);
            Tmp_CompLocation.all := "over";
            -- Otherwise the competitor has just left the checkPoint and he's
            --+ not arrived to the following one yet
         else
            Tmp_CompLocation := new STRING(1..8);
            Tmp_CompLocation.all := "arriving";
         end if;

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
           ("<competitor end=""" & Boolean'IMAGE(Competition_Computer.Has_CompetitorFinished(Competitor_Computer.Get_ID(Onboard_Computers(Index)),TimeInstant)) & """");

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String(
            " retired=""" & Boolean'IMAGE(Competition_Computer.Is_CompetitorOut(Competitor_Computer.Get_ID(Onboard_Computers(Index)),TimeInstant)) & """");

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String(
            " id=""" & Common.Integer_To_String(Competitor_Computer.Get_Id(Onboard_Computers(Index))) & """>");

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String(
            "<checkpoint pitstop=""" & Boolean'IMAGE(Tmp_Stats.IsPitStop) & """ compPosition=""" & Tmp_CompLocation.all & """ >" & Common.Integer_To_String(Tmp_Stats.CheckPoint) & "</checkpoint>" );

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String(
            "<lap>" & Common.Integer_To_String(Tmp_Stats.Lap) & "</lap>" &
            "<sector>" & Common.Integer_To_String(Tmp_Stats.Sector) & "</sector>" &
            "</competitor>");

         declare
	  HighestCompletedLapThisCompetitor : Integer;
	 begin
	  if(Tmp_CompLocation.all = "arriving" and Tmp_Stats.CheckPoint = 1) then
	    HighestCompletedLapThisCompetitor := Tmp_Stats.Lap-2;
	  else
	    HighestCompletedLapThisCompetitor := Tmp_Stats.Lap-1;
	  end if;
	    if(HighestCompletedLapThisCompetitor > HighestCompletedLap) then
	      HighestCompletedLap := HighestCompletedLapThisCompetitor;
	    end if;
	 end;

         --If the competition is finished for a competitor, get the classific of the last lap
         if(Competition_Computer.Has_CompetitorFinished(Competitor_Computer.Get_ID(Onboard_Computers(Index)),TimeInstant) = TRUE and
              Competition_Computer.Is_CompetitorOut(Competitor_Computer.Get_ID(Onboard_Computers(Index)),TimeInstant) = FALSE) then
            HighestCompletedLap := Tmp_Stats.Lap;
         end if;

      end loop;

      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String("</competitors>");

      ----------------------------
      --Retrie best performances--
      ----------------------------
      Competition_Computer.Get_BestLap(TimeInstant,
                        LapTime       => Tmp_BestLapTime,
                        LapNum        => Tmp_BestLapNum,
                        Competitor_ID => Tmp_BestLapCompetitor);

      Competition_Computer.Get_BestSectorTimes(TimeInstant,
                                Times          => Tmp_BestSectorTimes,
                                Competitor_IDs => Tmp_BestSectorCompetitors,
                                Laps => Tmp_BestSectorLaps);

      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
        ("<bestTimes>" &
         "<lap num=""" & Common.Integer_To_String(Tmp_BestLapNum) & """></lap>" &
         "<time>" & Float'IMAGE(Tmp_BestLapTime) & "</time>" &
         "<competitorId>" & Common.Integer_To_String(Tmp_BestLapCompetitor) & "</competitorId>" &
         "<sectors>"
        );

      for i in 1..3 loop
         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
           ("<sector num=""" & Common.Integer_To_String(i) & """>" &
            "<time>" & Float'IMAGE(Tmp_BestSectorTimes(i)) & "</time>" &
            "<competitorId>" & Common.Integer_To_String(Tmp_BestSectorCompetitors(i)) & "</competitorId>" &
            "<lap>" & Common.Integer_To_String(Tmp_BestSectorLaps(i)) & "</lap>" &
            "</sector>"
           );
      end loop;


      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
        ("</sectors>" &
         "</bestTimes>"
        );

      ---------------------------
      --Calculate the classific--
      ---------------------------
      if(HighestCompletedLap /= -1) then

         Competition_Computer.Get_Lap_Classification(HighestCompletedLap,
                                                     TimeInstant,
                                                     CompetitorID_InClassific,
                                                     Times_InClassific,
                                                     CompetitorIDs_PreviousClassific,
                                                     Times_PreviousClassific,
                                                     LappedCompetitors_ID,
                                                     LappedCompetitors_CurrentLap);

	 Merge(CompetitorID_InClassific,Times_InClassific,
	       CompetitorIDs_PreviousClassific,Times_PreviousClassific,
	       CompetitorIDs_WithTimes,ClassificationTimes);

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
           ("<classification>");

         for Index in 1..CompetitorID_InClassific.all'LENGTH loop


            Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
              ("<competitor id=""" & Common.Integer_To_String(CompetitorIDs_WithTimes(Index)) & """>" &
               "<lap>" & Common.Integer_To_String(HighestCompletedLap) & "</lap>" &
               "</competitor>");

         end loop;

         if(HighestCompletedLap /= 0) then
	  for Index in CompetitorID_InClassific.all'LENGTH+1..CompetitorIDs_WithTimes.all'LENGTH loop


	      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
		("<competitor id=""" & Common.Integer_To_String(CompetitorIDs_WithTimes(Index)) & """>" &
		"<lap>" & Common.Integer_To_String(HighestCompletedLap-1) & "</lap>" &
		"</competitor>");

	  end loop;
	 end if;

         if(LappedCompetitors_ID /= null) then
            for Index in 1..LappedCompetitors_ID.all'LENGTH loop
		if(Contains(LappedCompetitors_ID(Index),CompetitorIDs_WithTimes) = FALSE) then
		  Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
		    ("<competitor id=""" & Common.Integer_To_String(LappedCompetitors_ID(Index)) & """>" &
		     "<lap>" & Common.Integer_To_String(LappedCompetitors_CurrentLap(Index)) & "</lap>" &
		     "</competitor>");
		end if;
            end loop;
         end if;


         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
           ("</classification>");

      end if;

      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
        ("</competitionStatus>");

      --XMLInfo will contain the XML string describing the competition state
      XMLInfo := Tmp_StatsString;

   end Get_CompetitionInfo;

   procedure Get_CompetitionConfiguration( XmlInfo : out Unbounded_String.Unbounded_String;
                                          CircuitLength : out Float) is
      Laps_Out : Integer;
      Competitors_Out : Integer;
      Name_Out : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      CircuitLength_Out : Float;

      XMLString : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin
      Competition_Computer.Get_StaticInformation(Laps_Out,
                                                Competitors_Out,
                                                Name_Out,
                                                CircuitLength_Out);

      XMLString := Unbounded_String.To_Unbounded_String
        ("<?xml version=""1.0"" ?>" &
         "<competitionConfiguration>" &
         "<laps>" & Common.Integer_To_String(Laps_Out) & "</laps>" &
         "<competitors>" & Common.Integer_To_String(Competitors_Out) & "</competitors>" &
         "<name>" & Unbounded_String.To_String(Name_Out) & "</name>" &
         "</competitionConfiguration>");

      XmlInfo := XMLString;
      CircuitLength := CircuitLength_Out;
   end Get_CompetitionConfiguration;

   function Get_CompetitorConfiguration( Id : Integer ) return Unbounded_String.Unbounded_String is
      Name : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Surname : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Team : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

      XMLString : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin
      Competition_Computer.Get_CompetitorMinInfo(Id,
                                                Name,
                                                Surname,
                                                Team);

      XMLString := Unbounded_String.To_Unbounded_String
        ("<?xml version=""1.0"" ?>" &
         "<competitorConfiguration id=""" & Common.Integer_To_String(Id) & """ >" &
         "<name>") &
      Name &
      Unbounded_String.To_Unbounded_String("</name>" &
                                           "<surname>") &
      Surname &
      Unbounded_String.To_Unbounded_String("</surname>" &
                                           "<team>") &
      Team &
      Unbounded_String.To_Unbounded_String("</team>" &
                                           "</competitorConfiguration>");

      return XMLString;
   end Get_CompetitorConfiguration;

   --This method's used by to approximately know which instant the competition reached
   function Get_Latest_Time_Instant return Float is
   begin
   	return Competition_Computer.Get_Latest_Time_Instant;
   end Get_Latest_Time_Instant;

end Competition_Monitor;
