with Ada.Text_IO;
use Ada.Text_IO;

--with Competition_Monitor;

package body Competitor_Computer is

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

      entry Get_Info( Lap : INTEGER; Sector : INTEGER; Time : out FLOAT; Returns : out Unbounded_String.Unbounded_String; Metres : out FLOAT ) when true is
      begin

         if( Info.all(Lap)(Sector).UpdateString = Unbounded_String.Null_Unbounded_String ) then

            Updated := false;
            requeue Wait_Info;
         else

            Returns := Info.all(Lap)(Sector).UpdateString;
            Time := Info.all(Lap)(Sector).Time;
            Metres := Info.all(Lap)(Sector).Metres;
         end if;
      end Get_Info;

      entry Wait_Info( Lap : INTEGER; Sector : INTEGER; Time : out FLOAT; Returns : out Unbounded_String.Unbounded_String; Metres : out FLOAT ) when Updated = true is
      begin
         requeue Get_Info;
      end Wait_Info;

      procedure Set_Info( Lap : INTEGER; Sector : INTEGER; Time : FLOAT; Metres : FLOAT; UpdateString : Unbounded_String.Unbounded_String) is
      begin
         Info.all(Lap)(Sector).UpdateString := UpdateString;
         Info.all(Lap)(Sector).Time := Time;
         Info.all(Lap)(Sector).Metres := Metres;
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

   procedure Set_Update_For_Box(Data : Competitor_Stats;
                                Computer_In : Computer_Point) is
      Update_Str : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   begin

         Unbounded_String.Set_Unbounded_String(Update_Str,
                                               "<?xml version=""1.0""?>" &
                                               "<update>" &
                                               "<gasLevel>"& Common.Float_To_String(Data.Gas_Level) &"</gasLevel>" &
                                               "<tyreUsury>" & Common.Float_To_String(Data.Tyre_Usury) &"</tyreUsury>" &
                                               "<lap>" & Common.Integer_To_String(Data.Lap)&"</lap>" &
                                               "<sector>" & Common.Integer_To_String(Data.Sector)&"</sector>" &
                                               "<maxSpeed>" & Common.Float_To_String(Data.Max_Speed)&"</maxSpeed>" &
                                               "</update>");

      --aggiorno i dati nel competition_monitor in modo da averli nel caso qualcuno (i box) li richieda
      Computer_In.BoxInformation.Set_Info(Lap          => Data.Lap+1,
                                          Sector       => Data.Sector,
                                          Time => Data.Time,
                                          Metres => Computer_In.SectorLength_Helper,
                                          UpdateString => Update_Str);

   end Set_Update_For_Box;

   procedure Set_Best_Performances(Computer_In : Computer_Point;
                                   Lap : Integer;
                                   Sector : Integer;
                                   Time : Float;
                                   Checkpoint : Integer) is

      Tmp_Stats  : COMPETITOR_STATS_POINT := new COMPETITOR_STATS;

   begin

      --Retrieve the inormation related to the last checkpoint of the previous sector
      Tmp_Stats.Checkpoint := 1;

      if(Sector /= 1) then

         Get_StatsBySect(Get_ID( Computer_In ), Sector - 1, Lap, Tmp_Stats);

      elsif (Lap /= 0) then
         Get_StatsBySect(Get_ID( Computer_In ), 3, Lap - 1, Tmp_Stats);
      else
         Tmp_Stats.Time := 0.0;
      end if;

      if( Computer_In.CurrentBestSector_Times(Sector) = -1.0 or
           ( Time - Tmp_Stats.Time ) < Computer_In.CurrentBestSector_Times( Sector )) then
         --It's the first time we try to find it
         Computer_In.CurrentBestSector_Times(Sector) := Time - Tmp_Stats.Time;

      end if;

      --Update the lap statistics if the lap is finished
      if( Sector = 3 ) then
         if ( Computer_In.CurrentBestLap_Time /= -1.0 ) then

            Get_StatsByCheck(Get_ID(Computer_In), Checkpoint, Lap - 1, Tmp_Stats);

            if ( Time - Tmp_Stats.Time < Computer_In.CurrentBestLap_Time ) then
               Computer_In.CurrentBestLap_Time := Time - Tmp_Stats.Time;
               Computer_In.CurrentBestLap_Num := Lap;
            end if;
         else
            Computer_In.CurrentBestLap_Time := Time;
            Computer_In.CurrentBestLap_Num := Lap;
         end if;
      end if;
   end Set_Best_Performances;

   -- The method adds new data to the computer. We're sure that data are inserted
   --+ in time-increasing order because internal clock of competitors grows through each
   --+ checkpoint (remember that Computer is updated only once a checkpoint is reached)
   procedure Add_Data(Computer_In : COMPUTER_POINT;
                      Data : in out COMPETITOR_STATS) is
   begin

      -- If the information are related to last checkpoint of the sector
      --+ it's necessary to add those information to the competition monitor
      Computer_In.SectorLength_Helper := Computer_In.SectorLength_Helper + Data.PathLength; -- il primo valore lo aggiungo, poi faccio un loop

      if(Data.LastCheckInSect = true) then

         Set_Update_For_Box(Data,Computer_In);

         --Update the sector statistics
         if( Is_CompetitorOut(Get_ID(Computer_In ),Data.Time) = false) then

            Set_Best_Performances(Computer_In ,
                                  Lap         => Data.Lap,
                                  Sector      => Data.Sector,
                                  Time        => Data.Time,
                                  Checkpoint  => Data.Checkpoint);

         end if;

         Computer_In.SectorLength_Helper := 0.0; -- risetto a 0 la somma in modo da averla giusta nel prossimo settore

      end if;

      --Update max speed
      if (Computer_In.CurrentMaxSpeed < Data.Max_Speed ) then
         Computer_In.CurrentMaxSpeed := Data.Max_Speed;
      end if;

      Data.BestLapNum := Computer_In.CurrentBestLap_Num;
      Data.BestLaptime := Computer_In.CurrentBestLap_Time;

      for Index in 1..3 loop

         Data.BestSectorTimes(Index) := Computer_In.CurrentBestSector_Times(Index);
      end loop;


      Data.Max_Speed := Computer_In.CurrentMaxSpeed;

      Add_Stat(Computer_In.Competitor_Id,Data);


   end Add_Data;

   procedure CompetitorOut(Computer_In : COMPUTER_POINT;
                           Lap           : INTEGER;
                           Data          : COMPETITOR_STATS) is
   begin

      Competition_Computer.CompetitorOut(Computer_In.Competitor_Id,
                                        Lap,
                                        Data);

   end CompetitorOut;

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
                         Time_In : out FLOAT;
                         Metres : out FLOAT) is
   begin

      Computer_In.BoxInformation.Get_Info(Lap+1, Sector, Time_In, UpdateString_In, Metres);
   end Get_BoxInfo;

end Competitor_Computer;
