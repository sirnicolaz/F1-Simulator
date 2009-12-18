package body Stats is

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
                  if(Find_RowIndex(Row_In.Competitor_Id)/=-1) then
                     Delete_Row(Find_RowIndex(Row_In.Competitor_Id));
                  end if;
                  Shift_Down(index);
                  Add_Row(Row_In,index);
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
         for index in Index_In..Statistics'LENGTH loop
            if(Statistics(index).Competitor_Id = -1) then
               EmptyIndex := index;
               exit;
            end if;
         end loop;

         if(EmptyIndex /= -1) and (EmptyIndex /= 1) then
            for index in reverse Index_In..EmptyIndex loop
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
            if(Statistics(Statistics'LENGTH).Competitor_Id = 1) then
               Full := true; -- Table is packed, then it's sufficient to control the last row to verify if table is full or not
            end if;
         end if;
         Full_Out := Full;
      end Is_Full;

      function Get_Size return INTEGER is
      begin
         return Statistics'LENGTH;
      end Get_Size;

      entry Wait_ClassificComplete when Full is
      begin
         null;
      end Wait_ClassificComplete;


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

   function Get_BestLapNum(StatsContainer : GENERIC_STATS ) return INTEGER is
   begin
      return StatsContainer.BestLap_Num;
   end Get_BestLapNum;

   function Get_BestLapTime(StatsContainer : GENERIC_STATS ) return FLOAT is
   begin
      return StatsContainer.BestLap_Time;
   end Get_BestLapTime;

   function Get_BestSectorsTime(StatsContainer : GENERIC_STATS ) return BESTSECTORS_TIME_POINT is
   begin
      return StatsContainer.BestSectors_Time;
   end Get_BestSectorsTime;

   procedure Update_Stats_Lap( StatsContainer : in out GENERIC_STATS;
                              BestLapNum_In : INTEGER;
                              BestLapTime_In : FLOAT) is
   begin
      StatsContainer.BestLap_Num := BestLapNum_In;
      StatsContainer.BestLap_Time := BestLapTime_In;
   end Update_Stats_Lap;

   procedure Update_Stats_Sector( StatsContainer : in out GENERIC_STATS;
                                 BestSectorNum_In : INTEGER;
                                 BestSectorTime_In : FLOAT) is
   begin
      StatsContainer.BestSectors_Time(BestSectorNum_In) := BestSectorTime_In;
   end Update_Stats_Sector;

   protected body SYNCH_GLOBAL_STATS is

      procedure Init_GlobalStats( Update_Interval_in : FLOAT ) is
      begin
         GlobStats.BestLap_Num := 0;
         GlobStats.BestLap_Time := 0.0;
         GlobStats.BestSectors_Time(0) := 0.0;
         GlobStats.BestSectors_Time(1) := 0.0;
         GlobStats.BestSectors_Time(2) := 0.0;
         GlobStats.BestLap_CompetitorId := 0;
         GlobStats.BestTimePerSector_CompetitorId(0) := 0;
         GlobStats.BestTimePerSector_CompetitorId(1) := 0;
         GlobStats.BestTimePerSector_CompetitorId(2) := 0;
         GlobStats.Update_Interval := Update_Interval_in;
      end Init_GlobalStats;

      procedure Set_CompetitorsQty (CompetitorsQty : INTEGER) is
      begin
         GlobStats.Statistics_Table := Get_New_SOCT_NODE(CompetitorsQty);
      end Set_CompetitorsQty;

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
         Current_Table : SOCT_NODE_POINT := GlobStats.Statistics_Table;
         Control_Var : BOOLEAN;

         procedure Create_New(Previous : in out SOCT_NODE_POINT) is
            Temp_NewTable : SOCT_NODE_POINT;
         begin
            Temp_NewTable := Get_New_SOCT_NODE(Previous.This.Get_Size);

            -- Every row that has time <= the time represented by the new table has to be
            -- inserted in the new table.
            for index in 1..Previous.This.Get_Size loop
               -- Se il tempo di un concorrente nella tabella precedente è maggiore anche della barriera
               -- rappresentata dalla nuova tabella, allora va salvato. Infatti nel caso venga chiesta una
               -- classifica aggiornata dell'istante di tempo inerente a questa tabella, il concorrente
               -- sarà nella stessa posizione (ovvero tratto checkpoint e lap) di quella precedente.
               if(Previous.This.Get_Row(index).Time >= FLOAT(Previous.Index) * GlobStats.Update_Interval) then
                  Temp_NewTable.This.Add_Row(Previous.This.Get_Row(index));
               end if;
            end loop;

            Set_NextNode(Previous,Temp_NewTable);
         end Create_New;

      begin
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

         Current_Table.This.Is_Full(Control_Var);
         if(Control_Var) then
            Create_New(Current_Table);
         end if;

      end Update_Stats;
   end SYNCH_GLOBAL_STATS;

end Stats;
