with CORBA.ORB;

with Polyorb.Setup.Client;
pragma Warnings (Off, PolyORB.Setup.Client);

with Competition_Monitor;

with PolyORB.Utils.Report;
--with MonitorRadio;

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


   --Competitor_Qty : INTEGER := 10;
   --TODO:if possible, sooner or later try to use the cmpetitor classific
   --+ for calculating the strategy

   --Competitor information
   CompetitorID : INTEGER;
   GasTankCapacity : FLOAT;
   TyreType : Unbounded_String.Unbounded_String;

   -- Circuit length. Initialised after the competitor registration
   CircuitLength : FLOAT := 6.0;

   -- Hypothetical values for the gas and tyre consumption.
   --+ These are generic values, not connected neither to the type
   --+ of circuit nor to the driving style of the competitor. They're
   --+ ought to be used to calculate the first statistics when
   --+no statistical information are available yet.
   MeanTyreUsuryPerKm : PERCENTAGE := 1.17;
   MeanKmsPerLitre : FLOAT := 1.7;
   -- Depending on the driving style, the mean kilometres per litre
   --+ will change. 1 step is like moving from NORMAL to AGGRESSIVE.
   --+ If the style switch from AGGRESSIVE to conservative, the
   --+ total modifier it's (0.2 * 2) * -1 (it's 2 steps backward)
   DrivingStyle1StepModifierGas : FLOAT := 0.2;
   DrivingStyle1StepModifierTyre : FLOAT := 0.03;

   -- Total laps
   Laps : INTEGER := 0;

   --TODO: decide whether to keep seconds or milliseconds
   -- Time needed at the box to refill the gas tank by one litre (seconds)
   TimePerLitre : FLOAT := 0.083;
   -- Time needed at the box to change the tyres (seconds)
   TyreChangeTime : FLOAT := 1.2;

   -- The strategy factor depends on the box strategy. More risky
   --+ is the strategy, more optimistic is the evaluation of
   --+ doable laps with the given gas level and tyre usury.
   --+ Cautious -> evaluation assuming 1/3 less then the amount gas given
   --+ Normal -> evaluation assuming 1/5 less then the amount gas given
   --+ Risky --> evaluation assuming exactly the same amount of gas given
   --+ Fool --> evaluation assuming 1/7 more then the amount gas given
   StrategyFactor : FLOAT;

   procedure Init(Laps_In : in INTEGER;
                  CircuitLength_In : in FLOAT;
                  CompetitorId_In : in INTEGER;
                  BoxStrategy_In : in BOX_STRATEGY;
                  GasTankCapacity_In : FLOAT
                 ) is
   begin

      Laps := Laps_In;
      CircuitLength := CircuitLength_In;
      CompetitorID := CompetitorId_In;
      GasTankCapacity := GasTankCapacity_In;

      case BoxStrategy_In is
         when CAUTIOUS =>
            StrategyFactor := -0.2;
         when NORMAL | NULL_STRATEGY =>
            StrategyFactor := -0.1;
         when RISKY =>
            StrategyFactor := 0.0;
         when FOOL =>
            StrategyFactor := 0.2;
      end case;

   end Init;

   task body MONITOR is
      Info_XMLStr : Unbounded_String.Unbounded_String;
      Info : COMPETITION_UPDATE_POINT;
      Sector : INTEGER := 0;
      Lap : INTEGER := 0;
      UpdateBuffer : SYNCH_COMPETITION_UPDATES_POINT := SharedBuffer;

      Radio : Competition_Monitor.Ref;
      RadioCorbaLOC : STRING := Unbounded_String.To_String(MonitorRadio_CorbaLOC.all);
   begin
      Ada.Text_IO.Put_Line("Monitor begin");
      CORBA.ORB.Initialize("ORB");
      Corba.ORB.String_To_Object(CORBA.To_CORBA_String
                                 (Unbounded_String.To_String(MonitorRadio_CorbaLOC.all))
                                 , Radio);

      if Competition_Monitor.Is_Nil(Radio) then
         Ada.Text_IO.Put_Line("Monitor radio down");

      end if;

      -- MonitorRadio.Ready(CompetitorID);

      -- Test init values to avoid warnings DEL
      Info := new COMPETITION_UPDATE;
      Info.GasLevel := 42.0;
      Info.TyreUsury := 42.0;
      Info.MeanSpeed := 42.0;
      Info.MeanGasConsumption := 42.0;
      Info.Time := 42.0;
      loop

         Info_XMLStr := Unbounded_String.To_Unbounded_String
           (CORBA.To_Standard_String
              (Radio.getInfo
                 (CORBA.Short(Lap),
                  CORBA.Short(Sector),
                  CORBA.Short(Competitor_Id)))); --TODO: implement this.
         -- Info := XML2CompetitionUpdate(Info_XMLStr)
         UpdateBuffer.Add_Data(Info);
         exit when Info.Time = -1.0;
         Sector := Sector + 1;
         if(Sector = Sector_Qty) then
            Sector := 0;
            Lap := Lap + 1;
         end if;
         Info.Time := Info.Time + 1.0;--just for test;
         Delay(Standard.Duration(2));
      end loop;

   end MONITOR;

   --Monitor_Task : access MONITOR;

   function CalculateDoableLaps(CurrentGasLevel : FLOAT;
                                CurrentTyreUsury : PERCENTAGE;
                                MeanGasConsumption : FLOAT;
                                MeanTyreConsumption : PERCENTAGE) return INTEGER is

      RemainingDoableLaps_Gas : INTEGER;
      RemainingDoableLaps_Tyre : INTEGER;

      RemainingDoableLaps : INTEGER;

   begin

         -- Calculate how many laps are still doable with the given gas and tyre usury
      -- MeanGasConsuption is the amount of litres of gas used for 1 km calculated
      --+ against all the information obtained up to now.
      --+ Depending on the Global Strategy, the box will be more or less optimistic
      --+ calculating the number remaining laps.

      RemainingDoableLaps_Gas := INTEGER(FLOAT'Floor(
        (( CurrentGasLevel + (CurrentGasLevel * StrategyFactor) )/ (CircuitLength * MeanGasConsumption))));
      Ada.Text_IO.Put_Line("Remainin laps with gas " & INTEGER'IMAGE(RemainingDoableLaps_Gas));

      -- The MeanTyreUsury expresses how mouch the tyre was usured for each km.
      --+ The value it's calculated considering all the information up to now.
      RemainingDoableLaps_Tyre := INTEGER(FLOAT'Floor(
        ((100.00 - CurrentTyreUsury) / (CircuitLength * MeanTyreConsumption))));
      Ada.Text_IO.Put_Line("Remainin laps with tyre " & INTEGER'IMAGE(RemainingDoableLaps_Tyre));

      if( RemainingDoableLaps_Gas < RemainingDoableLaps_Tyre) then
         RemainingDoableLaps := RemainingDoableLaps_Gas;
      else
         RemainingDoableLaps := RemainingDoableLaps_Tyre;
      end if;

      return RemainingDoableLaps;
   end CalculateDoableLaps;

   -- Intanto è solo la bozza dello scheletro. In base all'algoritmo
   -- che si deciderà di utilizzare, verranno adottati più o meno
   -- parametri.
   function Compute_Strategy(
                             New_Info : COMPETITION_UPDATE;
                             Old_Strategy : STRATEGY;
                             PreviousLapMeanGasConsumption : FLOAT;
                             PreviousLapMeanTyreUsury : FLOAT
                            ) return STRATEGY is
      New_Strategy : STRATEGY;
      RemainingDoableLaps : INTEGER;

      Laps2PitStop : INTEGER;
      Laps2End : INTEGER;
      RemainingLaps : INTEGER; -- the minimum between Laps2PitStop and Laps2end

      CurrentMeanConsuption : FLOAT := MeanKmsPerLitre;

      Doable : BOOLEAN := false;
      Warning : BOOLEAN := false;
      ChangeStyle : BOOLEAN := false;
      Style2Simulate : Common.DRIVING_STYLE;

      function SimulateDrivingStyleChange(OldStyle : Common.DRIVING_STYLE;
                                          NewStyle : Common.DRIVING_STYLE;
                                          Laps2Simulate : INTEGER;
                                          GasLevel_in : FLOAT;
                                          TyreUsury_in : PERCENTAGE) return BOOLEAN is
         TotalStyleModifierGas : FLOAT;
         TotalStyleModifierTyre : FLOAT;
         GasNeeded : FLOAT;
         TyreNeeded : PERCENTAGE;

      begin
         TotalStyleModifierGas := DrivingStyle1StepModifierGas * FLOAT(Common.Style_Distance(OldStyle,NewStyle));
         TotalStyleModifierTyre := DrivingStyle1StepModifierTyre * FLOAT(Common.Style_Distance(OldStyle,NewStyle));

         GasNeeded := (PreviousLapMeanGasConsumption + TotalStyleModifierGas) *
           (CircuitLength * FLOAT(Laps2Simulate));
         TyreNeeded := (PreviousLapMeanTyreUsury + TotalStyleModifierTyre)
           * (CircuitLength * FLOAT(Laps2Simulate));
         if ( GasNeeded > GasLevel_In ) then
            return false;
         elsif (TyreNeeded < TyreUsury_In ) then
            return false;
         else
            return true;
         end if;

      end SimulateDrivingStyleChange;


   begin

      --TODO: implement AI
      RemainingDoableLaps := CalculateDoableLaps(CurrentGasLevel     => New_Info.GasLevel,
                                                 CurrentTyreUsury    => New_Info.TyreUsury,
                                                 MeanGasConsumption  => PreviousLapMeanGasConsumption,
                                                 MeanTyreConsumption => PreviousLapMeanTyreUsury);

      -- Calculate the remaining number of laps til either the pitstop or the
      --+ end of the competition.

      Laps2PitStop := Old_Strategy.PitStopLaps - 1;
      New_Strategy.PitStopLaps := Laps2PitStop;

      Laps2End := Laps - New_Info.Lap;
      if ( Laps2PitStop < Laps2end ) then
         RemainingLaps := Laps2PitStop;
      else
         RemainingLaps := Laps2End;
      end if;


      if ( RemainingLaps /= 0 ) then
         --If the number of doable laps is enough to either finish the comeptition
         --+ or to reach the next pitstop, try to see if it's possible to change the driving
         --+ style to a more aggressive one
         Style2Simulate := Old_Strategy.Style;
         ChangeStyle := false;
         if ( RemainingDoableLaps >= RemainingLaps ) then
            Warning := false;
            -- Calculate how many laps would be doable with a more aggressive driving style
            --+ (if it's not already the most aggressive one)
            if( Old_Strategy.Style /= Common.AGGRESSIVE ) then
               Style2Simulate := Common.AGGRESSIVE;
               Doable := SimulateDrivingStyleChange(Old_Strategy.Style,
                                                    Style2Simulate,
                                                    RemainingLaps,
                                                    New_Info.GasLevel,
                                                    New_Info.TyreUsury);

               if( Old_Strategy.Style /= Common.NORMAL or else Doable = false) then
                  Style2Simulate := Common.NORMAL;
                  Doable := SimulateDrivingStyleChange(Old_Strategy.Style,Style2Simulate, RemainingLaps, New_Info.GasLevel, New_Info.TyreUsury);
                  if ( Doable = true ) then
                     ChangeStyle := true;
                  end if;
               end if;
            end if;

         else
            -- If the laps the competitor can do are less then the remaining laps (either
            --+ to the pitstop or to the end of the competition), calculate whether with a more
            --+ conservative driving style it's possible to reach the target or not

            --Laps2Simulate := RemainingLaps;
            -- TODO: write this code better
            if( Old_Strategy.Style /= Common.CONSERVATIVE ) then
               Style2Simulate := Common.CONSERVATIVE;
               Doable := SimulateDrivingStyleChange(Old_Strategy.Style,Style2Simulate, RemainingLaps, New_Info.GasLevel, New_Info.TyreUsury);
               null;
               if( Doable = true ) then
                  ChangeStyle := true;

                  -- Try, if possible, to drive faster
                  if( Old_Strategy.Style /= Common.NORMAL ) then
                     Style2Simulate := Common.NORMAL;
                     Doable := SimulateDrivingStyleChange(Old_Strategy.Style,Style2Simulate, RemainingLaps, New_Info.GasLevel, New_Info.TyreUsury);
                     if ( Doable /= true ) then
                        Style2Simulate := Common.CONSERVATIVE;
                     end if;
                  end if;
               else
                  Warning := true;
               end if;
            end if;

         end if;

         if ( ChangeStyle = true ) then
            New_Strategy.Style := Style2Simulate;
         else
            if ( Warning = true and RemainingDoableLaps /= 0) then
               New_Strategy.PitStopLaps := RemainingDoableLaps - 1;
            end if;
            New_Strategy.Style := Old_Strategy.Style;
         end if;

      end if;

      -- If the number of laps to the PitStop is 0, it means that the competitor is going to
      --+ have a pitstop, so it's necessary to calculate the amount of gas to refill and
      --+ the type o tyres tu put on the car
      if ( New_Strategy.PitStopLaps = 0 ) then

         -- Calculate the amount of gas needed to reach the next pitstop (set on the
         --+ half of the remaining laps).
         New_Strategy.GasLevel :=
           ( ( FLOAT( Laps2End / 2 ) * CircuitLength ) *
              New_Info.MeanGasConsumption ) *
             ( 1.0 - StrategyFactor ); -- explain why - StrategyFactor instead of +

         -- Calculate the time needed to refill the gas tank
         New_Strategy.PitStopDelay :=  New_Strategy.GasLevel * TimePerLitre;

         -- The total delay at the box is the maximum time between gas refill
         --+ tyre change
         if ( New_Strategy.PitStopDelay < TyreChangeTime ) then
            New_Strategy.PitStopDelay := TyreChangeTime;
         end if;

         -- TODO: implement different type of tyre depending on the weather
         New_Strategy.Type_Tyre := Old_Strategy.Type_Tyre;

      else
         --HACK: Gas level used to compute the mean gas consumption by the
         --+ the box and not used by the competitor
         New_Strategy.GasLevel := New_Info.GasLevel;

      end if;

      return New_Strategy;

   end Compute_Strategy;

   task body STRATEGY_UPDATER is
      Index : INTEGER := 1;
      New_Info : COMPETITION_UPDATE_POINT;
      Evolving_Strategy : STRATEGY;
      UpdateBuffer : SYNCH_COMPETITION_UPDATES_POINT := SharedBuffer;
      StrategyHistory : SYNCH_STRATEGY_HISTORY_POINT := SharedHistory;

      -- The starting value are hypothetic value depending on the static
      --+ configuration of a generic F1 car
      LatestLapMeanGasConsumption : FLOAT := MeanKmsPerLitre;
      LatestLapMeanTyreUsury : PERCENTAGE := MeanTyreUsuryPerKm;
      -- Variables used to calculate the means progressively
      PreviousSectorGasLevel : FLOAT := InitialGasLevel.all;
      PreviousSectorTyreUsury : FLOAT := 0.0;
      PartialGasConsumptionMean : FLOAT := MeanKmsPerLitre;
      PartialTyreUsuryMean : FLOAT := MeanTyreUsuryPerKm;

      --it starts from 1 because the strategy is updated once the competitor reaches
      --+ sector previous to the last one. So the first lap strategy will be calculated
      --+ using only the firts 2 sectors.
      Sector : INTEGER := 2;
   begin

      Ada.Text_IO.Put_Line("Init Strategy updater");
      New_Info := new COMPETITION_UPDATE;
      --The first strategy is stored before the beginning of the competition
      --+ and it's calculated against some configured parameter and some hypothetical
      --+ values
      Evolving_Strategy.PitStopLaps := CalculateDoableLaps(CurrentGasLevel     => InitialGasLevel.all,
                                                          CurrentTyreUsury    => 0.0,
                                                          MeanGasConsumption  => LatestLapMeanGasConsumption,
                                                          MeanTyreConsumption => LatestLapMeanTyreUsury);

      Evolving_Strategy.Type_Tyre := Unbounded_String.To_Unbounded_String(InitialTyreType.all);
      Evolving_Strategy.Style := NORMAL;
      Evolving_Strategy.GasLevel := InitialGasLevel.all;
      Evolving_Strategy.PitStopDelay := 0.0;
      StrategyHistory.AddStrategy(Evolving_Strategy);
      -- Time = -1.0 means that race is over (think about when the competitor
      --+ is out of the race).
      loop
         UpdateBuffer.Get_Update(New_Info.all, Index);

         PartialGasConsumptionMean := PartialGasConsumptionMean +
           (PreviousSectorGasLevel - New_Info.GasLevel); -- the gas level is a decreasing float
         PreviousSectorGasLevel := New_Info.GasLevel;
         Ada.Text_IO.Put_Line("Partial gas consumption mean " & Common.FloatToString(PartialGasConsumptionMean));

         PartialTyreUsuryMean := PartialTyreUsuryMean +
           (New_Info.TyreUsury - PreviousSectorTyreUsury); -- the tyre usury is an increasing percentage
         PreviousSectorTyreUsury := New_Info.TyreUsury;

         Ada.Text_IO.Put_Line("Done. Time " & COmmon.FloatToString(New_Info.Time));
         Index := Index + 1;
         exit when New_Info.Lap = -1;

         Ada.Text_IO.Put_Line("Go ahead. Sector: " & INTEGER'IMAGE(Sector) & " out of " & INTEGER'IMAGE(Sector_Qty));


         if(Sector = Sector_Qty) then

            --Ada.Text_IO.Put_Line("Latest lap mean gas cons " & Common.FloatToString(LatestLapMeanGasConsumption));
            --Ada.Text_IO.Put_Line("Latest lap mean tyre cons " & Common.FloatToString(LatestLapMeanTyreUsury));

            Ada.Text_IO.Put_Line("Latest lap mean gas cons " &
                                 Common.FloatToString(LatestLapMeanGasConsumption));

            Ada.Text_IO.Put_Line("Latest lap mean tyre cons " &
                                 Common.FloatToString(LatestLapMeanTyreUsury));


            Evolving_Strategy := Compute_Strategy(New_Info.all,
                                         Evolving_Strategy,
                                         LatestLapMeanGasConsumption,
                                         LatestLapMeanTyreUsury
                                                 );

            LatestLapMeanGasConsumption := PartialGasConsumptionMean / CircuitLength;
            LatestLapMeanTyreUsury := PartialTyreUsuryMean / CircuitLength;

            StrategyHistory.AddStrategy(Evolving_Strategy);
            Sector := 0;
            PartialGasConsumptionMean := 0.0;
            PartialTyreUsuryMean := 0.0;
            PreviousSectorGasLevel := Evolving_Strategy.GasLevel;
            PreviousSectorTyreUsury := 0.0;--we assume that the tyre are always changed
         end if;


         Sector := Sector + 1;
         Ada.Text_IO.Put_Line("");

         end loop;
   end STRATEGY_UPDATER;

   --StrategyUpdater_Task : access STRATEGY_UPDATER;

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
            Ada.Text_IO.Put_Line("Constraint error adding update at time " & FloatToString(CompetitionUpdate_In.Time));


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
         history := new STRATEGY_HISTORY(1..Lap_Qty);
      end Init;

      procedure AddStrategy( Strategy_in : in STRATEGY ) is
      begin

         history.all(history_size+1) := Strategy_in;
         history_size := history_size + 1;
         Updated := true;
         exception when Constraint_Error =>
            Ada.Text_IO.Put("Either the resource SYNCH_STRATEGY_HISTORY not initialised or ");
            Ada.Text_IO.Put("the history array has had an access violation.");
      end AddStrategy;

      entry Get_Strategy( NewStrategy : out STRATEGY ;
                 Lap : in INTEGER) when Updated is
      begin
         if Lap <= history_size then
               NewStrategy := history.all(Lap);
            else
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

   function BoxStrategyToXML(Strategy_in : STRATEGY) return STRING is

      Style : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

      XML_String : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

   begin
      case Strategy_in.Style is
         when AGGRESSIVE =>
            Style := Unbounded_String.To_Unbounded_String("Aggressive");
         when NORMAL =>
            Style := Unbounded_String.To_Unbounded_String("Normal");
         when CONSERVATIVE =>
            Style := Unbounded_String.To_Unbounded_String("Conservative");
      end case;
      XML_String := Unbounded_String.To_Unbounded_String("<?xml version=""1.0""?>" &
      			"<strategy>" &
			      "<tyreType>" & Unbounded_String.To_String(Strategy_in.Type_Tyre)& "</tyreType>" &
			      "<style>" & Unbounded_String.To_String(Style) & "</style>" &
			      "<gasLevel>" & FloatToString(Strategy_in.GasLevel) & "</gasLevel>" &
			      "<PitStopLaps>" & IntegerToString(Strategy_in.PitStopLaps) & "</PitStopLaps>" &
			      "<pitStopDelay>" & FloatToString(Strategy_in.PitStopDelay) & "</pitStopDelay>" &
                                                         "</strategy>");

      return Unbounded_String.To_String(XML_String);
   end BoxStrategyToXML;

   -- Used to send to the client interface the information concerning the competition
   function CompetitionUpdateToXML(update : COMPETITION_UPDATE) return STRING is

      Competitor_Qty : INTEGER := 0;

      XML_String : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

      begin

      --Updating related to the classific are temporary removed.
      --if update.Classific /= null then
        -- Competitor_Qty := update.Classific'LENGTH;
      --end if;

      XML_String := Unbounded_String.To_Unbounded_String("<?xml version=""1.0""?>" &
                                                         "<update>" &
                                                         "<gasLevel>" & Common.FloatToString(update.GasLevel) & "<gasLevel> <!-- % -->" &
                                                         "<tyreUsury>" & Common.FloatToString(update.TyreUsury) & "</tyreUsury> <!-- % -->" &
                                                         "<meanSpeed>" & Common.FloatToString(update.MeanSpeed) & "</meanSpead> <!-- km/h --> " &
                                                         "<meanGasConsumption>" & Common.FloatToString(update.MeanGasConsumption) & "</meanGasConsumption> <!-- l/h --> " &
                                                         "<time>" & Common.FloatToString(update.Time) & "</time> <!-- time instant --> " &
                                                         "<lap>" & Common.IntegerToString(update.Lap) & "</lap> " &
                                                         "<sector>" & Common.IntegerToString(update.Sector) & "</sector> " );-- &
                                                         --"<classific competitors="" " & Common.IntegerToString(Competitor_Qty) & " "" >   <!-- competitor ids, pol position = first one --> ");
      -- The classific is expressed as an integer sequence where the first place
      --+ in the competition is related to the first position in the array.
      --for Index in 1..Competitor_Qty loop
        -- XML_String := XML_String & "<compId>" & Common.IntegerToString(update.Classific(Index)) & "</compId> ";
      --end loop;

      --XML_String := XML_String & "</classific></update> ";

      return Unbounded_String.To_String(XML_String);
   end CompetitionUpdateToXML;

end Box;
