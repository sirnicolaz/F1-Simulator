with Common; use Common;
with Path_Handler; use Path_Handler;
with Queue; use Queue;
with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes; use DOM.Core.Nodes;
with DOM.Core.Attrs; use DOM.Core.Attrs;
with Ada.IO_Exceptions;

with Ada.Text_IO;
use Ada.Text_IO;


package Circuit is

   RaceTrack_Length : FLOAT := 0.0;

   --Default value for Checkpoints and max competitors qty, used
   --+ in case of troubles with conf file
   Checkpoints_Qty : POSITIVE := 2;--TODO: verify if it's necessary
   MaxCompetitors_Qty : Integer;--4;

   procedure Set_CheckpointsQty (Qty_In : POSITIVE);
   procedure Set_MaxCompetitorsQty ( Qty_In : POSITIVE);

   --Checkpoint Structure delcaration.
   type Checkpoint is tagged private;
   type Checkpoint_Point is access Checkpoint'CLASS;


   function Get_Time(Checkpoint_In : Checkpoint_Point;
                     CompetitorID_In : Integer) return FLOAT;


   protected type CROSSING(Paths_In : Paths_Point) is
      procedure Update_Time(Time_In : in FLOAT;
                            PathIndex : in Integer);
      function Get_Size return Integer;
      function Get_Length(PathIndex : Integer) return FLOAT;
      function Get_Angle(PathIndex : Integer) return FLOAT;
      function Get_Grip(PathIndex : Integer) return FLOAT;
      function Get_PathTime(PathIndex : Integer) return FLOAT;

   private
      F_Paths : Paths_Point := Paths_In;
   end CROSSING;

   type CROSSING_POINT is access CROSSING;

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

      function getChanged return Boolean;

      entry Wait_Ready(Competitor_ID : Integer);

      procedure Get_Paths(Paths2Cross : out CROSSING_POINT;
                          Go2Box : BOOLEAN);

   private
      F_Checkpoint : Checkpoint_Point := Checkpoint_In;
      WaitBlock_Chain : access WAITING_BLOCK_ARRAY;
      Changed : BOOLEAN := false;
   end CHECKPOINT_SYNCH;


   type CHECKPOINT_SYNCH_POINT is access CHECKPOINT_SYNCH;
   function getChanged (temp : in CHECKPOINT_SYNCH_POINT) return Boolean;
   type RACETRACK is array(Integer range <>) of CHECKPOINT_SYNCH_POINT;
   type RACETRACK_POINT is access RACETRACK;

   --The iterator is supposed to be used by the Competitor, in order
   --to allow him to move in the "correct direction"
   type RACETRACK_ITERATOR is private;
   procedure Init_Racetrack(Racetrack_In : in out RACETRACK_POINT;
                            Document_In : DOCUMENT);
   procedure Set_Checkpoint(Racetrack_In : in out RACETRACK;
                         Checkpoint_In : CHECKPOINT_SYNCH_POINT;
                            Position_In : Integer);
   procedure Set_Competitors(Racetrack_In : in out RACETRACK_POINT;
                             Competitors : in Common.COMPETITOR_LIST);
   function Get_Iterator(Racetrack_In : RACETRACK_POINT) return RACETRACK_ITERATOR;
   procedure Get_CurrentCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                               CurrentCheckpoint : out CHECKPOINT_SYNCH_POINT);
   procedure Get_NextCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                               NextCheckpoint : out CHECKPOINT_SYNCH_POINT);
   procedure Get_PreviousCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                                    PreviousCheckpoint : out CHECKPOINT_SYNCH_POINT);
   procedure Get_ExitBoxCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                                   ExitBoxCheckpoint : out CHECKPOINT_SYNCH_POINT);
   procedure Get_BoxCheckpoint(RaceIterator : in out RACETRACK_ITERATOR;
                               BoxCheckpoint : out CHECKPOINT_SYNCH_POINT);
   function Get_RaceLength(RaceIterator : RACETRACK_ITERATOR) return Integer;
   function Get_Position(RaceIterator : RACETRACK_ITERATOR) return Integer;
   function Get_IsFinished(RaceIterator : RACETRACK_ITERATOR) return BOOLEAN;
   function Get_Racetrack(Racetrack_File : STRING) return RACETRACK_POINT;
   function Get_Checkpoint(Racetrack_In : RACETRACK;
                           Position : Integer) return CHECKPOINT_SYNCH_POINT;
   function Print_Racetrack(Racetrack_In : RACETRACK) return Integer;

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

   type RACETRACK_ITERATOR is record
      Race_Point : RACETRACK_POINT;
      Position : Integer := 0;
   end record;


end Circuit;
