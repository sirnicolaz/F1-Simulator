package body Circuit is

   procedure Set_Checkpoints (Qty_In : POSITIVE) is
   begin
      Checkpoints := Qty_In;
   end Set_Checkpoints;

   procedure Set_Max_Competitors ( Qty_In : POSITIVE) is
   begin
      Max_Competitors := Qty_In;
   end Set_Max_Competitors;

   --Racetrack methods implementation

   procedure Init_Racetrack(Racetrack_In : in out Racetrack_Point;
                            Document_In : DOCUMENT) is
      NodeQty : Integer;
      --Checkpoints : Integer;

      -- Between each XML tag there is a hidden "text" tag.
      --+ So, while looping through the Checkpoint nodes, it's necessary
      --+ to keep trace how many Checkpoints have been read.
      CheckpointCounter : Integer := 0;
      Sector_Qty : Integer := 3;
      Sector_List : Node_List;
      Checkpoint_List : Node_List;
      Feature_List : Node_List;
      Checkpoint_Index : Integer := 1;
      Current_Node : Node;

      Angle : ANGLE_GRADE;
      IsGoal_Attr : Attr;
      IsGoal : BOOLEAN;
      Is_Pre_Box_Attr : Attr;
      Is_Pre_Box : BOOLEAN;
      Is_Exit_Box_Attr : Attr;
      Is_Exit_Box : BOOLEAN;
      Is_Last_Of_The_Sector : BOOLEAN;
      Is_First_Of_The_Sector : BOOLEAN;
      Current_Length : Float;
      Current_Mult : Integer;
      Current_Angle : Float;
      Current_Grip : Float;
      Checkpoint_Synch_Current : Checkpoint_Synch_Point;

      Track_Iterator : Racetrack_Iterator;
      BoxLane_Length : Float;
   begin

      --If there is a conf file, use it to auto-init;
      Ada.Text_IO.Put_Line("Start building circuit");

      if Document_In /= null then

         --Find out the number of Checkpoint and allocate the Racetrack
         Checkpoint_List := Get_Elements_By_Tag_Name(Document_In,"checkpoint");
         Checkpoints := Length(Checkpoint_List);
         Racetrack_In := new Racetrack(0..Checkpoints);

         --Loop through the sectors and, for each one, init the related Checkpoints
         Sector_List := Get_Elements_By_Tag_Name(Document_In,"sector");

         -- 3 is the standard number of sector in a circuit
         for Index in 1..3 loop
            --Taking the first sector
            Current_Node := Item(Sector_List, Index-1);
            Checkpoint_List := Child_Nodes(Current_Node);

            NodeQty := Length(Checkpoint_List);
            Checkpoints := NodeQty - (NodeQty/2+1);
            Ada.Text_IO.Put_Line(Common.Integer_To_String(Checkpoints) & " Checkpoints");

            --Retrieve the information contained in each Checkpoint (if we are
            --+ dealing with a Checkpoint node)
            CheckpointCounter := 0;
            for Indez in 1..NodeQty loop
               if(DOM.Core.Nodes.Node_Name(Item(Checkpoint_List,Indez-1)) = "checkpoint") then
                  CheckpointCounter := CheckpointCounter + 1;

                  Current_Node := Item(Checkpoint_List, Indez-1);
                  IsGoal_Attr := Get_Named_Item (Attributes (Current_Node), "goal");

                  if IsGoal_Attr = null then
                     IsGoal := False;
                  else
                     IsGoal := Boolean'Value(Value(IsGoal_Attr));
                  end if;

                  Is_Pre_Box_Attr := Get_Named_Item (Attributes (Current_Node), "preBox");

                  if Is_Pre_Box_Attr = null then
                     Is_Pre_Box := False;
                  else
                     Is_Pre_Box := Boolean'Value(Value(Is_Pre_Box_Attr));
                  end if;

                  Is_Exit_Box_Attr := Get_Named_Item (Attributes (Current_Node), "exitBox");

                  if Is_Exit_Box_Attr = null then
                     Is_Exit_Box := False;
                  else
                     Is_Exit_Box := Boolean'Value(Value(Is_Exit_Box_Attr));
                  end if;

                  Feature_List := Child_Nodes(Current_Node);
                  Current_Length := Float'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"length"))));
                  Racetrack_Length := Racetrack_Length + Current_Length;

                  Current_Mult := Positive'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"mult"))));
                  Current_Angle := Float'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"angle"))));
                  Current_Grip := Float'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"grip"))));

                  if(CheckpointCounter = 1) then
                     Is_First_Of_The_Sector := True;
                     Is_Last_Of_The_Sector := False;
                  elsif (CheckpointCounter = Checkpoints) then
                     Is_First_Of_The_Sector := False;
                     Is_Last_Of_The_Sector := True;
                  else
                     Is_First_Of_The_Sector := False;
                     Is_Last_Of_The_Sector := False;
                  end if;

                  Initialize_Checkpoint_Synch(Checkpoint_Synch_Current,
                                              Index,
                                              IsGoal,
                                              Current_Length,
                                              Current_Angle,
                                              Current_Grip,
                                              1.0,
                                              Current_Mult,
                                              Max_Competitors,
                                              Is_Pre_Box,
                                              Is_Exit_Box,
                                              Is_First_Of_The_Sector,
                                              Is_Last_Of_The_Sector);

                  Racetrack_In(Checkpoint_Index) := Checkpoint_Synch_Current;
                  Checkpoint_Index := Checkpoint_Index + 1;

               end if;
            end loop;

         end loop;
	  Ada.Text_IO.Put_Line("Race Length " & Float'Image(Racetrack_Length));
      else
         --else automatically configure a default circular N_Checkpoints-M_Paths track (with N = Checkpoints and M = Max_Competitors -1;
         Angle := 360.00 / Float(Checkpoints);
         Checkpoints := Checkpoints;
         Racetrack_In := new Racetrack(1..Checkpoints);
         for Index in 1..Checkpoints loop
            Racetrack_Length := Racetrack_Length + 100.00;--TODO: decide whether to keep the shortest path Length

            if(Index = 1) then
               Is_First_Of_The_Sector := True;
               Is_Last_Of_The_Sector := False;
            elsif (Index = Checkpoints) then
               Is_First_Of_The_Sector := False;
               Is_Last_Of_The_Sector := True;
            else
               Is_First_Of_The_Sector := False;
               Is_Last_Of_The_Sector := False;
            end if;

            Initialize_Checkpoint_Synch(Checkpoint_Synch_Current,
                                        1,
                                        False,
                                        100.00,
                                        Angle,
                                        5.0,
                                        5.0,
                                        Max_Competitors,
                                        Max_Competitors,
                                        False,
                                        False,
                                        Is_First_Of_The_Sector,
                                        Is_Last_Of_The_Sector);

            Racetrack_In(Index) := Checkpoint_Synch_Current;

         end loop;

      end if;

      --Setting the box lane
      ---The method finds the pre-box and the exit-box checkpoints. The
      --+ lane length between them will be the total Length of the box.
      --+ Such lane has a Checkpoint in the middle (the box).
      Track_Iterator := Get_Iterator(Racetrack_In);

      Get_CurrentCheckpoint(Track_Iterator,Checkpoint_Synch_Current);

      declare
         Pre_Box_Checkpoint : Checkpoint_Synch_Point;
      begin

         while Checkpoint_Synch_Current.Is_PreBox /= True loop
            Get_NextCheckpoint(Track_Iterator,Checkpoint_Synch_Current);
         end loop;

         Pre_Box_Checkpoint := Checkpoint_Synch_Current;
         BoxLane_Length := Checkpoint_Synch_Current.Get_Length;

         Get_NextCheckpoint(Track_Iterator,Checkpoint_Synch_Current);
         while Checkpoint_Synch_Current.Is_ExitBox /= True loop
            BoxLane_Length := BoxLane_Length + Checkpoint_Synch_Current.Get_Length;
            Get_NextCheckpoint(Track_Iterator,Checkpoint_Synch_Current);
         end loop;

         Ada.Text_IO.Put_Line("Length of box " & Float'Image(BoxLane_Length));
         -- The prebox checkpoint cen bring either to the next segment of the circuir
         --+ or to the box lane. So the box lane Paths are set here.
         Pre_Box_Checkpoint.Set_Pre_Box(Float'Ceiling(BoxLane_Length/2.0));
      end;
      --Initialise the box Checkpoint that'll take the position 0 in the Racetrack.
      --+ that position is never inspected by the iteration function.
      --+ Only the Get_BoxCheckpoint directly access that location of the array.
      Initialize_Checkpoint_Synch(Checkpoint_Synch_Current,
                                  3, --Sector ID
                                  True, --IsGoal
                                  Float'Ceiling(BoxLane_Length/2.0), -- Length
                                  0.0, --Angle
                                  5.0, --Grip TODO: give a not standard value to this one and following
                                  1.0, --Difficulty
                                  Max_Competitors, -- Multiplicity
                                  Max_Competitors,--Competitor quantity
                                  False, -- Is Pre Box
                                  False, -- Is Exit box
                                  True, -- Is first one of the sector
                                  False); -- Is last one of the sector

      --In this way we use the path generator included into the Set values.
      --+ But the Paths after the box should be like the ones after the prebox.
      Racetrack_In(0) := Checkpoint_Synch_Current;

      -- "-1" because the box has not to be included in the amount of Checkpoints
      Checkpoints := Racetrack_In'Length-1;

   end Init_Racetrack;

   function Get_Racetrack(Racetrack_File : STRING) return Racetrack_Point is

      Doc : Document;
      Racetrack_Out : Racetrack_Point;

   begin
      Doc := Common.Get_Document(Racetrack_File);

      Init_Racetrack(Racetrack_Out, Doc);

      return Racetrack_Out;

   end Get_Racetrack;

   procedure Set_Competitors(Racetrack_In : in out Racetrack_Point;
                             Competitors : in Common.Competitor_List) is
      Race_Length : Integer;
      Race_It : Racetrack_Iterator := Get_Iterator(Racetrack_In);
      Times : Common.Float_ARRAY(1..Competitors'Length);
      Time : Float := 0.0;
   begin

      for ind in 1..Competitors'Length loop
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

      -- The box need to be treated in a different
      --+ way: all positions are set to -1 (competitor removed). When a competitor arrives,
      --+ he add himself to the Checkpoint queue. Once he finishes, he removes himself again.
      --+ It's a FIFO that doesn't consider the lower bound time instant like in the
      --+ other Checkpoints. That's because
      --+     - the box lanes have multiplicity equal to the competitor amount
      --+     - the paths in the box lane have the same features
      --+ This ensures that:
      --+     - there is no waiting time to cross a choosen path
      --+     - no matter which path a competitor chooses, they are all equal
      --+ So,when a competitor enters the boxlane, there will be no delay created
      --+ by other competitors. This ensures that even if the competitors take
      --+ the box Checkpoint in different instants among different executions, there
      --+ the crossing time will be the same.
      for ind in 1..Competitors'Length loop
         Times(ind) := 1.0;
      end loop;

      Get_Checkpoint(Race_It.Race_Point.all,0).Set_Competitors(Competitors,Times);
      for indez in Competitors'RANGE loop
         Get_Checkpoint(Race_It.Race_Point.all,0).Remove_Competitor(indez);
      end loop;

   end Set_Competitors;

   function Get_Iterator(Racetrack_In : Racetrack_Point) return Racetrack_Iterator is
      Iterator : Racetrack_Iterator;
   begin
      Iterator.Race_Point := Racetrack_In;
      Iterator.Position := 1;
      return Iterator;
   end Get_Iterator;

   procedure Get_CurrentCheckpoint(RaceIterator : in out Racetrack_Iterator;
                                   CurrentCheckpoint : out Checkpoint_Synch_Point) is
   begin
      CurrentCheckpoint := RaceIterator.Race_Point(RaceIterator.Position);
   end Get_CurrentCheckpoint;

   procedure Get_NextCheckpoint(RaceIterator : in out Racetrack_Iterator;
                                NextCheckpoint : out Checkpoint_Synch_Point) is
   begin
      --++++++Put_Line("Position " & Integer'Image(RaceIterator.Position));
      if RaceIterator.Position = 0 then
         RaceIterator.Position := 1;
         Get_CurrentCheckpoint(RaceIterator,
                               NextCheckpoint);
         if(NextCheckpoint.Is_ExitBox = False) then
            Get_ExitBoxCheckpoint(RaceIterator,NextCheckpoint);
         end if;
      -- Length - 1 is due to the box in position 0
      else
         if RaceIterator.Position /= RaceIterator.Race_Point'Length-1 then
            RaceIterator.Position := RaceIterator.Position + 1;
         else
            RaceIterator.Position := 1;
         end if;
         NextCheckpoint := RaceIterator.Race_Point(RaceIterator.Position);
      end if;
   end Get_NextCheckpoint;

   procedure Get_ExitBoxCheckpoint(RaceIterator : in out Racetrack_Iterator;
                                   ExitBoxCheckpoint : out Checkpoint_Synch_Point) is
      Tmp_Checkpoint : Checkpoint_Synch_Point;
   begin
      loop
         Get_NextCheckpoint(RaceIterator,Tmp_Checkpoint);
         exit when Tmp_Checkpoint.Is_ExitBox;
      end loop;

      ExitBoxCheckpoint := Tmp_Checkpoint;
   end Get_ExitBoxCheckpoint;

   procedure Get_BoxCheckpoint(RaceIterator : in out Racetrack_Iterator;
                               BoxCheckpoint : out Checkpoint_Synch_Point) is
   begin

      RaceIterator.Position := 0;
      BoxCheckpoint :=  RaceIterator.Race_Point(0);

   end Get_BoxCheckpoint;

   --Ti returns the Length including the index 0 box
   function Get_RaceLength(RaceIterator : Racetrack_Iterator) return Integer is
   begin
      return RaceIterator.Race_Point'Length;
   end Get_RaceLength;

   function Get_Position(RaceIterator : Racetrack_Iterator) return Integer is
   begin
      return RaceIterator.Position;
   end Get_Position;

   --The method verifies if someone has already reached the goal
   function Get_IsFinished(RaceIterator : Racetrack_Iterator) return BOOLEAN is
   begin
      return False;
   end Get_IsFinished;

   function Get_Checkpoint(Racetrack_In : Racetrack;
                           Position : Integer) return Checkpoint_Synch_Point is
   begin
      return Racetrack_In(Position);
   end Get_Checkpoint;

end Circuit;
