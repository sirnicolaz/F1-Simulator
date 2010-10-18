with Ada.Float_Text_IO;
use Ada.Float_Text_IO;
with Ada.Numerics.Elementary_Functions;
with Physic_Engine;
use Physic_Engine;
with Competition_Monitor;

with Common;
use Common;
with Ada.Calendar;
use Ada.Calendar;

with Competition_Computer;
use Competition_Computer;

with Checkpoint_Handler; use Checkpoint_Handler;
with Path_Handler; use Path_Handler;

with Ada.Exceptions;

package body Competitor is

   --THis value has to be the same for oeveryone
   LastLap : Integer;
   procedure Set_Laps( LapsQty : in Integer) is
   begin
      LastLap := LapsQty;
   end Set_Laps;

   --Get Methods implementation
   function Get_First_Name(Competitor_In : Competitor_Details_Point) return Str.Unbounded_String is
   begin
      return Competitor_In.Racing_Driver.First_Name;
   end Get_First_Name;

   procedure Get_Status(Competitor_In : Competitor_Details_Point; Tyre_Usury_Out : out Float; Gas_Level_Out : out Float) is

   begin
      Tyre_Usury_Out:=Competitor_In.Racing_Car.Tyre_Usury;
      Gas_Level_Out:=Competitor_In.Racing_Car.Gasoline_Level;
   end Get_Status;


   -- Set function - CAR
   procedure Configure_Car(Car_In : in out CAR;
                           Max_Speed_In : Float;
                           Max_Acceleration_In : Float;
                           Gas_Tank_Capacity_In : Float;
                           Engine_In : Str.Unbounded_String;
                           Tyre_Usury_In : Common.PERCENTAGE;
                           Gasoline_Level_In : Float;
                           Mixture_In : Str.Unbounded_String;
                           Model_In : Str.Unbounded_String;
                           Tyre_Type_In : Str.Unbounded_String) is
   begin
      Car_In.Max_Speed := Max_Speed_In;
      Car_In.Max_Acceleration := Max_Acceleration_In;
      Car_In.Gas_Tank_Capacity := Gas_Tank_Capacity_In;
      Car_In.Engine := Engine_In;
      Car_In.Tyre_Usury:=Tyre_Usury_In;
      Car_In.Gasoline_Level:=Gasoline_Level_In;
      Car_In.Mixture:=Mixture_In;
      Car_In.Model:=Model_In;
      Car_In.Tyre_Type:=Tyre_Type_In;
      Car_In.Last_Speed_Reached:= 0.0;
   end Configure_Car;

   -- Function for Calculating Status
   function Calculate_Status(infoLastSeg : in Competitor_Details_Point) return BOOLEAN is
      --questa funzione ritorna un boolean che indica se il concorrente
      --deve tornare o meno ai box
   begin
      if infoLastSeg.Racing_Car.Tyre_Usury <= 10.0 or infoLastSeg.Racing_Car.Gasoline_Level <= 10.0 then
         -- i parametri si possono cambiare ovviamente
         -- basta darci dei valori consistenti
         return TRUE;
      else return FALSE;
      end if;

   end Calculate_Status;
   -- procedure Calculate_Status(infoLastSeg);
   -- questo metodo controlla tyre usury e gasoline level
   -- se sono sotto una soglia critica richiede l'intervento dei box
   -- per ora metto parametri a caso (cio� bisogna definire di preciso
   -- quale dev'essere il limite per richiamare i box, bisogna evitare che
   --la macchina non riesca pi� a girare nel caso il box non sia tempestivo
   --  nella risposta quindi bisogna che la soglia permetta ancora qualche giro,
   -- almeno 2 direi

   procedure Configure_Driver(Driver_In: in out Driver;
                              Team_In :  Str.Unbounded_String;
                              First_Name_In :  Str.Unbounded_String;
                              Last_Name_In :  Str.Unbounded_String) is
   begin
      Driver_In.Team:=Team_In;
      Driver_In.First_Name:=First_Name_In;
      Driver_In.Last_Name:=Last_Name_In;
   end Configure_Driver;

   function Init_Competitor(Xml_file : String;
                            Current_Circuit_Race_Iterator  : Racetrack_Iterator;
                            Id_In : Integer;
                            Laps_In : Integer;
                            BoxRadio_CorbaLOC : String) return Competitor_Details_Point is
      --parametri
      Doc : Document;
      carDriver_XML : Node_List;
      carDriver_Length : Integer;

      --   carDriver_Out : Competitor_Details_Point;
      carDriver : Competitor_Details_Point := new Competitor_Details;


      procedure Try_OpenFile is--(xml_file : String; Input : in out File_Input; Reader : in out Tree_Reader; Doc : in out Document;
         --carDriver_XML : in out Node_List; carDriver_Length : in out Integer) is
      begin

	 Doc := Common.Get_Document(xml_file);

         carDriver_XML := Get_Elements_By_Tag_Name(Doc,"car_driver");
         carDriver_Length := Length(carDriver_XML);
      exception
         when ADA.IO_EXCEPTIONS.NAME_ERROR => Doc := null;
      end Try_OpenFile;


      function Configure_Car_File(xml_file_In : DOCUMENT) return CAR is
         Max_Speed_In : Float;
         Max_Acceleration_In : Float;
         Gas_Tank_Capacity_In : Float;
         Tyre_Usury_In : Float;
         Gasoline_Level_In : Float;
         Mixture_In : Str.Unbounded_String;
         Model_In : Str.Unbounded_String;
         Tyre_Type_In : Str.Unbounded_String;
         car_XML : Node_List;
         Current_Node : Node;
         Car_In : CAR;
         Engine_In : Str.Unbounded_String;

         function Get_Feature_Node(Node_In : NODE;
                                   FeatureName_In : String) return NODE is
            Child_Nodes_In : NODE_LIST;
            Current_Node : NODE;
         begin

            Child_Nodes_In := Child_Nodes(Node_In);
            for Index in 1..Length(Child_Nodes_In) loop
               Current_Node := Item(Child_Nodes_In,Index-1);
               if Node_Name(Current_Node) = FeatureName_In then
                  return Current_Node;
               end if;
            end loop;

            return null;
         end Get_Feature_Node;

      begin

         car_XML := Get_Elements_By_Tag_Name(xml_file_In,"car");

         Current_Node := Item(car_XML, 0);

         car_XML := Child_Nodes(Current_Node);
         Max_Speed_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxspeed"))));
         Max_Acceleration_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxacceleration"))));
         Gas_Tank_Capacity_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gastankcapacity"))));
         Engine_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"engine"))));
         Tyre_Usury_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"tyreusury"))));
         Gasoline_Level_In := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gasolinelevel"))));

         Mixture_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"mixture"))));
         Model_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"model"))));
         Tyre_Type_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"type_tyre"))));

         Configure_Car(Car_In,
                       Max_Speed_In,
                       Max_Acceleration_In,
                       Gas_Tank_Capacity_In,
                       Engine_In,
                       Tyre_Usury_In,
                       Gasoline_Level_In,
                       Mixture_In ,
                       Model_In ,
                       Tyre_Type_In);
         return Car_In;

      end Configure_Car_File;

      function Configure_Driver_File(xml_file_In : DOCUMENT) return DRIVER is
         Team_In : Str.Unbounded_String;
         First_Name_In : Str.Unbounded_String;
         Last_Name_In : Str.Unbounded_String;
         Last_Speed_Reached : Float :=0.0;
         driver_XML : Node_List;
         Current_Node : Node;
         Car_In : DRIVER;

         function Get_Feature_Node(Node_In : NODE;
                                   FeatureName_In : String) return NODE is
            Child_Nodes_In : NODE_LIST;
            Current_Node : NODE;
         begin

            Child_Nodes_In := Child_Nodes(Node_In);
            for Index in 1..Length(Child_Nodes_In) loop
               Current_Node := Item(Child_Nodes_In,Index-1);
               if Node_Name(Current_Node) = FeatureName_In then
                  return Current_Node;
               end if;
            end loop;

            return null;
         end Get_Feature_Node;

      begin
         driver_XML := Get_Elements_By_Tag_Name(xml_file_In,"driver");
         Current_Node := Item(driver_XML, 0);
         driver_XML := Child_Nodes(Current_Node);
         Team_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"team"))));
         First_Name_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"firstname"))));
         Last_Name_In := Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"lastname"))));
         Configure_Driver(Car_In,
                          Team_In,
                          First_Name_In,
                          Last_Name_In);
         return Car_In;
      end Configure_Driver_File;

      RadioConnection_Success : BOOLEAN := false;
   begin

      Ada.Text_IO.Put_Line("Begin");
      --apertura del file
      Try_OpenFile;
      --configurazione parametri
      Ada.Text_IO.Put_Line("Configure car");
      carDriver.Racing_Car := Configure_Car_File(doc);
      Ada.Text_IO.Put_Line("Configure Racing driver");
      carDriver.Racing_Driver := Configure_Driver_File(doc);
      Ada.Text_IO.Put_Line("Configure Race iterator");
      carDriver.Current_Circuit_Race_Iterator :=Current_Circuit_Race_Iterator ;
      Ada.Text_IO.Put_Line("Configure id");
      carDriver.Id:=id_In;
      --Init onboard computer
      Ada.Text_IO.Put_Line("Init Computer");
      Competitor_Computer.Init_Computer(Computer_In     => carDriver.On_Board_Computer ,
                                        CompetitorId_In => id_in,
                                        Laps            => laps_in);

      --Adding minimal information to stats (for presentation purspose)
      Ada.Text_IO.Put_Line("Adding min info");
      Competition_Computer.Add_CompetitorMinInfo(Id      => id_in,
                                                Name    => carDriver.Racing_Driver.First_Name,
                                                Surname => carDriver.Racing_Driver.Last_Name,
                                                Team    => carDriver.Racing_Driver.Team);

      --Initializing onboard computer references in the Competition Monitor
      Ada.Text_IO.Put_Line("Add obc");
      Competition_Monitor.Add_Onboard_Computer(carDriver.On_Board_Computer ,carDriver.Id);
      --Try to initialize the competitor radio. If it's still down, retry in 5 seconds
      --+ (probably other problems have occured in such a case)
      Ada.Text_IO.Put_Line("Connecting to box");
      loop CompetitorRadio.Init_BoxConnection(BoxRadio_CorbaLOC => BoxRadio_CorbaLOC,
                                            Radio             => carDriver.Radio,
                                            ID                => carDriver.Id,
                                              Success           => RadioConnection_Success);
         exit when RadioConnection_Success = true;
         Ada.Text_IO.Put_Line("Connection to box failed for competitor n. " &
                              Common.Integer_To_String(id_In));
         Ada.Text_IO.Put_Line("Retry in 5 seconds...");
         Delay(Standard.Duration(5));
      end loop;

      return carDriver;
   end Init_Competitor;


   procedure Fill_Up_Statistics_From_Goal_To_ExitBox_Checkpoint(Iterator : out Racetrack_Iterator;
                                                                Current_Checkpoint : out Integer_Point; Current_Lap : Integer;
                                                                Speed : Float; Predicted_Time : Float;
                                                                Gas_Level : Float; Tyre_Usury : Common.Percentage;
                                                                Onboard_Computer : Computer_Point) is

      Temp_Checkpoint : Checkpoint_Synch_Point;
      Iterator_InitialPosition : Integer := 1;
      ExitBox_Position : Integer;
      Step : Float := 0.0001;
      UpdatedCheckpoints : Float := 1.0;
      Temp_Competitor_Statistics : Competitor_Stats;

   begin
      pragma Warnings(Off,Current_Checkpoint);

      --Find the exit box position
      Get_ExitBoxCheckpoint(Iterator ,Temp_Checkpoint);
      ExitBox_Position := Get_Position(Iterator);

      --Put che iterator in position number one
      while Get_Position(Iterator) /= 2 loop
         Get_NextCheckpoint(Iterator ,Temp_Checkpoint);
      end loop;
      Current_Checkpoint.all := 2;

      --Update all the statistics up to the goal checkpoint
      while Get_Position(Iterator) /= ExitBox_Position loop
         --Update the statistic to send to the Competitor_Computer
         Temp_Competitor_Statistics.Checkpoint := Current_Checkpoint.all;
         Current_Checkpoint.all := Current_Checkpoint.all + 1;
         Temp_Competitor_Statistics.LastCheckInSect := FALSE;
         Temp_Competitor_Statistics.FirstCheckInSect := FALSE;
         Temp_Competitor_Statistics.Sector := Temp_Checkpoint.Get_SectorID;
         Temp_Competitor_Statistics.Gas_Level := Gas_Level;
         Temp_Competitor_Statistics.Tyre_Usury := Tyre_Usury;
         Temp_Competitor_Statistics.IsPitStop := TRUE;
         Temp_Competitor_Statistics.Time := Predicted_Time - (Step * UpdatedCheckpoints);
         UpdatedCheckpoints := UpdatedCheckpoints + 1.0;
         Temp_Competitor_Statistics.Max_Speed := Speed;
         Temp_Competitor_Statistics.Lap := Current_Lap;
         Temp_Competitor_Statistics.PathLength := 0.0;

         Competitor_Computer.Add_Data(Computer_In => Onboard_Computer ,
                                      Data        => Temp_Competitor_Statistics);

         Get_NextCheckpoint(Iterator ,Temp_Checkpoint);
      end loop;

      Current_Checkpoint.all := ExitBox_Position-1;
      --Restore the iterator initial position
      Get_BoxCheckpoint(Iterator ,Temp_Checkpoint);
   end Fill_Up_Statistics_From_Goal_To_ExitBox_Checkpoint;

   procedure Fill_Up_Statistics_From_Prebox_To_Goal(Iterator : out Racetrack_Iterator;
                                                    Current_Checkpoint : out Integer_Point; Current_Lap : Integer;
                                                    Speed : Float; Predicted_Time : Float;
                                                    Gas_Level : Float; Tyre_Usury : Common.Percentage;
                                                    Onboard_Computer : Computer_Point) is

      pragma Warnings(Off,Current_Checkpoint);

      Temp_Checkpoint : CHECKPOINT_SYNCH_POINT;
      Iterator_InitialPosition : Integer := Get_Position(Iterator);
      Step : Float := 0.0001;
      UpdatedCheckpoints : Float := 1.0;
      Temp_Competitor_Statistics : Competitor_Stats;

   begin
      Get_CurrentCheckpoint( Iterator, Temp_Checkpoint);

      --Update all the statistics up to the goal checkpoint
      while Get_Position(Iterator) /= Circuit.Checkpoints  loop
         --Update the statistic to send to the Competitor_Computer
         Temp_Competitor_Statistics.Checkpoint := Current_Checkpoint.all;
         Current_Checkpoint.all := Current_Checkpoint.all + 1;
         Temp_Competitor_Statistics.LastCheckInSect := FALSE;
         Temp_Competitor_Statistics.FirstCheckInSect := FALSE;
         Temp_Competitor_Statistics.Sector := Temp_Checkpoint.Get_SectorID;
         Temp_Competitor_Statistics.Gas_Level := Gas_Level;
         Temp_Competitor_Statistics.Tyre_Usury := Tyre_Usury;
         Temp_Competitor_Statistics.Max_Speed := Speed;
         Temp_Competitor_Statistics.IsPitStop := false;
         Temp_Competitor_Statistics.Time := Predicted_Time + Step*UpdatedCheckpoints;

         UpdatedCheckpoints := UpdatedCheckpoints + 1.0;
         Temp_Competitor_Statistics.Lap := Current_Lap;
         Temp_Competitor_Statistics.PathLength := 0.0;

         Competitor_Computer.Add_Data(Computer_In => Onboard_Computer ,
                                      Data        => Temp_Competitor_Statistics);

         Get_NextCheckpoint(Iterator ,Temp_Checkpoint);
      end loop;
      Current_Checkpoint.all := Circuit.Checkpoints;

      --Restore the iterator initial position
      while Get_Position(Iterator) /= Circuit.Checkpoints loop
         Get_NextCheckpoint(Iterator, Temp_Checkpoint );
      end loop;

   end Fill_Up_Statistics_From_Prebox_To_Goal;

   procedure Finalize_Competitor_Statistics(Iterator :  out Racetrack_Iterator;
                                            Current_Lap : Integer; Predicted_Time : Float;
                                            Gas_Level : Float; Tyre_Usury : Common.Percentage;
                                            Onboard_Computer : Computer_Point;
                                            Statistics : out Competitor_Stats) is

      pragma Warnings(Off,Statistics);
      --Update all the remaining information in the competitor statistics list, so
      --+ if someone was waiting on a list position for some new competitor data,
      --+ it will be notified
      Temp_Checkpoint : CHECKPOINT_SYNCH_POINT;
      Temp_CheckpointPos : Integer;
      Temp_Lap : Integer := Current_Lap;

   begin

      CompetitorOut(Computer_In => Onboard_Computer ,
                    Lap         => Current_Lap,
                    Data        => Statistics);

      loop

         Get_NextCheckpoint(Iterator ,Temp_Checkpoint);
         Temp_CheckpointPos := Get_Position(Iterator);

         if(Temp_Checkpoint.Is_Goal) then
            Temp_Lap := Temp_Lap + 1;
         end if;

         exit when Temp_Lap = LastLap;

         Statistics.Checkpoint := Temp_CheckpointPos;
         Statistics.LastCheckInSect := Temp_Checkpoint.Is_LastOfTheSector;
         Statistics.FirstCheckInSect := Temp_Checkpoint.Is_FirstOfTheSector;
         Statistics.Sector := Temp_Checkpoint.Get_SectorID;
         Statistics.Gas_Level := Gas_Level;
         Statistics.Tyre_Usury := Tyre_Usury;
         Statistics.IsPitStop := FALSE;
         Statistics.Time := Predicted_Time;
         Statistics.Lap := Temp_Lap;
         Statistics.PathLength := 0.0;

         Competitor_Computer.Add_Data(Computer_In => Onboard_Computer,
                                      Data        => Statistics);
      end loop;

   end Finalize_Competitor_Statistics;

   -----------------------------------
   -----------------------------------
   --TASK COMPETITOR IMPLEMENTATION --
   -----------------------------------
   -----------------------------------
   task body TASKCOMPETITOR is
      C_Checkpoint : CHECKPOINT_SYNCH_POINT;
      PredictedTime : Float := 0.0;
      DelayTime : Float := 1.0;
      Paths2Cross : CROSSING_POINT;
      MinSegTime : Float :=1.0;-- minima quantit� di tempo per attraversare un tratto
      lengthPath : Float := 0.0;
      carDriver : Competitor_Details_Point := carDriver_In;--
      MinRaceTime : Float := MinSegTime * Float(Get_RaceLength(carDriver.Current_Circuit_Race_Iterator ));
      CurrentCheckpoint : Common.Integer_Point := new Integer;
      ActualTime : Float;
      Finished : BOOLEAN := FALSE;
      Index : Integer := 0;
      id : Integer := carDriver.Id;
      StartingPosition :Integer;
      Speed : Float;
      CrossingTime : Float;
      endWait : Boolean :=False;
      j: Integer:=0;
      tempoTotale : Float := 0.0;
      valore:BOOLEAN :=False;
      compStats : COMPETITOR_STATS;
      SectorID : Integer;
      PitStop : BOOLEAN := false;  --indica se fermarsi o meno ai box

      -- The lap count is kept in this variable
      CurrentLap : Integer := 0;

      PitStopDone : BOOLEAN := false;

      --Strategy got from the box
      BrandNewStrategy : Common.STRATEGY;

      procedure Remove_CompetitorFromRace(Iterator_In : out Circuit.RACETRACK_ITERATOR;
                                          PitStopDone_In : in BOOLEAN;
                                          Competitor_ID : Integer) is
         StartingPosition_P : Integer;
         Checkpoint_P : CHECKPOINT_SYNCH_POINT;
      begin
         Circuit.Get_NextCheckpoint(Iterator_In,Checkpoint_P);
         StartingPosition_P := Get_Position(Iterator_In);

         loop
            Checkpoint_P.Remove_Competitor(Competitor_ID);

            Circuit.Get_NextCheckpoint(Iterator_In,Checkpoint_P);
            exit when Get_Position(Iterator_In) = StartingPosition_P;
         end loop;

         if(PitStopDone_In = true) then

            Get_BoxCheckpoint(Iterator_In,Checkpoint_P);

            Checkpoint_P.Remove_Competitor(Competitor_ID);

         end if;
      end Remove_CompetitorFromRace;

   begin

      CurrentCheckpoint.all := 1;

      Ada.Text_IO.Put_Line("init task");--sincronizzazione task iniziale
      loop exit when endWait=true;
         accept Start do

            endWait := True;
        end Start;
      end loop;

      Get_CurrentCheckPoint(carDriver.Current_Circuit_Race_Iterator ,C_Checkpoint);

      -- Ask the box for the starting strategy
      BrandNewStrategy := CompetitorRadio.Get_Strategy(carDriver.Radio, CurrentLap);

      --Updating the driver strategy with the first strategy given
      --+ by the box. TODO: verify wheter to set the gas level with
      --+ the one given by the box.
      carDriver.Current_Strategy.Tyre_Type := BrandNewStrategy.Tyre_Type;
      carDriver.Current_Strategy.Laps_To_Pitstop := BrandNewStrategy.Laps_To_Pitstop;
      carDriver.Current_Strategy.Gas_Level := BrandNewStrategy.Gas_Level;
      carDriver.Current_Strategy.Style := BrandNewStrategy.Style;

      loop
         --Istante di tempo segnato nel checkpoint attuale per il competitor
         ActualTime := C_Checkpoint.Get_Time(id);

         Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)& Integer'Image(id)&
                              ": SUMMURY lap : " & Integer'IMAGE(CurrentLap) &
                              ", actual time : " & Float'Image(ActualTime) &
                              ", gas " & Float'IMAGE(carDriver.Racing_Car.Gasoline_Level) &
                              ", tyre " & Float'IMAGE(carDriver.Racing_Car.Tyre_Usury) &
                              ", pit stop done " & BOOLEAN'IMAGE(PitStopDone));
         --Viene segnalato l'arrivo effettivo al checkpoint. In caso risulti primo,
         --viene subito assegnata la collezione  di path per la scelta della traiettoria

         if( C_Checkpoint.Is_PreBox = true ) then -- If true, the check point is a prebox

            begin
               --Box comunication section
               -- Ask for the box strategy once the prebox checkpoint is reached
               BrandNewStrategy := CompetitorRadio.Get_Strategy(carDriver.Radio,CurrentLap+1);

               if( BrandNewStrategy.Laps_To_Pitstop = -1 ) then
                  carDriver.Current_Strategy.Laps_To_Pitstop := 1;
               end if;

            exception
               when Error : others =>
                  Ada.Text_IO.Put_Line("Exception: " & Ada.Exceptions.Exception_Message(Error));
                  if( carDriver.Current_Strategy.Laps_To_Pitstop = 0) then
                     --To avoid another pitstop if done before
                     carDriver.Current_Strategy.Laps_To_Pitstop := 1;
                  end if;
                  --Reuse the same strategy as a new one
                  BrandNewStrategy := carDriver.Current_Strategy;
            end;
	    --Bisogna verificare se la Current_Strategy dice di tornare ai box, in tal caso:
            if(BrandNewStrategy.Laps_To_Pitstop = 0) then
               PitStop := true;
            end if;

	    carDriver.Current_Strategy.Style := BrandNewStrategy.Style;
            carDriver.Current_Strategy.Laps_To_Pitstop := BrandNewStrategy.Laps_To_Pitstop;
         end if;

         C_Checkpoint.Signal_Arrival(id);

         --When the competitor will be at the top of the list, he will be notified to
         --+ go ahead
         C_Checkpoint.Wait_To_Be_First(carDriver.Id);

         --Now the competitor is for sure first and he can pick up the path collection to
         --+ evaluate the best path to cross
         C_Checkpoint.Get_Paths(Paths2Cross,
                                Go2Box      => PitStop);

         StartingPosition := Get_Position(carDriver.Current_Circuit_Race_Iterator );

         SectorID:=C_Checkpoint.Get_SectorID;

         --If the competitor is in the box lane, set up the maximum speed to 80 km/h
         if(PitStop = true or PitStopDone = true) then

            declare
               OriginalSpeed : Float := CarDriver.Racing_Car.Max_Speed;
            begin
               carDriver.Racing_Car.Max_Speed := 80.0;

               Evaluate(C_Checkpoint,Paths2Cross,carDriver.Id,carDriver.Current_Strategy.Style,carDriver.Racing_Car.Max_Speed,
                        carDriver.Racing_Car.Max_Acceleration,carDriver.Racing_Car.Tyre_Type,carDriver.Racing_Car.Tyre_Usury,
                        carDriver.Racing_Car.Gasoline_Level,lengthPath, CrossingTime,Speed,carDriver.Racing_Car.Last_Speed_Reached);

               --original driver speed restored.
               carDriver.Racing_Car.Max_Speed := OriginalSpeed;
            end;
         else

            Evaluate(C_Checkpoint,Paths2Cross,carDriver.Id,carDriver.Current_Strategy.Style,carDriver.Racing_Car.Max_Speed,
                     carDriver.Racing_Car.Max_Acceleration,carDriver.Racing_Car.Tyre_Type,carDriver.Racing_Car.Tyre_Usury,
                     carDriver.Racing_Car.Gasoline_Level,lengthPath, CrossingTime,Speed,carDriver.Racing_Car.Last_Speed_Reached);
         end if;

         Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id) & ": evaluate done:" &
                              " length path " & Float'IMAGE(lengthPath) &
                              " crossing time " & Float'IMAGE(CrossingTime) &
                              " speed " & Float'IMAGE(Speed));
         --Ora non c'� pi� rischio di race condition sulla scelta delle traiettorie
         --quindi pu� essere segnalato il passaggio del checkpoint per permettere agli
         --altri thread di eseguire finch� vengono aggiornati i tempi di arrivo negli
         --altri checkpoint
         C_Checkpoint.Signal_Leaving(id);

         --If a pitstop occured, add the pit stop time to the crossing time.
         --+ We assume that the pitstop is in the first half of the lane, so before
         --+ the goal.

         -- TODO: add the time when the competitor has to leave the box
         if (PitStop = true) then
            CrossingTime := CrossingTime + BrandNewStrategy.Pit_Stop_Delay;
         end if;

         --Da adesso in poi, essendo state  rilasciate tutte le risorse, si possono
         --aggiornare i tempi di arrivo sui vari checkpoint senza rallentare il
         --procedere degli altri competitor

         PredictedTime := ActualTime + CrossingTime;

         --If the checkpoint is the prebox, it's necessary to update all
         --+ the statistics from the prebox to the goal
         if(PitStop = TRUE) then

            Fill_Up_Statistics_From_Prebox_To_Goal(carDriver.Current_Circuit_Race_Iterator,
                                                   CurrentCheckpoint, CurrentLap,
                                                   Speed, PredictedTime,
                                                   carDriver.Racing_Car.Gasoline_Level, carDriver.Racing_Car.Tyre_Usury,
                                                   carDriver.On_Board_Computer);

         end if;

         --Update the statistic to send to the Competitor_Computer
         compStats.Checkpoint := CurrentCheckpoint.all;
         compStats.LastCheckInSect := C_Checkpoint.Is_LastOfTheSector;
         compStats.FirstCheckInSect := C_Checkpoint.Is_FirstOfTheSector;
         compStats.Sector := SectorID;
         compStats.Gas_Level := carDriver.Racing_Car.Gasoline_Level;
         compStats.Tyre_Usury := carDriver.Racing_Car.Tyre_Usury;
         compStats.Time := PredictedTime;
         compStats.Lap := CurrentLap;
         compStats.PathLength := lengthPath;
         compStats.IsPitStop := FALSE;
         compStats.Max_Speed := Speed;

         -- The prebox might be way before the last checkpoint in the sector.
         --+ It's necessary though to set the field to TRUE to allow the update
         --+ of the box. Otherwise the information related to the 3rd sector
         --+ of this lap would never be added.
         if(PitStop = true) then
            compStats.LastCheckInSect := true;
         end if;

         if(PitStopDone = true) then
            compStats.IsPitStop := TRUE;
         end if;

         Competitor_Computer.Add_Data(Computer_In => carDriver.On_Board_Computer ,
                                  Data        => compStats);

         --If the checkpoint is the box, it's necessary to update all
         --+ the statistics from the box to the exit-box
         if(PitStopDone = true) then

            Fill_Up_Statistics_From_Goal_To_ExitBox_Checkpoint(carDriver.Current_Circuit_Race_Iterator,
                                                                CurrentCheckpoint, CurrentLap,
                                                                Speed, PredictedTime,
                                                                carDriver.Racing_Car.Gasoline_Level, carDriver.Racing_Car.Tyre_Usury,
                                                                carDriver.On_Board_Computer);

         end if;

         if(carDriver.Racing_Car.Gasoline_Level <= 0.0 or else carDriver.Racing_Car.Tyre_Usury >= 100.0) then
--
            Ada.Text_IO.Put_Line(Integer'IMAGE(carDriver.Id) & ": Sendin away competitor at " & Float'IMAGE(compStats.Time) & " last lap " & Integer'IMAGE(LastLap));

            Finalize_Competitor_Statistics(carDriver.Current_Circuit_Race_Iterator,
                                           CurrentLap, PredictedTime,
                                           carDriver.Racing_Car.Gasoline_Level, carDriver.Racing_Car.Tyre_Usury,
                                           carDriver.On_Board_Computer,
                                           compStats);

            Remove_CompetitorFromRace(Iterator_In    => carDriver.Current_Circuit_Race_Iterator ,
                                      PitStopDone_In => PitStopDone,
                                      Competitor_ID => carDriver.Id);

            Finished := TRUE;
         end if;

         exit when Finished = TRUE;

         -- UPdate the time written in the checkpoint queues. The first
         --+ one with the predicted time (the time the car will arrive)
         --+ and the other ones with that time increased with the minimum
         --+ time to cross a segment of the track.
         loop
            Circuit.Get_NextCheckpoint(carDriver.Current_Circuit_Race_Iterator ,C_Checkpoint);
            C_Checkpoint.Set_Lower_Bound_Arrival_Instant(id,PredictedTime);
            PredictedTime := PredictedTime + 0.001;--MinRaceTime - MinSegTime * Float(Index);
            Index := Index + 1;

            exit when Get_Position(carDriver.Current_Circuit_Race_Iterator ) = StartingPosition;
            --HACK:
            --+ premise: Get_NextCheckpoint never picks up the Box checkpoint
            --+ (in the reality it's not a track checkpoint). If the current checkpoint
            --+ is the box, the starting position
            --+ is 0. So the loop will never finish
            --+ if we keep just the exit statement.
            --+ Given these premises, once we find that the starting position is
            --+ 0 we have to reset it to another value to make the loop finish.
            --+ This value is the position before the ExitBox (the first checkpoint
            --+ retrieved in this loop). So taking the position of the first checkpoint
            --+ retrieved in the loop and subtracting one, we have the pre-exitbox checkpoint.
            if StartingPosition = 0 then
               StartingPosition := Get_Position(carDriver.Current_Circuit_Race_Iterator )-1;
            end if;
         end loop;

         if(PitStopDone) then
            Get_BoxCheckpoint(carDriver.Current_Circuit_Race_Iterator ,C_Checkpoint);
         end if;

         -- If there was a pitstop, get the checkpoint following the box one
         if( PitStop = true) then

            PitStop := false;
            PitStopDone := true;
            Get_BoxCheckpoint(carDriver.Current_Circuit_Race_Iterator ,C_Checkpoint);
            --HACK: in this way we add the competitor to the box queue (that is empty
            --+ by default)
            C_Checkpoint.Set_Lower_Bound_Arrival_Instant(carDriver.Id, predictedTime);

            --Those updates will be effective in the next loop (next checkpoint), so
            --+ they'll be used while doing the after-box path.
            if(BrandNewStrategy.Gas_Level /= -1.0) then
                carDriver.Current_Strategy.Gas_Level := BrandNewStrategy.Gas_Level;
                carDriver.Racing_Car.Gasoline_Level := BrandNewStrategy.Gas_Level;
            end if;
            carDriver.Current_Strategy.Tyre_Type := BrandNewStrategy.Tyre_Type;
            carDriver.Racing_Car.Tyre_Type := BrandNewStrategy.Tyre_Type;

            --We assume che every pitstop the tyre are replaced
            carDriver.Racing_Car.Tyre_Usury := 0.0;

         else

            if(PitStopDone = true) then
               PitStopDone := false;
               C_Checkpoint.Remove_Competitor(carDriver.Id);
            end if;

            Get_NextCheckPoint(carDriver.Current_Circuit_Race_Iterator ,C_Checkpoint);
         end if;


         if(C_CheckPoint.Is_Goal) then
            -- later on, at the end of the loop it will be updated to 1
            CurrentCheckpoint.all := 0;
            CurrentLap := CurrentLap + 1;
         end if;

         -- Just for simulation purpose
         delay until(Ada.Calendar.Clock + Standard.Duration(CrossingTime*Common.Simulation_Speed));

         --If the checkpoint is the goal, get the race over
         if C_CheckPoint.Is_Goal and CurrentLap = LastLap then
            Ada.Text_IO.Put_Line(Integer'Image(carDriver.Id)&" Last lap reached");
            Finished := true;

            Remove_CompetitorFromRace(Iterator_In    => carDriver.Current_Circuit_Race_Iterator ,
                                      PitStopDone_In => PitStopDone,
                                      Competitor_ID => carDriver.Id);

            --Not necessary to send last information to box because it should
            --+ already know that the last lap has been reached
         end if;

         exit when Finished = true;

         CurrentCheckpoint.all := CurrentCheckpoint.all + 1;

      end loop;

      CompetitorRadio.Close_BOxConnection(Radio => carDriver.Radio);

   end TASKCOMPETITOR;

   function Get_Tyre_Usury(Competitor_In : Competitor_Details_Point) return Common.Percentage is
   begin
      return Competitor_In.Racing_Car.Tyre_Usury;
   end Get_Tyre_Usury;

   function Get_Gasoline_Level(Competitor_In : Competitor_Details_Point) return Float is
   begin
      return Competitor_In.Racing_Car.Gasoline_Level;
   end Get_Gasoline_Level;

   function Get_Max_Acceleration(Competitor_In : Competitor_Details_Point) return Float is
   begin
      return Competitor_In.Racing_Car.Max_Acceleration;
   end Get_Max_Acceleration;

   function Get_Last_Speed_Reached(Competitor_In : Competitor_Details_Point) return Float is
   begin
      return Competitor_In.Racing_Car.Last_Speed_Reached;
   end Get_Last_Speed_Reached;

   function Get_Strategy_Style(Competitor_In : Competitor_Details_Point) return Common.Driving_Style is
   begin
      return Competitor_In.Current_Strategy.Style;
   end Get_Strategy_Style;


end Competitor;

