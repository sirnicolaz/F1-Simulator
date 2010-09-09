with System;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
with Ada.Calendar;
with Competitor;
use Competitor;
--with Competition;
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
with Common;
use Common;


procedure Main is
--     xml_file : STRING := "./obj/car_driver.xml";
--     --parametri
--     Input : File_Input;
--     Reader : Tree_Reader;
--     Doc : Document;
--     carDriver_XML : Node_List;
--     carDriver_Length : INTEGER;
--     --   carDriver_Out : CAR_DRIVER_ACCESS;
--     --carDriver : CAR_DRIVER_ACCESS;
--     tempStrategy : COMPETITOR.STRATEGY_CAR;
--     tempCar : COMPETITOR.CAR;
--     tempDriver : COMPETITOR.DRIVER;
   RaceTrackTemp : Circuit.RACETRACK_POINT :=Get_Racetrack("./obj/racetrack.xml");
   iteratorTemp : RACETRACK_ITERATOR := Get_Iterator(RaceTrackTemp);
   iteratorTemp2 : RACETRACK_ITERATOR := Get_Iterator(RaceTrackTemp);
   iteratorTemp3 : RACETRACK_ITERATOR := Get_Iterator(RaceTrackTemp);
   iteratorTemp4 : RACETRACK_ITERATOR := Get_Iterator(RaceTrackTemp);
--   iteratorTempABC : RACETRACK_ITERATOR := Get_Iterator(RaceTrackTemp);
   carDriverTemp : CAR_DRIVER_ACCESS :=Init_Competitor("./obj/car_driver.xml",iteratorTemp, 1);
   carDriverTemp2 : CAR_DRIVER_ACCESS:=Init_Competitor("./obj/car_driver3.xml",iteratorTemp2, 2);
   carDriverTemp3 : CAR_DRIVER_ACCESS:=Init_Competitor("./obj/car_driver1.xml",iteratorTemp3, 3);
   carDriverTemp4 : CAR_DRIVER_ACCESS:=Init_Competitor("./obj/car_driver2.xml",iteratorTemp4, 4);
   TempTask3: TASKCOMPETITOR(carDriverTemp3);
   TempTask4: TASKCOMPETITOR(carDriverTemp4);
   TempTask : TASKCOMPETITOR(carDriverTemp);
   TempTask2: TASKCOMPETITOR(carDriverTemp2);
   Comp_List : Common.COMPETITORS_LIST(1..4);
  -- taskComp : CompetitionTask;
begin

--   Ada.Text_IO.Put_Line("MAIN : "&Integer'Image(Circuit.Print_Racetrack(RaceTrackTemp));
   Comp_List(1) := 1;
   Comp_List(2) := 2;
   Comp_List(3) := 3;
   Comp_List(4) := 4;
   Set_Competitors(RaceTrackTemp, Comp_List);
   Ada.Text_IO.Put_Line("init race...");
   TempTask3.Start;
   TempTask4.Start;
   TempTask.Start;
   TempTask2.Start;

end Main;
