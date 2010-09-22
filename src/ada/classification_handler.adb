package body Classification_Handler is

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

end Classification_Handler;
