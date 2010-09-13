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
	Ada.Text_IO.Put_Line(INTEGER'IMAGE(ExpectedBoxes) & " expected boxes");
      end Ready;
      --TODO: maybe not necessary
      procedure Stop( CompetitorID : in INTEGER) is
      begin
         null;
      end Stop;

      --Through this method the competition knows when to start the competitors
      entry WaitReady when ExpectedBoxes = 0 is
      begin
         --Ada.Text_IO.Put_Line("READY!!!!!");
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

   procedure Get_CompetitorInfo(lap : INTEGER; sector : INTEGER ; id : INTEGER; time : out FLOAT; metres : out FLOAT; updString : out Unbounded_String.Unbounded_String) is
      ComputerIndex : INTEGER := 1;
   begin
      while OnBoardComputer.Get_Id(arrayComputer(ComputerIndex)) /= id loop
         ComputerIndex := ComputerIndex + 1;
      end loop;

      OnboardCOmputer.Get_BoxInfo(arrayComputer(ComputerIndex),
                                  lap,
                                  sector,
                                  updString,
                                  time,
                                  metres);

   end Get_CompetitorInfo;

   --Given 2 float arrays with times e ids of competitors in classific, the function creates
   --+ 1 array with the firs array + the elements of the second one whose id is not itn the first one.
   procedure Merge(IdArray1 : INTEGER_ARRAY_POINT;
		   TimeArray1 : FLOAT_ARRAY_POINT; 
		   IdArray2 : INTEGER_ARRAY_POINT;
		   TimeArray2 : FLOAT_ARRAY_POINT;
		   IdArrayOut : out INTEGER_ARRAY_POINT;
		   TimeArrayOut : out FLOAT_ARRAY_POINT) is
    MergedArraySize : INTEGER := 0;
    Copy : BOOLEAN := false;
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

   IdArrayOut := new INTEGER_ARRAY(1..MergedArraySize);
   TimeArrayOut := new FLOAT_ARRAY(1..MergedArraySize);
   
   if(IdArray1 /= null) then

    for Index in 1..IdArray1.all'LENGTH loop

      IdArrayOut.all(Index) := IdArray1.all(Index);
      TimeArrayOut.all(Index) := TimeArray1.all(Index);
    end loop;
   end if;
   
   
   if(IdArray1 /= null) then

	for Index in IdArray1.all'LENGTH+1..MergedArraySize loop
	  if(IdArray2.all(Index-IdArray1.all'LENGTH) /= -1) then
	    IdArrayOut.all(Index) := IdArray2.all(Index-IdArray1.all'LENGTH);
	    TimeArrayOut.all(Index) := TimeArray2.all(Index-IdArray1.all'LENGTH);
	  end if;
	end loop;
   else

	for Index in 1..MergedArraySize loop
	  if(IdArray2.all(Index) /= -1) then
	    IdArrayOut.all(Index) := IdArray2.all(Index);
	    TimeArrayOut.all(Index) := TimeArray2.all(Index);
	  end if;
	end loop;
   end if;
   
   end Merge;
   
   function Is_Present(ID : INTEGER;
		       IdArray : INTEGER_ARRAY_POINT) return BOOLEAN is
   begin
      if(IdArray /= null) then
	for Index in IdArray.all'RANGE loop
	    if(IdArray.all(Index) = ID) then
		return TRUE;
	    end if;
	end loop;
      end if;
      return FALSE;
   end Is_Present;

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
      CompetitorIDs_WithTimes : INTEGER_ARRAY_POINT;
      CompetitorID_InClassific : INTEGER_ARRAY_POINT;
      Times_InClassific : FLOAT_ARRAY_POINT;
      CompetitorIDs_PreviousClassific : INTEGER_ARRAY_POINT;
      Times_PreviousClassific : FLOAT_ARRAY_POINT;
      LappedCompetitors_ID : INTEGER_ARRAY_POINT;
      LappedCompetitors_CurrentLap : INTEGER_ARRAY_POINT;
   begin
      CompetitionHandler.WaitReady;

      Tmp_StatsString := Common.Unbounded_String.To_Unbounded_String
        ("<?xml version=""1.0""?>" &
         "<competitionStatus time=""" & FLOAT'IMAGE(TimeInstant) & """><competitors>");
      for Index in arrayComputer'RANGE loop

         CompetitionComputer.Get_StatsByTime(Competitor_ID => OnboardComputer.Get_ID(arrayComputer(Index)),
                               Time        => TimeInstant,
                               Stats_In    => Tmp_Stats);

         -- In this case the competitor is arriving to the checkpoint
         if( Tmp_Stats.Time < TimeInstant ) then
            Tmp_CompLocation := new STRING(1..6);
            Tmp_CompLocation.all := "passed";
            --In this case the competitor is exaclty on the checkpoint
         elsif( Tmp_Stats.Time = TimeInstant) then
            Tmp_CompLocation := new STRING(1..4);
            Tmp_CompLocation.all := "over";
            -- Otherwise the competitor has just left the checkpoint and he's
            --+ not arrived to the following one yet
         else
            Tmp_CompLocation := new STRING(1..8);
            Tmp_CompLocation.all := "arriving";
         end if;

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
           ("<competitor end=""" & BOOLEAN'IMAGE(CompetitionComputer.Has_CompetitorFinished(OnboardComputer.Get_ID(arrayComputer(Index)),TimeInstant)) & """");

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String(  
            " retired=""" & BOOLEAN'IMAGE(CompetitionComputer.Is_CompetitorOut(OnboardComputer.Get_ID(arrayComputer(Index)),TimeInstant)) & """");

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String(
            " id=""" & Common.IntegerToString(OnboardComputer.Get_Id(arrayComputer(Index))) & """>");

         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String(
            "<checkpoint pitstop=""" & BOOLEAN'IMAGE(Tmp_Stats.IsPitStop) & """ compPosition=""" & Tmp_CompLocation.all & """ >" & Common.IntegerToString(Tmp_Stats.Checkpoint) & "</checkpoint>" );

Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String(   
            "<lap>" & Common.IntegerToString(Tmp_Stats.Lap) & "</lap>" &
            "<sector>" & Common.IntegerToString(Tmp_Stats.Sector) & "</sector>" &
            "</competitor>");


         
         declare
	  HighestCompletedLapThisCompetitor : INTEGER;
	 begin
	  if(Tmp_CompLocation.all = "arriving" and Tmp_Stats.Checkpoint = 1) then
	    HighestCompletedLapThisCompetitor := Tmp_Stats.Lap-2;
	  else
	    HighestCompletedLapThisCompetitor := Tmp_Stats.Lap-1;
	  end if;
	    if(HighestCompletedLapThisCompetitor > HighestCompletedLap) then
	      HighestCompletedLap := HighestCompletedLapThisCompetitor;
	    end if;
	 end;

         --If the competition is finished for a competitor, get the classific of the last lap
         if(CompetitionComputer.Has_CompetitorFinished(OnboardComputer.Get_ID(arrayComputer(Index)),TimeInstant) = TRUE and
              CompetitionComputer.Is_CompetitorOut(OnboardComputer.Get_ID(arrayComputer(Index)),TimeInstant) = FALSE) then
            HighestCompletedLap := Tmp_Stats.Lap;
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
              ("<competitor id=""" & Common.IntegerToString(CompetitorIDs_WithTimes(Index)) & """>" &
               "<lap>" & Common.IntegerToString(HighestCompletedLap) & "</lap>" &
               "</competitor>");
             
         end loop;
         
         if(HighestCompletedLap /= 0) then
	  for Index in CompetitorID_InClassific.all'LENGTH+1..CompetitorIDs_WithTimes.all'LENGTH loop


	      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
		("<competitor id=""" & Common.IntegerToString(CompetitorIDs_WithTimes(Index)) & """>" &
		"<lap>" & Common.IntegerToString(HighestCompletedLap-1) & "</lap>" &
		"</competitor>");
	      
	  end loop;
	 end if;

         if(LappedCompetitors_ID /= null) then
            for Index in 1..LappedCompetitors_ID.all'LENGTH loop
		if(Is_Present(LappedCompetitors_ID(Index),CompetitorIDs_WithTimes) = FALSE) then
		  Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
		    ("<competitor id=""" & Common.IntegerToString(LappedCompetitors_ID(Index)) & """>" &
		     "<lap>" & Common.IntegerToString(LappedCompetitors_CurrentLap(Index)) & "</lap>" &
		     "</competitor>");
		end if;
            end loop;
         end if;


         Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
           ("</classification>");

      end if;

      Tmp_StatsString := Tmp_StatsString & Common.Unbounded_String.To_Unbounded_String
        ("</competitionStatus>");

      XMLInfo := Tmp_StatsString;

   end Get_CompetitionInfo;

   procedure Get_CompetitionConfiguration( XmlInfo : out Unbounded_String.Unbounded_String;
                                          CircuitLength : out FLOAT) is
      Laps_Out : INTEGER;
      Competitors_Out : INTEGER;
      Name_Out : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      CircuitLength_Out : FLOAT;

      XMLString : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin
      CompetitionComputer.Get_StaticInformation(Laps_Out,
                                                Competitors_Out,
                                                Name_Out,
                                                CircuitLength_Out);

      XMLString := Unbounded_String.To_Unbounded_String
        ("<?xml version=""1.0"" ?>" &
         "<competitionConfiguration>" &
         "<laps>" & Common.IntegerToString(Laps_Out) & "</laps>" &
         "<competitors>" & Common.IntegerToString(Competitors_Out) & "</competitors>" &
         "<name>" & Unbounded_String.To_String(Name_Out) & "</name>" &
         "</competitionConfiguration>");

      XmlInfo := XMLString;
      CircuitLength := CircuitLength_Out;
   end Get_CompetitionConfiguration;

   function Get_CompetitorConfiguration( Id : INTEGER ) return Unbounded_String.Unbounded_String is
      Name : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Surname : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Team : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

      XMLString : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin
      CompetitionComputer.Get_CompetitorMinInfo(Id,
                                                Name,
                                                Surname,
                                                Team);

      XMLString := Unbounded_String.To_Unbounded_String
        ("<?xml version=""1.0"" ?>" &
         "<competitorConfiguration id=""" & Common.IntegerToString(Id) & """ >" &
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
end Competition_Monitor;
