package body Stats is

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

   protected body SYNCH_ORDERED_STATS_TABLE is
      procedure Init_Table(NumRows : INTEGER) is
         NullRow : STATS_ROW;
      begin
         NullRow.Competitor_Id := -1;
         Statistics := new STATS_TABLE(1..NumRows);
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
            for index in Statistics'RANGE loop
               if(Statistics(index) < Row_In ) then
                  if(Find_RowIndex(Row_In.Competitor_Id)/=-1) then
                     Delete_Row(Find_RowIndex(Row_In.Competitor_Id));
                  end if;
                  Shift_Down(index);
                  Add_Row(Row_In,index);
               end if;
            end loop;
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

         if(EmptyIndex /= -1) then
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

   end SYNCH_ORDERED_STATS_TABLE;

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

end Stats;
