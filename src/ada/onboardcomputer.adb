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

      entry Get_Info( Lap : INTEGER; Sector : INTEGER; Time : out FLOAT; Returns : out Unbounded_String.Unbounded_String; Metres : out FLOAT ) when true is
      begin
      Ada.Text_IO.Put_Line("UP: getting box info for lap " & INTEGER'IMAGE(Lap) & " and sector " & INTEGER'IMAGE(Sector));
         if( Info.all(Lap)(Sector).UpdateString = Unbounded_String.Null_Unbounded_String ) then
         Ada.Text_IO.Put_Line("UP: not yet, waiting");
            Updated := false;
            requeue Wait_Info;
         else
         Ada.Text_IO.Put_Line("UP: now");
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

   -- The method adds new data to the computer. We're sure that data are inserted
   --+ in time-increasing order because internal clock of competitors grows through each
   --+ checkpoint (remember that Computer is updated only once a checkpoint is reached)
   procedure Add_Data(Computer_In : COMPUTER_POINT;
                      Data : in out COMPETITOR_STATS) is

      updateStr : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      --
   begin

      -- If the information are related to last checkpoint of the sector
      --+ it's necessary to add those information to the competition monitor

      Computer_In.SectorLength_Helper := COmputer_In.SectorLength_Helper + Data.PathLength; -- il primo valore lo aggiungo, poi faccio un loop

Ada.Text_IO.Put_Line("ON : 1");
      if(Data.LastCheckInSect = true) then
Ada.Text_IO.Put_Line("ON : 2 putting stuff of lap " & INTEGER'IMAGE(Data.Lap) & " and sector " & INTEGER'IMAGE(Data.Sector) & " gas level " & FLOAT'IMAGE(Data.GasLevel));

         Unbounded_String.Set_Unbounded_String(updateStr,
                                               "<?xml version=""1.0""?>" &
                                               "<update>" &
                                               "<gasLevel>"& Common.FloatToString(Data.GasLevel) &"</gasLevel>" &
                                               "<tyreUsury>" & Common.FloatToString(Data.TyreUsury) &"</tyreUsury>" &
                                               "<lap>" & Common.IntegerToString(Data.Lap)&"</lap>" &
                                               "<sector>" & Common.IntegerToString(Data.Sector)&"</sector>" &
                                               --"<metres>" & Common.FloatToString(Computer_In.SectorLength_Helper)&"</metres>" &
                                               --"<metres>" & Common.FloatToString(50.0) & "</metres>" &
                                               "</update>"
                                              );
Ada.Text_IO.Put_Line("ON : 3");

         --aggiorno i dati nel competition_monitor in modo da averli nel caso qualcuno (i box) li richieda
         Computer_In.BoxInformation.Set_Info(Lap          => Data.Lap+1,
                                             Sector       => Data.Sector,
                                             Time => Data.Time,
                                             Metres => Computer_In.SectorLength_Helper,
                                             UpdateString => updateStr);
Ada.Text_IO.Put_Line("ON : 4");
         --Update the sector statistics
         if( Is_CompetitorOut(Get_ID(Computer_In ),Data.Time) = false) then
		      declare
			  CurrentSector : INTEGER := Data.Sector;
			  CurrentLap : INTEGER := Data.Lap;
			  Tmp_Stats  : COMPETITOR_STATS_POINT := new COMPETITOR_STATS;
		      begin

			    --Retrieve the inormation related to the last checkpoint of the previous sector
			  Tmp_Stats.Checkpoint := 1;

			  if(CurrentSector /= 1) then
			    Get_StatsBySect(Get_ID(Computer_In ), CurrentSector - 1, CurrentLap, Tmp_Stats);

			  elsif (CurrentLap /= 0) then
			    Get_StatsBySect(Get_ID(Computer_In ), 3, CurrentLap - 1, Tmp_Stats);
			  else
			    Tmp_Stats.Time := 0.0;
			  end if;
	      Ada.Text_IO.Put_Line("ON : 5");
			  if( Computer_In.CurrentBestSector_Times(CurrentSector) = -1.0 or
			      (Data.Time - Tmp_Stats.Time) < Computer_In.CurrentBestSector_Times(CurrentSector)) then
			      Ada.Text_IO.Put_Line("ON : 5.1");
			    --It's the first time we try to find it
			    Computer_In.CurrentBestSector_Times(CurrentSector) := Data.Time - Tmp_Stats.Time;

			  end if;
	      Ada.Text_IO.Put_Line("ON : 5.2");

			  --Update the lap statistics if the lap is finished
			  if( CurrentSector = 3 ) then
			  Ada.Text_IO.Put_Line("ON : 5.3");
			    if ( Computer_In.CurrentBestLap_Time /= -1.0 ) then
	      Ada.Text_IO.Put_Line("ON : 5.4 and time " &  FLOAT'IMAGE(Computer_In.CurrentBestLap_Time));
				Get_StatsByCheck(Get_ID(Computer_In), Data.Checkpoint, CurrentLap - 1, Tmp_Stats);
	      Ada.Text_IO.Put_Line("ON : 5.5");
				if ( Data.Time - Tmp_Stats.Time < Computer_In.CurrentBestLap_Time ) then
				Ada.Text_IO.Put_Line("ON : 5.6");
				  Computer_In.CurrentBestLap_Time := Data.Time - Tmp_Stats.Time;
				  Computer_In.CurrentBestLap_Num := CurrentLap;
				  Ada.Text_IO.Put_Line("ON : 5.7");
				end if;
			    else
			    Ada.Text_IO.Put_Line("ON : 5.8");
				Computer_In.CurrentBestLap_Time := Data.Time;
				Computer_In.CurrentBestLap_Num := CurrentLap;
			    end if;
			  end if;
		      end;
	  end if;
Ada.Text_IO.Put_Line("ON : 6");
         Computer_In.SectorLength_Helper := 0.0; -- risetto a 0 la somma in modo da averla giusta nel prossimo settore

      end if;


      --Update max speed TODO CRITICAL
      if (Computer_In.CurrentMaxSpeed < Data.MaxSpeed ) then
         Computer_In.CurrentMaxSpeed := Data.MaxSpeed;
      end if;

      Data.BestLapNum := Computer_In.CurrentBestLap_Num;

      Data.BestLaptime := Computer_In.CurrentBestLap_Time;
Ada.Text_IO.Put_Line("ON : 7");
      for Index in 1..3 loop
      Ada.Text_IO.Put_Line("ON : 7i");
         Data.BestSectorTimes(Index) := Computer_In.CurrentBestSector_Times(Index);
      end loop;


      Data.MaxSpeed := Computer_In.CurrentMaxSpeed;
Ada.Text_IO.Put_Line("ON : 7.5");
      Add_Stat(Computer_In.Competitor_Id,Data);

Ada.Text_IO.Put_Line("ON : 8");
   end Add_Data;

   procedure CompetitorOut(Computer_In : COMPUTER_POINT;
                           Lap           : INTEGER;
                           Data          : COMPETITOR_STATS) is
   begin
      CompetitionCOmputer.CompetitorOut(Computer_In.Competitor_Id,
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

end OnBoardComputer;
