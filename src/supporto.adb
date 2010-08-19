
with System;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
with Ada.Calendar;
--  with Competitor;
--  use Competitor;
with Competition_Monitor;
--use Competition;
with Circuit;
use Circuit;
with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes; use DOM.Core.Nodes;
with DOM.Core.Attrs; use DOM.Core.Attrs;
with Ada.IO_Exceptions;
with OnBoardComputer;
use OnBoardComputer;
with Common;
use Common;
  with Stats;
  use Stats;
with supporto;

package body supporto is
task body prova is
--     begin
--        Ada.Text_IO.Put_Line("TASK : faccio una getInfo su una cosa che ancora non esiste");
--        Ada.Text_IO.Put_Line("TASK : getInfo ... \n"&Competition_Monitor.getInfo(0,2,1));
--        Ada.Text_IO.Put_Line("TASK : fine esecuzione");
--     end prova;
--  end supporto;

  -- taskProva : supporto.prova;
--   RaceTrackTemp : Circuit.RACETRACK_POINT :=Get_Racetrack("./obj/racetrack.xml");
   obc : COMPUTER_POINT := new COMPUTER;
   compStats : COMP_STATS_POINT := new COMP_STATS;
   predictedTime : FLOAT := 150.0;
   upd : FLOAT := 100.0;
   global : GLOBAL_STATS_HANDLER_POINT;
   temp : GENERIC_STATS_POINT := new GENERIC_STATS;
   temp_2 : GENERIC_STATS_POINT;
   temp_new : GENERIC_STATS_POINT := new GENERIC_STATS;
   class : CLASSIFICATION_TABLE_POINT := new CLASSIFICATION_TABLE(1..10);
   updateStr : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   updateStr2 : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   start: Competition_Monitor.STARTSTOPHANDLER_POINT;

begin


   --     temp := new GENERIC_STATS_POINT;
     temp_2 := temp;
     global := new GLOBAL_STATS_HANDLER(new FLOAT'(upd), temp);--new GENERIC_STATS);--'(temp.all));

     Unbounded_String.Set_Unbounded_String(updateStr,
                                                  "<?xml version=""1.0""?>" &
                                                  "<update>" &
                                                  "<gasLevel>0.1<gasLevel>" &
                                                  "<tyreUsury>0.1</tyreUsury>" &
                                                  "<time>150.0</time>" &
                                                  "<lap>0</lap>" &
                                                  "<sector>1</sector>"
                                          );
   Unbounded_String.Set_Unbounded_String(updateStr2,
                                                  "<?xml version=""1.0""?>" &
                                                  "<update>" &
                                                  "<gasLevel>0.5<gasLevel>" &
                                                  "<tyreUsury>0.4</tyreUsury>" &
                                                  "<time>100.0</time>" &
                                                  "<lap>0</lap>" &
                                                  "<sector>2</sector>"
                                          );
   start := Competition_Monitor.Init(10,10,global);
   Competition_Monitor.setInfo(0,1,1,updateStr);
   Ada.Text_IO.Put_Line("prova di stampa : \n "&Competition_Monitor.getInfo(0,1,1));
   --Competition_Monitor.getInfo(0,2,1);
   --Ada.Text_IO.Put_Line("prova di stampa 2 : \n "&Competition_Monitor.getInfo(0,2,1));

   Competition_Monitor.setInfo(0,2,1,updateStr2);
   delay(1.0);
Ada.Text_IO.Put_Line("prova di stampa 3 : \n "&Competition_Monitor.getInfo(0,2,1));

   end prova;
   end supporto;
