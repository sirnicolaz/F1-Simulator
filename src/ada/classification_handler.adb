with Competition_Computer;

package body Classification_Handler is

   Competitors : INTEGER;

   function Get_StatsRow(Competitor_Id_In : Integer;
                         Time_In : Float) return Stats_Row is
      Row2Return : Stats_Row;
   begin
      Row2Return.Competitor_Id := Competitor_Id_In;
      Row2Return.Time := Time_In;
      return Row2Return;
   end Get_StatsRow;

   function Get_Competitor_Id(Row : Stats_Row) return Integer is
   begin
      return Row.Competitor_Id;
   end Get_Competitor_Id;

   function Get_Time(Row : Stats_Row) return Float is
   begin
      return Row.Time;
   end Get_Time;

   procedure Set_Competitor_Id ( Row : out Stats_Row;
                                Competitor_Id : Integer ) is
   begin
      Row.Competitor_Id := Competitor_Id;
   end Set_Competitor_Id;

   procedure Set_Time ( Row : out Stats_Row;
                       Time : Float ) is
   begin
      Row.Time := Time;
   end Set_Time;

   function "<" (Left, Right : Stats_Row) return Boolean is
   begin

      if(Left.Time < Right.Time) then
         return true;
      else
         return false;
      end if;

   end "<";


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

   function Get_New_SOCT_NODE(Size : Integer) return SOCT_NODE_POINT is
      TempTableListNode : SOCT_NODE_POINT := new SOCT_NODE;
      TempSOCT : SOCT_POINT := new Synch_Ordered_Classification_Table;
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

   function IsLast(SynchOrdStatTabNode : SOCT_NODE_POINT) return Boolean is
   begin
      return SynchOrdStatTabNode.IsLast;
   end IsLast;

   function IsFirst(SynchOrdStatTabNode : SOCT_NODE_POINT) return Boolean is
   begin
      return SynchOrdStatTabNode.IsFirst;
   end IsFirst;

   function Get_Index(SynchOrdStatTabNode : SOCT_NODE_POINT) return Integer is
   begin
      return SynchOrdStatTabNode.Index;
   end Get_Index;

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

   protected body Synch_Ordered_Classification_Table is
      procedure Init_Table(NumRows : Integer) is
         NullRow : Stats_Row;
      begin
         NullRow.Competitor_Id := -1;
         NullRow.Time := -1.0;
         Statistics := new CLASSIFICATION_TABLE(1..NumRows);
         for index in Statistics'RANGE loop
            Statistics(index) := NullRow;
         end loop;

      end Init_Table;

      procedure Remove_Competitor is
         Tmp_Stats : CLASSIFICATION_TABLE_POINT;
         New_Size : Integer := Statistics'LENGTH - 1;
      begin

         Tmp_Stats := new CLASSIFICATION_TABLE(1..New_Size);
         --Copy elements from old array to new one
         for Index in 1..New_Size loop --Tmp_Stats'RANGE loop
            Tmp_Stats.all(Index).Competitor_Id := Statistics.all(Index).Competitor_Id;
            Tmp_Stats.all(Index).Time := Statistics.all(Index).Time;
         end loop;
         Statistics := Tmp_Stats;
      end Remove_Competitor;

      procedure Add_Row(Row_In : Stats_Row;
                        Index_In : Integer) is
      begin
         Statistics(Index_In) := Row_In;
      end Add_Row;


      procedure Add_Row(Row_In : Stats_Row) is
      begin


         if (Statistics(1).Competitor_Id = -1) then

            Add_Row(Row_In,1);
         else

            for index in Statistics'RANGE loop
               if(Row_In < Statistics(index) ) then
                  if(Find_RowIndex(Row_In.Competitor_Id) /= -1) then
                     Delete_Row(Find_RowIndex(Row_In.Competitor_Id));
                  end if;
                  Shift_Down(index);
                  Add_Row(Row_In,index);


                  exit;
               elsif(Statistics(index).Competitor_Id = -1) then
                  Add_Row(Row_In,index);

                  exit;
               end if;
            end loop;
         end if;

      end Add_Row;

      procedure Remove_Row(Index_In : Integer;
                           Row_Out : in out Stats_Row) is
      begin
         Row_Out := Statistics(Index_In);
         Delete_Row(Index_In);
      end Remove_Row;

      procedure Delete_Row(Index_In : Integer) is
         NullRow : Stats_Row;
      begin
         NullRow.Competitor_Id := -1;
         Statistics(Index_In) := NullRow;
      end Delete_Row;

      procedure Shift_Down(Index_In : Integer) is
         EmptyIndex : Integer := -1;
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


      function Get_Row(Index_In : Integer) return Stats_Row is
      begin
         return Statistics(Index_In);
      end Get_Row;

      function Find_RowIndex(CompetitorId_In : Integer) return Integer is
      begin
         for index in Statistics'RANGE loop
            if(Statistics(index).Competitor_Id = CompetitorID_In) then
               return index;
            end if;
         end loop;
         return -1;
      end Find_RowIndex;

      procedure Is_Full(Full_Out : out Boolean) is
      begin
         if(not Full) then
            if(Statistics(Statistics'LENGTH).Competitor_Id /= -1) then
               Full := true; -- Table is packed, then it's sufficient to control the last row to verify if table is full or not
            end if;
         end if;
         Full_Out := Full;
      end Is_Full;

      function Get_Size return Integer is
      begin
         return Statistics'LENGTH;
      end Get_Size;

   end Synch_Ordered_Classification_Table;

   procedure Update_Classific(Competitor_ID : INTEGER;
                              CompletedLap : INTEGER;
                              Time : FLOAT) is
      Row : STATS_ROW;
   begin
      --Find the right table for this lap
      Set_Competitor_Id(Row, Competitor_ID);
      Set_Time(Row, Time);

      --Add the information inside
      Classification_Tables.all(CompletedLap).Add_Row(Row);
      --Done

   end Update_Classific;


   --It returs the competitors who have been lapped at a certain time instant
   --+ (the lap it's necessary to optimize the retrieval: only the competitors
   --+ riding in a previous lap during the given instant will be kept in consideration).
   procedure Get_LappedCompetitors(TimeInstant : FLOAT;
                                   CurrentLap : INTEGER;
                                   CompetitorIDs_PreviousClassific : out INTEGER_ARRAY_POINT;
                                   Times_PreviousClassific : out FLOAT_ARRAY_POINT;
                                   Competitor_IDs : out INTEGER_ARRAY_POINT;
                                   Competitor_Lap : out INTEGER_ARRAY_POINT) is
      Temp_Row : STATS_ROW;
      PolePosition_Time : FLOAT;
      ProcessedCompetitors_IdList : INTEGER_ARRAY(1..Competitors);--alias for Competitors
      NotLapped_Count : INTEGER := 0;
      PreviousClassific_Count : INTEGER := 0;
      Lapped_Competitors : INTEGER := 0;
      Lapped_Count : INTEGER := 0;
      ExitLoop : BOOLEAN := false;
   begin
      --Init the processed competitors id list array: when the array position is filled with 1 it means that the
      --+ competitor with id corresponding to that index has not been processed yet (we don't know whether he
      --+ has been lapped or not)
      for id in ProcessedCompetitors_IdList'RANGE loop
         if(Competition_Computer.Is_CompetitorOut(id,TimeInstant) = TRUE) then
            --The competitor is no longer in the classific
            ProcessedCompetitors_IdList(id) := 1;
            NotLapped_Count := NotLapped_Count + 1;
         else
            ProcessedCompetitors_IdList(id) := 0;
         end if;
      end loop;

      --Pick up the pole position time in the classification table related the CurrentLap
      PolePosition_Time := Get_Time(Classification_Tables.all(CurrentLap+1).Get_Row(1));

      -- search backward (in the table list) the lap of the lapped competitors. It will be (for each competitor)
      --+ the index of the first table where the competitor has written a time less then the best time
      --+ found at the beginning of the method. If such table is the one before the current one, it's not lapped.

      --Find out the competitors already into the previous table after the pole position time.
      --+Those competitors will not be counted in the lapped list.
      if( CurrentLap > 0) then

         for Index in 1..Classification_Tables.all(CurrentLap).Get_Size loop

            Temp_Row := Classification_Tables.all(CurrentLap).Get_Row(Index);
            if (Get_Competitor_Id(Temp_Row) /= -1 and then Get_Time(Temp_Row) <= PolePosition_Time
		and then ProcessedCompetitors_IdList(Get_Competitor_Id(Temp_Row)) /= 1) then

               ProcessedCompetitors_IdList(Get_Competitor_Id(Temp_Row)) := 1;
               NotLapped_Count := NotLapped_Count + 1;
	       PreviousClassific_Count := PreviousClassific_Count + 1;
	     --It means that it was considered as out of competition in the previous check and so not counted as being in the previous lap.
	    --+ so now we find out that before being squalified he completed the previous lap and so he's to be added to the previousClassific count
            elsif(Get_Competitor_Id(Temp_Row) /= -1 and then Get_Time(Temp_Row) <= PolePosition_Time
		and then ProcessedCompetitors_IdList(Get_Competitor_Id(Temp_Row)) = 1 and then Competition_Computer.Is_CompetitorOut(Get_Competitor_Id(Temp_Row),TimeInstant) = TRUE) then
		    PreviousClassific_Count := PreviousClassific_Count + 1;
	    else
               ExitLoop := true;
            end if;

            exit when ExitLoop = true;
         end loop;

         --Filling up the array with competitors that have not started the new lap yet but that have already
         --+ finished the previous one (so, they have a classification time for that lap). This is done to
         --+ avoid the problem o "skipped competitor in classification"
         if(PreviousClassific_Count /= 0) then

	    CompetitorIDs_PreviousClassific := new INTEGER_ARRAY(1..PreviousClassific_Count);
	    Times_PreviousClassific := new FLOAT_ARRAY(1..PreviousClassific_Count);
	    for Index in 1..Classification_Tables.all(CurrentLap).Get_Size loop
	      Temp_Row := Classification_Tables.all(CurrentLap).Get_Row(Index);
	      if (Get_Competitor_Id(Temp_Row) /= -1 and Get_Time(Temp_Row) <= PolePosition_Time) then

		CompetitorIDs_PreviousClassific(Index) := Get_Competitor_Id(Temp_Row);
		Times_PreviousClassific(Index) := Get_Time(Temp_Row);
	      else
		exit;
	      end if;
	    end loop;
	 else
	  CompetitorIDs_PreviousClassific := null;
	  Times_PreviousClassific := null;
	 end if;

         if(Competitors-NotLapped_Count = 0) then
            Competitor_IDs := null;
            Competitor_Lap := null;
         else

            Competitor_IDs := new INTEGER_ARRAY(1..Competitors-NotLapped_Count);
            Competitor_Lap := new INTEGER_ARRAY(1..Competitors-NotLapped_Count);
            --Initialise these 2 arrays
            for i in Competitor_Lap'RANGE loop
               Competitor_IDs.all(i) := -1;
               Competitor_Lap.all(i) := -1;
            end loop;

            ExitLoop := false;
            --Loop backward in the classification table list and find id and lap of lapped competitors
            for Index in reverse 1..CurrentLap-1 loop

               for i in 1..Classification_Tables.all(Index).Get_Size loop

                  Temp_Row := Classification_Tables.all(Index).Get_Row(i);
                  if (Get_Time(Temp_Row) /= -1.0 and then
                        Get_Time(Temp_Row) <= PolePosition_Time and then
                          ProcessedCompetitors_IdList(Get_Competitor_Id(Temp_Row)) = 0 ) then

                     Lapped_Count := Lapped_Count + 1;
                     ProcessedCompetitors_IdList(Get_Competitor_Id(Temp_Row)) := 1;

                     Competitor_IDs.all(Lapped_Count) := Get_Competitor_Id(Temp_Row);

		     Competitor_Lap.all(Lapped_Count) := Index;--In the interface laps are counted starting by 0

		  end if;
               end loop;
            end loop;

            --If a competitor is still riding in the first lap, he will not appear in the tables.
            --+ So let's fill up the remaining positions of the lapped array
            for Index in 1..ProcessedCompetitors_IdList'LENGTH loop
               if(ProcessedCompetitors_IdList(Index) = 0) then
                  Lapped_Count := Lapped_Count + 1;
                  ProcessedCompetitors_IdList(Index) := 1;
                  Competitor_IDs.all(Lapped_Count) := Index;
                  Competitor_Lap.all(Lapped_Count) := 0;
               end if;
            end loop;
         end if;
      else
         --If the lap is the first one, impossible to have lapped competitors
         Competitor_IDs := null;
         Competitor_Lap := null;
      end if;

   end Get_LappedCompetitors;

   procedure Get_LapClassific(Lap : INTEGER;
                              TimeInstant : FLOAT;
                              CompetitorID_InClassific : out INTEGER_ARRAY_POINT;
                              Times_InClassific : out FLOAT_ARRAY_POINT;
                              CompetitorIDs_PreviousClassific : out INTEGER_ARRAY_POINT;
                              Times_PreviousClassific : out FLOAT_ARRAY_POINT;
                              LappedCompetitors_ID : out INTEGER_ARRAY_POINT;
                              LappedCompetitors_CurrentLap : out INTEGER_ARRAY_POINT) is
      Temp_Row : STATS_ROW;
      InClassific_Count : INTEGER := 0;
      ExitLoop : BOOLEAN := FALSE;
   begin

      for Index in 1..Classification_Tables.all(Lap+1).Get_Size loop
         Temp_Row := Classification_Tables.all(Lap+1).Get_Row(Index);

         --Competitor in classific
         if(Get_Competitor_Id(Temp_Row) /= -1 and Get_Time(Temp_Row) <= TimeInstant) then

            InClassific_Count := InClassific_Count + 1;
         else
            -- it means that the following rows have either a greater time instant
            --+ or are not set yet (and they will be set in a time instatn greater than
            --+ the asked one)
            ExitLoop := TRUE;
         end if;

         exit when ExitLoop = true;
      end loop;

      CompetitorID_InClassific := new INTEGER_ARRAY(1..InClassific_Count);
      Times_InClassific := new FLOAT_ARRAY(1..InClassific_Count);
      ExitLoop := FALSE;

      for Index in 1..InClassific_Count loop
         Temp_Row := Classification_Tables.all(Lap+1).Get_Row(Index);
         if(Get_Competitor_Id(Temp_Row) /= -1 and then Get_Time(Temp_Row) <= TimeInstant) then
            --Rows are already ordered by arrival time, so we can keep this order for
            --+ writing the classific in the array
            CompetitorID_InClassific.all(Index) := Get_Competitor_Id(Temp_Row);
            Times_InClassific.all(Index) := Get_Time(Temp_Row);
         else
            ExitLoop := TRUE;
         end if;

         exit when ExitLoop = TRUE;
      end loop;

      Get_LappedCompetitors(TimeInstant,
                            Lap,
                            CompetitorIDs_PreviousClassific,
                            Times_PreviousClassific,
                            LappedCompetitors_ID,
                            LappedCompetitors_CurrentLap);

   end Get_LapClassific;

   procedure Decrease_Classification_Size_From_Lap( Lap : Integer ) is
   begin
      for Index in Lap+1..Classification_Tables.all'LENGTH loop
         Classification_Tables.all(Index).Remove_Competitor;
      end loop;
   end Decrease_Classification_Size_From_Lap;

   procedure Initialize(Laps : Integer;
                        Competitors_In : Integer) is
   begin
      Competitors := Competitors_In;
      Classification_Tables := new SOCT_ARRAY(1..Laps);
      for Index in Classification_Handler.Classification_Tables'RANGE loop
         Classification_Tables.all(Index) := new SYNCH_ORDERED_CLASSIFICATION_TABLE;
         Classification_Tables.all(Index).Init_Table(Competitors_In);
      end loop;
   end Initialize;

end Classification_Handler;
