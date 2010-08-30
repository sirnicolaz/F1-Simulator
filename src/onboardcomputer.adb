with Ada.Text_IO;
use Ada.Text_IO;

--with Competition_Monitor;

package body OnBoardComputer is

   protected body SYNCH_INFO_FOR_BOX is

      procedure Init(Laps : INTEGER) is
      begin
         Info := new LAP_UPDATE_ARRAY(1..Laps);
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
                           Laps : INTEGER) is
   begin
      Computer_In.Competitor_Id := CompetitorId_In;
      --Computer_In.Information := new SYNCH_COMPETITOR_STATS_HANDLER_ARRAY(1..Laps*Checkpoints);
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
                      Data : in out COMPETITOR_STATS) is

      updateStr : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      --
   begin
      Ada.Text_IO.Put_Line(INTEGER'IMAGE(Get_ID(Computer_In)) & ": inizio add_data");
      -- If the information are related to last checkpoint of the sector
      --+ it's necessary to add those information to the competition monitor

      Computer_In.SectorLength_Helper := COmputer_In.SectorLength_Helper + Data.PathLength; -- il primo valore lo aggiungo, poi faccio un loop
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
            CurrentLap : INTEGER := Data.Lap;
            Tmp_Stats  : COMPETITOR_STATS_POINT := new COMPETITOR_STATS;
         begin

            if(CurrentSector = 1) then
               Sector2Ask := 3;
               Lap2Ask := CurrentLap - 1;
            else
               Sector2Ask := CurrentSector - 1;
               Lap2Ask := CurrentLap;
            end if;

            if(Lap2Ask >= 0) then
               Get_StatsBySect(Get_ID(Computer_In ), Sector2Ask, Lap2Ask, Tmp_Stats);
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

                  Get_StatsByCheck(Get_ID(Computer_In), 1, CurrentLap - 1, Tmp_Stats);

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
                           " and sector " & INTEGER'IMAGE(Data.Checkpoint));

      --TODO if the lap is finished, update the classific

      Add_Stat(Computer_In.Competitor_Id,Data);

      Ada.Text_IO.Put_Line("fine add_data");

   end Add_Data;


   -- It returns the competitor ID related to this Computer
   function Get_Id(Computer_In : COMPUTER_POINT) return INTEGER is
   begin
      return Computer_In.Competitor_Id;
   end Get_Id;


   --This method retrieve the information related to a sector and a lap. Information useful
   --+ to the box.
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
