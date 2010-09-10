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
                        Grip_In : GRIP_RANGE;
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

   --Method for initialising the paths of the box
   procedure Init_BoxLanePaths(Paths_Collection_In : in out POINT_PATHS;
                               Competitor_Qty : INTEGER;
                               Length : FLOAT) is
   begin
      Paths_Collection_In := new PATHS(1..Competitor_Qty);
      for index in 1..Competitor_Qty loop
         Set_Values(Paths_Collection_In.all(index),Length ,ANGLE_GRADE(180.0),GRIP_RANGE(5.0),DIFFICULTY_RANGE(1.0));
      end loop;
   end Init_BoxLanePaths;

   --Checkpoint methods implementation
   procedure Set_Values(Checkpoint_In : in out POINT_Checkpoint;
                        SectorID_In : INTEGER;
                        IsGoal_In : BOOLEAN;
                        Length_In : FLOAT; -- y
                        Angle_In : ANGLE_GRADE; -- alpha
                        Grip_In : GRIP_RANGE;
                        Difficulty_In : DIFFICULTY_RANGE;
                        PathsQty_In : POSITIVE; -- mult
                        Competitors_Qty : POSITIVE;
                        IsPreBox_In : BOOLEAN;
                        IsExitBox : BOOLEAN;
                        IsFirstOfTheSector : BOOLEAN;
                        IsLastOfTheSector : BOOLEAN) is

      PathsCollection : POINT_PATHS;

      procedure Init_Paths(Paths_Collection_In : in out POINT_PATHS;
                           Paths_Qty : INTEGER) is

         AlphaRad : FLOAT := (3.14 * Angle_In) / 180.0;
         Shortest_Side : FLOAT := Length_In;
         r : FLOAT := Shortest_Side / AlphaRad;
         Tmp_Length : FLOAT := (r * 1.0) * AlphaRad ;

      begin
         Paths_Collection_In := new PATHS(1..Paths_Qty);
         for index in 1..Paths_Qty loop
            Tmp_Length := (((FLOAT(index)-1.0) * 1.6) + r ) * AlphaRad;
            Set_Values(Paths_Collection_In.all(index),Tmp_Length ,Angle_In,GRIP_RANGE(9.00),DIFFICULTY_RANGE(9.8));
         end loop;

      end Init_Paths;

   begin
      Checkpoint_In.SectorID := SectorID_In;
      Checkpoint_In.IsGoal := IsGoal_In;
      Checkpoint_In.Multiplicity :=  PathsQty_In;
      Checkpoint_In.Queue := new SORTED_QUEUE(1..Competitors_Qty);
      Checkpoint_In.IsPreBox := IsPreBox_In;
      Checkpoint_In.IsExitBox := IsExitBox;
      Checkpoint_In.IsLastOfTheSector := IsLastOfTheSector;
      Checkpoint_In.IsFirstOfTheSector := IsFirstOfTheSector;
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

      return Get_CompetitorArrivalTime(Checkpoint_In.Queue.all, CompetitorID_In);
   end Get_Time;

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
      procedure Signal_Arrival(CompetitorID_In : INTEGER) is
      begin


         Set_Arrived(F_Checkpoint.Queue.all,CompetitorID_In,TRUE);
         if Get_Position(F_Checkpoint.Queue.all,CompetitorID_In) = 1 then

            WaitBlock_Chain.all(CompetitorID_In).Notify;
         end if;

      end Signal_Arrival;


      procedure Set_Competitors(Competitors : Common.COMPETITOR_LIST;
                                Times : Common.FLOAT_ARRAY) is
      begin
         Set_Competitors(F_Checkpoint.Queue.all,Competitors,Times);
         WaitBlock_Chain := new WAITING_BLOCK_ARRAY(1..Competitors'LENGTH);
      end Set_Competitors;

      procedure Signal_Leaving(CompetitorID_In : INTEGER) is
      begin

         Set_Arrived(F_Checkpoint.Queue.all,CompetitorID_In,FALSE);
         --NEW
         --if Get_IsArrived(F_Checkpoint.Queue.all,1) then
         --   Changed := TRUE;
         --end if;
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
            WaitBlock_Chain.all(Get_CompetitorID(F_Checkpoint.Queue.all,1)).Notify;
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
            WaitBlock_Chain.all(Get_CompetitorID(F_Checkpoint.Queue.all,1)).Notify;
            Changed := TRUE;
         end if;
      end Remove_Competitor;

      function Get_Time(CompetitorID_In : INTEGER) return FLOAT is
      begin

         return Get_Time(F_Checkpoint, CompetitorID_In);
      end Get_Time;

      function Is_PreBox return BOOLEAN is
      begin
         return F_CheckPoint.IsPreBox;
      end Is_PreBox;

      function Is_ExitBox return BOOLEAN is
      begin
         return F_CheckPoint.IsExitBox;
      end Is_ExitBox;

      function Is_FirstOfTheSector return BOOLEAN is
      begin
         return F_CheckPoint.IsFirstOfTheSector;
      end Is_FirstOfTheSector;

      function Is_LastOfTheSector return BOOLEAN is
      begin
         return F_CheckPoint.IsLastOfTheSector;
      end Is_LastOfTheSector;

      function Is_Goal return BOOLEAN is
      begin
         return F_CheckPoint.IsGoal;
      end Is_Goal;

      --The function returns the length of the shortest path
      function Get_Length return FLOAT is
      begin
         return F_CheckPoint.PathsCollection.Get_Length(1);
      end Get_Length;

      function Get_SectorID return INTEGER is
      begin
         return F_Checkpoint.SectorID;
      end Get_SectorID;

      entry Wait_Ready(Competitor_ID : INTEGER) when true is
      begin
         requeue WaitBlock_Chain.all(Competitor_ID).Wait;
      end Wait_Ready;

      --Method that allows the tasks Competitor to Wait till they reach
      --the 1st position in the checkpoint queue. Once one of them is first,
      --his Paths2Cross is initialized with the corresponding CROSSING_POINT,
      --in order to let it "cross" the segment.
      procedure Get_Paths(Paths2Cross : out CROSSING_POINT;
                          Go2Box : BOOLEAN) is
      begin

         if ( Go2Box = true ) then
            Paths2Cross := PreBox(F_Checkpoint.all).Box;
         else
            Paths2Cross := F_Checkpoint.PathsCollection;
         end if;

      end Get_Paths;

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
      NodeQty : INTEGER;
      CheckpointQty : INTEGER;
      --In an XML file, between each tag there is a hidden tag text.
      --+ So, while looping through the checkpoint node, it's necessary
      --+ to keep trace of which of the inspected nodes are checkpoints
      --+ and which ones are not.
      CheckpointCounter : INTEGER := 0;
      Sector_Qty : INTEGER := 3;
      Sector_List : Node_List;
      Checkpoint_List : Node_List;
      Feature_List : Node_List;
      Checkpoint_Index : INTEGER := 1;
      Current_Node : Node;

      Angle : ANGLE_GRADE;
      IsGoal_Attr : Attr;
      IsGoal : BOOLEAN;
      IsPreBox_Attr : Attr;
      IsPreBox : BOOLEAN;
      IsExitBox_Attr : Attr;
      IsExitBox : BOOLEAN;
      IsLastOfTheSector : BOOLEAN;
      IsFirstOfTheSector : BOOLEAN;
      Current_Length : FLOAT;
      Current_Mult : INTEGER;
      Current_Angle : FLOAT;
      Current_Grip : FLOAT;
      Current_Difficutly : FLOAT;
      Checkpoint_Temp : POINT_Checkpoint;
      CheckpointSynch_Current : CHECKPOINT_SYNCH_POINT;

      Track_Iterator : RACETRACK_ITERATOR;
      BoxLane_Length : FLOAT;
      PreBox_Checkpoint : POINT_Checkpoint;
      PreBox_Paths : POINT_PATHS;
   begin

      --If there is a conf file, use it to auto-init;


      Ada.Text_IO.Put_Line("Start building circuit");

      if Document_In /= null then



         --Find out the number of checkpoint and allocate the Racetrack
         CheckPoint_List := Get_Elements_By_Tag_Name(Document_In,"checkpoint");
         CheckpointQty := Length(CheckPoint_List);
         Racetrack_In := new RACETRACK(0..CheckpointQty);

         --Loop through the sectors and, for each one, init the related checkpoints
         Sector_List := Get_Elements_By_Tag_Name(Document_In,"sector");

         -- 3 is the standard number of sector in a circuit
         for Index in 1..3 loop
            --Taking the first sector
            Current_Node := Item(Sector_List, Index-1);
            CheckPoint_List := Child_Nodes(Current_Node);

            NodeQty := Length(CheckPoint_List);
            CheckpointQty := NodeQty - (NodeQty/2+1);
            Ada.Text_IO.Put_Line(Common.IntegerToString(CheckpointQty) & " checkpoints");

            --Retrieve the information contained in each checkpoint (if we are
            --+ dealing with a checkpoint node)
            CheckpointCounter := 0;
            for Indez in 1..NodeQty loop
               if(DOM.Core.Nodes.Node_Name(Item(CheckPoint_List,Indez-1)) = "checkpoint") then
                  CheckpointCounter := CheckpointCounter + 1;

                  Current_Node := Item(CheckPoint_List, Indez-1);
                  IsGoal_Attr := Get_Named_Item (Attributes (Current_Node), "goal");

                  if IsGoal_Attr = null then
                     IsGoal := false;
                  else
                     IsGoal := Boolean'Value(Value(IsGoal_Attr));
                  end if;

                  IsPreBox_Attr := Get_Named_Item (Attributes (Current_Node), "preBox");

                  if IsPreBox_Attr = null then
                     IsPreBox := false;
                  else
                     IsPreBox := Boolean'Value(Value(IsPreBox_Attr));
                  end if;

                  IsExitBox_Attr := Get_Named_Item (Attributes (Current_Node), "exitBox");

                  if IsExitBox_Attr = null then
                     IsExitBox := false;
                  else
                     IsExitBox := Boolean'Value(Value(IsExitBox_Attr));
                  end if;

                  Feature_List := Child_Nodes(Current_Node);
                  Current_Length := Float'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"length"))));
                  RaceTrack_Length := RaceTrack_Length + Current_Length;--TODO: decide whether to keep the shortest path length or the longest one to calculate the total circuit length

                  Current_Mult := Positive'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"mult"))));
                  Current_Angle := Float'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"angle"))));
                  Current_Grip := Float'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"grip"))));
                  Current_Difficutly := Float'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"difficulty"))));

                  if IsPreBox = false then
                     Checkpoint_Temp := new Checkpoint;
                  else
                     Checkpoint_Temp := new PreBox;
                     PreBox_Checkpoint := Checkpoint_Temp;
                  end if;

                  if(CheckpointCounter = 1) then

                     IsFirstOfTheSector := true;
                     IsLastOfTheSector := false;
                  elsif (CheckpointCounter = CheckpointQty) then

                     IsFirstOfTheSector := false;
                     IsLastOfTheSector := true;
                  else
                     IsFirstOfTheSector := false;
                     IsLastOfTheSector := false;
                  end if;

                  Set_Values(Checkpoint_Temp,
                             Index,
                             IsGoal,
                             Current_Length,
                             Current_Angle,
                             Current_Grip,
                             Current_Difficutly,
                             Current_Mult,
                             MaxCompetitors_Qty,
                             IsPreBox,
                             IsExitBox,
                             IsFirstOfTheSector,
                             IsLastOfTheSector);

                  CheckpointSynch_Current := new CHECKPOINT_SYNCH(Checkpoint_Temp);
                  Racetrack_In(Checkpoint_Index) := CheckpointSynch_Current;
                  Checkpoint_Index := Checkpoint_Index + 1;

               end if;
            end loop;

         end loop;

      else
         --else auto configure a default circular N_Checkpoints-M_paths track (with N = Checkpoints_Qty and M = MaxCompetitors_Qty -1;
         Angle := 360.00 / FLOAT(Checkpoints_Qty);
         CheckpointQty := Checkpoints_Qty;
         Racetrack_In := new RACETRACK(1..CheckpointQty);
         for Index in 1..Checkpoints_Qty loop
            Checkpoint_Temp := new Checkpoint;
            RaceTrack_Length := RaceTrack_Length + 100.00;--TODO: decide whether to keep the shortest path length

            if(Index = 1) then
               IsFirstOfTheSector := true;
               IsLastOfTheSector := false;
            elsif (Index = CheckpointQty) then
               IsFirstOfTheSector := false;
               IsLastOfTheSector := true;
            else
               IsFirstOfTheSector := false;
               IsLastOfTheSector := false;
            end if;

            Set_Values(Checkpoint_Temp,
                       1,
                       FALSE,
                       100.00,
                       Angle,
                       5.0,
                       5.0,
                       MaxCompetitors_Qty,
                       MaxCompetitors_Qty,
                       False,
                       False,
                       IsFirstOfTheSector,
                       IsLastOfTheSector);
            CheckpointSynch_Current := new CHECKPOINT_SYNCH(Checkpoint_Temp);
            Racetrack_In(Index) := CheckpointSynch_Current;

         end loop;

      end if;

      --Setting the box lane
      ---The method find out the pre-box and the exit-box checkpoint. The
      --+length between them will be the total length of the box.
      --+ Such lane has a checkpoint in the middle.
      Track_Iterator := Get_Iterator(Racetrack_In);

      Get_CurrentCheckpoint(Track_Iterator,CheckpointSynch_Current);
      while CheckpointSynch_Current.Is_PreBox /= true loop
         Get_NextCheckpoint(Track_Iterator,CheckpointSynch_Current);
      end loop;

      BoxLane_Length := CheckpointSynch_Current.Get_Length;

      Get_NextCheckpoint(Track_Iterator,CheckpointSynch_Current);
      while CheckpointSynch_Current.Is_ExitBox /= true loop
         BoxLane_Length := BoxLane_Length + CheckpointSynch_Current.Get_Length;
         Get_NextCheckpoint(Track_Iterator,CheckpointSynch_Current);
      end loop;

      --The box lane paths has to be initilised in a different way than the usual
      --+paths.
      Init_BoxLanePaths(PreBox_Paths,MaxCompetitors_Qty,FLOAT'CEILING(BoxLane_Length/2.0));
      PreBox(PreBox_Checkpoint.all).Box := new CROSSING(PreBox_Paths);

      --Initialise the box checkpoint that'll take the position 0 of the RaceTrack.
      --+ that position is never inspected by the iteration function.
      --+ Only the Get_BoxCheckPoint directly access that location of the array.
      Checkpoint_Temp := new Checkpoint;
      Set_Values(Checkpoint_Temp,
                 3, --Sector ID
                 TRUE, --IsGoal
                 FLOAT'CEILING(BoxLane_Length/2.0), -- Length
                 180.0, --Angle
                 5.0, --Grip TODO: give a not standard value to this one and following
                 1.0, --Difficulty
                 MaxCompetitors_Qty, -- Multiplicity
                 MaxCompetitors_Qty,--Competitor quantity
                 FALSE, -- Is Pre Box
                 FALSE, -- Is Exit box
                 TRUE, -- Is first one of the sector
                 FALSE); -- Is last one of the sector

      --In this way we use the path generator included into the Set values.
      --+ But the paths after the box should be like the ones after the prebox.
      --+verify TODO
      CheckpointSynch_Current := new CHECKPOINT_SYNCH(Checkpoint_Temp);
      Ada.Text_IO.Put_Line("Length of box " &Common.FloatToString(RaceTrack_In(7).Get_Length));
      RaceTrack_In(0) := CheckpointSynch_Current;

      -- "-1" because the box has not to be included in the number of checkpoints
      Checkpoints_Qty := RaceTrack_In'LENGTH-1;
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
                            Position_In : INTEGER) is
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
                             Competitors : in Common.COMPETITOR_LIST) is
      Race_Length : INTEGER;
      Race_It : RACETRACK_ITERATOR := Get_Iterator(Racetrack_In);
      Times : Common.FLOAT_ARRAY(1..Competitors'LENGTH);
      Time : FLOAT := 0.0;
   begin

      for ind in 1..Competitors'LENGTH loop
         Times(ind) := Time;
         Time := Time + 1.0; -- TODO: The time gap between 2 following competitors isn't definitive.
      end loop;

      Race_Length := Get_RaceLength(Race_It);
      for index in 1..Race_Length-1 loop
         Get_Checkpoint(Race_It.Race_Point.all,index).Set_Competitors(Competitors,Times);
         for indez in Times'RANGE loop
            Times(indez) := Times(indez)+1.0;
         end loop;
      end loop;

      --TODO: this method is experimental. The box need to be treated in a different
      --+ way. All positions are -1 set (competitor removed). When a competitor arrives,
      --+ he add himself to the checkpoint queue. Once fnished, he remove himself again.
      --+ The box can be available on demand and even if a .. TODO explanation

      for ind in 1..Competitors'LENGTH loop
         Times(ind) := 1.0;
      end loop;

      Get_Checkpoint(Race_It.Race_Point.all,0).Set_Competitors(Competitors,Times);
      for indez in Competitors'RANGE loop
         Get_Checkpoint(Race_It.Race_Point.all,0).Remove_Competitor(indez);
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

   --TODO: test
   procedure Get_NextCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                                NextCheckpoint : out CHECKPOINT_SYNCH_POINT) is
   begin
      --++++++Put_Line("Position " & INTEGER'IMAGE(RaceIterator.Position));
      if RaceIterator.Position = 0 then
         RaceIterator.Position := 1;
         Get_CurrentCheckpoint(RaceIterator,
                               NextCheckpoint);
         if(NextCheckpoint.Is_ExitBox = false) then
            Get_ExitBoxCheckpoint(RaceIterator,NextCheckpoint);
         end if;
      -- LENGTH - 1 is due to the box in position 0
      else
         if RaceIterator.Position /= RaceIterator.Race_Point'LENGTH-1 then
            RaceIterator.Position := RaceIterator.Position + 1;
         else
            RaceIterator.Position := 1;
         end if;
         NextCheckpoint := RaceIterator.Race_Point(RaceIterator.Position);
      end if;
   end Get_NextCheckpoint;

   --TODO: update to make it work with Box checkpoint
   procedure Get_PreviousCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                                    PreviousCheckpoint : out CHECKPOINT_SYNCH_POINT) is
   begin
      if RaceIterator.Position /= 1 then
         RaceIterator.Position := RaceIterator.Position - 1;
      else
         RaceIterator.Position := RaceIterator.Race_Point'LENGTH-1;
      end if;

      PreviousCheckpoint := RaceIterator.Race_Point(RaceIterator.Position);

   end Get_PreviousCheckpoint;

   procedure Get_ExitBoxCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                                   ExitBoxCheckpoint : out CHECKPOINT_SYNCH_POINT) is
      Tmp_Checkpoint : CHECKPOINT_SYNCH_POINT;
   begin
      loop
         Get_NextCheckpoint(RaceIterator,Tmp_Checkpoint);
         exit when Tmp_Checkpoint.Is_ExitBox;
      end loop;

      ExitBoxCheckpoint := Tmp_Checkpoint;
   end Get_ExitBoxCheckpoint;

   procedure Get_BoxCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                               BoxCheckpoint : out CHECKPOINT_SYNCH_POINT) is
   begin

      RaceIterator.Position := 0;
      BoxCHeckPoint :=  RaceIterator.Race_Point(0);

   end Get_BoxCheckpoint;

   --Ti returns the length including the index 0 box
   function Get_RaceLength(RaceIterator : RACETRACK_ITERATOR) return INTEGER is
   begin
      return RaceIterator.Race_Point'LENGTH;
   end Get_RaceLength;

   function Get_Position(RaceIterator : RACETRACK_ITERATOR) return INTEGER is
   begin
      return RaceIterator.Position;
   end Get_Position;

   --The method verifies if someone has already reached the goal
   function Get_IsFinished(RaceIterator : RACETRACK_ITERATOR) return BOOLEAN is
   begin
      return false;
   end Get_IsFinished;


   function Get_Checkpoint(Racetrack_In : RACETRACK;
                           Position : INTEGER) return CHECKPOINT_SYNCH_POINT is
   begin
      return Racetrack_In(Position);
   end Get_Checkpoint;

   function Print_Racetrack(Racetrack_In : RACETRACK) return INTEGER is
   begin
      return 4;
   end Print_Racetrack;

end Circuit;
