with Ada.Text_IO;
use Ada.Text_IO;

package body Stats is



   --Singleton
   Competitor_Statistics : STATISTIC_COLLECTION_POINT;
   Classification_Tables : SOCT_ARRAY_POINT;

   Checkpoints : INTEGER;


   protected body SYNCH_COMP_STATS_HANDLER is

      entry Get_Time( Result : out FLOAT ) when Initialised = TRUE is
      begin
         Result := Statistic.Time;
      end Get_Time;

      entry Get_Checkpoint (Result : out INTEGER) when Initialised = TRUE is
      begin
         Result := Statistic.Checkpoint;
      end Get_Checkpoint;

      entry Get_Lap (Result : out INTEGER) when Initialised = TRUE is
      begin
         Result := Statistic.Lap;
      end Get_Lap;

      entry Get_Sector (Result : out INTEGER) when Initialised = TRUE is
      begin
         Result := Statistic.Sector;
      end Get_Sector;

      entry Get_BestLapNum (Result : out INTEGER) when Initialised = TRUE is
      begin
         Result := Statistic.BestLapNum;
      end Get_BestLapNum;

      entry Get_BestLapTime (Result : out FLOAT) when Initialised = TRUE is
      begin
         Result := Statistic.BestLapTime;
      end Get_BestLapTime;

      entry Get_BestSectorTime( SectorNum : INTEGER; Result : out FLOAT) when Initialised = TRUE is
      begin
         Result := Statistic.BestSectorTimes(SectorNum);
      end Get_BestSectorTime;

      entry Get_MaxSpeed (Result : out FLOAT) when Initialised = TRUE is
      begin
         Result := Statistic.MaxSpeed;
      end Get_MaxSpeed;

      entry Get_IsLastCheckInSector (Result : out BOOLEAN) when Initialised = TRUE is
      begin
         Result := Statistic.LastCheckInSect;
      end Get_IsLastCheckInSector;

      entry Get_IsFirstCheckInSector (Result : out BOOLEAN) when Initialised = TRUE is
      begin
         Result := Statistic.FirstCheckInSect;
      end Get_IsFirstCheckInSector;

      entry Get_PathLength (Result : out FLOAT) when Initialised = TRUE is
      begin
         Result := Statistic.PathLength;
      end Get_PathLength;

      entry Get_GasLevel (Result : out FLOAT) when Initialised = TRUE is
      begin
         Result := Statistic.GasLevel;
      end Get_GasLevel;

      entry Get_TyreUsury (Result : out PERCENTAGE) when Initialised = TRUE is
      begin
         Result := Statistic.TyreUsury;
      end Get_TyreUsury;

      entry Get_All( Result : out COMP_STATS) when Initialised = TRUE is
      begin
         Result := Statistic;
      end Get_All;

      entry Initialise(Stats_In : in COMP_STATS) when Initialised = FALSE is

      begin
         Ada.Text_IO.Put_Line("Adding " & INTEGER'IMAGE(Stats_In.Checkpoint));
         Statistic := Stats_In;
         Initialised := TRUE;
      end Initialise;

   end SYNCH_COMP_STATS_HANDLER;



   -- It sets the CompStats parameter with the statistics related to the given sector and lap
   procedure Get_StatsBySect(Competitor_ID : INTEGER;
                             Sector : INTEGER;
                             Lap : INTEGER;
                             Stats_In : out COMP_STATS_POINT) is
      Index : INTEGER := Lap+1; -- laps start from 0, information are store starting from 1
      Tmp_Sector : INTEGER;
      Tmp_Bool : BOOLEAN;
   begin
      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Sector(Tmp_Sector);
      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_IsLastCheckInSector (Tmp_Bool);

      while Tmp_Sector = Sector and then Tmp_Bool loop
         Index := Index + 1;
         Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Sector(Tmp_Sector);
         Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_IsLastCheckInSector (Tmp_Bool);
      end loop;
      Competitor_Statistics.all(Competitor_ID).LastAccessedPosition := Index;

      if( Stats_In = null ) then
        Stats_In := new COMP_STATS;
      end if;

      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_All(Stats_In.all);

   end Get_StatsBySect;

    -- It return a statistic related to a certain time. If the statistic is not
   --+ initialised yet, the requesting task will wait on the resource Information
   --+ as long as it's been initialised
   procedure Get_StatsByTime(Competitor_ID : INTEGER;
                            Time : FLOAT;
                            Stats_In : out COMP_STATS_POINT) is

      Index : INTEGER := Competitor_Statistics.all(Competitor_ID).LastAccessedPosition;
      Tmp_Time : FLOAT;
   begin
      Ada.Text_IO.Put_Line("TV asking by time");
      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(Tmp_Time);
      Ada.Text_IO.Put_Line("TV time got");
      if (Tmp_Time >= Time ) then
         Ada.Text_IO.Put_Line("TV backward");
         Index := Index - 1;
         if(Index /= 0) then
            Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(Tmp_Time);
         end if;
         while Index > 1 and then Tmp_Time > Time loop
            Index := Index - 1;
            Ada.Text_IO.Put_Line("TV cycle for index " & INTEGER'IMAGE(Index));
            Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(Tmp_Time);
         end loop;

         if( Stats_In = null ) then
            Stats_In := new COMP_STATS;
         end if;
         Ada.Text_IO.Put_Line("TV out");

         Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index+1).Get_All(Stats_In.all);
         Competitor_Statistics.all(Competitor_ID).LastAccessedPosition := Index + 1;
         Ada.Text_IO.Put_Line("TV get all done");

      else
         Ada.Text_IO.Put_Line("TV forward");
         Index := Index + 1;
         Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(Tmp_Time);
         while Tmp_Time < Time loop
            Ada.Text_IO.Put_Line("TV cycle");
            Index := Index + 1;
            Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_Time(Tmp_Time);
         end loop;

         Ada.Text_IO.Put_Line("TV getting");
         Competitor_Statistics.all(Competitor_ID).Competitor_Info.all(Index).Get_All(Stats_In.all);
         Competitor_Statistics.all(Competitor_ID).LastAccessedPosition := Index;

      end if;
      Ada.Text_IO.Put_Line("TV got");

   end Get_StatsByTime;

   -- It sets the CompStats parameter with the statistics related to the given check-point and lap
   procedure Get_StatsByCheck(Competitor_ID : INTEGER;
                              Checkpoint : INTEGER;
                              Lap : INTEGER;
                              Stats_In : out COMP_STATS_POINT) is
   begin

      if( Stats_In = null ) then
        Stats_In := new COMP_STATS;
      end if;

      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all((Lap+1)*Checkpoint).Get_All(Stats_In.all);
      Competitor_Statistics.all(Competitor_ID).LastAccessedPosition := (Lap+1)*Checkpoint;
   end Get_StatsByCheck;

   --It Just initializes the Statistic_Collection with the right size
   procedure Init_Stats(Competitor_Qty : INTEGER;
                        Laps : INTEGER;
                        Checkpoints_In : INTEGER) is
      Tmp_Collection : STATISTIC_COLLECTION_POINT := new ALL_COMPETITOR_STAT_COLLECTION(1..Competitor_Qty);

   begin

      Checkpoints := Checkpoints_In;

      for Index in Tmp_Collection'RANGE loop
         Tmp_Collection.all(Index) := new STATS_ARRAY_OPTIMIZER;
         Tmp_Collection.all(Index).Competitor_Info := new SYNCH_COMP_STATS_HANDLER_ARRAY(1..(Laps*Checkpoints));
      end loop;

      Competitor_Statistics := Tmp_Collection;
      Classification_Tables := new SOCT_ARRAY(1..Laps);
      for Index in Classification_Tables'RANGE loop
         Classification_Tables.all(Index) := new SYNCH_ORDERED_CLASSIFICATION_TABLE;
         Classification_Tables.all(Index).Init_Table(Competitor_Qty);
      end loop;

   end Init_Stats;


   procedure Add_Stat(Competitor_ID : INTEGER;
                       Data : COMP_STATS) is
   begin

      --NB: the order of these 2 operations is really important.
      --+ When a Competitor_Statistic is added, it might be that if someone
      --+ was waiting for it and it finds that a competitor has just finished
      --+ a lap, it may ask for the time instant (in order to fill the classific).
      --+ So, to retrieve this time istant it will ask for the row in the classification
      --+ table related to that event. This row has to be already filled with the value
      --+ That's why that operation is done before the update of the statistic.

      --If the checkpoint is the last one of the circuit, update the classification table as well
      Ada.Text_IO.Put_Line(Common.IntegerToString(Competitor_ID) & ": updating classific");
      if(Data.LastCheckInSect and Data.Sector = 3) then
         --Update_Classific(Competitor_ID,
         --                 Data.Lap,
         --                 Data.Time);
         null; --TODO
      end if;
      --Update the statistics
      Ada.Text_IO.Put_Line(Common.IntegerToString(Competitor_ID) & ": updating statistic");
      Competitor_Statistics.all(Competitor_ID).Competitor_Info.all((Data.Lap*Checkpoints) + Data.Checkpoint).Initialise(Data);
   end Add_Stat;

   procedure Update_Classific(Competitor_ID : INTEGER;
                              CompletedLap : INTEGER;
                              Time : FLOAT) is
      Row : STATS_ROW;
   begin
      --Find the right table for this lap
      Row.Competitor_Id := Competitor_ID;
      Row.Time := Time;

      --Add the information inside
      Classification_Tables(CompletedLap).Add_Row(Row_In => Row);
      --Done

   end Update_Classific;


   procedure Get_BestLap(TimeInstant : FLOAT;
                         LapTime : out FLOAT;
                         LapNum : out INTEGER;
                         Competitor_ID : out INTEGER) is
      Temp_Stats : COMP_STATS_POINT := new COMP_STATS;
      Temp_BestLapNum : INTEGER := -1;
      Temp_BestLapTime : FLOAT := -1.0;
      Temp_BestLapCompetitor : INTEGER := -1;
   begin

      --Retrieve all the information related to the give time for each competitor
      for Index in 1..Competitor_Statistics.all'LENGTH loop
         Get_StatsByTime(Competitor_ID => Index,
                         Time          => TimeInstant,
                         Stats_In      => Temp_Stats);

         --compare the "bestlap" values and find out the best one
         if( (Temp_Stats.BestLaptime /= -1.0 and Temp_Stats.BestLapTime < Temp_BestLapTime) or else
              Temp_BestLapTime = -1.0 ) then
            Temp_BestLapTime := Temp_Stats.BestLaptime;
            Temp_BestLapNum := Temp_Stats.BestLapNum;
            Temp_BestLapCompetitor := Index;
         end if;

      end loop;

      --initialize che out variables correctly
      LapTime := Temp_BestLapTime;
      LapNum := Temp_BestLapNum;
      Competitor_ID := Temp_BestLapCompetitor;

   end Get_BestLap;

   procedure Get_BestSectorTimes(TimeInstant : FLOAT;
                                 Times : out FLOAT_ARRAY;
                                 Competitor_IDs : out INTEGER_ARRAY) is
      Temp_BestSectorTimes : FLOAT_ARRAY(1..3);
      Temp_BestSectorCompetitors : INTEGER_ARRAY(1..3);
      Temp_Stats : COMP_STATS_POINT := new COMP_STATS;
   begin

      for i in 1..3 loop
         Temp_BestSectorTimes(i) := -1.0;
         Temp_BestSectorCompetitors(i) := -1;
      end loop;

      --Retrieve all the information related to the give time for each competitor
      for Index in 1..Competitor_Statistics.all'LENGTH loop
         Get_StatsByTime(Competitor_ID => Index,
                         Time          => TimeInstant,
                         Stats_In      => Temp_Stats);

         --compare the "bestlap" values and find out the best one
         for i in 1..3 loop
            if( (Temp_Stats.BestSectorTimes(i) /= -1.0 and Temp_Stats.BestSectorTimes(i) < Temp_BestSectorTimes(i)) or
                 Temp_BestSectorTimes(i) = -1.0 ) then
               Temp_BestSectorTimes(i) := Temp_Stats.BestSectorTimes(i);
               Temp_BestSectorCompetitors(i) := Index;
            end if;
         end loop;

      end loop;

      Times := Temp_BestSectorTimes;
      Competitor_IDs := Temp_BestSectorCompetitors;

   end Get_BestSectorTimes;

   procedure Get_LapTime(Competitor_ID : INTEGER;
                         Lap : INTEGER;
                         Time : out FLOAT) is
   begin
      null;
   end Get_LapTime;


   procedure Get_LappedCompetitor(TimeInstant : FLOAT;
                                  CurrentLap : INTEGER;
                                  Competitor_IDs : access INTEGER_ARRAY;
                                  Competitor_Lap : access INTEGER_ARRAY) is
   begin
      null;
   end Get_LappedCompetitor;

   function print return BOOLEAN is
   begin
      Ada.Text_IO.put_Line("in costruttore S_GLOB");
      return true;
   end print;

   function Get_StatsRow(Competitor_Id_In : INTEGER;
                         Time_In : FLOAT) return STATS_ROW is
      Row2Return : STATS_ROW;
   begin
      Row2Return.Competitor_Id := Competitor_Id_In;
      Row2Return.Time := Time_In;
      return Row2Return;
   end Get_StatsRow;

   function Get_CompetitorId(Row : STATS_ROW) return INTEGER is
   begin
      return Row.Competitor_Id;
   end Get_CompetitorId;

   function Get_Time(Row : STATS_ROW) return FLOAT is
   begin
      return Row.Time;
   end Get_Time;



   function "<" (Left, Right : STATS_ROW) return BOOLEAN is
   begin

      if(Left.Time < Right.Time) then
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

      -- It add e new row with the given information. If in the current table there are no
      -- rows with the given COmpetitor_ID, than insert there the new data.
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
         -- If competitor's info are already saved in the current table,
         --+control what is the first
         --+ free table
         while Competitor_RowIndex /= -1 loop
            -- if there are no free table, create a new one
            if(Get_NextNode(Current_Table) = null) then
               Create_New(Current_Table);
            end if;
            Current_Table := Get_NextNode(Current_Table);
            Competitor_RowIndex := Current_Table.This.Find_RowIndex(CompetitorId_In);
         end loop;
         Current_Table.This.Add_Row(Get_StatsRow(CompetitorId_In,Time_In));

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

end Stats;

