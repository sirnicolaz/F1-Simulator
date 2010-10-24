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
   procedure Configure_Car(Car_In 		: in out CAR;
                           Max_Speed_In 	: Float;
                           Max_Acceleration_In 	: Float;
                           Gas_Tank_Capacity_In : Float;
                           Engine_In 		: Str.Unbounded_String;
                           Tyre_Usury_In 	: Common.PERCENTAGE;
                           Gasoline_Level_In 	: Float;
                           Mixture_In 		: Str.Unbounded_String;
                           Model_In 		: Str.Unbounded_String;
                           Tyre_Type_In 	: Str.Unbounded_String) is
   begin
      Car_In.Max_Speed 		:= Max_Speed_In;
      Car_In.Max_Acceleration 	:= Max_Acceleration_In;
      Car_In.Gas_Tank_Capacity 	:= Gas_Tank_Capacity_In;
      Car_In.Engine		:= Engine_In;
      Car_In.Tyre_Usury		:= Tyre_Usury_In;
      Car_In.Gasoline_Level	:= Gasoline_Level_In;
      Car_In.Mixture		:= Mixture_In;
      Car_In.Model		:= Model_In;
      Car_In.Tyre_Type		:= Tyre_Type_In;
      Car_In.Last_Speed_Reached	:= 0.0;
   end Configure_Car;

   procedure Configure_Driver(Driver_In		: in out Driver;
                              Team_In 		: Str.Unbounded_String;
                              First_Name_In 	: Str.Unbounded_String;
                              Last_Name_In 	: Str.Unbounded_String) is
   begin
      Driver_In.Team		:=Team_In;
      Driver_In.First_Name	:=First_Name_In;
      Driver_In.Last_Name	:=Last_Name_In;
   end Configure_Driver;

   function Init_Competitor(Xml_file 				: String;
                            Current_Circuit_Race_Iterator  	: Racetrack_Iterator;
                            Id_In 				: Integer;
                            Laps_In 				: Integer;
                            BoxRadio_CorbaLOC 			: String) return Competitor_Details_Point is
      Doc 		: Document;
      Car_Driver_XML 	: Node_List;
      Car_Driver_Length : Integer;
      Car_Driver 	: Competitor_Details_Point := new Competitor_Details;
      procedure Try_OpenFile is
      begin
	 Doc 		   := Common.Get_Document(xml_file);
         Car_Driver_XML    := Get_Elements_By_Tag_Name(Doc,"car_driver");
         Car_Driver_Length := Length(Car_Driver_XML);
      exception
         when ADA.IO_EXCEPTIONS.NAME_ERROR => Doc := null;
      end Try_OpenFile;

      function Configure_Car_File(xml_file_In : DOCUMENT) return CAR is
         Max_Speed_In 		: Float;
         Max_Acceleration_In 	: Float;
         Gas_Tank_Capacity_In 	: Float;
         Tyre_Usury_In		: Float;
         Gasoline_Level_In 	: Float;
         Mixture_In 		: Str.Unbounded_String;
         Model_In 		: Str.Unbounded_String;
         Tyre_Type_In 		: Str.Unbounded_String;
         car_XML 		: Node_List;
         Current_Node 		: Node;
         Car_In 		: CAR;
         Engine_In 		: Str.Unbounded_String;

         function Get_Feature_Node(Node_In 	  : NODE;
                                   FeatureName_In : String) return NODE is
            Child_Nodes_In : NODE_LIST;
            Current_Node   : NODE;
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

         car_XML 		:= Get_Elements_By_Tag_Name(xml_file_In,"car");
         Current_Node 		:= Item(car_XML, 0);
         car_XML 		:= Child_Nodes(Current_Node);
         Max_Speed_In 		:= Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxspeed"))));
         Max_Acceleration_In 	:= Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"maxacceleration"))));
         Gas_Tank_Capacity_In 	:= Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gastankcapacity"))));
         Engine_In 		:= Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"engine"))));
         Tyre_Usury_In 		:= Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"tyreusury"))));
         Gasoline_Level_In 	:= Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"gasolinelevel"))));
         Mixture_In 		:= Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"mixture"))));
         Model_In 		:= Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"model"))));
         Tyre_Type_In 		:= Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"type_tyre"))));
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
         Team_In 		: Str.Unbounded_String;
         First_Name_In 		: Str.Unbounded_String;
         Last_Name_In 		: Str.Unbounded_String;
         Last_Speed_Reached 	: Float :=0.0;
         driver_XML 		: Node_List;
         Current_Node 		: Node;
         Car_In 		: DRIVER;
         function Get_Feature_Node(Node_In 	  : NODE;
                                   FeatureName_In : String) return NODE is
            Child_Nodes_In : NODE_LIST;
            Current_Node   : NODE;
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
         driver_XML 	:= Get_Elements_By_Tag_Name(xml_file_In,"driver");
         Current_Node 	:= Item(driver_XML, 0);
         driver_XML 	:= Child_Nodes(Current_Node);
         Team_In 	:= Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"team"))));
         First_Name_In 	:= Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"firstname"))));
         Last_Name_In 	:= Str.To_Unbounded_String(Node_Value(First_Child(Get_Feature_Node(Current_Node,"lastname"))));
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
      Car_Driver.Racing_Car := Configure_Car_File(doc);
      Ada.Text_IO.Put_Line("Configure Racing driver");
      Car_Driver.Racing_Driver := Configure_Driver_File(doc);
      Ada.Text_IO.Put_Line("Configure Race iterator");
      Car_Driver.Current_Circuit_Race_Iterator :=Current_Circuit_Race_Iterator ;
      Ada.Text_IO.Put_Line("Configure id");
      Car_Driver.Id:=id_In;
      --Init onboard computer
      Ada.Text_IO.Put_Line("Init Computer");
      Competitor_Computer.Init_Computer(Computer_In     => Car_Driver.On_Board_Computer ,
                                        CompetitorId_In => id_in,
                                        Laps            => laps_in);

      --Adding minimal information to stats (for presentation purspose)
      Ada.Text_IO.Put_Line("Adding min info");
      Competition_Computer.Add_CompetitorMinInfo(Id      => id_in,
                                                Name    => Car_Driver.Racing_Driver.First_Name,
                                                Surname => Car_Driver.Racing_Driver.Last_Name,
                                                Team    => Car_Driver.Racing_Driver.Team);

      --Initializing onboard computer references in the Competition Monitor
      Ada.Text_IO.Put_Line("Add obc");
      Competition_Monitor.Add_Onboard_Computer(Car_Driver.On_Board_Computer ,Car_Driver.Id);
      --Try to initialize the competitor radio. If it's still down, retry in 5 seconds
      --+ (probably other problems have occured in such a case)
      Ada.Text_IO.Put_Line("Connecting to box");
      loop CompetitorRadio.Init_BoxConnection(BoxRadio_CorbaLOC => BoxRadio_CorbaLOC,
                                              Radio             => Car_Driver.Radio,
                                              ID                => Car_Driver.Id,
                                              Success           => RadioConnection_Success);
         exit when RadioConnection_Success = true;
         Ada.Text_IO.Put_Line("Connection to box failed for competitor n. " &
                              Common.Integer_To_String(id_In));
         Ada.Text_IO.Put_Line("Retry in 5 seconds...");
         Delay(Standard.Duration(5));
      end loop;

      return Car_Driver;
   end Init_Competitor;

   procedure Fill_Up_Statistics_From_Goal_To_ExitBox_Checkpoint(Iterator 		: out Racetrack_Iterator;
                                                                Current_Checkpoint 	: out Integer_Point;
                                                                Current_Lap 		: Integer;
                                                                Speed 			: Float;
                                                                Predicted_Time 		: Float;
                                                                Gas_Level 		: Float;
                                                                Tyre_Usury 		: Common.Percentage;
                                                                Onboard_Computer 	: Computer_Point) is

      Temp_Checkpoint 		 : Checkpoint_Synch_Point;
      Iterator_InitialPosition 	 : Integer := 1;
      ExitBox_Position 		 : Integer;
      Step 			 : Float := 0.0001;
      UpdatedCheckpoints 	 : Float := 1.0;
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
         Temp_Competitor_Statistics.Checkpoint 		:= Current_Checkpoint.all;
         Current_Checkpoint.all 			:= Current_Checkpoint.all + 1;
         Temp_Competitor_Statistics.LastCheckInSect 	:= FALSE;
         Temp_Competitor_Statistics.FirstCheckInSect 	:= FALSE;
         Temp_Competitor_Statistics.Sector 		:= Temp_Checkpoint.Get_SectorID;
         Temp_Competitor_Statistics.Gas_Level 		:= Gas_Level;
         Temp_Competitor_Statistics.Tyre_Usury 		:= Tyre_Usury;
         Temp_Competitor_Statistics.IsPitStop 		:= TRUE;
         Temp_Competitor_Statistics.Time 		:= Predicted_Time - (Step * UpdatedCheckpoints);
         UpdatedCheckpoints 				:= UpdatedCheckpoints + 1.0;
         Temp_Competitor_Statistics.Max_Speed 		:= Speed;
         Temp_Competitor_Statistics.Lap 		:= Current_Lap;
         Temp_Competitor_Statistics.PathLength 		:= 0.0;

         Competitor_Computer.Add_Data(Computer_In => Onboard_Computer ,
                                      Data        => Temp_Competitor_Statistics);

         Get_NextCheckpoint(Iterator ,Temp_Checkpoint);
      end loop;

      Current_Checkpoint.all := ExitBox_Position-1;
      --Restore the iterator initial position
      Get_BoxCheckpoint(Iterator ,Temp_Checkpoint);
   end Fill_Up_Statistics_From_Goal_To_ExitBox_Checkpoint;

   procedure Fill_Up_Statistics_From_Prebox_To_Goal(Iterator 		: out Racetrack_Iterator;
                                                    Current_Checkpoint 	: out Integer_Point;
                                                    Current_Lap 	: Integer;
                                                    Speed 		: Float;
                                                    Predicted_Time 	: Float;
                                                    Gas_Level 		: Float;
                                                    Tyre_Usury 		: Common.Percentage;
                                                    Onboard_Computer 	: Computer_Point) is
      pragma Warnings(Off,Current_Checkpoint);
      Temp_Checkpoint 		 : CHECKPOINT_SYNCH_POINT;
      Iterator_InitialPosition 	 : Integer := Get_Position(Iterator);
      Step 			 : Float := 0.0001;
      UpdatedCheckpoints 	 : Float := 1.0;
      Temp_Competitor_Statistics : Competitor_Stats;

   begin
      Get_CurrentCheckpoint( Iterator, Temp_Checkpoint);
      --Update all the statistics up to the goal checkpoint
      while Get_Position(Iterator) /= Circuit.Checkpoints  loop
         --Update the statistic to send to the Competitor_Computer
         Temp_Competitor_Statistics.Checkpoint 		:= Current_Checkpoint.all;
         Current_Checkpoint.all 			:= Current_Checkpoint.all + 1;
         Temp_Competitor_Statistics.LastCheckInSect 	:= FALSE;
         Temp_Competitor_Statistics.FirstCheckInSect 	:= FALSE;
         Temp_Competitor_Statistics.Sector 		:= Temp_Checkpoint.Get_SectorID;
         Temp_Competitor_Statistics.Gas_Level 		:= Gas_Level;
         Temp_Competitor_Statistics.Tyre_Usury 		:= Tyre_Usury;
         Temp_Competitor_Statistics.Max_Speed 		:= Speed;
         Temp_Competitor_Statistics.IsPitStop 		:= false;
         Temp_Competitor_Statistics.Time 		:= Predicted_Time + Step*UpdatedCheckpoints;

         UpdatedCheckpoints 				:= UpdatedCheckpoints + 1.0;
         Temp_Competitor_Statistics.Lap 		:= Current_Lap;
         Temp_Competitor_Statistics.PathLength 		:= 0.0;

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

   procedure Finalize_Competitor_Statistics(Iterator 		:  out Racetrack_Iterator;
                                            Current_Lap 	: Integer;
                                            Predicted_Time 	: Float;
                                            Gas_Level 		: Float;
                                            Tyre_Usury 		: Common.Percentage;
                                            Onboard_Computer 	: Computer_Point;
                                            Statistics 		: out Competitor_Stats) is

      pragma Warnings(Off,Statistics);
      --Update all the remaining information in the competitor statistics list, so
      --+ if someone was waiting on a list position for some new competitor data,
      --+ it will be notified
      Temp_Checkpoint 	 : CHECKPOINT_SYNCH_POINT;
      Temp_CheckpointPos : Integer;
      Temp_Lap 		 : Integer := Current_Lap;

   begin

      CompetitorOut(Computer_In => Onboard_Computer,
                    Lap         => Current_Lap,
                    Data        => Statistics);

      loop

         Get_NextCheckpoint(Iterator ,Temp_Checkpoint);
         Temp_CheckpointPos := Get_Position(Iterator);

         if(Temp_Checkpoint.Is_Goal) then
            Temp_Lap := Temp_Lap + 1;
         end if;

         exit when Temp_Lap = LastLap;

         Statistics.Checkpoint 		:= Temp_CheckpointPos;
         Statistics.LastCheckInSect 	:= Temp_Checkpoint.Is_LastOfTheSector;
         Statistics.FirstCheckInSect 	:= Temp_Checkpoint.Is_FirstOfTheSector;
         Statistics.Sector 		:= Temp_Checkpoint.Get_SectorID;
         Statistics.Gas_Level 		:= Gas_Level;
         Statistics.Tyre_Usury 		:= Tyre_Usury;
         Statistics.IsPitStop 		:= FALSE;
         Statistics.Time 		:= Predicted_Time;
         Statistics.Lap			:= Temp_Lap;
         Statistics.PathLength 		:= 0.0;

         Competitor_Computer.Add_Data(Computer_In => Onboard_Computer,
                                      Data        => Statistics);
      end loop;

   end Finalize_Competitor_Statistics;

   -----------------------------------
   -----------------------------------
   --TASK COMPETITOR IMPLEMENTATION --
   -----------------------------------
   -----------------------------------
   task body Competitor_Task is
      C_Checkpoint   	: CHECKPOINT_SYNCH_POINT;
      Predicted_Time  	: Float 			:= 0.0;
      Delay_Time      	: Float 			:= 1.0;
      Paths_2_Cross    	: CROSSING_POINT;
      Min_Seg_Time     	: Float 			:= 1.0;-- minima quantità di tempo per attraversare un tratto
      Length_Path     	: Float 			:= 0.0;
      Car_Driver 	: Competitor_Details_Point 	:= Car_Driver_In;--
      Min_Race_Time 	: Float 			:= Min_Seg_Time * Float(Get_RaceLength(Car_Driver.Current_Circuit_Race_Iterator ));
      Current_Checkpoint: Common.Integer_Point 		:= new Integer;
      Actual_Time 	: Float;
      Finished 		: BOOLEAN		 	:= FALSE;
      Index 		: Integer 			:= 0;
      id 		: Integer 			:= Car_Driver.Id;
      Starting_Position : Integer;
      Speed 		: Float;
      Crossing_Time 	: Float;
      End_Wait 		: Boolean 			:= False;
      j 		: Integer			:= 0;
      Total_Time 	: Float			 	:= 0.0;
      Valore		: BOOLEAN 			:= False;
      Comp_Stats	: COMPETITOR_STATS;
      Sector_Id 	: Integer;
      Pit_Stop 		: BOOLEAN 			:= false;  --indica se fermarsi o meno ai box
      -- The lap count is kept in this variable
      Current_Lap 	: Integer 			:= 0;
      Pit_StopDone 	: BOOLEAN 			:= false;
      --Strategy got from the box
      BrandNewStrategy 	: Common.STRATEGY;

      procedure Remove_CompetitorFromRace(Iterator_In : out Circuit.RACETRACK_ITERATOR;
                                          PitStopDone_In : in BOOLEAN;
                                          Competitor_ID : Integer) is
         Starting_Position_P : Integer;
         Checkpoint_P : CHECKPOINT_SYNCH_POINT;
      begin
         Circuit.Get_NextCheckpoint(Iterator_In,Checkpoint_P);
         Starting_Position_P := Get_Position(Iterator_In);

         loop
            Checkpoint_P.Remove_Competitor(Competitor_ID);

            Circuit.Get_NextCheckpoint(Iterator_In,Checkpoint_P);
            exit when Get_Position(Iterator_In) = Starting_Position_P;
         end loop;

         if(PitStopDone_In = true) then

            Get_BoxCheckpoint(Iterator_In,Checkpoint_P);

            Checkpoint_P.Remove_Competitor(Competitor_ID);

         end if;
      end Remove_CompetitorFromRace;

   begin

      Current_Checkpoint.all := 1;

      Ada.Text_IO.Put_Line("init task");--sincronizzazione task iniziale
      loop exit when End_Wait=true;
         accept Start do

            End_Wait := True;
        end Start;
      end loop;

      Get_CurrentCheckPoint(Car_Driver.Current_Circuit_Race_Iterator ,C_Checkpoint);

      -- Ask the box for the starting strategy
      BrandNewStrategy := CompetitorRadio.Get_Strategy(Car_Driver.Radio, Current_Lap);

      --Updating the driver strategy with the first strategy given
      --+ by the box. TODO: verify wheter to set the gas level with
      --+ the one given by the box.
      Car_Driver.Current_Strategy.Tyre_Type := BrandNewStrategy.Tyre_Type;
      Car_Driver.Current_Strategy.Laps_To_Pitstop := BrandNewStrategy.Laps_To_Pitstop;
      Car_Driver.Current_Strategy.Gas_Level := BrandNewStrategy.Gas_Level;
      Car_Driver.Current_Strategy.Style := BrandNewStrategy.Style;

      loop
         --Istante di tempo segnato nel checkpoint attuale per il competitor
         Actual_Time := C_Checkpoint.Get_Time(id);

         Ada.Text_IO.Put_Line(Integer'Image(Car_Driver.Id)& Integer'Image(id)&
                              ": SUMMURY lap : " & Integer'IMAGE(Current_Lap) &
                              ", actual time : " & Float'Image(Actual_Time) &
                              ", gas " & Float'IMAGE(Car_Driver.Racing_Car.Gasoline_Level) &
                              ", tyre " & Float'IMAGE(Car_Driver.Racing_Car.Tyre_Usury) &
                              ", pit stop done " & BOOLEAN'IMAGE(Pit_StopDone));
         --Viene segnalato l'arrivo effettivo al checkpoint. In caso risulti primo,
         --viene subito assegnata la collezione  di path per la scelta della traiettoria

         if( C_Checkpoint.Is_PreBox = true ) then -- If true, the check point is a prebox

            begin
               --Box comunication section
               -- Ask for the box strategy once the prebox checkpoint is reached
               BrandNewStrategy := CompetitorRadio.Get_Strategy(Car_Driver.Radio,Current_Lap+1);

               if( BrandNewStrategy.Laps_To_Pitstop = -1 ) then
                  Car_Driver.Current_Strategy.Laps_To_Pitstop := 1;
               end if;

            exception
               when Error : others =>
                  Ada.Text_IO.Put_Line("Exception: " & Ada.Exceptions.Exception_Message(Error));
                  if( Car_Driver.Current_Strategy.Laps_To_Pitstop = 0) then
                     --To avoid another pitstop if done before
                     Car_Driver.Current_Strategy.Laps_To_Pitstop := 1;
                  end if;
                  --Reuse the same strategy as a new one
                  BrandNewStrategy := Car_Driver.Current_Strategy;
            end;
	    --Bisogna verificare se la Current_Strategy dice di tornare ai box, in tal caso:
            if(BrandNewStrategy.Laps_To_Pitstop = 0) then
               Pit_Stop := true;
            end if;

	    Car_Driver.Current_Strategy.Style := BrandNewStrategy.Style;
            Car_Driver.Current_Strategy.Laps_To_Pitstop := BrandNewStrategy.Laps_To_Pitstop;
         end if;

         C_Checkpoint.Signal_Arrival(id);

         --When the competitor will be at the top of the list, he will be notified to
         --+ go ahead
         C_Checkpoint.Wait_To_Be_First(Car_Driver.Id);

         --Now the competitor is for sure first and he can pick up the path collection to
         --+ evaluate the best path to cross
         C_Checkpoint.Get_Paths(Paths_2_Cross,
                                Go2Box      => Pit_Stop);

         Starting_Position := Get_Position(Car_Driver.Current_Circuit_Race_Iterator );

         Sector_Id:=C_Checkpoint.Get_SectorID;

         --If the competitor is in the box lane, set up the maximum speed to 80 km/h
         if(Pit_Stop = true or Pit_StopDone = true) then

            declare
               OriginalSpeed : Float := Car_Driver.Racing_Car.Max_Speed;
            begin
               Car_Driver.Racing_Car.Max_Speed := 80.0;

               Evaluate(C_Checkpoint,Paths_2_Cross,Car_Driver.Id,Car_Driver.Current_Strategy.Style,Car_Driver.Racing_Car.Max_Speed,
                        Car_Driver.Racing_Car.Max_Acceleration,Car_Driver.Racing_Car.Tyre_Type,Car_Driver.Racing_Car.Tyre_Usury,
                        Car_Driver.Racing_Car.Gasoline_Level,Length_Path, Crossing_Time,Speed,Car_Driver.Racing_Car.Last_Speed_Reached);

               --original driver speed restored.
               Car_Driver.Racing_Car.Max_Speed := OriginalSpeed;
            end;
         else

            Evaluate(C_Checkpoint,Paths_2_Cross,Car_Driver.Id,Car_Driver.Current_Strategy.Style,Car_Driver.Racing_Car.Max_Speed,
                     Car_Driver.Racing_Car.Max_Acceleration,Car_Driver.Racing_Car.Tyre_Type,Car_Driver.Racing_Car.Tyre_Usury,
                     Car_Driver.Racing_Car.Gasoline_Level,Length_Path, Crossing_Time,Speed,Car_Driver.Racing_Car.Last_Speed_Reached);
         end if;

         Ada.Text_IO.Put_Line(Integer'Image(Car_Driver.Id) & ": evaluate done:" &
                              " length path " & Float'IMAGE(Length_Path) &
                              " crossing time " & Float'IMAGE(Crossing_Time) &
                              " speed " & Float'IMAGE(Speed));
         --Ora non c'è più rischio di race condition sulla scelta delle traiettorie
         --quindi può essere segnalato il passaggio del checkpoint per permettere agli
         --altri thread di eseguire finchè vengono aggiornati i tempi di arrivo negli
         --altri checkpoint
         C_Checkpoint.Signal_Leaving(id);

         --If a pitstop occured, add the pit stop time to the crossing time.
         --+ We assume that the pitstop is in the first half of the lane, so before
         --+ the goal.

         -- add the delay when the competitor has to leave the box
         if (Pit_StopDone = true) then
            Crossing_Time := Crossing_Time + BrandNewStrategy.Pit_Stop_Delay;
         end if;

         --Da adesso in poi, essendo state  rilasciate tutte le risorse, si possono
         --aggiornare i tempi di arrivo sui vari checkpoint senza rallentare il
         --procedere degli altri competitor
         Predicted_Time := Actual_Time + Crossing_Time;

         --If the checkpoint is the prebox, it's necessary to update all
         --+ the statistics from the prebox to the goal
         if(Pit_Stop = TRUE) then

            Fill_Up_Statistics_From_Prebox_To_Goal(Car_Driver.Current_Circuit_Race_Iterator,
                                                   Current_Checkpoint, Current_Lap,
                                                   Speed, Predicted_Time,
                                                   Car_Driver.Racing_Car.Gasoline_Level, Car_Driver.Racing_Car.Tyre_Usury,
                                                   Car_Driver.On_Board_Computer);

         end if;

         --Update the statistic to send to the Competitor_Computer
         Comp_Stats.Checkpoint := Current_Checkpoint.all;
         Comp_Stats.LastCheckInSect := C_Checkpoint.Is_LastOfTheSector;
         Comp_Stats.FirstCheckInSect := C_Checkpoint.Is_FirstOfTheSector;
         Comp_Stats.Sector := Sector_Id;
         Comp_Stats.Gas_Level := Car_Driver.Racing_Car.Gasoline_Level;
         Comp_Stats.Tyre_Usury := Car_Driver.Racing_Car.Tyre_Usury;
         Comp_Stats.Time := Predicted_Time;
         Comp_Stats.Lap := Current_Lap;
         Comp_Stats.PathLength := Length_Path;
         Comp_Stats.IsPitStop := FALSE;
         Comp_Stats.Max_Speed := Speed;

         -- The prebox might be way before the last checkpoint in the sector.
         --+ It's necessary though to set the field to TRUE to allow the update
         --+ of the box. Otherwise the information related to the 3rd sector
         --+ of this lap would never be added.
         if(Pit_Stop = true) then
            Comp_Stats.LastCheckInSect := true;
         end if;

         if(Pit_StopDone = true) then
            Comp_Stats.IsPitStop := TRUE;
         end if;

         Competitor_Computer.Add_Data(Computer_In => Car_Driver.On_Board_Computer ,
                                  Data        => Comp_Stats);

         --If the checkpoint is the box, it's necessary to update all
         --+ the statistics from the box to the exit-box
         if(Pit_StopDone = true) then

            Fill_Up_Statistics_From_Goal_To_ExitBox_Checkpoint(Car_Driver.Current_Circuit_Race_Iterator,
                                                                Current_Checkpoint, Current_Lap,
                                                                Speed, Predicted_Time,
                                                                Car_Driver.Racing_Car.Gasoline_Level, Car_Driver.Racing_Car.Tyre_Usury,
                                                                Car_Driver.On_Board_Computer);
         end if;

         if(Car_Driver.Racing_Car.Gasoline_Level <= 0.0 or else
              Car_Driver.Racing_Car.Tyre_Usury >= 100.0 or else
                Length_Path = 0.0) then

            Ada.Text_IO.Put_Line(Integer'IMAGE(Car_Driver.Id) & ": Sendin away competitor at " & Float'IMAGE(Comp_Stats.Time) & " last lap " & Integer'IMAGE(LastLap));

            Finalize_Competitor_Statistics(Car_Driver.Current_Circuit_Race_Iterator,
                                           Current_Lap, Predicted_Time,
                                           Car_Driver.Racing_Car.Gasoline_Level, Car_Driver.Racing_Car.Tyre_Usury,
                                           Car_Driver.On_Board_Computer,
                                           Comp_Stats);

            Remove_CompetitorFromRace(Iterator_In    => Car_Driver.Current_Circuit_Race_Iterator ,
                                      PitStopDone_In => Pit_StopDone,
                                      Competitor_ID => Car_Driver.Id);

            Finished := TRUE;
         end if;

         exit when Finished = TRUE;

         -- UPdate the time written in the checkpoint queues. The first
         --+ one with the predicted time (the time the car will arrive)
         --+ and the other ones with that time increased with the minimum
         --+ time to cross a segment of the track.
         loop
            Circuit.Get_NextCheckpoint(Car_Driver.Current_Circuit_Race_Iterator ,C_Checkpoint);
            C_Checkpoint.Set_Lower_Bound_Arrival_Instant(id,Predicted_Time);
            Predicted_Time := Predicted_Time + 0.001;--Min_Race_Time - Min_Seg_Time * Float(Index);
            Index := Index + 1;

            exit when Get_Position(Car_Driver.Current_Circuit_Race_Iterator ) = Starting_Position;
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
            if Starting_Position = 0 then
               Starting_Position := Get_Position(Car_Driver.Current_Circuit_Race_Iterator )-1;
            end if;
         end loop;

         if(Pit_StopDone) then
            Get_BoxCheckpoint(Car_Driver.Current_Circuit_Race_Iterator ,C_Checkpoint);
         end if;

         -- If there was a pitstop, get the checkpoint following the box one
         if( Pit_Stop = true) then

            Pit_Stop := false;
            Pit_StopDone := true;
            Get_BoxCheckpoint(Car_Driver.Current_Circuit_Race_Iterator ,C_Checkpoint);
            --HACK: in this way we add the competitor to the box queue (that is empty
            --+ by default)
            C_Checkpoint.Set_Lower_Bound_Arrival_Instant(Car_Driver.Id, Predicted_Time);

            --Those updates will be effective in the next loop (next checkpoint), so
            --+ they'll be used while doing the after-box path.
            if(BrandNewStrategy.Gas_Level /= -1.0) then
                Car_Driver.Current_Strategy.Gas_Level := BrandNewStrategy.Gas_Level;
                Car_Driver.Racing_Car.Gasoline_Level := BrandNewStrategy.Gas_Level;
            end if;
            Car_Driver.Current_Strategy.Tyre_Type := BrandNewStrategy.Tyre_Type;
            Car_Driver.Racing_Car.Tyre_Type := BrandNewStrategy.Tyre_Type;

            --We assume che every pitstop the tyre are replaced
            Car_Driver.Racing_Car.Tyre_Usury := 0.0;

         else

            if(Pit_StopDone = true) then
               Pit_StopDone := false;
               C_Checkpoint.Remove_Competitor(Car_Driver.Id);
            end if;

            Get_NextCheckPoint(Car_Driver.Current_Circuit_Race_Iterator ,C_Checkpoint);
         end if;


         if(C_CheckPoint.Is_Goal) then
            -- later on, at the end of the loop it will be updated to 1
            Current_Checkpoint.all := 0;
            Current_Lap := Current_Lap + 1;
         end if;

         -- Just for simulation purpose
         delay until(Ada.Calendar.Clock + Standard.Duration(Crossing_Time*Common.Simulation_Speed));

         --If the checkpoint is the goal, get the race over
         if C_CheckPoint.Is_Goal and Current_Lap = LastLap then
            Ada.Text_IO.Put_Line(Integer'Image(Car_Driver.Id)&" Last lap reached");
            Finished := true;

            Remove_CompetitorFromRace(Iterator_In    => Car_Driver.Current_Circuit_Race_Iterator ,
                                      PitStopDone_In => Pit_StopDone,
                                      Competitor_ID => Car_Driver.Id);

            --Not necessary to send last information to box because it should
            --+ already know that the last lap has been reached
         end if;

         exit when Finished = true;

         Current_Checkpoint.all := Current_Checkpoint.all + 1;

      end loop;

      CompetitorRadio.Close_BoxConnection(Radio => Car_Driver.Radio);

   end Competitor_Task;

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

