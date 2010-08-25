with Ada.Text_IO;
use Ada.Text_IO;

--with Competition_Monitor;

package body OnBoardComputer is

   protected body SYNCH_COMP_STATS_HANDLER is

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
         Result := Statistic.MaxSpeed;
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
         Result := Statistic.GasLevel;
      end Get_GasLevel;

      entry Get_TyreUsury (Result : out PERCENTAGE) when Initialised = TRUE is
      begin
         Result := Statistic.TyreUsury;
      end Get_TyreUsury;

      entry Get_All( Result : out COMP_STATS) when Initialised = TRUE is
      begin
         Result := Statistic;
      end Get_All;

      entry Initialise(Stats_In : in COMP_STATS) when Initialised = FALSE is

      begin
         Ada.Text_IO.Put_Line("Adding " & INTEGER'IMAGE(Stats_In.Checkpoint));
         Statistic := Stats_In;
         Initialised := TRUE;
      end Initialise;

   end SYNCH_COMP_STATS_HANDLER;


   protected body SYNCH_INFO_FOR_BOX is

      procedure Init(Laps : INTEGER) is
      begin
         Info := new LAP_INFO(1..Laps);
         for Index in Info'RANGE loop
            for Indez in 1..3 loop
               Info.all(Index)(Indez).UpdateString := Unbounded_String.Null_Unbounded_String;
               Info.all(Index)(Indez).Time := -1.0;
            end loop;
         end loop;
      end Init;

      entry Get_Info( Lap : INTEGER; Sector : INTEGER; Time : out FLOAT; Returns : out Unbounded_String.Unbounded_String ) when true is
      begin
         if( Info.all(Lap)(Sector).UpdateString = Unbounded_String.Null_Unbounded_String ) then
            Updated := false;
            requeue Wait_Info;
         else
            Returns := Info.all(Lap)(Sector).UpdateString;
            Time := Info.all(Lap)(Sector).Time;
         end if;
      end Get_Info;

      entry Wait_Info( Lap : INTEGER; Sector : INTEGER; Time : out FLOAT; Returns : out Unbounded_String.Unbounded_String ) when Updated = true is
      begin
         requeue Get_Info;
      end Wait_Info;

      procedure Set_Info( Lap : INTEGER; Sector : INTEGER; Time : FLOAT; UpdateString : Unbounded_String.Unbounded_String) is
      begin
         Info.all(Lap)(Sector).UpdateString := UpdateString;
         Info.all(Lap)(Sector).Time := Time;
         Updated := TRUE;
      end Set_Info;

   end SYNCH_INFO_FOR_BOX;

   -- This method create a brand new COMPUTER whose current_node and last_node
   --+ are set to an empty one.
   procedure Init_Computer(Computer_In : COMPUTER_POINT;
                           CompetitorId_In : INTEGER;
                           Laps : INTEGER;
                           Checkpoints : INTEGER) is
   begin
      Computer_In.Competitor_Id := CompetitorId_In;
      Computer_In.Information := new SYNCH_COMP_STATS_HANDLER_ARRAY(1..Laps*Checkpoints);
      Computer_In.Checkpoints := Checkpoints;
      COmputer_In.BoxInformation := new SYNCH_INFO_FOR_BOX;
      Computer_In.BoxInformation.Init(Laps);
      Computer_In.CurrentBestSector_Times(1) := -1.0;
      Computer_In.CurrentBestSector_Times(2) := -1.0;
      Computer_In.CurrentBestSector_Times(3) := -1.0;
      Computer_In.CurrentBestLap_Time := -1.0;
      Computer_In.CurrentBestLap_Num := -1;
      Computer_In.CurrentMaxSpeed := -1.0;
      Computer_In.LastSlotAccessed := 1;
      Computer_In.SectorLength_Helper := 0.0;
   end Init_Computer;

   -- The method adds new data to the computer. We're sure that data are inserted
   --+ in time-increasing order because internal clock of competitors grows through each
   --+ checkpoint (remember that Computer is updated only once a checkpoint is reached)
   procedure Add_Data(Computer_In : COMPUTER_POINT;
                      Data : in out COMP_STATS) is

      updateStr : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      --
   begin
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Get_ID(Computer_In)) & ": inizio add_data");
      -- If the information are related to last checkpoint of the sector
      --+ it's necessary to add those information to the competition monitor

      COmputer_In.SectorLength_Helper := COmputer_In.SectorLength_Helper + Data.PathLength; -- il primo valore lo aggiungo, poi faccio un loop
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Get_ID(Computer_In)) & ": path length set");
      if(Data.LastCheckInSect = true) then
         Ada.Text_IO.Put_Line("Last check in sector");
         Unbounded_String.Set_Unbounded_String(updateStr,
                                               "<?xml version=""1.0""?>" &
                                               "<update>" &
                                               "<gasLevel>"& Common.FloatToString(Data.GasLevel) &"</gasLevel>" &
                                               "<tyreUsury>" & Common.FloatToString(Data.TyreUsury) &"</tyreUsury>" &
                                               "<lap>" & Common.IntegerToString(Data.Lap)&"</lap>" &
                                               "<sector>" & Common.IntegerToString(Data.Sector)&"</sector>" &
                                               "<metres>" & Common.FloatToString(Computer_In.SectorLength_Helper)&"</metres>" &
                                               "</update>"
                                              );
         Ada.Text_IO.Put_Line("Adding news to monitor : ");

         --aggiorno i dati nel competition_monitor in modo da averli nel caso qualcuno (i box) li richieda
         Computer_In.BoxInformation.Set_Info(Lap          => Data.Lap+1,
                                             Sector       => Data.Sector,
                                             Time => Data.Time,
                                             UpdateString => updateStr);

         --Update the sector statistics
         declare
            Sector2Ask : INTEGER;
            Lap2Ask : INTEGER;
            CurrentSector : INTEGER := Data.Sector;
            CurrentLap : INTEGER := Data.Lap+1;
            Tmp_Stats  : COMP_STATS_POINT := new COMP_STATS;
         begin

            if(CurrentSector = 1) then
               Sector2Ask := 3;
               Lap2Ask := CurrentLap - 1;
            else
               Sector2Ask := CurrentSector - 1;
               Lap2Ask := CurrentLap;
            end if;

            if(Lap2Ask > 0) then
               Get_StatsBySect(Computer_In, Sector2Ask, Lap2Ask, Tmp_Stats);
            end if;

            if( Computer_In.CurrentBestSector_Times(CurrentSector) = -1.0 ) then
               --It's the first time we try to find it
               Computer_In.CurrentBestSector_Times(CurrentSector) := data.Time;
            elsif (Data.Time - Tmp_Stats.Time) < Computer_In.CurrentBestSector_Times(CurrentSector)
               --The following statement shouldn't be necessary because if the
               --+ stats for the given lap is not accessible it means that also
               --+ the best sector is set yet
               --Get_Checkpoint(Tmp_Stats) = -1 or else
                 then

               Computer_In.CurrentBestSector_Times(CurrentSector) := data.Time - Tmp_Stats.Time;

            end if;
            Ada.Text_IO.Put_Line("Best sector calculated");
            --Update the lap statistics if the lap is finished
            if( CurrentSector = 3 ) then
               if ( Computer_In.CurrentBestLap_Time /= -1.0 ) then

                  Get_StatsByCheck(Computer_In, 1, CurrentLap - 1, Tmp_Stats);

                  if ( Data.Time - Tmp_Stats.Time < Computer_In.CurrentBestLap_Time ) then
                     Computer_In.CurrentBestLap_Time := Data.Time - Tmp_Stats.Time;
                     Computer_In.CurrentBestLap_Num := CurrentLap;
                  end if;
               else
                  Computer_In.CurrentBestLap_Time := Data.Time;
                  Computer_In.CurrentBestLap_Num := CurrentLap;
               end if;
            end if;
         end;

         Computer_In.SectorLength_Helper := 0.0; -- risetto a 0 la somma in modo da averla giusta nel prossimo settore

      end if;

      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Get_ID(Computer_In)) & ": out of the huge if");
      --Update max speed TODO CRITICAL
      if (Computer_In.CurrentMaxSpeed < Data.MaxSpeed ) then
         Computer_In.CurrentMaxSpeed := Data.MaxSpeed;
      end if;
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Get_ID(Computer_In)) & ": speed set");
      Data.BestLapNum := Computer_In.CurrentBestLap_Num;
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Get_ID(Computer_In)) & ": best lap num set");
      Data.BestLaptime := Computer_In.CurrentBestLap_Time;
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Get_ID(Computer_In)) & ": best lap time set");
      for Index in 1..3 loop
         Data.BestSectorTimes(Index) := Computer_In.CurrentBestSector_Times(Index);
      end loop;
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Get_ID(Computer_In)) & ": sectors time set");

      Data.MaxSpeed := Computer_In.CurrentMaxSpeed;
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Get_ID(Computer_In)) & ": data speed set");
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Get_ID(Computer_In)) & ": Registering data of lap : " &
                           INTEGER'IMAGE(Data.Lap+1) &
                           " and sector " & INTEGER'IMAGE(Data.Checkpoint) &
                           " at index " & INTEGER'IMAGE((Data.Lap*Computer_In.Checkpoints) + Data.Checkpoint));
      Computer_In.Information.all((Data.Lap*Computer_In.Checkpoints) + Data.Checkpoint).Initialise(Data);

      Ada.Text_IO.Put_Line("fine add_data");

   end Add_Data;


   -- It sets the CompStats parameter with the statistics related to the given sector and lap
   procedure Get_StatsBySect(Computer_In : COMPUTER_POINT;
                             Sector : INTEGER;
                             Lap : INTEGER;
                             Stats_In : out COMP_STATS_POINT) is
      Index : INTEGER := Lap+1; -- laps start from 0, information are store starting from 1
      Tmp_Sector : INTEGER;
      Tmp_Bool : BOOLEAN;
   begin
      Computer_In.Information(Index).Get_Sector(Tmp_Sector);
      Computer_In.Information(Index).Get_IsLastCheckInSector (Tmp_Bool);

      while Tmp_Sector = Sector and then Tmp_Bool loop
         Index := Index + 1;
         Computer_In.Information(Index).Get_Sector(Tmp_Sector);
         Computer_In.Information(Index).Get_IsLastCheckInSector (Tmp_Bool);
      end loop;
      Computer_In.LastSlotAccessed := Index;

      if( Stats_In = null ) then
        Stats_In := new COMP_STATS;
      end if;

      Computer_In.Information(Index).Get_All(Stats_In.all);

   end Get_StatsBySect;

   -- It returns the competitor ID related to this Computer
   function Get_Id(Computer_In : COMPUTER_POINT) return INTEGER is
   begin
      return Computer_In.Competitor_Id;
   end Get_Id;

   -- It return a statistic related to a certain time. If the statistic is not
   --+ initialised yet, the requesting task will wait on the resource Information
   --+ as long as it's been initialised
   procedure Get_StatsByTime(Computer_In : COMPUTER_POINT;
                            Time : FLOAT;
                            Stats_In : out COMP_STATS_POINT) is

      Index : INTEGER := Computer_In.LastSlotAccessed;
      Tmp_Time : FLOAT;
   begin
      Computer_In.Information(Index).Get_Time(Tmp_Time);
      if (Tmp_Time >= Time ) then
         Index := Index - 1;
         Computer_In.Information(Index).Get_Time(Tmp_Time);
         while Index = -1 or else Tmp_Time > Time loop
            Index := Index - 1;
            Computer_In.Information(Index).Get_Time(Tmp_Time);
         end loop;

         if( Stats_In = null ) then
            Stats_In := new COMP_STATS;
         end if;

         Computer_In.Information(Index+1).Get_All(Stats_In.all);

      else
         Index := Index + 1;
         Computer_In.Information(Index).Get_Time(Tmp_Time);
         while Tmp_Time < Time loop
            Index := Index + 1;
            Computer_In.Information(Index).Get_Time(Tmp_Time);
         end loop;

         COmputer_In.Information(Index).Get_All(Stats_In.all);

      end if;

      Computer_In.LastSlotAccessed := Index;

   end Get_StatsByTime;

   -- It sets the CompStats parameter with the statistics related to the given check-point and lap
   procedure Get_StatsByCheck(Computer_In : COMPUTER_POINT;
                              Checkpoint : INTEGER;
                              Lap : INTEGER;
                              Stats_In : out COMP_STATS_POINT) is
   begin

      if( Stats_In = null ) then
        Stats_In := new COMP_STATS;
      end if;

      Computer_In.Information((Lap+1)*Checkpoint).Get_All(Stats_In.all);
      Computer_In.LastSlotAccessed := (Lap+1)*Checkpoint;
   end Get_StatsByCheck;

   procedure Get_BoxInfo(Computer_In : COMPUTER_POINT;
                         Lap : INTEGER;
                         Sector : INTEGER;
                         UpdateString_In : out Unbounded_String.Unbounded_String;
                         Time_In : out FLOAT) is
   begin
      Ada.Text_IO.Put_Line("In onboard computer");
      Computer_In.BoxInformation.Get_Info(Lap+1, Sector, Time_In, UpdateString_In);
   end Get_BoxInfo;

end OnBoardComputer;
