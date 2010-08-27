with Ada.Text_IO;

package body Box_Data is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;


   procedure Set_Node(Info_Node_Out : in out INFO_NODE_POINT; Value : COMPETITION_UPDATE ) is
   begin
      Info_Node_Out.This := new COMPETITION_UPDATE;
      Info_Node_Out.This.all := Value;
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
         Value.Previous := Info_Node_Out;
         Value.Index := Info_Node_Out.Index + 1;
         Info_Node_Out.Next := Value;
      end if;
   end Set_NextNode;

   function Search_Node( Starting_Node : in INFO_NODE_POINT;
                        Num : in INTEGER) return INFO_NODE_POINT is
      Iterator : INFO_NODE_POINT := Starting_Node;
   begin
      if (Iterator /= null) then
         if (Iterator.Index < Num ) then
            --Search forward
            loop
               Iterator := Iterator.Next;
               exit when Iterator = null or else Iterator.Index = Num;
            end loop;
         elsif (Iterator.Index > Num) then
            --Search backward
            loop
               Iterator := Iterator.Previous;
               exit when Iterator.Previous = null or else Iterator.Index = Num;
            end loop;
         end if;
      end if;

      return Iterator;

   end Search_Node;


   protected body SYNCH_COMPETITION_UPDATES is

      procedure Add_Data(CompetitionUpdate_In : COMPETITION_UPDATE_POINT) is
         New_Update : INFO_NODE_POINT := new INFO_NODE;

      begin
         -- If info related to a time interval are already saved, do nothing.
         if(Updates_Last = null) then
            New_Update.This := new COMPETITION_UPDATE;
            New_Update.This.all := CompetitionUpdate_In.all;
            Updates_Last := New_Update;
            Updates_Last.Index := 1;
            Updates_Last.Previous := null;
            Updates_Last.Next := null;
            Updates_Current := Updates_Last;
            Updated := true;
         elsif (Updates_Last.This.Time < CompetitionUpdate_In.Time) then

            New_Update.This := new COMPETITION_UPDATE;

            New_Update.This.all := CompetitionUpdate_In.all;

            Set_NextNode(Updates_Last,New_Update);

            Updates_Last := New_Update;
            Updated := True;
         end if;
      exception when Program_Error =>
            Ada.Text_IO.Put_Line("Constraint error adding update");


      end Add_Data;

      entry Wait(NewInfo : out COMPETITION_UPDATE;
                 Num : in INTEGER) when Updated is
      begin
         requeue Get_Update;
      end Wait;

      entry Get_Update( NewInfo : out COMPETITION_UPDATE;
                       Num : INTEGER ) when true is
      begin
         if ( Updates_Last = null or else Updates_Last.Index < Num ) then
            Updated := false;
            requeue Wait;
         else
            Updates_Current := Search_Node(Updates_Current, Num);
            NewInfo := Updates_Current.This.all;
         end if;
      end Get_Update;

      function IsUpdated return BOOLEAN is
      begin
         return Updated;
      end;

   end SYNCH_COMPETITION_UPDATES;

   protected body SYNCH_STRATEGY_HISTORY is

      procedure Init( Lap_Qty : in INTEGER ) is
      begin
         history := new STRATEGY_HISTORY(0..Lap_Qty);
      end Init;

      procedure AddStrategy( Strategy_in : in STRATEGY ) is
      begin
         Ada.Text_IO.Put_Line("Adding strategy with");
         Ada.Text_IO.Put_Line("gas: " & FLOAT'IMAGE(Strategy_In.GasLevel));
         Ada.Text_IO.Put_Line("tyre: " & Unbounded_String.To_String(Strategy_In.Type_Tyre));
         Ada.Text_IO.Put_Line("pit stop laps:" & INTEGER'IMAGE(Strategy_In.PitStopLaps));


         Ada.Text_IO.Put_Line("History size " & INTEGER'IMAGE(history_size));

         history.all(history_size) := Strategy_in;
         history_size := history_size + 1;
         Updated := true;
         Ada.Text_IO.Put_Line("Strategy "& Common.IntegerToString(history_size-1) & " added");
         exception when Constraint_Error =>
            Ada.Text_IO.Put("Either the resource SYNCH_STRATEGY_HISTORY not initialised or ");
            Ada.Text_IO.Put("the history array has had an access violation.");
      end AddStrategy;

      entry Get_Strategy( NewStrategy : out STRATEGY ;
                 Lap : in INTEGER) when Updated is
      begin
         Ada.Text_IO.Put_Line("Retrieving new strategy for lap " & Common.IntegerToString(Lap));
         Ada.Text_IO.Put_Line("History size " & Common.IntegerToString(history_size));
         --TODO: verify whether to put <= or <
         if Lap < history_size then
            Ada.Text_IO.Put_Line("Strategy got");
            NewStrategy := history.all(Lap);
         else
            Ada.Text_IO.Put_Line("Strategy missing");
            Updated := false;
            requeue Get_Strategy;
         end if;

      end Get_Strategy;

      -- TODO: test it
      function Get_PitStopDone return INTEGER is
         TotalPitStops : INTEGER := 0;
      begin
         for Index in 1..history_size loop
            if history(Index).PitStopLaps = 0 then
               TotalPitStops := TotalPitStops + 1;
            end if;
            end loop;
         return TotalPitStops;
      end Get_PitStopDone;

   end SYNCH_STRATEGY_HISTORY;

   protected body SYNCH_ALL_INFO_BUFFER is
      procedure Init( Size : POSITIVE) is
      begin
         Info_List := new ALL_INFO_ARRAY(1..Size);
         Ready := true;
      end Init;

      entry Get_Info( Num : POSITIVE; Info : out ALL_INFO ) when Ready = true is
      begin
         Ada.Text_IO.Put_Line("DEBUG Getting info");
         if( Num <= Info_Qty ) then
            Ada.Text_IO.Put_Line("DEBUG Info ready");
            Info := Info_List.all(Num);
         else
            Ada.Text_IO.Put_Line("DEBUG Info not ready");
            Updated := false;
            requeue Wait;
         end if;
      end Get_Info;

      entry Wait( Num : POSITIVE; Info : out ALL_INFO ) when Updated = true is
      begin
         Ada.Text_IO.Put_Line("DEBUG Stop waiting");
         requeue Get_Info;
      end Wait;

      procedure Add_Info(Update_In : EXT_COMPETITION_UPDATE ) is
      begin
         Ada.Text_IO.Put_Line("DEBUG Adding extended info to buffer");
         Info_Qty := Info_Qty + 1;
         Info_List.all(Info_Qty).PerSectorUpdate := new EXT_COMPETITION_UPDATE;
         Info_List.all(Info_Qty).PerSectorUpdate.all := Update_In;
         Updated := true;
      end Add_Info;

      procedure Add_Info(Update_In : EXT_COMPETITION_UPDATE;
                         Strategy_In : STRATEGY) is
      begin
         Add_Info(Update_In);
         Ada.Text_IO.Put_Line("DEBUG Adding strategy to buffer");
         Info_List.all(Info_Qty).StrategyUpdate := new STRATEGY;
         Info_List.all(Info_Qty).StrategyUpdate.all := Strategy_In;
      end Add_Info;

   end SYNCH_ALL_INFO_BUFFER;



   function Get_StrategyXML( Data : ALL_INFO ) return Unbounded_String.Unbounded_String is
      Tmp_String : Unbounded_String.Unbounded_String;
   begin
      Ada.Text_IO.Put_Line("DEBUG Getting xml strategy");
      if(Data.StrategyUpdate /= null) then
         Tmp_String := Unbounded_String.To_Unbounded_String(BoxStrategyToXML(Data.StrategyUpdate.all));
      else
         Tmp_String := Unbounded_String.To_Unbounded_String("");
      end if;

      return Tmp_String;
   end Get_StrategyXML;

   function Get_UpdateXML( Data : ALL_INFO ) return Unbounded_String.Unbounded_String is
      Tmp_String : Unbounded_String.Unbounded_String;
   begin
      Ada.Text_IO.Put_Line("DEBUG Getting xml update");
      Tmp_String := Unbounded_String.To_Unbounded_String
        ("<status>" &
         "<gasLevel>" & Common.FloatToString(Data.PerSectorUpdate.GasLevel) & "</gasLevel>" &
         "<tyreUsury>" & Common.FloatToString(Data.PerSectorUpdate.TyreUsury) & "</tyreUsury>" &
         "<lap>" & Common.IntegerToString(Data.PerSectorUpdate.Lap) & "</lap> " &
         "<sector>" & Common.IntegerToString(Data.PerSectorUpdate.Sector) & "</sector>" &
         "<metres>" & Common.FloatToString(Data.PerSectorUpdate.PathLength) & "</metres>" &
         "<meanTyreUsury>" & Common.FloatToString(Data.PerSectorUpdate.MeanTyreUsury) & "</meanTyreUsury>" &
         "<meanGasConsumption>" & Common.FloatToString(Data.PerSectorUpdate.MeanGasConsumption) & "</meanGasConsumption>" &
         "</status>" );

      return Tmp_String;
   end Get_UpdateXML;

   function Get_Time ( Data : ALL_INFO ) return FLOAT is
   begin
      Ada.Text_IO.Put_Line("DEBUG Getting time");
      return Data.PerSectorUpdate.Time;
   end Get_Time;

   function BoxStrategyToXML(Strategy_in : STRATEGY) return STRING is


      Style : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

      XML_String : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

   begin
      Ada.Text_IO.Put_Line("Producing xml strategy...");

      case Strategy_in.Style is
         when AGGRESSIVE =>
            Style := Unbounded_String.To_Unbounded_String("Aggressive");
         when NORMAL =>
            Style := Unbounded_String.To_Unbounded_String("Normal");
         when CONSERVATIVE =>
            Style := Unbounded_String.To_Unbounded_String("Conservative");
         when others =>
            Ada.Text_IO.Put_Line("Error, no style set");
      end case;

      Ada.Text_IO.Put_Line("Creating xml string");
      XML_String := Unbounded_String.To_Unbounded_String
        ("<strategy>");

      Ada.Text_IO.Put_Line("Setting tyre");
      XML_STring := XML_String &
      Unbounded_String.To_Unbounded_String("<tyreType>") &
      Strategy_in.Type_Tyre &
      Unbounded_String.To_Unbounded_String("</tyreType>");
      Ada.Text_IO.Put_Line("First part of the strategy " & Unbounded_String.To_String(XML_String));

      Ada.Text_IO.Put_Line("Setting style");
      XML_String := XML_String &
      Unbounded_String.To_Unbounded_String("<style>") &
      Style &
      Unbounded_String.To_Unbounded_String("</style>");

      Ada.Text_IO.Put_Line("Setting gas level");
      XML_String := XML_String &
      Unbounded_String.To_Unbounded_String("<gasLevel>") &
      FloatToString(Strategy_in.GasLevel) &
      Unbounded_String.To_Unbounded_String("</gasLevel>");

      Ada.Text_IO.Put_Line("Setting put stop laps" & Common.IntegerToString(Strategy_in.PitStopLaps));
      XML_String := XML_String &
      Unbounded_String.To_Unbounded_String("<pitStopLaps>") &
      IntegerToString(Strategy_in.PitStopLaps) &
      Unbounded_String.To_Unbounded_String("</pitStopLaps>");

      Ada.Text_IO.Put_Line("Setting pit stop delay");
      Ada.Text_IO.Put_Line("pit stop delay " & FLOAT'IMAGE(Strategy_in.PitStopDelay));
      XML_String := XML_String &
      Unbounded_String.To_Unbounded_String("<pitStopDelay>") &
      FloatToString(Strategy_in.PitStopDelay) &
      Unbounded_String.To_Unbounded_String("</pitStopDelay>" &
                                           "</strategy>");

      Ada.Text_IO.Put_Line("Strategy done");

      return Unbounded_String.To_String(XML_String);
   end BoxStrategyToXML;

end Box_Data;
