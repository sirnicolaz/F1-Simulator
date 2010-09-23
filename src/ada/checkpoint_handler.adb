with Path_Handler;
use Path_Handler;

package body Checkpoint_Handler is

   --Checkpoint methods implementation
   procedure Set_Values(Checkpoint_In : in out Checkpoint_Point;
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

      PathsCollection : Paths_Point;

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

      Init_Paths(PathsCollection,
                 PathsQty_In,
                 Innermost_Path_Length     => Length_In,
                 Innermost_Path_Angle      => Angle_In,
                 Innermost_Path_Grip       => Grip_In,
                 Innermost_Path_Difficulty => Difficulty_In);

      Checkpoint_In.PathsCollection := new CROSSING(PathsCollection);

   end Set_Values;

   procedure Set_Goal(Checkpoint_In : in out Checkpoint) is
   begin
      Checkpoint_In.IsGoal := TRUE;
   end Set_Goal;

   function Get_Time(Checkpoint_In : Checkpoint_Point;
                     CompetitorID_In : INTEGER) return FLOAT is
   begin

      return Get_CompetitorArrivalTime(Checkpoint_In.Queue.all, CompetitorID_In);
   end Get_Time;

   protected body CHECKPOINT_SYNCH is

      -- The method set the calling task Competitor as "arrived".
      --+ If he's in the 1st position,
      --+ the guard in the waiting block related to the 1st competitor
      --+ is opened to let him essentialy take the Paths.
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

      end Signal_Leaving;


      procedure Set_Lower_Bound_Arrival_Instant(CompetitorID_In : INTEGER;
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

      end Set_Lower_Bound_Arrival_Instant;

      --The procedure virtually removes the competitor from the queue of
      --+the given checkpoint. It means that the competitor is not supposed
      --+to arrive to this checkpoint anymore.
      procedure Remove_Competitor(CompetitorID_In : INTEGER) is
      begin
         Remove_CompetitorFromQueue(F_Checkpoint.Queue.all,CompetitorID_In);
         -- Removing the competitor it may happen that the first position
         --+ of the queue turns taken by a competitor that is ready to cross
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

      entry Wait_To_Be_First(Competitor_ID : INTEGER) when true is
      begin
         requeue WaitBlock_Chain.all(Competitor_ID).Wait;
      end Wait_To_Be_First;

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

      procedure Set_Pre_Box(Box_Lane_Length : Float) is

         Pre_Box_Paths : Paths_Point;
         Max_Competitor_Qty : INTEGER := F_Checkpoint.Queue'LENGTH;

      begin

         Init_BoxLanePaths(Pre_Box_Paths,Max_Competitor_Qty,Box_Lane_Length);
         PreBox(F_Checkpoint.all).Box := new CROSSING(Pre_Box_Paths);

      end Set_Pre_Box;

      function Get_Checkpoint return Checkpoint_Point is
      begin
         return F_Checkpoint;
      end Get_Checkpoint;

   end CHECKPOINT_SYNCH;

   procedure Initialize_Checkpoint_Synch(Checkpoint_Synch_Out : out Checkpoint_Synch_Point;
                                         Sector_ID : INTEGER;
                                         Is_Goal : BOOLEAN;
                                         Length : FLOAT; -- y
                                         Angle : ANGLE_GRADE; -- alpha
                                         Grip : GRIP_RANGE;
                                         Difficulty : DIFFICULTY_RANGE;
                                         Paths_Qty : POSITIVE; -- mult
                                         Competitors_Qty : POSITIVE;
                                         Is_Pre_Box : BOOLEAN;
                                         Is_Exit_Box : BOOLEAN;
                                         Is_First_Of_The_Sector : BOOLEAN;
                                         Is_Last_Of_The_Sector : BOOLEAN) is

      Checkpoint_Temp : Checkpoint_Point;

   begin

      if ( Is_Pre_Box = false ) then
         Checkpoint_Temp := new Checkpoint;
      else
         Checkpoint_Temp := new PreBox;
      end if;

      Set_Values(Checkpoint_Temp,
                 Sector_ID,
                 Is_Goal,
                 Length,
                 Angle,
                 Grip,
                 Difficulty,
                 Paths_Qty,
                 Competitors_Qty,
                 Is_Pre_Box,
                 Is_Exit_Box,
                 Is_First_Of_The_Sector,
                 Is_Last_Of_The_Sector);

      Checkpoint_Synch_Out := new CHECKPOINT_SYNCH(Checkpoint_Temp);

   end Initialize_Checkpoint_Synch;

end Checkpoint_Handler;
