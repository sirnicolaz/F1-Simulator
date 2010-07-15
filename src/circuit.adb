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
                        PathsQty_In : POSITIVE;
                        Competitors_Qty : POSITIVE) is

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
      Checkpoint_In.Queue := new SORTED_QUEUE(1..Competitors_Qty);
      Init_Queue(Checkpoint_In.Queue.all);
      Init_Paths(PathsCollection,PathsQty_In);
      Checkpoint_In.PathsCollection := new CROSSING(PathsCollection);
   end Set_Values;

   procedure Set_Goal(Checkpoint_In : in out Checkpoint) is
   begin
      Checkpoint_In.IsGoal := TRUE;
   end Set_Goal;

   function Get_Time(Checkpoint_In : POINT_Checkpoint;
                     CompetitorID_In : INTEGER) return FLOAT is
   begin
--      Ada.Text_IO.Put_Line(Integer'Image(CompetitorID_In)&" : sono get_time e chiamo get_competitorArrivaltime");
      return Get_CompetitorArrivalTime(Checkpoint_In.Queue.all, CompetitorID_In);
   end Get_Time;


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

   protected body CROSSING is

      --This method update the
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

      function Get_PathTime(PathIndex : INTEGER) return FLOAT is
      begin
         return F_Paths.all(PathIndex).LastTime;
      end Get_PathTime;
   end CROSSING;

   protected body CHECKPOINT_SYNCH is

      --The method set the calling task Competitor as arrived.
      --+If he's in the 1st position,
      --+the Path2Cross is initialised,
      --+in order to let the task choose the path and "cross" the segment.
      procedure Signal_Arrival(CompetitorID_In : INTEGER;
                               Paths2Cross : out CROSSING_POINT) is
      begin
         Set_Arrived(F_Checkpoint.Queue.all,CompetitorID_In,TRUE);
--        Ada.Text_IO.Put_Line(Integer'Image(CompetitorID_In)&" : sono signal_arrival e chiamo get_position");
         if Get_Position(F_Checkpoint.Queue.all,CompetitorID_In) = 1 then
            Paths2Cross := F_Checkpoint.PathsCollection;
         else
            Paths2Cross := null; -- TODO: fix this crap
         end if;

      end Signal_Arrival;


      procedure Set_Competitors(Competitors : Common.COMPETITORS_LIST;
                                Times : Common.FLOAT_LIST) is
      begin
         Set_Competitors(F_Checkpoint.Queue.all,Competitors,Times);
      end Set_Competitors;

      procedure Signal_Leaving(CompetitorID_In : INTEGER) is
      begin
         --++++++Ada.Text_IO.Put_Line(Integer'Image(CompetitorID_In)&" : signal leaving");
         Set_Arrived(F_Checkpoint.Queue.all,CompetitorID_In,FALSE);
      end Signal_Leaving;


      procedure Set_ArrivalTime(CompetitorID_In : INTEGER;
                                Time_In : FLOAT) is
      begin
         Add_Competitor2Queue(F_Checkpoint.Queue.all,CompetitorID_In,Time_In);
         -- If in the 1st position of the queue now there is a competitor who's
         --+ tagged as "arrived", it means that he has to be notified
         --+ about the change. In this way he can start to cross the checkpoint.
         --+ The notification is sent setting the variable "CHANGED".
         if Get_IsArrived(F_Checkpoint.Queue.all,1) then
            Changed := TRUE;
         end if;

      end Set_ArrivalTime;

      --The procedure virtually removes the competitor from the queue of
      --+the given checkpoint. It means that the competitor is not supposed
      --+to arrive to this checkpoint anymore.
      procedure Remove_Competitor(CompetitorID_In : INTEGER) is
      begin
         Remove_CompetitorFromQueue(F_Checkpoint.Queue.all,CompetitorID_In);
         -- Removing the competitor it may happen that the first position
         --+ of the queue becomes taken by a competitor that is ready to cross
         --+ the checkpoint ( in such a case the Get_IsArrived function with
         --+ "1" as the second parameter returns true). If that's the case, it's
         --+ necessary to notify that competitor about the change setting
         --+ the variable "CHANGED" as we do for the Set_ArrivalTime procedure.
         if Get_IsArrived(F_Checkpoint.Queue.all,1) then
            Changed := TRUE;
         end if;
      end Remove_Competitor;

      function Get_Time(CompetitorID_In : INTEGER) return FLOAT is
      begin
         --++++++Ada.Text_IO.Put_Line(Integer'Image(CompetitorID_In)&" : sono get_time(competitorid_in) e chiamo get_time(F_checkpoint, competitorid)");
         return Get_Time(F_Checkpoint, CompetitorID_In);
      end Get_Time;

      function Get_SectorID return INTEGER is
      begin
         return F_Checkpoint.SectorID;
      end Get_SectorID;

      --Method that allows the tasks Competitor to Wait till they reach
      --the 1st position in the checkpoint queue. Once one of them is first,
      --his Paths2Cross is initialized with the corresponding CROSSING_POINT,
      --in order to let it "cross" the segment.
      entry Wait(CompetitorID_In : INTEGER;
                 Paths2Cross : out CROSSING_POINT) when Changed = TRUE is
      begin
         --++++++Ada.Text_IO.Put_Line("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"&Integer'Image(CompetitorID_In)&" : sono wait e chiamo get_position, CHANGED= "&Boolean'Image(getChanged));
         if Get_Position(F_Checkpoint.Queue.all,CompetitorID_In) = 1 then
            Changed := FALSE;
            Paths2Cross := F_Checkpoint.PathsCollection;
         end if;
--         Ada.Text_IO.Put_Line("--------********$$$$$$$$$$$$$$$$$$$$$"&Integer'Image(CompetitorID_In)&" : esco dalla WAIT, CHANGED= "&Boolean'Image(getChanged));
      end Wait;

      function getChanged return Boolean is
      begin
         return Changed;
      end getChanged;

   end CHECKPOINT_SYNCH;

   function getChanged(temp : CHECKPOINT_SYNCH_POINT) return Boolean is
   begin
      return temp.getChanged;
   end getChanged;

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
                       Current_Mult,
                       MaxCompetitors_Qty);
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
                       MaxCompetitors_Qty,
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

      Doc : Document;
      Racetrack_Out : RACETRACK_POINT;

   begin

      Doc := Common.Get_Document(Racetrack_File);

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

   procedure Set_Competitors(Racetrack_In : in out RACETRACK_POINT;
                             Competitors : in Common.COMPETITORS_LIST) is
      Race_Length : INTEGER;
      Race_It : RACETRACK_ITERATOR := Get_Iterator(Racetrack_In);
      Times : Common.FLOAT_LIST(1..Competitors'LENGTH);
      Time : FLOAT := 0.0;
   begin
      --Ada.Text_IO.Put_Line("^^^^^^^^^________________^^^^^^^^^^^ Competitors'LENGTH: "&Integer'Image(Competitors'LENGTH));
      for ind in 1..Competitors'LENGTH loop
         Times(ind) := Time;
         Time := Time + 1.0; -- The time gap between 2 following competitors isn't definitive.
      end loop;

      Race_Length := Get_RaceLength(Race_It);
      for index in 1..Race_Length loop
         Get_Checkpoint(Race_It.Race_Point.all,index).Set_Competitors(Competitors,Times);
         for indez in Times'RANGE loop
            Times(indez) := Times(indez)+1.0;
         end loop;
      end loop;
   end Set_Competitors;

   function Get_Iterator(Racetrack_In : RACETRACK_POINT) return RACETRACK_ITERATOR is
      Iterator : RACETRACK_ITERATOR;
   begin
      Iterator.Race_Point := Racetrack_In;
      Iterator.Position := 1;
      return Iterator;
   end Get_Iterator;

   procedure Get_CurrentCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                                   CurrentCheckpoint : out CHECKPOINT_SYNCH_POINT) is
   begin
      CurrentCheckpoint := RaceIterator.Race_Point(RaceIterator.Position);
   end Get_CurrentCheckpoint;

   procedure Get_NextCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                                NextCheckpoint : out CHECKPOINT_SYNCH_POINT) is
   begin
      --++++++Put_Line("Position " & INTEGER'IMAGE(RaceIterator.Position));
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
