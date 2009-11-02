package body Circuit is

   procedure Set_CheckpointsQty (Qty_In : POSITIVE) is
   begin
      Checkpoints_Qty := Qty_In;
   end Set_CheckpointsQty;

   procedure Set_MaxCompetitorsQty ( Qty_In : POSITIVE) is
   begin
      MaxCompetitors_Qty := Qty_In;
   end Set_MaxCompetitorsQty;

   --PATH methods implementation
   procedure Set_Values(Path_In : in out PATH;
                        Length_In : FLOAT;
                        Angle_In : ANGLE_GRADE;
                        Grip_In : FLOAT;
                        Difficulty_In : DIFFICULTY_RANGE) is
   begin
      Path_In.Length := Length_In;
      Path_In.Angle := Angle_In;
      Path_In.Difficulty := Difficulty_In;
      Path_In.Grip := Grip_In;
   end Set_Values;

   function Get_Length(Path_In : PATH) return FLOAT is
   begin
      return Path_In.Length;
   end Get_Length;

   function Get_Angle(Path_In : PATH) return FLOAT is
   begin
      return Path_In.Angle;
   end Get_Angle;

   function Get_Grip(Path_In : PATH) return FLOAT is
   begin
      return Path_In.Grip;
   end Get_Grip;

   function Get_Difficulty(Path_In : PATH) return FLOAT is
   begin
      return Path_In.Difficulty;
   end Get_Difficulty;

   --Checkpoint methods implementation
   procedure Set_Values(Checkpoint_In : in out POINT_Checkpoint;
                        SectorID_In : INTEGER;
                        IsGoal_In : BOOLEAN;
                        Length_In : FLOAT;
                        Angle_In : ANGLE_GRADE;
                        PathsQty_In : POSITIVE) is

      PathsCollection : POINT_PATHS;

      procedure Init_Paths(Paths_Collection_In : in out POINT_PATHS;
                           Paths_Qty : INTEGER) is
      begin
         Paths_Collection_In := new PATHS(1..Paths_Qty);
         for index in 1..Paths_Qty loop
            Set_Values(Paths_Collection_In.all(index),Length_In,Angle_In,12.00,DIFFICULTY_RANGE(9.8));
         end loop;
         null;
      end Init_Paths;

   begin
      Checkpoint_In.SectorID := SectorID_In;
      Checkpoint_In.IsGoal := IsGoal_In;
      Checkpoint_In.Multiplicity :=  PathsQty_In;
      Init_Paths(PathsCollection,PathsQty_In);
      Checkpoint_In.PathsCollection := new CROSSING(PathsCollection);
   end Set_Values;

   procedure Set_Goal(Checkpoint_In : in out Checkpoint) is
   begin
      Checkpoint_In.IsGoal := TRUE;
   end Set_Goal;

   --procedure Set_Next(Checkpoint_In : in out POINT_Checkpoint;
    --                  NextCheckpoint_In : POINT_Checkpoint) is
   --begin
     -- Checkpoint_In.NextCheckpoint := NextCheckpoint_In;
   --end Set_Next;

   --function Get_Path(Checkpoint_In : POINT_Checkpoint;
   --                  Path_Num : INTEGER ) return PATH is
   --begin
   --   return Checkpoint_In.PathsCollection(Path_Num);
   --end Get_Path;

   --function Get_Next_Checkpoint(Checkpoint_In : POINT_Checkpoint) return POINT_Checkpoint is
   --begin
   --   return Checkpoint_In.NextCheckpoint;
   --end Get_Next_Checkpoint;

   --function Get_Length(Checkpoint_In : POINT_Checkpoint) return FLOAT is
   --begin
   --   return Checkpoint_In.PathsCollection(1).Length;
   --end Get_Length;

   --this resource handle the path choice by the task Competitor.
   --they're still needed some parameters to use for the evaluation,
   --like, for example, strategy and car_status.
   --Valutare se sia il caso di spostare questo funzionalità direttamente nel competitor,
   --oppure se passare anche il competitor al metodo per fare in modo che possa essere lui stesso
   --a invocare il metodo per la valutazione (in modo da non dover fare
   --uscire dal package oggetti che dovrebbero rimanere nascosti).
   protected body CROSSING is

      procedure Choose_BestPath(CompetitorID_In : INTEGER;
                                CrossingTime_Out : out FLOAT;
                                ChoosenPath_Out : out INTEGER;
                                ArrivalTime_In : FLOAT) is
         StartingInstant : FLOAT := 0.0;
         WaitingTime : FLOAT := 0.0;
         PathTime : FLOAT;
         CrossingTime : FLOAT := 0.0;
         TotalDelay : FLOAT := 0.0;
         MinDelay : FLOAT := -1.0;
         ChoosenPathIndex : INTEGER := 1;
      begin
         -- loop through paths

         for Index in F_Paths'RANGE loop
            PathTime := F_Paths.all(Index).LastTime;
            WaitingTime := PathTime - ArrivalTime_In;
            StartingInstant := PathTime;
            CrossingTime_Out := WaitingTime;
            if WaitingTime < 0.0 then
               WaitingTime := 0.0;
               StartingInstant := ArrivalTime_In;
               CrossingTime_Out := 0.0;
            end if;

            --CrossingTime := CalculateCHECKPOINT_SYNCHTime(F_Checkpoint.PathsCollection(Index),Competitor_Status,Competitor_Strategy);
            TotalDelay := StartingInstant + CrossingTime;
            if TotalDelay < MinDelay or MinDelay < 0.0 then
               MinDelay := TotalDelay;
               ChoosenPathIndex := Index;
               CrossingTime_Out := CrossingTime_Out + CrossingTime;
            end if;
         end loop;

         F_Paths.all(ChoosenPathIndex).LastTime := MinDelay;
         ChoosenPath_Out := ChoosenPathIndex;

      end Choose_BestPath;

      procedure Update_Time(Time_In : FLOAT;
                            PathIndex : INTEGER) is
      begin
         F_Paths(PathIndex).LastTime := Time_In;
      end Update_Time;


      function Get_Size return INTEGER is
      begin
         return F_Paths'LENGTH;
      end Get_Size;

      function Get_Length(PathIndex : INTEGER) return FLOAT is
      begin
         return Get_Length(F_Paths(PathIndex));
      end Get_Length;

      function Get_Angle(PathIndex : INTEGER) return FLOAT is
      begin
         return Get_Angle(F_Paths(PathIndex));
      end Get_Angle;

      function Get_Grip(PathIndex : INTEGER) return FLOAT is
      begin
           return Get_Grip(F_Paths(PathIndex));
      end Get_Grip;

      function Get_Difficulty(PathIndex : INTEGER) return FLOAT is
      begin
         return Get_Difficulty(F_Paths(PathIndex));
      end Get_Difficulty;

   end CROSSING;

   protected body CHECKPOINT_SYNCH is

      --The method set the calling task Competitor as arrived. If he's in the 1st position,
      --the CROSSING_POINT is initialized, in order to let the task "cross" the segment.
      procedure Signal_Arrival(CompetitorID_In : INTEGER;
                               Paths2Cross : out CROSSING_POINT) is
      begin
         Set_Arrived(F_Checkpoint.Queue,CompetitorID_In,TRUE);
         if Get_Position(F_Checkpoint.Queue,CompetitorID_In) = 1 then
            Paths2Cross := F_Checkpoint.PathsCollection;
         end if;
      end Signal_Arrival;

      procedure Signal_Leaving(CompetitorID_In : INTEGER) is
      begin
         Set_Arrived(F_Checkpoint.Queue,CompetitorID_In,FALSE);
      end Signal_Leaving;

      procedure Set_ArrivalTime(CompetitorID_In : INTEGER;
                                Time_In : FLOAT) is
      begin
         Add_Competitor2Queue(F_Checkpoint.Queue,CompetitorID_In,Time_In);
         if Get_IsArrived(F_Checkpoint.Queue,1) then
            Changed := TRUE;
         end if;

      end Set_ArrivalTime;

      --Method that allow the tasks Competitor to Wait til they reach
      --the 1st position in the checkpoint queue. Once one of them is first,
      --his Paths2Cross is initialized with the segment corresponding CROSSING_POINT,
      --in order to let it "cross" the segment.
      entry Wait(CompetitorID_In : INTEGER;
                 Paths2Cross : out CROSSING_POINT) when Changed = TRUE is
      begin
         if Get_Position(F_Checkpoint.Queue,CompetitorID_In) = 1 then
            Changed := FALSE;
            Paths2Cross := F_Checkpoint.PathsCollection;
         end if;

      end Wait;
   end CHECKPOINT_SYNCH;

   --RACETRACK methods implementation

   --TODO: validate input file and verify haandle exceptions
   procedure Init_Racetrack(Racetrack_In : in out RACETRACK_POINT;
                            Document_In : DOCUMENT) is
      CheckpointQty_In : INTEGER;
      Angle : ANGLE_GRADE;
      Racetrack_XML : Node_List;
      Checkpoint_XML : Node_List;
      Current_Node : Node;
      IsGoal_Attr : Attr;
      IsGoal : BOOLEAN;
      Current_Length : FLOAT;
      Current_Mult : INTEGER;
      Current_Angle : FLOAT;
      Checkpoint_Temp : POINT_Checkpoint;
      CheckpointSynch_Current : CHECKPOINT_SYNCH_POINT;

      function Get_Feature_Node(Node_In : NODE;
                           FeatureName_In : STRING) return NODE is
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

      --If there is a conf file, use it to auto-init;

      if Document_In /= null then

         Racetrack_XML := Get_Elements_By_Tag_Name(Document_In,"checkpoint");
         CheckpointQty_In := Length(Racetrack_XML);
         Racetrack_In := new RACETRACK(1..CheckpointQty_In);
         for Index in 1..CheckpointQty_In loop
            Current_Node := Item(Racetrack_XML, Index-1);
            IsGoal_Attr := Get_Named_Item (Attributes (Current_Node), "goal");

            if IsGoal_Attr = null then
               IsGoal := false;
            else
               IsGoal := Boolean'Value(Value(IsGoal_Attr));
            end if;

            Checkpoint_XML := Child_Nodes(Current_Node);
            Current_Length := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"length"))));
            Current_Mult := Positive'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"mult"))));
            Current_Angle := Float'Value(Node_Value(First_Child(Get_Feature_Node(Current_Node,"angle"))));
            Checkpoint_Temp := new Checkpoint;

            Set_Values(Checkpoint_Temp,
                       1,
                       false,
                       Current_Length,
                       Current_Angle,
                       Current_Mult);
            CheckpointSynch_Current := new CHECKPOINT_SYNCH(Checkpoint_Temp);
            Racetrack_In(Index) := CheckpointSynch_Current;
         end loop;

      else
         --else auto configure a default circular N_Checkpoints-M_paths track (with N = Checkpoints_Qty and M = MaxCompetitors_Qty -1;
         Angle := 360.00 / FLOAT(Checkpoints_Qty);
         CheckpointQty_In := Checkpoints_Qty;
         Racetrack_In := new RACETRACK(1..CheckpointQty_In);
         for Index in 1..Checkpoints_Qty loop
            Checkpoint_Temp := new Checkpoint;
            Set_Values(Checkpoint_Temp,
                       1,
                       FALSE,
                       100.00,
                       Angle,
                       MaxCompetitors_Qty);
            CheckpointSynch_Current := new CHECKPOINT_SYNCH(Checkpoint_Temp);
            Racetrack_In(Index) := CheckpointSynch_Current;
         end loop;

      end if;

      --for Index in 1..CheckpointQty_In-1 loop
         --Set_Next(Racetrack_In(Index),Racetrack_In(Index+1));
      --end loop;

      --Set_Next(Racetrack_In(CheckpointQty_In),Racetrack_In(1));
      --Set_Goal(Racetrack_In(1).all);

   end Init_Racetrack;

   function Get_Racetrack(Racetrack_File : STRING) return RACETRACK_POINT is
      Input : File_Input;
      Reader : Tree_Reader;
      Doc : Document;
      Racetrack_XML : Node_List;
      Racetrack_Length : INTEGER;
      Racetrack_Out : RACETRACK_POINT;

   procedure Try_OpenFile is
      begin

         Open(Racetrack_File,Input);

         Set_Feature(Reader,Validation_Feature,False);
         Set_Feature(Reader,Namespace_Feature,False);

         Parse(Reader,Input);

         Doc := Get_Tree(Reader);
         Racetrack_XML := Get_Elements_By_Tag_Name(Doc,"Checkpoint");
         Racetrack_Length := Length(Racetrack_XML);
      exception
            when ADA.IO_EXCEPTIONS.NAME_ERROR => Doc := null;
      end Try_OpenFile;

   begin

      Try_OpenFile;

      Init_Racetrack(Racetrack_Out, Doc);

      return Racetrack_Out;

   end Get_Racetrack;



   procedure Set_Checkpoint(Racetrack_In : in out RACETRACK;
                         Checkpoint_In : CHECKPOINT_SYNCH_POINT;
                         Position_In : POSITIVE) is
   begin
      if Position_In >= Racetrack_In'FIRST and Position_In <= Racetrack_In'LAST then
         Racetrack_In(Position_In) := Checkpoint_In;
         --if Position_In > Racetrack_In'FIRST and Racetrack_In(Position_In - 1) /= null then
         --   Set_Next(Racetrack_In(Position_In - 1), Racetrack_In(Position_In));
         --end if;
         --if Position_In = Racetrack_In'FIRST and Racetrack_In(Racetrack_In'LAST) /= null then
         --   Set_Next(Racetrack_In(Racetrack_In'LAST), Racetrack_In(Position_In));
         --end if;
         --if Position_In < Racetrack_In'LAST and Racetrack_In(Position_In + 1) /= null then
         --   Set_Next(Racetrack_In(Position_In), Racetrack_In(Position_In + 1));
         --end if;
         --if Position_In = Racetrack_In'LAST and Racetrack_In(Racetrack_In'FIRST) /= null then
         --   Set_Next(Racetrack_In(Position_In), Racetrack_In(Racetrack_In'FIRST));
         --end if;
      end if;

   end Set_Checkpoint;

   function Get_Iterator(Racetrack_In : RACETRACK_POINT) return RACETRACK_ITERATOR is
   Iterator : RACETRACK_ITERATOR;
   begin
      Iterator.Race_Point := Racetrack_In;
      Iterator.Position := 1;
      return Iterator;
   end Get_Iterator;

   procedure Get_NextCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                                NextCheckpoint : out CHECKPOINT_SYNCH_POINT) is
   begin
      if RaceIterator.Position /= RaceIterator.Race_Point'LENGTH then
         RaceIterator.Position := RaceIterator.Position + 1;
      else
         RaceIterator.Position := 1;
      end if;

      NextCheckpoint := RaceIterator.Race_Point(RaceIterator.Position);
   end Get_NextCheckpoint;

   procedure Get_PreviousCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                                    PreviousCheckpoint : out CHECKPOINT_SYNCH_POINT) is
      begin
      if RaceIterator.Position /= 1 then
         RaceIterator.Position := RaceIterator.Position - 1;
      else
         RaceIterator.Position := RaceIterator.Race_Point'LENGTH;
      end if;

      PreviousCheckpoint := RaceIterator.Race_Point(RaceIterator.Position);

   end Get_PreviousCheckpoint;

   function Get_RaceLength(RaceIterator : RACETRACK_ITERATOR) return INTEGER is
   begin
      return RaceIterator.Race_Point'LENGTH;
   end Get_RaceLength;

   function Get_Position(RaceIterator : RACETRACK_ITERATOR) return POSITIVE is
   begin
      return RaceIterator.Position;
   end Get_Position;

   --The method verifies if someone has already reached the goal
   function Get_IsFinished(RaceIterator : RACETRACK_ITERATOR) return BOOLEAN is
   begin
      return false;
   end Get_IsFinished;


   function Get_Checkpoint(Racetrack_In : RACETRACK;
                        Position : POSITIVE) return CHECKPOINT_SYNCH_POINT is
   begin
      return Racetrack_In(Position);
   end Get_Checkpoint;

   function Print_Racetrack(Racetrack_In : RACETRACK) return INTEGER is
   begin
      return 4;
   end Print_Racetrack;

end Circuit;
