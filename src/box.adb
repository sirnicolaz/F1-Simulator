with CORBA.ORB;
with Polyorb.Setup.Client;
--with CompetitorRadio;

with Input_Sources.File;
use Input_Sources.File;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes; use DOM.Core.Nodes;
with DOM.Core.Attrs; use DOM.Core.Attrs;

with Ada.Text_IO;
with ADA.Float_Text_IO;
with Common;
use Common;

package body Box is


   UpdatesBuffer : SYNCH_COMPETITION_UPDATES;
   StrategyHistory : SYNCH_STRATEGY_HISTORY;
   CompetitorRadio_CorbaLOC : access STRING;

   task body MONITOR is
      Info : COMPETITION_UPDATE;
      Sector : INTEGER := 0;
      Lap : INTEGER := 0;
   begin
      loop
         -- Test init values to avoid warnings DEL
         Info.GasLevel := 42.0;
         Info.TyreUsury := 42.0;
         Info.MeanSpeed := 42.0;
         Info.MeanGasConsumption := 42.0;
         Info.Time := 42.0;

         -- Info := RequestInfo (Competitor_Id,Sector,Lap); TODO: implement this.
         UpdatesBuffer.Add_Data(Info);
         exit when Info.Time = -1.0;
         Sector := Sector + 1;--TODO: think the goal of this update
         if(Sector = Sector_Qty) then
            Sector := 0;
            Lap := Lap + 1;
         end if;
      end loop;

   end MONITOR;

   --Monitor_Task : access MONITOR;

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
      New_Strategy.Type_Tyre := Unbounded_String.To_Unbounded_String("Rain tyre");
      return New_Strategy;
   end Compute_Strategy;

   task body STRATEGY_UPDATER is
      Index : INTEGER := 1;
      Old_Info : COMPETITION_UPDATE;
      New_Info : COMPETITION_UPDATE;
      Strategy : BOX_STRATEGY;
      --it starts from 1 because the strategy is updated once the competitor
      --+ the next to last sector. So the first lap strategy will be calculated
      --+ using only the firts 2 sectors.
      Sector : INTEGER := 1;
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
      Strategy.Type_Tyre := Unbounded_String.To_Unbounded_String("Regular tyre");
      Strategy.Style := NORMAL;
      Strategy.GasLevel := 0.0;
      Strategy.PitStopLap := 1;
      Strategy.PitStopDelay := 0.0;
      -- Time = -1.0 means that race is over (think about when the competitor
      --+ is out of the race).
      loop
         UpdatesBuffer.Wait(New_Info, Index);
         Index := Index + 1;
         exit when New_Info.Time /= -1.0;
         Sector := Sector + 1;
         Strategy := Compute_Strategy(New_Info    => New_Info,
                                      Old_Info    => Old_Info,
                                      Old_Strategy => Strategy
                                     );
         if(Sector = Sector_Qty) then
            StrategyHistory.AddStrategy(Strategy);
            Sector := 0;
         end if;
         Old_Info := New_Info;
      end loop;
   end STRATEGY_UPDATER;

   --StrategyUpdater_Task : access STRATEGY_UPDATER;

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

      procedure Init_Buffer is
      begin
         Updated := False;
	 Updates_Current := null;
         Updates_Last := Updates_Current;
      end Init_Buffer;

      procedure Add_Data(CompetitionUpdate_In : in out COMPETITION_UPDATE) is
         New_Update : INFO_NODE_POINT := new INFO_NODE;
      begin
         -- If info related to a time interval are already saved, do nothing.

         if(Updates_Last = null) then
            New_Update.This := CompetitionUpdate_In;
            Updates_Last := New_Update;
            Updates_Last.Index := 1;
            Updates_Last.Previous := null;
            Updates_Last.Next := null;
            Updates_Current := Updates_Last;
            Updated := true;
         elsif (Updates_Last.This.Time < CompetitionUpdate_In.Time) then
            New_Update.This := CompetitionUpdate_In;

            Set_NextNode(Updates_Last,New_Update);

            Updates_Last := New_Update;
            Updated := True;

         end if;
      exception when Program_Error =>
            Ada.Text_IO.Put_Line("Constraint error adding update at time " & FloatToString(CompetitionUpdate_In.Time));
      end Add_Data;

      entry Wait(NewInfo : out COMPETITION_UPDATE;
                 Num : in INTEGER) when Updated is
         --New_Update : INFO_NODE_POINT;
      begin
         requeue Get_Update;
         --NewInfo := Updates_Current.This;
         --if(Updates_Current.Next = null) then
         --   New_Update :=  new INFO_NODE;
         --   Set_NextNode(Updates_Current,New_Update);
         --   Updates_Current := New_Update;
         --   Updated := false;
         --end if;
      end Wait;

      entry Get_Update( NewInfo : out COMPETITION_UPDATE;
                       Num : INTEGER ) when true is
      begin
         Ada.Text_IO.Put_Line("Asking for " & INTEGER'IMAGE(Num) & " last update index " & INTEGER'IMAGE(Updates_Last.Index));
         if ( Updates_Last.Index < Num ) then
            Updated := false;
            Ada.Text_IO.Put_Line("FAIL retrieving num " & INTEGER'IMAGE(num));
            requeue Wait;
         else
            Updates_Current := Search_Node(Updates_Current, Num);
            NewInfo := Updates_Current.This;
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
         history := new STRATEGY_HISTORY(1..Lap_Qty);
      end Init;

      procedure AddStrategy( Strategy : in BOX_STRATEGY ) is
      begin

         history.all(history_size+1) := Strategy;
         history_size := history_size + 1;
         Updated := true;

         exception when Constraint_Error =>
            Ada.Text_IO.Put("Either the resource SYNCH_STRATEGY_HISTORY not initialised or ");
            Ada.Text_IO.Put("the history array has had an access violation.");
      end AddStrategy;

      entry Wait( NewStrategy : out BOX_STRATEGY ;
                 Lap : in INTEGER) when Updated is
      begin
         if Lap <= history_size then
               NewStrategy := history.all(Lap);
            else
               Updated := false;
               requeue Wait;
            end if;

      end Wait;

   end SYNCH_STRATEGY_HISTORY;

   function BoxStrategyToXML(strategy : BOX_STRATEGY) return STRING is

      Style : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

      XML_String : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

   begin
      case strategy.Style is
         when AGGRESSIVE =>
            Style := Unbounded_String.To_Unbounded_String("Aggressive");
         when NORMAL =>
            Style := Unbounded_String.To_Unbounded_String("Normal");
         when CONSERVATIVE =>
            Style := Unbounded_String.To_Unbounded_String("Conservative");
      end case;

      XML_String := Unbounded_String.To_Unbounded_String("<?xml version=""1.0""?>" &
      			"<strategy>" &
			      "<tyreType>" & Unbounded_String.To_String(strategy.Type_Tyre)& "</tyreType>" &
			      "<style>" & Unbounded_String.To_String(Style) & "</style>" &
			      "<gasLevel>" & FloatToString(strategy.GasLevel) & "</gasLevel>" &
			      "<pitStopLap>" & IntegerToString(strategy.PitStopLap) & "</pitStopLap>" &
			      "<pitStopDelay>" & FloatToString(strategy.PitStopDelay) & "</pitStopDelay>" &
                                                         "</strategy>");

      return Unbounded_String.To_String(XML_String);
   end BoxStrategyToXML;


   function RequestStrategy( lap : in INTEGER ) return STRING is
      strategy : BOX_STRATEGY;
   begin
      StrategyHistory.Wait(strategy,lap);
      return BoxStrategyToXML(strategy);
   end RequestStrategy;

begin

   -- After registering to the competition, it's possible
   --+ to know the number of laps and use it to initialise
   --+ strategy history.

--   UpdatesBuffer.Init_Buffer;
--   StrategyHistory.Init(10);

   --Test init for avoiding warning. DEL
   CompetitorRadio_CorbaLOC := new STRING(1..3);
   CompetitorRadio_CorbaLOC.all := "101";

--   Monitor_Task := new MONITOR;
--   StrategyUpdater_Task := new STRATEGY_UPDATER;

end Box;
