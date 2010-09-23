with Queue;
use Queue;

with Path_Handler;
use Path_Handler;

with Common;
use Common;

package Checkpoint_Handler is

   --Checkpoint Structure delcaration.
   type Checkpoint is tagged private;
   type Checkpoint_Point is access Checkpoint'CLASS;

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
                        IsLastOfTheSector : BOOLEAN);

   function Get_Time(Checkpoint_In : Checkpoint_Point;
                     CompetitorID_In : Integer) return FLOAT;

   protected type CHECKPOINT_SYNCH(Checkpoint_In : Checkpoint_Point) is

      procedure Signal_Arrival(CompetitorID_In : Integer);
      procedure Signal_Leaving(CompetitorID_In : Integer);
      procedure Set_ArrivalTime(CompetitorID_In : Integer;
                                Time_In : FLOAT);
      procedure Remove_Competitor(CompetitorID_In : Integer);
      procedure Set_Competitors(Competitors : Common.COMPETITOR_LIST;
                                Times : Common.FLOAT_ARRAY);
      function Get_Time(CompetitorID_In : Integer) return FLOAT;

      function Is_PreBox return BOOLEAN;
      function Is_ExitBox return BOOLEAN;

      function Is_FirstOfTheSector return BOOLEAN;
      function Is_LastOfTheSector return BOOLEAN;

      function Is_Goal return BOOLEAN;

      function Get_Length return FLOAT;

      function Get_SectorID return Integer;

      entry Wait_Ready(Competitor_ID : Integer);

      procedure Get_Paths(Paths2Cross : out CROSSING_POINT;
                          Go2Box : BOOLEAN);

      procedure Set_Pre_Box(Box_Lane_Length : Float);

   private
      F_Checkpoint : Checkpoint_Point := Checkpoint_In;
      WaitBlock_Chain : access WAITING_BLOCK_ARRAY;
      Changed : BOOLEAN := false;
   end CHECKPOINT_SYNCH;


   type CHECKPOINT_SYNCH_POINT is access CHECKPOINT_SYNCH;

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
                                         Is_Last_Of_The_Sector : BOOLEAN);

private

   type Checkpoint is tagged record
      Queue : access SORTED_QUEUE;
      SectorID : Integer;
      IsGoal : BOOLEAN;
      Multiplicity : POSITIVE;
      PathsCollection : CROSSING_POINT;
      IsPreBox : BOOLEAN;
      IsExitBox : BOOLEAN;
      IsFirstOfTheSector : BOOLEAN;
      IsLastOfTheSector : BOOLEAN;
   end record;

   type PreBox is new Checkpoint
   with
      record
         Box : CROSSING_POINT;
      end record;

end Checkpoint_Handler;
