with Ada.Text_IO;

package body Box_Data is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;


   procedure Set_Node(Info_Node_Out : in out Info_Node_Point; Value : Competition_Update ) is
   begin
      Info_Node_Out.This := new Competition_Update;
      Info_Node_Out.This.all := Value;
   end Set_Node;

   procedure Set_PreviousNode(Info_Node_Out : in out Info_Node_Point ; Value : in out Info_Node_Point) is
   begin
      if(Value /= null) then
         Info_Node_Out.Previous := Value;
         Info_Node_Out.Previous.Next := Info_Node_Out;
         Info_Node_Out.Index := Info_Node_Out.Previous.Index + 1;
      end if;
   end Set_PreviousNode;

   procedure Set_NextNode(Info_Node_Out : in out Info_Node_Point; Value : in out Info_Node_Point ) is
   begin
      if(Value /= null) then
         Value.Previous := Info_Node_Out;
         Value.Index := Info_Node_Out.Index + 1;
         Info_Node_Out.Next := Value;
      end if;
   end Set_NextNode;

   function Search_Node( Starting_Node : in Info_Node_Point;
                        Num : in Integer) return Info_Node_Point is
      Iterator : Info_Node_Point := Starting_Node;
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


   protected body Synch_Competition_Updates is

      procedure Add_Data(CompetitionUpdate_In : Competition_Update_Point) is
         New_Update : Info_Node_Point := new Info_Node;

      begin
         -- If info related to a time interval are already saved, do nothing.
         if(Updates_Last = null) then
            New_Update.This := new Competition_Update;
            New_Update.This.all := CompetitionUpdate_In.all;
            Updates_Last := New_Update;
            Updates_Last.Index := 1;
            Updates_Last.Previous := null;
            Updates_Last.Next := null;
            Updates_Current := Updates_Last;
            Updated := true;
         elsif (Updates_Last.This.Time < CompetitionUpdate_In.Time) then

            New_Update.This := new Competition_Update;

            New_Update.This.all := CompetitionUpdate_In.all;

            Set_NextNode(Updates_Last,New_Update);

            Updates_Last := New_Update;
            Updated := True;
         end if;
      exception when Program_Error =>
            Ada.Text_IO.Put_Line("Constraint error adding update");


      end Add_Data;

      entry Wait(NewInfo : out Competition_Update;
                 Num : in Integer) when Updated is
      begin
         requeue Get_Update;
      end Wait;

      entry Get_Update( NewInfo : out Competition_Update;
                       Num : Integer ) when true is
      begin
         if ( Updates_Last = null or else Updates_Last.Index < Num ) then
            Updated := false;
            requeue Wait;
         else
            Updates_Current := Search_Node(Updates_Current, Num);
            NewInfo := Updates_Current.This.all;
         end if;
      end Get_Update;

      function IsUpdated return Boolean is
      begin
         return Updated;
      end;

   end Synch_Competition_Updates;

   protected body Synch_Strategy_History is

      procedure Init( Lap_Qty : in Integer ) is
      begin
         History := new Strategy_History(0..Lap_Qty);
      end Init;

      procedure AddStrategy( Strategy_in : in Strategy ) is
      begin

         History.all(History_size) := Strategy_in;
         History_size := History_size + 1;
         Updated := true;

         exception when Constraint_Error =>
            Ada.Text_IO.Put("Either the resource Synch_Strategy_History not initialised or ");
            Ada.Text_IO.Put("the History array has had an access violation.");
      end AddStrategy;

      entry Get_Strategy(New_Strategy : out Strategy;
                         Lap : in Integer) when Updated is
      begin


         -- verify whether to put <= or <
         if Lap < History_size then

            New_Strategy := History.all(Lap);
         else

            Updated := false;
            requeue Get_Strategy;
         end if;

      end Get_Strategy;

   end Synch_Strategy_History;

   protected body Synch_All_Info_Buffer is
      procedure Init( Size : Positive) is
      begin

         Info_List := new All_Info_Array(1..Size);
         Ready := true;

      end Init;

      entry Get_Info( Num : Positive; Info : out All_Info ) when Ready = true is
      begin

         if( Num <= Info_Qty ) then

            Info := Info_List.all(Num);
         else

            Updated := false;
            requeue Wait;

         end if;

      end Get_Info;

      entry Wait( Num : Positive; Info : out All_Info ) when Updated = true is
      begin

         requeue Get_Info;

      end Wait;

      procedure Add_Info(Update_In : Extended_Competition_Update ) is
      begin

         Info_Qty := Info_Qty + 1;
         Info_List.all(Info_Qty).Per_Sector_Update := new Extended_Competition_Update;
         Info_List.all(Info_Qty).Per_Sector_Update.all := Update_In;
         Updated := true;

      end Add_Info;

      procedure Add_Info(Update_In : Extended_Competition_Update;
                         Strategy_In : Strategy) is
      begin

         Add_Info(Update_In);
         Info_List.all(Info_Qty).Strategy_Update := new Strategy;
         Info_List.all(Info_Qty).Strategy_Update.all := Strategy_In;

      end Add_Info;

   end Synch_All_Info_Buffer;


   function Get_Strategy_XML( Data : All_Info ) return Unbounded_String.Unbounded_String is
      Tmp_String : Unbounded_String.Unbounded_String;
   begin

      if(Data.Strategy_Update /= null) then
         Tmp_String := Unbounded_String.To_Unbounded_String(Box_Strategy_To_XML(Data.Strategy_Update.all));
      else
         Tmp_String := Unbounded_String.To_Unbounded_String("");
      end if;

      return Tmp_String;
   end Get_Strategy_XML;

   function Get_Update_XML( Data : All_Info ) return Unbounded_String.Unbounded_String is
      Tmp_String : Unbounded_String.Unbounded_String;
   begin

      Tmp_String := Unbounded_String.To_Unbounded_String
        ("<status>" &
         "<gasLevel>" & Common.Float_To_String(Data.Per_Sector_Update.Gas_Level) & "</gasLevel>" &
         "<tyreUsury>" & Common.Float_To_String(Data.Per_Sector_Update.Tyre_Usury) & "</tyreUsury>" &
         "<lap>" & Common.Integer_To_String(Data.Per_Sector_Update.Lap) & "</lap> " &
         "<sector>" & Common.Integer_To_String(Data.Per_Sector_Update.Sector) & "</sector>" &
         --"<metres>" & Common.Float_To_String(Data.Per_Sector_Update.PathLength) & "</metres>" &
         "<meanTyreUsury>" & Common.Float_To_String(Data.Per_Sector_Update.Mean_Tyre_Usury) & "</meanTyreUsury>" &
         "<meanGasConsumption>" & Common.Float_To_String(Data.Per_Sector_Update.Mean_Gas_Consumption) & "</meanGasConsumption>" &
         "<maxSpeed>" & Common.Float_To_String(Data.Per_Sector_Update.Max_Speed) & "</maxSpeed>" &
         "</status>" );

      return Tmp_String;
   end Get_Update_XML;

   function Get_Metres ( Data : All_Info ) return Float is
   begin

      return Data.Per_Sector_Update.Path_Length;
   end Get_Metres;

   function Get_Time ( Data : All_Info ) return Float is
   begin

      return Data.Per_Sector_Update.Time;
   end Get_Time;

   function Box_Strategy_To_XML(Strategy_in : Strategy) return String is

      Style      : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      XML_String : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

   begin

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

      XML_String := Unbounded_String.To_Unbounded_String
        ("<strategy>");

      XML_String := XML_String &
      Unbounded_String.To_Unbounded_String("<tyreType>") &
      Strategy_in.Tyre_Type &
      Unbounded_String.To_Unbounded_String("</tyreType>");

      XML_String := XML_String &
      Unbounded_String.To_Unbounded_String("<style>") &
      Style &
      Unbounded_String.To_Unbounded_String("</style>");

      XML_String := XML_String &
      Unbounded_String.To_Unbounded_String("<gasLevel>") &
      Float_To_String(Strategy_in.Gas_Level) &
      Unbounded_String.To_Unbounded_String("</gasLevel>");

      XML_String := XML_String &
      Unbounded_String.To_Unbounded_String("<Laps_To_Pitstop>") &
      Integer_To_String(Strategy_in.Laps_To_Pitstop) &
      Unbounded_String.To_Unbounded_String("</Laps_To_Pitstop>");

      XML_String := XML_String &
      Unbounded_String.To_Unbounded_String("<Pit_Stop_Delay>") &
      Float_To_String(Strategy_in.Pit_Stop_Delay) &
      Unbounded_String.To_Unbounded_String("</Pit_Stop_Delay>" &
                                           "</strategy>");

      return Unbounded_String.To_String(XML_String);
   end Box_Strategy_To_XML;

end Box_Data;
