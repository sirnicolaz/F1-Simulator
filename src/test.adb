with System;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Float_Text_IO;
with Ada.Calendar;
--  with Competitor;
--  use Competitor;
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
with OnBoardComputer;
use OnBoardComputer;
with Common;
use Common;
  with Stats;
  use Stats;

procedure Test is
   RaceTrackTemp : Circuit.RACETRACK_POINT :=Get_Racetrack("./obj/racetrack.xml");
   obc : COMPUTER_POINT := new COMPUTER;
   compStats : COMP_STATS_POINT := new COMP_STATS;
   predictedTime : FLOAT := 150.0;
   upd : FLOAT := 100.0;
   global : GLOBAL_STATS_HANDLER_POINT;
   temp : GENERIC_STATS_POINT := new GENERIC_STATS;
   temp_2 : GENERIC_STATS_POINT;
   temp_new : GENERIC_STATS_POINT := new GENERIC_STATS;
begin
   --temp := new GENERIC_STATS_POINT;
   temp_2 := temp;
   global := new GLOBAL_STATS_HANDLER(new FLOAT'(upd), temp);--new GENERIC_STATS);--'(temp.all));
                                                     --pritnGlobUPD(global.all);
--creazione giri migliori e tempi su settore migliori per scopi di test
   setGSLAP(temp_new.all, 1, 42, 0.5);
   setGS_SECTOR(temp_new.all,1, 1, 42, 0.3);
   setGS_SECTOR(temp_new.all,2, 1, 42, 0.3);
   setGS_SECTOR(temp_new.all,3, 1, 42, 0.3);
   Ada.Text_IO.Put_Line("global.updatePeriod : "&Float'Image(global.updatePeriod));
   --AGGIORNAMENTO ONBOARDCOMPUTER
         -- qua va creata la statistica da aggiungere al computer di bordo
    -- per poi invocare il metodo Add_Data
  -- Ada.Text_IO.Put_Line("PRE setcheckpoint");
   Common.Set_Checkpoint(compStats, 1);
   -- Ada.Text_IO.Put_Line("POST setcheckpoint PRE setSector");
   Common.Set_Sector(compStats, 1); -- TODO, non abbiamo definito i sector, ritorna sempre uno.
   -- ONBOARDCOMPUTER.Set_Lap(); -- TODO, non ho ancora un modo per sapere il numero di giro
                                                   --commentato- da correggere il ripo di gaslevel ONBOARDCOMPUTER.Set_Gas(compStats, carDriver.auto.GasolineLevel);
   -- Ada.Text_IO.Put_Line("POST setsector PRE set tyre");
   Common.Set_Tyre(compStats, 0.15);
   -- Ada.Text_IO.Put_Line("POST settyre PREset time");
   Common.Set_Time(compStats, predictedTime);
   --se il tempo segnato è tale da inserire il nuovo valore nella tabella lo inserisco.
  global.global.Init_GlobalStats(temp_2,10, upd);
   if predictedTime >100.0 then
      Ada.Text_IO.Put_Line("predictedTime > 100.0");
      -- Common.Update_Stats(compStats);--, global);
      updateCompetitorInfo(global, 1, compStats);
   end if;
  compareTime(temp_new.all, temp_2.all);--passaggio primo parametro mancante
   obc.Add_Data(compStats);

   Ada.Text_IO.Put_Line("bestLapNum : "&Integer'Image(Get_BestLapNum(temp_2.all)));
   Ada.Text_IO.Put_Line("bestLapTime : "&Float'Image(Get_BestLapTime(temp_2.all)));
   Ada.Text_IO.Put_Line("bestSector(1)time : "&Float'Image(Get_BestSectorsTime(temp_2.all, 1)));
   Ada.Text_IO.Put_Line("bestSector(1)lap : "&Integer'Image(Get_BestSectorsLap(temp_2.all, 1)));
   Ada.Text_IO.Put_Line("bestSector(1)id : "&Integer'Image(Get_BestSectorsId(temp_2.all, 1)));

--     function Get_BestSectorsTime(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return FLOAT;--_ARRAY;
--     function Get_BestSectorsLap(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return INTEGER;
--     function Get_BestSectorsId(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return INTEGER;
         --FINE AGGIORNAMENTO ONBOARDCOMPUTER
end Test;
