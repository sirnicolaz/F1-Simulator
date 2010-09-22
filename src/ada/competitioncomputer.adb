with Ada.Text_IO;
use Ada.Text_IO;

package body CompetitionComputer is

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
   Classification_Tables : SOCT_ARRAY_POINT;
   StaticInformation : SYNCH_STATIC_INFORMATION_POINT := new SYNCH_STATIC_INFORMATION;
   CompetitorMinInfo_Collection : COMPETITOR_MIN_INFO_ARRAY_POINT;

   Checkpoints : INTEGER;

   procedure Init_StaticInformation(Laps_In : INTEGER;
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

   end Init_StaticInformation;

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
      Competitor_Statistics.all(Competitor_ID).LastAccessedPosition := Index;

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

      Index : INTEGER := Competitor_Statistics.all(Competitor_ID).LastAccessedPosition;
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
               Competitor_Statistics.all(Competitor_ID).LastAccessedPosition := CHoosenIndex;
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
               Competitor_Statistics.all(Competitor_ID).LastAccessedPosition := ChoosenIndex;
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
      Competitor_Statistics.all(Competitor_ID).LastAccessedPosition := (Lap*Checkpoints)+Checkpoint;
   end Get_StatsByCheck;

   --It Just initializes the Statistic_Collection with the right size
   procedure Init_Stats(Competitor_Qty : INTEGER;
                        Laps : INTEGER;
                        Checkpoints_In : INTEGER) is
      Tmp_Collection : STATISTIC_COLLECTION_POINT := new ALL_COMPETITOR_STAT_COLLECTION(1..Competitor_Qty);

   begin

      Checkpoints := Checkpoints_In;

      for Index in Tmp_Collection'RANGE loop
         Tmp_Collection.all(Index) := new STATS_ARRAY_OPTIMIZER;
         Tmp_Collection.all(Index).Competitor_Info := new SYNCH_COMPETITOR_STATS_HANDLER_ARRAY(1..(Laps*Checkpoints));
      end loop;

      Competitor_Statistics := Tmp_Collection;
      Classification_Tables := new SOCT_ARRAY(1..Laps);
      for Index in Classification_Tables'RANGE loop
         Classification_Tables.all(Index) := new SYNCH_ORDERED_CLASSIFICATION_TABLE;
         Classification_Tables.all(Index).Init_Table(Competitor_Qty);
      end loop;

   end Init_Stats;

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

      for Index in Lap+1..Classification_Tables.all'LENGTH loop
         Classification_Tables.all(Index).Remove_Competitor;
      end loop;
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


         Update_Classific(Competitor_ID,
                          Data.Lap+1,--Count starts from 1 in the table, lap are counted from 0 instead
                          Data.Time);

      end if;

      --Update the statistics

   Competitor_Statistics.all(Competitor_ID).Competitor_Info.all((Data.Lap*Checkpoints) + Data.Checkpoint).Initialise(Data);

   --The competitor is out
      if(Data.Gas_Level > 0.0 and Data.Tyre_Usury < 100.0) then
         --If not retired and the array is full, the competition is regularly finished

         if(((Data.Lap*Checkpoints) + Data.Checkpoint) =
           Competitor_Statistics.all(Competitor_ID).Competitor_Info.all'LENGTH ) then
            Competitor_Statistics.all(Competitor_ID).Competition_Finished := TRUE;

         end if;
      end if;

   end Add_Stat;

   procedure Update_Classific(Competitor_ID : INTEGER;
                              CompletedLap : INTEGER;
                              Time : FLOAT) is
      Row : STATS_ROW;
   begin
      --Find the right table for this lap
      Row.Competitor_Id := Competitor_ID;
      Row.Time := Time;

      --Add the information inside
      Classification_Tables.all(CompletedLap).Add_Row(Row);
      --Done

   end Update_Classific;


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

   procedure Get_LapTime(Competitor_ID : INTEGER;
                         Lap : INTEGER;
                         Time : out FLOAT) is
   begin
      null;
   end Get_LapTime;


   procedure Get_LapClassific(Lap : INTEGER;
                              TimeInstant : FLOAT;
                              CompetitorID_InClassific : out INTEGER_ARRAY_POINT;
                              Times_InClassific : out FLOAT_ARRAY_POINT;
                              CompetitorIDs_PreviousClassific : out INTEGER_ARRAY_POINT;
                              Times_PreviousClassific : out FLOAT_ARRAY_POINT;
                              LappedCompetitors_ID : out INTEGER_ARRAY_POINT;
                              LappedCompetitors_CurrentLap : out INTEGER_ARRAY_POINT) is
      Tmp_Row : STATS_ROW;
      InClassific_Count : INTEGER := 0;
      ExitLoop : BOOLEAN := FALSE;
   begin

      for Index in 1..Classification_Tables.all(Lap+1).Get_Size loop
         Tmp_Row := Classification_Tables.all(Lap+1).Get_Row(Index);

         --Competitor in classific
         if(Tmp_Row.Competitor_Id /= -1 and Tmp_Row.Time <= TimeInstant) then

            InClassific_Count := InClassific_Count + 1;
         else
            -- it means that the following rows have either a greater time instant
            --+ or are not set yet (and they will be set in a time instatn greater than
            --+ the asked one)
            ExitLoop := TRUE;
         end if;

         exit when ExitLoop = true;
      end loop;



      CompetitorID_InClassific := new INTEGER_ARRAY(1..InClassific_Count);
      Times_InClassific := new FLOAT_ARRAY(1..InClassific_Count);
      ExitLoop := FALSE;

      for Index in 1..InClassific_Count loop
         Tmp_Row := Classification_Tables.all(Lap+1).Get_Row(Index);
         if(Tmp_Row.Competitor_Id /= -1 and then Tmp_Row.Time <= TimeInstant) then
            --Rows are already ordered by arrival time, so we can keep this order for
            --+ writing the classific in the array
            CompetitorID_InClassific.all(Index) := Tmp_Row.Competitor_Id;
            Times_InClassific.all(Index) := Tmp_Row.Time;
         else
            ExitLoop := TRUE;
         end if;

         exit when ExitLoop = TRUE;
      end loop;


      Get_LappedCompetitors(TimeInstant,
                            Lap,
                            CompetitorIDs_PreviousClassific,
                            Times_PreviousClassific,
                            LappedCompetitors_ID,
                            LappedCompetitors_CurrentLap);

   end Get_LapClassific;


   procedure Get_LappedCompetitors(TimeInstant : FLOAT;
                                   CurrentLap : INTEGER;
                                   CompetitorIDs_PreviousClassific : out INTEGER_ARRAY_POINT;
                                   Times_PreviousClassific : out FLOAT_ARRAY_POINT;
                                   Competitor_IDs : out INTEGER_ARRAY_POINT;
                                   Competitor_Lap : out INTEGER_ARRAY_POINT) is
      Temp_Row : STATS_ROW;
      PolePosition_Time : FLOAT;
      CompetitorQty : INTEGER := CompetitorMinInfo_Collection.all'LENGTH;
      ProcessedCompetitors_IdList : INTEGER_ARRAY(1..CompetitorQty);--alias for CompetitorQty
      NotLapped_Count : INTEGER := 0;
      PreviousClassific_Count : INTEGER := 0;
      Lapped_Competitors : INTEGER := 0;
      Lapped_Count : INTEGER := 0;
      ExitLoop : BOOLEAN := false;
   begin
      --Init the processed competitors id list array: when the array position is filled with 1 it means that the
      --+ competitor with id corresponding to that index has not been processed yet (we don't know whether he
      --+ has been lapped or not)
      for id in ProcessedCompetitors_IdList'RANGE loop
         if(Is_CompetitorOut(id,TimeInstant) = TRUE) then
            --The competitor is no longer in the classific
            ProcessedCompetitors_IdList(id) := 1;
            NotLapped_Count := NotLapped_Count + 1;
         else
            ProcessedCompetitors_IdList(id) := 0;
         end if;
      end loop;

      --Pick up the pole position time in the classification table related the CurrentLap
      PolePosition_Time := Classification_Tables.all(CurrentLap+1).Get_Row(1).Time;

      -- search backward (in the table list) the lap of the lapped competitors. It will be (for each competitor)
      --+ the index of the first table where the competitor has written a time less then the best time
      --+ found at the beginning of the method. If such table is the one before the current one, it's not lapped.

      --Find out the competitors already into the previous table after the pole position time.
      --+Those competitors will not be counted in the lapped list.
      if( CurrentLap > 0) then

         for Index in 1..Classification_Tables.all(CurrentLap).Get_Size loop

            Temp_Row := Classification_Tables.all(CurrentLap).Get_Row(Index);
            if (Temp_Row.Competitor_ID /= -1 and then Temp_Row.Time <= PolePosition_Time
		and then ProcessedCompetitors_IdList(Temp_Row.Competitor_ID) /= 1) then

               ProcessedCompetitors_IdList(Temp_Row.Competitor_Id) := 1;
               NotLapped_Count := NotLapped_Count + 1;
	       PreviousClassific_Count := PreviousClassific_Count + 1;
	     --It means that it was considered as out of competition in the previous check and so not counted as being in the previous lap.
	    --+ so now we find out that before being squalified he completed the previous lap and so he's to be added to the previousClassific count
            elsif(Temp_Row.Competitor_ID /= -1 and then Temp_Row.Time <= PolePosition_Time
		and then ProcessedCompetitors_IdList(Temp_Row.Competitor_ID) = 1 and then Is_CompetitorOut(Temp_Row.Competitor_ID,TimeInstant) = TRUE) then
		    PreviousClassific_Count := PreviousClassific_Count + 1;
	    else
               ExitLoop := true;
            end if;

            exit when ExitLoop = true;
         end loop;

         --Filling up the array with competitors that have not started the new lap yet but that have already
         --+ finished the previous one (so, they have a classification time for that lap). This is done to
         --+ avoid the problem o "skipped competitor in classification"
         if(PreviousClassific_Count /= 0) then

	    CompetitorIDs_PreviousClassific := new INTEGER_ARRAY(1..PreviousClassific_Count);
	    Times_PreviousClassific := new FLOAT_ARRAY(1..PreviousClassific_Count);
	    for Index in 1..Classification_Tables.all(CurrentLap).Get_Size loop
	      Temp_Row := Classification_Tables.all(CurrentLap).Get_Row(Index);
	      if (Temp_Row.Competitor_ID /= -1 and Temp_Row.Time <= PolePosition_Time) then

		CompetitorIDs_PreviousClassific(Index) := Temp_Row.Competitor_Id;
		Times_PreviousClassific(Index) := Temp_Row.Time;
	      else
		exit;
	      end if;
	    end loop;
	 else
	  CompetitorIDs_PreviousClassific := null;
	  Times_PreviousClassific := null;
	 end if;


         if(CompetitorQty-NotLapped_Count = 0) then
            Competitor_IDs := null;
            Competitor_Lap := null;
         else

            Competitor_IDs := new INTEGER_ARRAY(1..CompetitorQty-NotLapped_Count);
            Competitor_Lap := new INTEGER_ARRAY(1..CompetitorQty-NotLapped_Count);
            --Initialise these 2 arrays
            for i in Competitor_Lap'RANGE loop
               Competitor_IDs.all(i) := -1;
               Competitor_Lap.all(i) := -1;
            end loop;

            ExitLoop := false;
            --Loop backward in the classification table list and find id and lap of lapped competitors
            for Index in reverse 1..CurrentLap-1 loop

               for i in 1..Classification_Tables.all(Index).Get_Size loop

                  Temp_Row := Classification_Tables.all(Index).Get_Row(i);
                  if (Temp_Row.Time /= -1.0 and then
                        Temp_Row.Time <= PolePosition_Time and then
                          ProcessedCompetitors_IdList(Temp_Row.Competitor_Id) = 0 ) then

                     Lapped_Count := Lapped_Count + 1;
                     ProcessedCompetitors_IdList(Temp_Row.Competitor_Id) := 1;

                     Competitor_IDs.all(Lapped_Count) := Temp_Row.Competitor_Id;

		     Competitor_Lap.all(Lapped_Count) := Index;--In the interface laps are counted starting by 0

		  end if;

               end loop;

            end loop;

            --If a competitor is still riding in the first lap, he will not appear in the tables.
            --+ So let's fill up the remaining positions of the lapped array
            for Index in 1..ProcessedCompetitors_IdList'LENGTH loop

               if(ProcessedCompetitors_IdList(Index) = 0) then
                  Lapped_Count := Lapped_Count + 1;
                  ProcessedCompetitors_IdList(Index) := 1;
                  Competitor_IDs.all(Lapped_Count) := Index;
                  Competitor_Lap.all(Lapped_Count) := 0;
               end if;
            end loop;
         end if;
      else

         --If the lap is the first one, impossible to have lapped competitors
         Competitor_IDs := null;
         Competitor_Lap := null;
      end if;

   end Get_LappedCompetitors;

   function Get_StatsRow(Competitor_Id_In : INTEGER;
                         Time_In : FLOAT) return STATS_ROW is
      Row2Return : STATS_ROW;
   begin
      Row2Return.Competitor_Id := Competitor_Id_In;
      Row2Return.Time := Time_In;
      return Row2Return;
   end Get_StatsRow;

   function Get_CompetitorId(Row : STATS_ROW) return INTEGER is
   begin
      return Row.Competitor_Id;
   end Get_CompetitorId;

   function Get_Time(Row : STATS_ROW) return FLOAT is
   begin
      return Row.Time;
   end Get_Time;



   function "<" (Left, Right : STATS_ROW) return BOOLEAN is
   begin

      if(Left.Time < Right.Time) then
         return true;
      else
         return false;
      end if;

   end "<";

   protected body SYNCH_ORDERED_CLASSIFICATION_TABLE is
      procedure Init_Table(NumRows : INTEGER) is
         NullRow : STATS_ROW;
      begin
         NullRow.Competitor_Id := -1;
         NullRow.Time := -1.0;
         Statistics := new CLASSIFICATION_TABLE(1..NumRows);
         for index in Statistics'RANGE loop
            Statistics(index) := NullRow;
         end loop;

      end Init_Table;

      procedure Remove_Competitor is
         Tmp_Stats : CLASSIFICATION_TABLE_POINT;
         New_Size : INTEGER := Statistics'LENGTH - 1;
      begin

         Tmp_Stats := new CLASSIFICATION_TABLE(1..New_Size);
         --Copy elements from old array to new one
         for Index in 1..New_Size loop --Tmp_Stats'RANGE loop
            Tmp_Stats.all(Index).Competitor_Id := Statistics.all(Index).Competitor_Id;
            Tmp_Stats.all(Index).Time := Statistics.all(Index).Time;
         end loop;
         Statistics := Tmp_Stats;
      end Remove_Competitor;

      procedure Add_Row(Row_In : STATS_ROW;
                        Index_In : INTEGER) is
      begin
         Statistics(Index_In) := Row_In;
      end Add_Row;


      procedure Add_Row(Row_In : STATS_ROW) is
      begin


         if (Statistics(1).Competitor_Id = -1) then

            Add_Row(Row_In,1);
         else

            for index in Statistics'RANGE loop
               if(Row_In < Statistics(index) ) then
                  if(Find_RowIndex(Row_In.Competitor_Id) /= -1) then
                     Delete_Row(Find_RowIndex(Row_In.Competitor_Id));
                  end if;
                  Shift_Down(index);
                  Add_Row(Row_In,index);


                  exit;
               elsif(Statistics(index).Competitor_Id = -1) then
                  Add_Row(Row_In,index);

                  exit;
               end if;
            end loop;
         end if;

      end Add_Row;

      procedure Remove_Row(Index_In : INTEGER;
                           Row_Out : in out STATS_ROW) is
      begin
         Row_Out := Statistics(Index_In);
         Delete_Row(Index_In);
      end Remove_Row;

      procedure Delete_Row(Index_In : INTEGER) is
         NullRow : STATS_ROW;
      begin
         NullRow.Competitor_Id := -1;
         Statistics(Index_In) := NullRow;
      end Delete_Row;

      procedure Shift_Down(Index_In : INTEGER) is
         EmptyIndex : INTEGER := -1;
      begin
         for index in Index_In..Statistics'LAST loop
            if(Statistics(index).Competitor_Id = -1) then
               EmptyIndex := index;
               exit;
            end if;
         end loop;

         if(EmptyIndex /= -1) and (EmptyIndex /= 1) then
            for index in reverse Index_In+1..EmptyIndex loop
               Statistics(index) := Statistics(index-1);
            end loop;
         end if;

      end Shift_Down;


      function Get_Row(Index_In : INTEGER) return STATS_ROW is
      begin
         return Statistics(Index_In);
      end Get_Row;

      function Find_RowIndex(CompetitorId_In : INTEGER) return INTEGER is
      begin
         for index in Statistics'RANGE loop
            if(Statistics(index).Competitor_Id = CompetitorID_In) then
               return index;
            end if;
         end loop;
         return -1;
      end Find_RowIndex;

      procedure Is_Full(Full_Out : out BOOLEAN) is
      begin
         if(not Full) then
            if(Statistics(Statistics'LENGTH).Competitor_Id /= -1) then
               Full := true; -- Table is packed, then it's sufficient to control the last row to verify if table is full or not
            end if;
         end if;
         Full_Out := Full;
      end Is_Full;

      function Get_Size return INTEGER is
      begin
         return Statistics'LENGTH;
      end Get_Size;

   end SYNCH_ORDERED_CLASSIFICATION_TABLE;

   function Get_New_SOCT_NODE(Size : INTEGER) return SOCT_NODE_POINT is
      TempTableListNode : SOCT_NODE_POINT := new SOCT_NODE;
      TempSOCT : SOCT_POINT := new SYNCH_ORDERED_CLASSIFICATION_TABLE;
   begin
      Init_Node(TempTableListNode);
      TempSOCT.Init_Table(Size);
      TempTableListNode.This := TempSOCT;
      return TempTableListNode;
   end Get_New_SOCT_NODE;

   function Get_PreviousNode( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_NODE_POINT is
   begin
      return SynchOrdStatTabNode.Previous;
   end Get_PreviousNode;

   function Get_NextNode( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_NODE_POINT is
   begin
      return SynchOrdStatTabNode.Next;
   end Get_NextNode;

   function Get_NodeContent( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_POINT is
   begin
      return SynchOrdStatTabNode.This;
   end Get_NodeContent;

   function IsLast(SynchOrdStatTabNode : SOCT_NODE_POINT) return BOOLEAN is
   begin
      return SynchOrdStatTabNode.IsLast;
   end IsLast;

   function IsFirst(SynchOrdStatTabNode : SOCT_NODE_POINT) return BOOLEAN is
   begin
      return SynchOrdStatTabNode.IsFirst;
   end IsFirst;

   function Get_Index(SynchOrdStatTabNode : SOCT_NODE_POINT) return INTEGER is
   begin
      return SynchOrdStatTabNode.Index;
   end Get_Index;


   procedure Init_Node(SynchOrdStatTabNode : in out SOCT_NODE_POINT) is
   begin
      if(SynchOrdStatTabNode.This = null) then
         SynchOrdStatTabNode.IsLast := true;
         SynchOrdStatTabNode.IsFirst := true;
         SynchOrdStatTabNode.Index := 1;
         SynchOrdStatTabNode.Previous := null;
         SynchOrdStatTabNode.Next := null;
      end if;
   end Init_Node;


   procedure Set_Node(SynchOrdStatTabNode : in out SOCT_NODE_POINT; Value : SOCT_POINT ) is
   begin
      SynchOrdStatTabNode.This := Value;
   end Set_Node;

   procedure Set_PreviousNode(SynchOrdStatTabNodePoint : in out SOCT_NODE_POINT ; Value : in out SOCT_NODE_POINT) is
   begin
      if(Value /= null) then
         SynchOrdStatTabNodePoint.Previous := Value;
         SynchOrdStatTabNodePoint.Previous.Next := SynchOrdStatTabNodePoint;
         SynchOrdStatTabNodePoint.Previous.IsLast := false;
         SynchOrdStatTabNodePoint.IsFirst := false;
         SynchOrdStatTabNodePoint.Index := SynchOrdStatTabNodePoint.Previous.Index + 1;
      end if;
   end Set_PreviousNode;

   procedure Set_NextNode(SynchOrdStatTabNodePoint : in out SOCT_NODE_POINT; Value : in out SOCT_NODE_POINT ) is
   begin
      if(Value /= null) then
         SynchOrdStatTabNodePoint.Next := Value;
         SynchOrdStatTabNodePoint.Next.Previous := SynchOrdStatTabNodePoint;
         SynchOrdStatTabNodePoint.Next.IsFirst := false;
         SynchOrdStatTabNodePoint.IsLast := false;
         SynchOrdStatTabNodePoint.Next.Index := SynchOrdStatTabNodePoint.Index + 1;
      end if;
   end Set_NextNode;


end CompetitionComputer;

