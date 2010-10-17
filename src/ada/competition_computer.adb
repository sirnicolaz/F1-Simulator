with Ada.Text_IO;
use Ada.Text_IO;

with Classification_Handler;
use Classification_Handler;

package body Competition_Computer is

   protected type SYNCH_COMPETITOR_MIN_INFO is
      entry Get_Info(Name : out Unbounded_String.Unbounded_String;
                     Surname : out Unbounded_String.Unbounded_String;
                     Team : out Unbounded_String.Unbounded_String);
      entry Initialize(Name : Unbounded_String.Unbounded_String;
                           Surname : Unbounded_String.Unbounded_String;
                           Team : Unbounded_String.Unbounded_String);
   private
      Initialized : BOOLEAN := FALSE;
      Info : COMPETITOR_MIN_INFO;
   end SYNCH_COMPETITOR_MIN_INFO;

   protected body SYNCH_COMPETITOR_MIN_INFO is
      entry Get_Info(Name : out Unbounded_String.Unbounded_String;
                     Surname : out Unbounded_String.Unbounded_String;
                     Team : out Unbounded_String.Unbounded_String) when Initialized = true is
      begin
         Name := Info.Name;
         SurName := Info.SurName;
         Team := Info.Team;
      end Get_Info;

      entry Initialize(Name : Unbounded_String.Unbounded_String;
                       Surname : Unbounded_String.Unbounded_String;
                       Team : Unbounded_String.Unbounded_String) when Initialized = false is
      begin
         Info.Name := Name;
         Info.SurName := SurName;
         Info.Team := Team;
         Initialized := true;
      end Initialize;

   end SYNCH_COMPETITOR_MIN_INFO;

   type SYNCH_COMPETITOR_MIN_INFO_POINT is access SYNCH_COMPETITOR_MIN_INFO;

   type COMPETITOR_MIN_INFO_ARRAY is array(POSITIVE range <>) of SYNCH_COMPETITOR_MIN_INFO_POINT;
   type COMPETITOR_MIN_INFO_ARRAY_POINT is access COMPETITOR_MIN_INFO_ARRAY;

   protected type SYNCH_STATIC_INFORMATION is
      entry Get_CompetitionStaticInfo(Laps_Out : out INTEGER;
                                      Competitors_Out : out INTEGER;
                                      Name_Out : out Unbounded_String.Unbounded_String;
                                      CircuitLength_Out : out FLOAT);

      entry Initialize(Laps_In : INTEGER;
                       Competitors_In : INTEGER;
                       Name_In : Unbounded_String.Unbounded_String;
                       CircuitLength_In : FLOAT);
   private
      Initialized : BOOLEAN := FALSE;
      Laps : INTEGER;
      Competitors : INTEGER;
      Name : Unbounded_String.Unbounded_String;
      CircuitLength : FLOAT;
   end SYNCH_STATIC_INFORMATION;

   protected body SYNCH_STATIC_INFORMATION is

      entry Get_CompetitionStaticInfo(Laps_Out : out INTEGER;
                                      Competitors_Out : out INTEGER;
                                      Name_Out : out Unbounded_String.Unbounded_String;
                                      CircuitLength_Out : out FLOAT) when Initialized = true is
      begin

         Laps_Out := Laps;
         Competitors_Out := Competitors;
         Name_Out := Name;
         CircuitLength_Out := CircuitLength;

      end Get_CompetitionStaticInfo;

      entry Initialize(Laps_In : INTEGER;
                       Competitors_In : INTEGER;
                       Name_In : Unbounded_String.Unbounded_String;
                       CircuitLength_In : FLOAT) when Initialized = false is
      begin
         Laps := Laps_In;
         Competitors := Competitors_In;
         Name := Name_In;
         CircuitLength := CircuitLength_In;
         Initialized := true;
      end Initialize;

   end SYNCH_STATIC_INFORMATION;

   type SYNCH_STATIC_INFORMATION_POINT is access SYNCH_STATIC_INFORMATION;

   --Singleton
   Competitor_Statistics : STATISTIC_COLLECTION_POINT;
   StaticInformation : SYNCH_STATIC_INFORMATION_POINT := new SYNCH_STATIC_INFORMATION;
   CompetitorMinInfo_Collection : COMPETITOR_MIN_INFO_ARRAY_POINT;

   Checkpoints : INTEGER;

   procedure Initialize_Static_Information(Laps_In : INTEGER;
                                           Competitors_In : INTEGER;
                                           Name_In : Unbounded_String.Unbounded_String;
                                           CircuitLength_In : FLOAT) is
   begin

      StaticInformation.Initialize(Laps_In,
                                   Competitors_In,
                                   Name_In,
                                   CircuitLength_In);

      CompetitorMinInfo_Collection := new COMPETITOR_MIN_INFO_ARRAY(1..Competitors_In);
      for Index in 1..Competitors_In loop
         CompetitorMinInfo_Collection.all(Index) := new SYNCH_COMPETITOR_MIN_INFO;
      end loop;

   end Initialize_Static_Information;

   procedure Get_StaticInformation(Laps_Out : out INTEGER;
                                   Competitors_Out : out INTEGER;
                                   Name_Out : out Unbounded_String.Unbounded_String;
                                   CircuitLength_Out : out FLOAT) is
   begin
      StaticInformation.Get_CompetitionStaticInfo(Laps_Out,
                                                  Competitors_Out,
                                                  Name_Out,
                                                  CircuitLength_Out);
   end Get_StaticInformation;


   procedure Add_CompetitorMinInfo(Id : INTEGER;
                                   Name : Unbounded_String.Unbounded_String;
                                   Surname : Unbounded_String.Unbounded_String;
                                   Team : Unbounded_String.Unbounded_String) is
   begin
      CompetitorMinInfo_Collection.all(Id).Initialize(Name,
                                                      Surname,
                                                      Team);
   end Add_CompetitorMinInfo;

   procedure Get_CompetitorMinInfo(Id : INTEGER;
                                   Name : out Unbounded_String.Unbounded_String;
                                   Surname : out Unbounded_String.Unbounded_String;
                                   Team : out Unbounded_String.Unbounded_String) is
   begin
      if(CompetitorMinInfo_Collection /= null) then
         CompetitorMinInfo_Collection.all(Id).Get_Info(Name,
                                                       Surname,
                                                       Team);
      end if;
   end Get_CompetitorMinInfo;

   protected body SYNCH_COMPETITOR_STATS_HANDLER is

      entry Get_Time( Result : out FLOAT ) when Initialised = TRUE is
      begin
         Result := Statistic.Time;
      end Get_Time;

      entry Get_Checkpoint (Result : out INTEGER) when Initialised = TRUE is
      begin
         Result := Statistic.Checkpoint;
      end Get_Checkpoint;

      entry Get_Lap (Result : out INTEGER) when Initialised = TRUE is
      begin
         Result := Statistic.Lap;
      end Get_Lap;

      entry Get_Sector (Result : out INTEGER) when Initialised = TRUE is
      begin
         Result := Statistic.Sector;
      end Get_Sector;

      entry Get_BestLapNum (Result : out INTEGER) when Initialised = TRUE is
      begin
         Result := Statistic.BestLapNum;
      end Get_BestLapNum;

      entry Get_BestLapTime (Result : out FLOAT) when Initialised = TRUE is
      begin
         Result := Statistic.BestLapTime;
      end Get_BestLapTime;

      entry Get_BestSectorTime( SectorNum : INTEGER; Result : out FLOAT) when Initialised = TRUE is
      begin
         Result := Statistic.BestSectorTimes(SectorNum);
      end Get_BestSectorTime;

      entry Get_MaxSpeed (Result : out FLOAT) when Initialised = TRUE is
      begin
         Result := Statistic.Max_Speed;
      end Get_MaxSpeed;

      entry Get_IsLastCheckInSector (Result : out BOOLEAN) when Initialised = TRUE is
      begin
         Result := Statistic.LastCheckInSect;
      end Get_IsLastCheckInSector;

      entry Get_IsFirstCheckInSector (Result : out BOOLEAN) when Initialised = TRUE is
      begin
         Result := Statistic.FirstCheckInSect;
      end Get_IsFirstCheckInSector;

      entry Get_PathLength (Result : out FLOAT) when Initialised = TRUE is
      begin
         Result := Statistic.PathLength;
      end Get_PathLength;

      entry Get_GasLevel (Result : out FLOAT) when Initialised = TRUE is
      begin
         Result := Statistic.Gas_Level;
      end Get_GasLevel;

      entry Get_TyreUsury (Result : out PERCENTAGE) when Initialised = TRUE is
      begin
         Result := Statistic.Tyre_Usury;
      end Get_TyreUsury;

      entry Get_All( Result : out COMPETITOR_STATS) when Initialised = TRUE is
      begin
         Result := Statistic;
      end Get_All;

      entry Initialise(Stats_In : in COMPETITOR_STATS) when Initialised = FALSE is

      begin

         Statistic := Stats_In;
         Initialised := TRUE;
      end Initialise;

   end SYNCH_COMPETITOR_STATS_HANDLER;

   -- It sets the CompStats parameter with the statistics related to the given sector and lap
   procedure Get_StatsBySect(Competitor_ID : INTEGER;
                             Sector : INTEGER;
                             Lap : INTEGER;
                             Stats_In : out COMPETITOR_STATS_POINT) is
      Index : INTEGER := (Lap*Checkpoints)+1; -- laps start from 0, information are stored starting from 1
      Tmp_Sector : INTEGER;
      Tmp_Bool : BOOLEAN;
   begin

      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Sector(Tmp_Sector);
      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_IsLastCheckInSector(Tmp_Bool);

      loop
         Index := Index + 1;
         Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Sector(Tmp_Sector);
         Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_IsLastCheckInSector (Tmp_Bool);
         exit when Tmp_Sector = Sector and Tmp_Bool = TRUE;
      end loop;

      if( Stats_In = null ) then
        Stats_In := new COMPETITOR_STATS;
      end if;

      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_All(Stats_In.all);

   end Get_StatsBySect;

   function Has_CompetitorFinished(Competitor_ID : INTEGER;
                                   Time : FLOAT) return BOOLEAN is
      Temp_Time : FLOAT;
   begin
      if(Competitor_Statistics.all(Competitor_ID).Competition_Finished = TRUE) then

         Competitor_Statistics.all(Competitor_ID).Competitor_Info.all
           (Competitor_Statistics.all(Competitor_ID).Competitor_Info.all'LAST).Get_Time(Temp_Time);
         if(Temp_Time <= Time) then
            return TRUE;
         end if;
      end if;

      return FALSE;

   end Has_CompetitorFinished;

   function Is_CompetitorOut(Competitor_ID : INTEGER;
                             Time : FLOAT) return BOOLEAN is
   begin

      if(Competitor_Statistics.all(Competitor_ID).Retired_Time /= -1.0 and
           Competitor_Statistics.all(Competitor_ID).Retired_Time <= Time) then
         return TRUE;
      else
         return FALSE;
      end if;

   end Is_CompetitorOut;

   function Calculate_CloserTime(ReferenceTime : FLOAT;
                                 LeftTime : FLOAT;
                                 RightTime : FLOAT) return FLOAT is
   begin
      if( ReferenceTime - LeftTime < RightTime - ReferenceTime ) then
         return LeftTime;
      else
         return RightTime;
      end if;

   end Calculate_CloserTime;

   -- It return a statistic related to a certain time. If the statistic is not
   --+ initialised yet, the requesting task will wait on the resource Information
   --+ as long as it's been initialised
   procedure Get_StatsByTime(Competitor_ID : INTEGER;
                             Time : FLOAT;
                             Stats_In : out COMPETITOR_STATS_POINT) is

      Index : INTEGER := Competitor_Statistics.all(Competitor_ID).Last_Initialized_Index;
      Tmp_Time : FLOAT;
      ExitLoop : BOOLEAN := FALSE;
   begin


      if( Stats_In = null ) then
         Stats_In := new COMPETITOR_STATS;
      end if;


      --Verify whether the competitor is out the competition
      if(Is_CompetitorOut(Competitor_ID,Time) = TRUE) then

      --The competitor is out, so get the last information available
      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all
        ((Competitor_Statistics.all(Competitor_ID).Last_Lap * Checkpoints) +
           Competitor_Statistics.all(Competitor_ID).Last_Checkpoint).Get_All(Stats_In.all);

      else

         Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(Tmp_Time);

         if (Tmp_Time >= Time ) then
            Index := Index - 1;
            if(Index /= 0) then
               Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(Tmp_Time);
            end if;
            while Index > 1 and then Tmp_Time > Time loop
               Index := Index - 1;

               Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(Tmp_Time);
            end loop;

            declare
               LeftTime : FLOAT;
               RightTime : FLOAT;
               ChoosenIndex : INTEGER;
            begin
               if(Index /= 0) then
                  Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(LeftTime);
                  Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index+1).Get_Time(RightTime);

                  if(Calculate_CloserTime(Time,
                                          LeftTime,
                                          RightTime) = LeftTime) then
                     ChoosenIndex := Index;
                  else
                     CHoosenIndex := Index+1;
                  end if;
               else
                  ChoosenIndex := Index+1;
               end if;

               Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(CHoosenIndex).Get_All(Stats_In.all);

            end;
         else

            Index := Index + 1;
            if(Index > Competitor_Statistics.all(Competitor_ID).Competitor_Info.all'LENGTH) then
               Index := Index - 1;
            end if;
            Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(Tmp_Time);
            while Tmp_Time < Time and ExitLoop = false loop

               Index := Index + 1;
               --Handle the case when an information cronologically after the end of the competition
               --+ is asked
               if(Index > Competitor_Statistics.all(Competitor_ID).Competitor_Info.all'LENGTH) then
                  ExitLoop := true;
                  Index := Index - 1;
               else
                  Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(Tmp_Time);
               end if;
            end loop;

            declare
               LeftTime : FLOAT;
               RightTime : FLOAT;
               ChoosenIndex : INTEGER;
            begin
               Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index-1).Get_Time(LeftTime);
               Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(RightTime);

               if(Calculate_CloserTime(Time,
                                       LeftTime,
                                       RightTime) = LeftTime) then
                  ChoosenIndex := Index-1;
               else
                  CHoosenIndex := Index;
               end if;


               Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(ChoosenIndex).Get_All(Stats_In.all);

            end;
         end if;
      end if;

   end Get_StatsByTime;

   -- It sets the CompStats parameter with the statistics related to the given check-point and lap
   procedure Get_StatsByCheck(Competitor_ID : INTEGER;
                              Checkpoint : INTEGER;
                              Lap : INTEGER;
                              Stats_In : out COMPETITOR_STATS_POINT) is
   begin

      if( Stats_In = null ) then
        Stats_In := new COMPETITOR_STATS;
      end if;

      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all((Lap*Checkpoints)+Checkpoint).Get_All(Stats_In.all);
   end Get_StatsByCheck;

   --It Just initializes the Statistic_Collection with the right size
   procedure Initialize(Competitor_Qty : INTEGER;
                        Laps : INTEGER;
                        Checkpoints_In : INTEGER;
                        Name_In : Unbounded_String.Unbounded_String;
                        Circuit_Length : Float) is
      Tmp_Collection : STATISTIC_COLLECTION_POINT := new ALL_COMPETITOR_STAT_COLLECTION(1..Competitor_Qty);

   begin

      Initialize_Static_Information(Laps,
                                    Competitor_Qty,
                                    Name_In,
                                    Circuit_Length);

      Checkpoints := Checkpoints_In;

      for Index in Tmp_Collection'RANGE loop
         Tmp_Collection.all(Index) := new STATS_ARRAY_OPTIMIZER;
         Tmp_Collection.all(Index).Competitor_Info := new SYNCH_COMPETITOR_STATS_HANDLER_ARRAY(1..(Laps*Checkpoints));
      end loop;

      Competitor_Statistics := Tmp_Collection;

      Classification_Handler.Initialize(Laps,
                                        Competitor_Qty);

   end Initialize;

   procedure CompetitorOut(Competitor_ID : INTEGER;
                           Lap : INTEGER;
                           Data : COMPETITOR_STATS) is
   begin

      --Mark the exit time, checkpoint and lap
      Ada.Text_IO.Put_Line("Retiring at " & FLOAT'IMAGE(Data.Time));
      Competitor_Statistics.all(Competitor_ID).Retired_Time := Data.Time;
      Competitor_Statistics.all(Competitor_ID).Last_Checkpoint := Data.Checkpoint;
      Competitor_Statistics.all(Competitor_ID).Last_Lap := Data.Lap;
      Competitor_Statistics.all(Competitor_ID).Competition_Finished := TRUE;

      Classification_Handler.Decrease_Classification_Size_From_Lap(Lap);

   end CompetitorOut;

   procedure Add_Stat(Competitor_ID : INTEGER;
                       Data : COMPETITOR_STATS) is
   begin

      --NB: the order of these 2 operations is really important.
      --+ When a Competitor_Statistic is added, it might be that if someone
      --+ was waiting for it and it finds that a competitor has just finished
      --+ a lap, it may ask for the time instant (in order to fill the classific).
      --+ So, to retrieve this time istant it will ask for the row in the classification
      --+ table related to that event. This row has to be already filled with the value
      --+ That's why that operation is done before the update of the statistic.

      --If the checkpoint is the last one of the circuit, update the classification table as well
      if(Data.LastCheckInSect = true and Data.Sector = 3 and
           Data.Gas_Level > 0.0 and Data.Tyre_Usury < 100.0) then


         Classification_Handler.Update_Classific(Competitor_ID,
                                                 Data.Lap+1,--Count starts from 1 in the table, lap are counted from 0 instead
                                                 Data.Time);

      end if;

      --Update the statistics

      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all((Data.Lap*Checkpoints) + Data.Checkpoint).Initialise(Data);
      Competitor_Statistics.all(Competitor_ID).Last_Initialized_Index := (Data.Lap*Checkpoints) + Data.Checkpoint;

   --The competitor is out
      if(Data.Gas_Level > 0.0 and Data.Tyre_Usury < 100.0) then
         --If not retired and the array is full, the competition is regularly finished

         if(((Data.Lap*Checkpoints) + Data.Checkpoint) =
           Competitor_Statistics.all(Competitor_ID).Competitor_Info.all'LENGTH ) then
            Competitor_Statistics.all(Competitor_ID).Competition_Finished := TRUE;

         end if;
      end if;

   end Add_Stat;

   procedure Get_BestLap(TimeInstant : FLOAT;
                         LapTime : out FLOAT;
                         LapNum : out INTEGER;
                         Competitor_ID : out INTEGER) is

      Temp_Stats : COMPETITOR_STATS_POINT := new COMPETITOR_STATS;
      Temp_BestLapNum : INTEGER := -1;
      Temp_BestLapTime : FLOAT := -1.0;
      Temp_BestLapCompetitor : INTEGER := -1;

   begin

      --Retrieve all the information related to the given time for each competitor
      for Index in 1..Competitor_Statistics.all'LENGTH loop

            Get_StatsByTime(Competitor_ID => Index,
                            Time          => TimeInstant,
                            Stats_In      => Temp_Stats);

            --compare the "bestlap" values and find out the best one

            if( (Temp_Stats.BestLaptime /= -1.0 and Temp_Stats.BestLapTime < Temp_BestLapTime) or else
                 Temp_BestLapTime = -1.0 ) then
               Temp_BestLapTime := Temp_Stats.BestLaptime;
               Temp_BestLapNum := Temp_Stats.BestLapNum;
               Temp_BestLapCompetitor := Index;
            end if;

         end loop;

      --initialize che out variables correctly
      LapTime := Temp_BestLapTime;
      LapNum := Temp_BestLapNum;
      Competitor_ID := Temp_BestLapCompetitor;

   end Get_BestLap;

   procedure Get_BestSectorTimes(TimeInstant : FLOAT;
                                 Times : out FLOAT_ARRAY;
                                 Competitor_IDs : out INTEGER_ARRAY;
                                 Laps : out INTEGER_ARRAY) is
      Temp_BestSectorTimes : FLOAT_ARRAY(1..3);
      Temp_BestSectorCompetitors : INTEGER_ARRAY(1..3);
      Temp_Stats : COMPETITOR_STATS_POINT := new COMPETITOR_STATS;
   begin

      for i in 1..3 loop
         Temp_BestSectorTimes(i) := -1.0;
         Temp_BestSectorCompetitors(i) := -1;
      end loop;

      --Retrieve all the information related to the give time for each competitor
      for Index in 1..Competitor_Statistics.all'LENGTH loop
         Get_StatsByTime(Competitor_ID => Index,
                         Time          => TimeInstant,
                         Stats_In      => Temp_Stats);

         --compare the "bestlap" values and find out the best one
         for i in 1..3 loop
            if( (Temp_Stats.BestSectorTimes(i) /= -1.0 and Temp_Stats.BestSectorTimes(i) < Temp_BestSectorTimes(i)) or
                 Temp_BestSectorTimes(i) = -1.0 ) then
               Temp_BestSectorTimes(i) := Temp_Stats.BestSectorTimes(i);
               Temp_BestSectorCompetitors(i) := Index;
            end if;
         end loop;

      end loop;

      Times := Temp_BestSectorTimes;
      Competitor_IDs := Temp_BestSectorCompetitors;

      --Find out the lap when the best time was done
      declare
         Temp_Time : FLOAT;
      begin
         --Given the competitor that broke the record and the time for each sector (of index i),
         --+ loop thtough the competitor statistics as long as the first stat with that best sector time
         --+ is found. Essentialy pick up the Lap number related to that stat.
         for i in 1..3 loop
            for Index in 1..Competitor_Statistics.all(Competitor_IDs(i)).Competitor_Info'LENGTH loop
               Competitor_Statistics.all(Competitor_IDs(i)).Competitor_Info.all(Index).Get_BestSectorTime(i,Temp_Time);
               if( Temp_Time = Times(i) ) then
                  -- return lap
                  Competitor_Statistics.all(Competitor_IDs(i)).Competitor_Info.all(Index).Get_Lap(Result => Laps(i));
                  exit;
               end if;
            end loop;
         end loop;
      end;
   end Get_BestSectorTimes;

   procedure Get_Lap_Classification(Lap : INTEGER;
                                    TimeInstant : FLOAT;
                                    CompetitorID_InClassific : out INTEGER_ARRAY_POINT;
                                    Times_InClassific : out FLOAT_ARRAY_POINT;
                                    CompetitorIDs_PreviousClassific : out INTEGER_ARRAY_POINT;
                                    Times_PreviousClassific : out FLOAT_ARRAY_POINT;
                                    LappedCompetitors_ID : out INTEGER_ARRAY_POINT;
                                    LappedCompetitors_CurrentLap : out INTEGER_ARRAY_POINT) is

   begin
      Classification_Handler.Get_Lap_Classification(Lap,
                                                    TimeInstant,
                                                    CompetitorID_InClassific,
                                                    Times_InClassific,
                                                    CompetitorIDs_PreviousClassific,
                                                    Times_PreviousClassific,
                                                    LappedCompetitors_ID,
                                                    LappedCompetitors_CurrentLap);
   end Get_Lap_Classification;

   --The function takes the the latest time instant that every car passed
   function Get_Latest_Time_Instant return Float is

      Minimum_Latest_Time : Float := -1.0;
      Current_Checked_Time : Float := 0.0;
      Current_Last_Initialised_Index : Integer := 0;

   begin
      for Index in Competitor_Statistics'RANGE loop
         Current_Last_Initialised_Index := Competitor_Statistics.all(Index).Last_Initialized_Index;
         Competitor_Statistics.all(Index).Competitor_Info.all(Current_Last_Initialised_Index).Get_Time(Current_Checked_Time);
         if(Minimum_Latest_Time = -1.0 or else Current_Checked_Time < Minimum_Latest_Time) then
            Minimum_Latest_Time := Current_Checked_Time;
         end if;
      end loop;

      return Minimum_Latest_Time;

   end Get_Latest_Time_Instant;

end Competition_Computer;

