package Stats is

   type GENERIC_STATS is tagged private;
   --type COMPETITOR_STATS is new GENERIC_STATS with private;
   type GLOBAL_STATS is new GENERIC_STATS with private;

   type STATS_ROW is private;
   function "<" (Left, Right : STATS_ROW) return BOOLEAN;

   type STATS_TABLE is array(POSITIVE range <>) of STATS_ROW;
   type STATS_TABLE_POINT is access STATS_TABLE;


   -- Resource used to maintain statistics ordered and mutually-exclusive accessible
   protected type SYNCH_ORDERED_STATS_TABLE is
      procedure Init_Table(NumRows : INTEGER);
      procedure Add_Row(Row_In : STATS_ROW;
                        Index_In : INTEGER);
      procedure Add_Row(Row_In : STATS_ROW);
      procedure Remove_Row(Index_In : INTEGER;
                           Row_Out : in out STATS_ROW);
      procedure Delete_Row(Index_In : INTEGER);
      procedure Shift_Down(Index_In : INTEGER);
      function Get_Row(Index_In : INTEGER) return STATS_ROW;
      function Find_RowIndex(CompetitorId_In : INTEGER) return INTEGER;
   private
      Statistics : STATS_TABLE_POINT;
   end SYNCH_ORDERED_STATS_TABLE;

   type SOST_POINT is access SYNCH_ORDERED_STATS_TABLE;

   type BESTSECTORS_TIME is array(INTEGER range <> ) of FLOAT;
   type BESTSECTORS_TIME_POINT is access BESTSECTORS_TIME;

   type BESTSECTORS_TIME_COMPETITORSID is array( INTEGER range <> ) of INTEGER;
   type BESTSECTORS_TIME_COMPETITORSID_POINT is access BESTSECTORS_TIME_COMPETITORSID;

   function Get_BestLapNum(StatsContainer : GENERIC_STATS ) return INTEGER;
   function Get_BestLapTime(StatsContainer : GENERIC_STATS ) return FLOAT;
   function Get_BestSectorsTime(StatsContainer : GENERIC_STATS ) return BESTSECTORS_TIME_POINT;
   procedure Update_Stats_Lap( StatsContainer : in out GENERIC_STATS;
                              BestLapNum_In : INTEGER;
                              BestLapTime_In : FLOAT);
   procedure Update_Stats_Sector( StatsContainer : in out GENERIC_STATS;
                                 BestSectorNum_In : INTEGER;
                                 BestSectorTime_In : FLOAT);


private

   type GENERIC_STATS is tagged record
      BestLap_Num : INTEGER; -- Num of best time lap
      BestLap_Time : FLOAT;
      BestSectors_Time : BESTSECTORS_TIME_POINT;
   end record;

   type GLOBAL_STATS is new GENERIC_STATS with
      record
         BestLap_CompetitorId : INTEGER;
         BestTimePerSector_CompetitorId : BESTSECTORS_TIME_COMPETITORSID_POINT;
         FirstTableFree : INTEGER; --maybe unuseful if table is freed each time it's completed
	 Statistics_Table : SOST_POINT;
      end record;

   type STATS_ROW is
      record
         Competitor_Id : INTEGER;
         Lap_Num : INTEGER;
         Checkpoint_Num : INTEGER;
         Time : FLOAT;
      end record;

end Stats;
