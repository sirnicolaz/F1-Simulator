with Ada.Text_IO;
use Ada.Text_IO;
--  with ONBOARDCOMPUTER;
--  use ONBOARDCOMPUTER;
package body Stats is

   function print return BOOLEAN is
   begin
      Ada.Text_IO.put_Line("in costruttore S_GLOB");
      return true;
   end print;

   function Get_StatsRow(Competitor_Id_In : INTEGER;
                         Lap_Num_In : INTEGER;
                         Checkpoint_Num_In : INTEGER;
                         Time_In : FLOAT) return STATS_ROW is
      Row2Return : STATS_ROW;
   begin
      Row2Return.Competitor_Id := Competitor_Id_In;
      Row2Return.Lap_Num := Lap_Num_In;
      Row2Return.Checkpoint_Num := Checkpoint_Num_In;
      Row2Return.Time := Time_In;
      return Row2Return;
   end Get_StatsRow;

   function Get_CompetitorId(Row : STATS_ROW) return INTEGER is
   begin
      return Row.Competitor_Id;
   end Get_CompetitorId;

   function Get_Lap(Row : STATS_ROW) return INTEGER is
   begin
      return Row.Lap_Num;
   end Get_Lap;

   function Get_CheckPoint(Row : STATS_ROW) return INTEGER is
   begin
      return Row.Checkpoint_Num;
   end Get_CheckPoint;

   function Get_Time(Row : STATS_ROW) return FLOAT is
   begin
      return Row.Time;
   end Get_Time;



   function "<" (Left, Right : STATS_ROW) return BOOLEAN is
   begin

      if(Left.Lap_Num < Right.Lap_Num) then
         return true;
      elsif(Left.Lap_Num = Right.Lap_Num) and (Left.Checkpoint_Num < Right.Checkpoint_Num) then
         return true;
      elsif(Left.Lap_Num = Right.Lap_Num) and (Left.Checkpoint_Num = Right.Checkpoint_Num) and (Left.Time > Right.Time) then
         return true;
      else
         return false;
      end if;

   end "<";

   protected body SYNCH_ORDERED_CLASSIFICATION_TABLE is
      procedure Init_Table(NumRows : INTEGER) is
         NullRow : STATS_ROW;
      begin
         NullRow.Competitor_Id := -1;
         NullRow.Lap_Num := -1;
         NullRow.Checkpoint_Num := -1;
         NullRow.Time := -1.0;
         Statistics := new CLASSIFICATION_TABLE(1..NumRows);
         for index in Statistics'RANGE loop
            Statistics(index) := NullRow;
         end loop;

      end Init_Table;

      procedure Add_Row(Row_In : STATS_ROW;
                        Index_In : INTEGER) is
      begin
         Statistics(Index_In) := Row_In;
      end Add_Row;


      procedure Add_Row(Row_In : STATS_ROW) is
      begin
         if (Statistics(1).Competitor_Id = -1) then
            Add_Row(Row_In,1);
         else
            for index in Statistics'RANGE loop
               if(Statistics(index) < Row_In ) then
                  if(Find_RowIndex(Row_In.Competitor_Id) /= -1) then
                     Delete_Row(Find_RowIndex(Row_In.Competitor_Id));
                  end if;
                  Shift_Down(index);
                  Add_Row(Row_In,index);
                  exit;
               end if;
            end loop;
         end if;

      end Add_Row;

      procedure Remove_Row(Index_In : INTEGER;
                           Row_Out : in out STATS_ROW) is
      begin
         Row_Out := Statistics(Index_In);
         Delete_Row(Index_In);
      end Remove_Row;

      procedure Delete_Row(Index_In : INTEGER) is
         NullRow : STATS_ROW;
      begin
         NullRow.Competitor_Id := -1;
         Statistics(Index_In) := NullRow;
      end Delete_Row;

      procedure Shift_Down(Index_In : INTEGER) is
         EmptyIndex : INTEGER := -1;
      begin
         for index in Index_In..Statistics'LAST loop
            if(Statistics(index).Competitor_Id = -1) then
               EmptyIndex := index;
               exit;
            end if;
         end loop;

         if(EmptyIndex /= -1) and (EmptyIndex /= 1) then
            for index in reverse Index_In+1..EmptyIndex loop
               Statistics(index) := Statistics(index-1);
            end loop;
         end if;

      end Shift_Down;


      function Get_Row(Index_In : INTEGER) return STATS_ROW is
      begin
         return Statistics(Index_In);
      end Get_Row;

      function Find_RowIndex(CompetitorId_In : INTEGER) return INTEGER is
      begin
         for index in Statistics'RANGE loop
            if(Statistics(index).Competitor_Id = CompetitorID_In) then
               return index;
            end if;
         end loop;
         return -1;
      end Find_RowIndex;

      procedure Is_Full(Full_Out : out BOOLEAN) is
      begin
         if(not Full) then
            if(Statistics(Statistics'LENGTH).Competitor_Id /= -1) then
               Full := true; -- Table is packed, then it's sufficient to control the last row to verify if table is full or not
            end if;
         end if;
         Full_Out := Full;
      end Is_Full;

      function Get_Size return INTEGER is
      begin
         return Statistics'LENGTH;
      end Get_Size;

      function Test_Get_Classific return CLASSIFICATION_TABLE is
      begin
         return Statistics.all;
      end Test_Get_Classific;

      -- Per mantenere il vincolo di sottotipo con la Get_Classific nel SYNCH_GLOBAL_STATS
      -- e poter così utilizzare la requeue, si è dovuto tenere il primo parametro intero.
      -- TODO: studiare un modo per ovviare a questo spreco di parametri formali.
      entry Get_Classific(Garbage : INTEGER; Classific_Out : out CLASSIFICATION_TABLE) when Full is
      begin
         Classific_Out := Statistics.all;
      end Get_Classific;


   end SYNCH_ORDERED_CLASSIFICATION_TABLE;

   function Get_New_SOCT_NODE(Size : INTEGER) return SOCT_NODE_POINT is
      TempTableListNode : SOCT_NODE_POINT := new SOCT_NODE;
      TempSOCT : SOCT_POINT := new SYNCH_ORDERED_CLASSIFICATION_TABLE;
   begin
      Init_Node(TempTableListNode);
      TempSOCT.Init_Table(Size);
      TempTableListNode.This := TempSOCT;
      return TempTableListNode;
   end Get_New_SOCT_NODE;

   function Get_PreviousNode( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_NODE_POINT is
   begin
      return SynchOrdStatTabNode.Previous;
   end Get_PreviousNode;

   function Get_NextNode( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_NODE_POINT is
   begin
      return SynchOrdStatTabNode.Next;
   end Get_NextNode;

   function Get_NodeContent( SynchOrdStatTabNode : SOCT_NODE_POINT ) return SOCT_POINT is
   begin
      return SynchOrdStatTabNode.This;
   end Get_NodeContent;

   function IsLast(SynchOrdStatTabNode : SOCT_NODE_POINT) return BOOLEAN is
   begin
      return SynchOrdStatTabNode.IsLast;
   end IsLast;

   function IsFirst(SynchOrdStatTabNode : SOCT_NODE_POINT) return BOOLEAN is
   begin
      return SynchOrdStatTabNode.IsFirst;
   end IsFirst;

   function Get_Index(SynchOrdStatTabNode : SOCT_NODE_POINT) return INTEGER is
   begin
      return SynchOrdStatTabNode.Index;
   end Get_Index;


   procedure Init_Node(SynchOrdStatTabNode : in out SOCT_NODE_POINT) is
   begin
      if(SynchOrdStatTabNode.This = null) then
         SynchOrdStatTabNode.IsLast := true;
         SynchOrdStatTabNode.IsFirst := true;
         SynchOrdStatTabNode.Index := 1;
         SynchOrdStatTabNode.Previous := null;
         SynchOrdStatTabNode.Next := null;
      end if;
   end Init_Node;


   procedure Set_Node(SynchOrdStatTabNode : in out SOCT_NODE_POINT; Value : SOCT_POINT ) is
   begin
      SynchOrdStatTabNode.This := Value;
   end Set_Node;

   procedure Set_PreviousNode(SynchOrdStatTabNodePoint : in out SOCT_NODE_POINT ; Value : in out SOCT_NODE_POINT) is
   begin
      if(Value /= null) then
         SynchOrdStatTabNodePoint.Previous := Value;
         SynchOrdStatTabNodePoint.Previous.Next := SynchOrdStatTabNodePoint;
         SynchOrdStatTabNodePoint.Previous.IsLast := false;
         SynchOrdStatTabNodePoint.IsFirst := false;
         SynchOrdStatTabNodePoint.Index := SynchOrdStatTabNodePoint.Previous.Index + 1;
      end if;
   end Set_PreviousNode;

   procedure Set_NextNode(SynchOrdStatTabNodePoint : in out SOCT_NODE_POINT; Value : in out SOCT_NODE_POINT ) is
   begin
      if(Value /= null) then
         SynchOrdStatTabNodePoint.Next := Value;
         SynchOrdStatTabNodePoint.Next.Previous := SynchOrdStatTabNodePoint;
         SynchOrdStatTabNodePoint.Next.IsFirst := false;
         SynchOrdStatTabNodePoint.IsLast := false;
         SynchOrdStatTabNodePoint.Next.Index := SynchOrdStatTabNodePoint.Index + 1;
      end if;
   end Set_NextNode;

   -- TODO: Remove and Delete this, previous, next node;

   function Get_BestLapNum(StatsContainer : GENERIC_STATS) return INTEGER is
   begin
--        if(StatsContainer.BestLap_Num'LENGTH <= RequestedIndex) then
--           return StatsContainer.BestLap_Num(RequestedIndex);
--        end if;
--        return -1;
      return StatsContainer.bestLap.numBestLap;
   end Get_BestLapNum;

   function Get_BestLapTime(StatsContainer : GENERIC_STATS) return FLOAT is
   begin
--        if(StatsContainer.BestLap_Time'LENGTH <= RequestedIndex) then
--           return StatsContainer.BestLap_Time(RequestedIndex);
--        end if;
--        return -1.0;
      return StatsContainer.bestLap.timeLap;
   end Get_BestLapTime;

   --TODO: perchè è commentata?
   --function getLapTime(computerIn : COMP_STATS_NODE_POINT; competitorId_In : in INTEGER; numLap : in INTEGER ) return FLOAT is
   --begin
  --        computerIn
   --end getLapTime;

   funCtion Get_BestLapId(StatsContainer : GENERIC_STATS) return INTEGER IS
   begin
      return StatsContainer.bestLap.idCompetitor;
   end Get_BestLapId;

   function Get_BestSectorsTime(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return FLOAT is--FLOAT_ARRAY is
--        Current_BST : FLOAT_ARRAY_LIST_NODE;
--        Null_Array : FLOAT_ARRAY := (1 => -1.0);
returnNum : INTEGER;
   begin
      for z in 1..3
      loop
         if StatsContainer.bestSector(z).numSector = RequestedIndex then
             returnNum := StatsContainer.bestSector(z).numSector;
         end if;
      end loop;
      return StatsContainer.bestSector(returnNum).timeSector;
--        if(StatsContainer.BestSectors_Time.Index <= RequestedIndex) then
--           Current_BST := StatsContainer.BestSectors_Time;
--           while Current_BST.Index = RequestedIndex loop
--              exit when Current_BST.Previous = null;
--              Current_BST := Current_BST.Previous.all;
--           end loop;
--        end if;
--        if(Current_BST.Index = RequestedIndex) then
--           return Current_BST.This.all;
--        else
--           return Null_Array;
--        end if;
   end Get_BestSectorsTime;

   function Get_BestSectorsId(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return INTEGER Is
      returnNum : INTEGER;
   begin
      for z in 1..3
      loop
         if StatsContainer.bestSector(z).numSector = RequestedIndex then
             returnNum := StatsContainer.bestSector(z).numSector;
         end if;
      end loop;
      return StatsContainer.bestSector(returnNum).idCompetitor;
   end Get_BestSectorsId;

   function Get_BestSectorsLap(StatsContainer : GENERIC_STATS; RequestedIndex : INTEGER ) return INTEGER Is
      returnNum : INTEGER;
   begin
      for z in 1..3
      loop
         if StatsContainer.bestSector(z).numSector = RequestedIndex then
             returnNum := StatsContainer.bestSector(z).numSector;
         end if;
      end loop;
      return StatsContainer.bestSector(returnNum).numBestLap;
   end Get_BestSectorsLap;
   --procedure Update_Stats_Lap( StatsContainer : in out GENERIC_STATS;
   --                           BestLapNum_In : INTEGER;
   --                           BestLapTime_In : FLOAT) is
   --begin
   --   StatsContainer.BestLap_Num := BestLapNum_In;
   --   StatsContainer.BestLap_Time := BestLapTime_In;
   --end Update_Stats_Lap;

   --procedure Update_Stats_Sector( StatsContainer : in out GENERIC_STATS;
   --                              BestSectorNum_In : INTEGER;
   --                              BestSectorTime_In : FLOAT) is
   --begin
   --   StatsContainer.BestSectors_Time(BestSectorNum_In) := BestSectorTime_In;
   --end Update_Stats_Sector;

   procedure initGlobalStatsHandler(globalStatsHandler : in out GLOBAL_STATS_HANDLER_POINT; sgs_In : in S_GLOB_STATS_POINT;
                                   updatePeriod_In : FLOAT) is
   begin
      globalStatsHandler.global := sgs_In; -- inizializzazione SYNCH_GLOBAL_STATS
      globalStatsHandler.updatePeriod := updatePeriod_In;
   end initGlobalStatsHandler;

   function getUpdateTime(global : in GLOBAL_STATS_HANDLER) return FLOAT is
   begin
      return global.updatePeriod;
   end getUpdateTime;


   procedure compareTime(StatsGeneric : in GENERIC_STATS;  NewStats : in out GENERIC_STATS) is
      -- prendo la global_stats che ho a disposizione e confronto settore per settore se ho stabilito un nuovo record
      -- e poi confronto sul giro totale.
      time : FLOAT;
   begin
      Ada.Text_IO.Put_Line("in comparetime");
      time := Get_BestLapTime(NewStats);
      Ada.Text_IO.Put_Line("Get_BestLapTime(StatsGeneric) = "&Float'Image(time));
      Ada.Text_IO.Put_Line("StatsGeneric.bestLap.timeLap"&Float'Image(StatsGeneric.bestLap.timeLap));
      if time > StatsGeneric.bestLap.timeLap or else time < 0.0 then
         Ada.Text_IO.Put_Line("in comparetime, time > statsgeneric.bestLap.timeLap");
         NewStats.bestLap.numBestLap := StatsGeneric.bestLap.numBestLap;
         NewStats.bestLap.idCompetitor := StatsGeneric.bestLap.idCompetitor;
         NewStats.bestLap.timeLap := StatsGeneric.bestLap.timeLap;
      end if;
      --scorro le generic_stats relative ai tre settori e aggiorno le informazioni se serve
      Ada.Text_IO.Put_Line("in loop");
      for z in 1..3
      loop
         if NewStats.bestSector(z).timeSector > StatsGeneric.bestSector(z).timeSector or else NewStats.bestSector(z).timeSector < 0.0 then
            Ada.Text_IO.Put_Line("NewStats.bestSector(z).timeSector > StatsGeneric.bestSector(z).timeSector");
            NewStats.bestSector(z).timeSector := StatsGeneric.bestSector(z).timeSector;
            NewStats.bestSector(z).numBestLap := StatsGeneric.bestSector(z).numBestLap;
            NewStats.bestSector(z).idCompetitor := StatsGeneric.bestSector(z).idCompetitor;
         end if;
      end loop;
   end compareTime;


   protected body SYNCH_GLOBAL_STATS is

      -- function to init reference to global_stats
      procedure Init_GlobalStats(genStats_In : in GENERIC_STATS_POINT;CompetitorsQty : in INTEGER ; Update_Interval_in : FLOAT) is
      begin
         --GlobStats := new GLOBAL_STATS(genStats_In, Update_Interval_in); --inizializzo il campo dati per poi assegnarci i valori, altrimenti eccezione
         GlobStats.firstTableFree :=1;
         GlobStats.lastClassificUpdate := new SOCT_NODE;
         GlobStats.genStats := genStats_In.all; -- init generic_stats
         Set_CompetitorsQty (CompetitorsQty);
         --GlobStats.BestLap_Num := 0;
         --GlobStats.BestLap_Time := 0.0;
         -- Temp
         --GlobStats.BestSectors_Time := new BESTSECTORS_TIME(0..2);
         --GlobStats.BestSectors_Time(0) := 0.0;
         --GlobStats.BestSectors_Time(1) := 0.0;
         --GlobStats.BestSectors_Time(2) := 0.0;
         --GlobStats.BestLap_CompetitorId := 0;
         --GlobStats.BestTimePerSector_CompetitorId := new BESTSECTORS_TIME_COMPETITORSID(0..2);
         --GlobStats.BestTimePerSector_CompetitorId(0) := 0;
         --GlobStats.BestTimePerSector_CompetitorId(1) := 0;
         --GlobStats.BestTimePerSector_CompetitorId(2) := 0;
         -------------------------------------------------
         GlobStats.Update_Interval := Update_Interval_in;
         Ada.Text_IO.Put_Line("GlobStats.genStats.bestLap.idCompetitor : " & Integer'Image(GlobStats.genStats.bestLap.idCompetitor));
         Ada.Text_IO.Put_Line("GlobStats.genStats.bestLap.numBestLap : " & Integer'Image(GlobStats.genStats.bestLap.numBestLap));
         Ada.Text_IO.Put_Line("GlobStats.genStats.bestLap.timeLap : " & Float'Image(GlobStats.genStats.bestLap.timeLap));

         Ada.Text_IO.Put_Line("GlobStats.genStats.bestSector(i).idCompetitor : " & Integer'Image(GlobStats.genStats.bestSector(3).idCompetitor));
         Ada.Text_IO.Put_Line("GlobStats.genStats.bestSector(i).numSector : " & Integer'Image(GlobStats.genStats.bestSector(3).numSector));
         Ada.Text_IO.Put_Line("GlobStats.genStats.bestSector(i).numBestLap : " & Integer'Image(GlobStats.genStats.bestSector(3).numBestLap));
         Ada.Text_IO.Put_Line("GlobStats.genStats.bestSector(i).timeSector : " & Float'Image(GlobStats.genStats.bestSector(3).timeSector));

      end Init_GlobalStats;

      procedure Set_CompetitorsQty (CompetitorsQty : INTEGER) is
      begin
         GlobStats.competitorNum := CompetitorsQty;
      end Set_CompetitorsQty;

      function Get_CompetitorsQty return INTEGER IS
      begin
         return
           GlobStats.competitorNum;
      end Get_CompetitorsQty;


      function Test_Get_Classific return CLASSIFICATION_TABLE is
      begin
         Ada.Text_IO.Put_Line("init get_classific");
         return GlobStats.lastClassificUpdate.This.Test_Get_Classific;--.Get_Classific;--Statistics_Table.This.Test_Get_Classific;
      end Test_Get_Classific;

      entry Get_Classific(RequestedIndex : INTEGER; Classific_Out : out CLASSIFICATION_TABLE) when true is
         CurrentIndex : INTEGER := GlobStats.firstTableFree;--Statistics_Table.Index;
         TempStatsTable : SOCT_NODE_POINT;
      begin
         if (CurrentIndex = RequestedIndex) then
            requeue GlobStats.lastClassificUpdate.This.Get_Classific;-- .Statistics_Table.This.Get_Classific;
         else
            CurrentIndex := CurrentIndex - 1;
            TempStatsTable := GlobStats.lastClassificUpdate.Previous;--Statistics_Table.Previous;
            while CurrentIndex /= RequestedIndex loop
               TempStatsTable := TempStatsTable.Previous;
               CurrentIndex := CurrentIndex - 1;
            end loop;
            requeue TempStatsTable.This.Get_Classific;
         end if;
      end Get_Classific;

      -- It adds e new row with the given information. If in the current table there are no
      -- rows with the given COmpetitor_ID, the insert there the new data.
      -- Otherwise, it searches for a table that respects the prerequisite. If no tables are found,
      -- then a new table is created and linked to the last one of the list.
      -- NB: we are sure that previous tables of the list can't have any empty row, because GlobalStats
      -- always references as the current table the one immediatly following the last full one.
      procedure Update_Stats(CompetitorId_In : INTEGER;
                             Lap_In : INTEGER;
                             Checkpoint_In : INTEGER;
                             Time_In : FLOAT) is
         Competitor_RowIndex : INTEGER;
         Current_Table : SOCT_NODE_POINT := GlobStats.lastClassificUpdate;--Statistics_Table;
         Control_Var : BOOLEAN;
         procedure Create_New(Previous : in out SOCT_NODE_POINT) is
            Temp_NewTable : SOCT_NODE_POINT;
         begin
            Ada.Text_IO.Put_Line("in create new");
            Temp_NewTable := Get_New_SOCT_NODE(Previous.This.Get_Size);
            Set_NextNode(Previous,Temp_NewTable);

            -- Every row that has time <= the time represented by the new table has to be
            -- inserted in the new table.
            for index in 1..Previous.This.Get_Size loop
               -- Se il tempo di un concorrente nella tabella precedente è maggiore anche della barriera
               -- rappresentata dalla nuova tabella, allora va salvato. Infatti nel caso venga chiesta una
               -- classifica aggiornata dell'istante di tempo inerente a questa tabella, il concorrente
               -- sarà nella stessa posizione (ovvero tratto checkpoint e lap) di quella precedente.
               if(Previous.This.Get_Row(index).Time >= FLOAT(Temp_NewTable.Index) * GlobStats.Update_Interval) then
                  Temp_NewTable.This.Add_Row(Previous.This.Get_Row(index));
               end if;
            end loop;

         end Create_New;

      begin
         if Current_Table.This = null then
            Init_Node(Current_Table);
            Current_Table.This := new SYNCH_ORDERED_CLASSIFICATION_TABLE;--inizializzo un nodo, se non esiste.
            Current_Table.This.Init_Table(10);-- inizializzare il campo this
            Ada.Text_IO.Put_Line("init node & table");
         end if;
--           Current_Table.This :=
           -- Create_New(Current_Table);
         --if Current_Table.This = null then Ada.Text_IO.Put_Line("this null");
         --end if;
         Competitor_RowIndex := Current_Table.This.Find_RowIndex(CompetitorId_In);
         -- If competitor's infos are already saved in the current table, control what is the first
         -- free table
         while Competitor_RowIndex /= -1 loop
            -- if there are no free table, create a new one
            if(Get_NextNode(Current_Table) = null) then
               Create_New(Current_Table);
            end if;
            Current_Table := Get_NextNode(Current_Table);
            Competitor_RowIndex := Current_Table.This.Find_RowIndex(CompetitorId_In);
         end loop;
         Current_Table.This.Add_Row(Get_StatsRow(CompetitorId_In,Lap_In,Checkpoint_In,Time_In));

         -- Se la riga è stata aggiunta alla tabella attualmente riferita dal GlobStats, allora
         -- bisogna verificare se è piena. In tal caso bisogna crearne una nuova vuota da far puntare
         -- al globStats per mantere valida l'invariante secondo cui la tabella riferita dal GlobStat
         -- è sempre quella non piena subito dopo l'ultima piena della lista.
         GlobStats.lastClassificUpdate.This.Is_Full(Control_Var);--Statistics_Table.This.Is_Full(Control_Var);
         if(Control_Var) then
            if(Get_NextNode(GlobStats.lastClassificUpdate) = null) then--Statistics_Table) = null) then
               Create_New(GlobStats.lastClassificUpdate);--Statistics_Table);
            end if;
            GlobStats.lastClassificUpdate := Get_NextNode(GlobStats.lastClassificUpdate);--Statistics_Table);
         end if;
      end Update_Stats;
   end SYNCH_GLOBAL_STATS;

   procedure updateCompetitorInfo(global_In : in out GLOBAL_STATS_HANDLER_POINT; competitorID_In : INTEGER;
                                  competitorInfo_In : COMP_STATS_POINT)is
      tempCheck : INTEGER;
      tempLap : INTEGER;
      tempTime : FLOAT;
   begin
      Ada.Text_IO.Put_Line("in updateCompetitorInfo");
      tempCheck := Common.Get_Checkpoint(competitorInfo_In.all); -- numero checkpoint
      tempLap := Common.Get_Lap(competitorInfo_In.all); -- numero giro
      Ada.Text_IO.Put_Line("tempLap : "&Integer'Image(tempLap));
      tempTime := Common.Get_Time(competitorInfo_In.all); -- tempo
      Ada.Text_IO.Put_Line(" creazione singoli campi");
      global_In.global.Update_Stats(CompetitorId_In,tempLap,tempCheck, tempTime); -- aggiornamento tabella
      Ada.Text_IO.Put_Line("aggiornamento tabella completato");
      --controllo se migliori prestazioni
     -- if global_In
   end updateCompetitorInfo;

--     function getClassification(global_In : in GLOBAL_STATS_HANDLER_POINT ) return CLASSIFICATION_TABLE --return the last classific available
--     is
--        Classific_Out : CLASSIFICATION_TABLE_POINT := new CLASSIFICATION_TABLE(1..global_In.global.Get_CompetitorsQty);
--        RequestedIndex : INTEGER := 0;
--     begin
--        global_In.global.Get_Classific(RequestedIndex ,Classific_Out.all );
--
--        return Classific_Out.all;
--     end getClassification;
--
   -- return the last classificationtable complete
   function lastClassificUpdate(global_In : in GLOBAL_STATS_POINT) return CLASSIFICATION_TABLE is
   begin
      Ada.Text_IO.Put_Line("lastClassificUpdate");
      return global_In.lastClassificUpdate.This.Test_Get_Classific;
   end lastClassificUpdate;

   -- updated the calssificationtable with the info of the competitor

--     procedure updateClassification(global_In : in GLOBAL_STATS_HANDLER_POINT; competitorID_In : INTEGER;
--                                    competitorInfo_In : COMP_STATS);

   procedure printGlobUPD(gl : GLOBAL_STATS_HANDLER) is
   begin
      Ada.Text_IO.Put_Line("global update time : "&Float'Image(gl.updatePeriod));
      end printGlobUPD;


   procedure setGSLAP(genStats_In : in out GENERIC_STATS; numBestLap : INTEGER; idCompetitor : INTEGER; timeLap : FLOAT) IS
   begin
      genStats_In.bestLap.numBestLap := numBestLap;
      genStats_In.bestLap.idCompetitor := idCompetitor;
      genStats_In.bestLap.timeLap := timeLap;
      Ada.Text_IO.Put_Line("Generic stats.GS_LAP ok");
   end setGSLAP;

   procedure setGS_SECTOR(genStats_In : in out GENERIC_STATS; numSector : INTEGER; numBestLap : INTEGER; idCompetitor : INTEGER; timeSector : FLOAT) is
   begin
      genStats_In.bestSector(numSector).numSector := numSector;
      genStats_In.bestSector(numSector).numBestLap := numBestLap;
      genStats_In.bestSector(numSector).idCompetitor := idCompetitor;
      genStats_In.bestSector(numSector).timeSector := timeSector;
      Ada.Text_IO.Put_Line("Generic stats.GS_SECTOR("&Integer'Image(numSector)&") ok");
   end setGS_SECTOR;


end Stats;
