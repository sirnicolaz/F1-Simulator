package body Box is

   UpdatesBuffer : SYNCH_UPDATES_BUFFER;

   task body MONITOR is
      Infos : COMPETITION_INFOS;
      Sector : INTEGER := 0;
      Lap : INTEGER := 0;
   begin
      loop
         -- Infos := RequestInfos (Competitor_Id,Sector,Lap);
         UpdatesBuffer.Add_Data(Infos);
         exit when Infos.Time = -1.0;
         Sector := Sector + 1;
         if(Sector = Sector_Qty) then
            Sector := 0;
            Lap := Lap + 1;
         end if;

      end loop;

   end MONITOR;

   -- Intanto è solo la bozza dello scheletro. In base all'algoritmo
   -- che si deciderà di utilizzare, verranno adottati più o meno
   -- parametri.
   function Compute_Strategy(
                             New_Infos : COMPETITION_INFOS;
                             Old_Infos : COMPETITION_INFOS;
                             Old_Strategy : BOX_STRATEGY
                            ) return BOX_STRATEGY is
      New_Strategy : BOX_STRATEGY;
   begin
      return New_Strategy;
   end Compute_Strategy;

   task body STRATEGY_CALCULATOR is
      Old_Infos : COMPETITION_INFOS;
      New_Infos : COMPETITION_INFOS;
      Strategy : BOX_STRATEGY;
      Sector : INTEGER := 0;
   begin
      Old_Infos.GasLevel := 0.0;
      Old_Infos.TyreUsury := 0.0;
      Old_Infos.MeanSpeed := 0.0;
      Old_Infos.MeanGasConsumption := 0.0;
      Old_Infos.Time := 0.0;
      New_Infos.GasLevel := 0.0;
      New_Infos.TyreUsury := 0.0;
      New_Infos.MeanSpeed := 0.0;
      New_Infos.MeanGasConsumption := 0.0;
      New_Infos.Time := 0.0;
      Strategy.Type_Tyre := "Regular             ";
      Strategy.Style := NORMAL;
      Strategy.GasLevel := 0.0;
      Strategy.PitStopLap := 1;
      Strategy.PitStopDelay := 0.0;
      -- Time = -1.0 means that race is over.
      loop
         UpdatesBuffer.Wait(New_Infos);
         exit when New_Infos.Time /= -1.0;
         Sector := Sector + 1;
         Strategy := Compute_Strategy(New_Infos    => New_Infos,
                                      Old_Infos    => Old_Infos,
                                      Old_Strategy => Strategy
                                     );
         if(Sector = Sector_Qty) then
            -- send strategy to competitor
            Sector := 0;
         end if;
         Old_Infos := New_Infos;
      end loop;
   end STRATEGY_CALCULATOR;


   procedure Set_Node(Info_Node_Out : in out INFO_NODE_POINT; Value : Competition_Infos ) is
   begin
        Info_Node_Out.This := Value;
   end Set_Node;

   procedure Set_PreviousNode(Info_Node_Out : in out Info_Node_POINT ; Value : in out Info_Node_POINT) is
   begin
      if(Value /= null) then
         Info_Node_Out.Previous := Value;
         Info_Node_Out.Previous.Next := Info_Node_Out;
         Info_Node_Out.Index := Info_Node_Out.Previous.Index + 1;
      end if;
   end Set_PreviousNode;

   procedure Set_NextNode(Info_Node_Out : in out Info_Node_POINT; Value : in out Info_Node_POINT ) is
   begin
      if(Value /= null) then
         Info_Node_Out.Next := Value;
         Info_Node_Out.Next.Previous := Info_Node_Out;
         Info_Node_Out.Next.Index := Info_Node_Out.Index + 1;
      end if;
   end Set_NextNode;

   protected body SYNCH_UPDATES_BUFFER is

      procedure Init_Buffer is
      begin
         Updated := False;
         Updates_Current.Index := 1;
         Updates_Current.Previous := null;
         Updates_Current.Next := null;
         Updates_Current.This.MeanSpeed := -1.0;
         Updates_Last := Updates_Current;
      end Init_Buffer;

      procedure Add_Data(Competition_Infos_In : COMPETITION_INFOS) is
         New_Update : INFO_NODE_POINT := new INFO_NODE;
      begin
         -- If infos related to a time interval are already saved, do nothing.
         if(Updates_Last.Previous = null) or (Updates_Last.Previous.This.Time >= Competition_Infos_In.Time) then
            Updates_Last.This := Competition_Infos_In;
            Set_NextNode(Updates_Last,New_Update);
            Updates_Last := New_Update;
            Updated := True;
         end if;
      end Add_Data;

      entry Wait(NewInfos : out COMPETITION_INFOS) when Updated is
         New_Update : INFO_NODE_POINT;
      begin
         NewInfos := Updates_Current.This;
         if(Updates_Current.Next = null) then
            New_Update :=  new INFO_NODE;
            Set_NextNode(Updates_Current,New_Update);
            Updates_Current := New_Update;
            Updated := false;
         end if;
      end Wait;

      function IsUpdated return BOOLEAN is
      begin
         return Updated;
      end;

   end SYNCH_UPDATES_BUFFER;

begin
   UpdatesBuffer.Init_Buffer;
end Box;
