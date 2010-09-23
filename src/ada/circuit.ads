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

   Racetrack_Length : FLOAT := 0.0;

   --Default value for Checkpoints and max competitors qty, used
   --+ in case of troubles with conf file
   Checkpoints : POSITIVE := 2;--TODO: verify if it's necessary
   Max_Competitors : Integer;--4;

   procedure Set_Checkpoints (Qty_In : POSITIVE);
   procedure Set_Max_Competitors ( Qty_In : POSITIVE);

   --function getChanged (temp : in CHECKPOINT_SYNCH_POINT) return Boolean;
   type Racetrack is array(Integer range <>) of CHECKPOINT_SYNCH_POINT;
   type Racetrack_Point is access Racetrack;

   --The iterator is supposed to be used by the Competitor, in order
   --to allow him to move in the "correct direction"
   type Racetrack_Iterator is private;

   function Get_Iterator(Racetrack_In : Racetrack_Point) return Racetrack_Iterator;

   procedure Init_Racetrack(Racetrack_In : in out Racetrack_Point;
                            Document_In : DOCUMENT);
   procedure Set_Competitors(Racetrack_In : in out Racetrack_Point;
                             Competitors : in Common.COMPETITOR_LIST);
   procedure Get_CurrentCheckpoint(RaceIterator : in out Racetrack_Iterator;
                               CurrentCheckpoint : out CHECKPOINT_SYNCH_POINT);
   procedure Get_NextCheckpoint(RaceIterator : in out Racetrack_Iterator;
                               NextCheckpoint : out CHECKPOINT_SYNCH_POINT);
   procedure Get_ExitBoxCheckpoint(RaceIterator : in out Racetrack_Iterator;
                                   ExitBoxCheckpoint : out CHECKPOINT_SYNCH_POINT);
   procedure Get_BoxCheckpoint(RaceIterator : in out Racetrack_Iterator;
                               BoxCheckpoint : out CHECKPOINT_SYNCH_POINT);

   function Get_RaceLength(RaceIterator : Racetrack_Iterator) return Integer;
   function Get_Position(RaceIterator : Racetrack_Iterator) return Integer;
   function Get_IsFinished(RaceIterator : Racetrack_Iterator) return BOOLEAN;
   function Get_Racetrack(Racetrack_File : STRING) return Racetrack_Point;
   function Get_Checkpoint(Racetrack_In : Racetrack;
                           Position : Integer) return CHECKPOINT_SYNCH_POINT;

private

   type Racetrack_Iterator is record
      Race_Point : Racetrack_Point;
      Position : Integer := 0;
   end record;


end Circuit;
