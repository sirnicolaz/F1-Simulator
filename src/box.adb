with CORBA.ORB;

package body Box is

   UpdatesBuffer : SYNCH_COMPETITION_UPDATES;
   CompetitorRadio_IOR : STRING;

   task body MONITOR is
      Info : COMPETITION_UPDATE;
      Sector : INTEGER := 0;
      Lap : INTEGER := 0;
   begin
      loop
         -- Infos := RequestInfos (Competitor_Id,Sector,Lap);
         UpdatesBuffer.Add_Data(Info);
         exit when Info.Time = -1.0;
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
                             New_Info : COMPETITION_UPDATE;
                             Old_Info : COMPETITION_UPDATE;
                             Old_Strategy : BOX_STRATEGY
                            ) return BOX_STRATEGY is
      New_Strategy : BOX_STRATEGY;
   begin
      return New_Strategy;
   end Compute_Strategy;

   task body STRATEGY_UPDATER is
      Old_Info : COMPETITION_UPDATE;
      New_Info : COMPETITION_UPDATE;
      Strategy : BOX_STRATEGY;
      Sector : INTEGER := 0;
   begin
      Old_Info.GasLevel := 0.0;
      Old_Info.TyreUsury := 0.0;
      Old_Info.MeanSpeed := 0.0;
      Old_Info.MeanGasConsumption := 0.0;
      Old_Info.Time := 0.0;
      New_Info.GasLevel := 0.0;
      New_Info.TyreUsury := 0.0;
      New_Info.MeanSpeed := 0.0;
      New_Info.MeanGasConsumption := 0.0;
      New_Info.Time := 0.0;
      Strategy.Type_Tyre := "Regular             ";
      Strategy.Style := NORMAL;
      Strategy.GasLevel := 0.0;
      Strategy.PitStopLap := 1;
      Strategy.PitStopDelay := 0.0;
      -- Time = -1.0 means that race is over.
      loop
         UpdatesBuffer.Wait(New_Info);
         exit when New_Info.Time /= -1.0;
         Sector := Sector + 1;
         Strategy := Compute_Strategy(New_Info    => New_Info,
                                      Old_Info    => Old_Info,
                                      Old_Strategy => Strategy
                                     );
         if(Sector = Sector_Qty) then
            -- send strategy to competitor
            Sector := 0;
         end if;
         Old_Info := New_Info;
      end loop;
   end STRATEGY_UPDATER;


   procedure Set_Node(Info_Node_Out : in out INFO_NODE_POINT; Value : COMPETITION_UPDATE ) is
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

   protected body SYNCH_COMPETITION_UPDATES is

      procedure Init_Buffer is
      begin
         Updated := False;
         Updates_Current.Index := 1;
         Updates_Current.Previous := null;
         Updates_Current.Next := null;
         Updates_Current.This.MeanSpeed := -1.0;
         Updates_Last := Updates_Current;
      end Init_Buffer;

      procedure Add_Data(CompetitionUpdate_In : COMPETITION_UPDATE) is
         New_Update : INFO_NODE_POINT := new INFO_NODE;
      begin
         -- If info related to a time interval are already saved, do nothing.
         if(Updates_Last.Previous = null) or (Updates_Last.Previous.This.Time >= CompetitionUpdate_In.Time) then
            Updates_Last.This := CompetitionUpdate_In;
            Set_NextNode(Updates_Last,New_Update);
            Updates_Last := New_Update;
            Updated := True;
         end if;
      end Add_Data;

      entry Wait(NewInfos : out COMPETITION_UPDATE) when Updated is
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

   end SYNCH_COMPETITION_UPDATES;

   procedure SendStrategy(New_Strategy : BOX_STRATEGY) is
      orb : CORBA.ORB;
   begin
      --Initialise the connection with the competitor radio
      orb := CORBA.ORB.Init(CompetitorRadio_IOR, null);
      --Invoke the method to communicate the new strategy
   end SendStrategy;

   procedure StrategyEmergencyRequest (Lap : INTEGER;
                                       Update : COMPETITION_UPDATE) is
   begin
      null;
   end StrategyEmergencyRequest;

   procedure RequestPitstop is
   begin
      null;
   end RequestPitstop;


begin
   UpdatesBuffer.Init_Buffer;

end Box;
