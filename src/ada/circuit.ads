with Common; use Common;

with Path_Handler; use Path_Handler;
with Checkpoint_Handler; use Checkpoint_Handler;

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

   --function getChanged (temp : in CHECKPOINT_SYNCH_POINT) return Boolean;
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

   type RACETRACK_ITERATOR is record
      Race_Point : RACETRACK_POINT;
      Position : Integer := 0;
   end record;


end Circuit;
