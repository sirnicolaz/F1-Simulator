with CORBA.ORB;

with Competition_Monitor_Radio;

--with PolyORB.Utils.Report;
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
   MeanTyreUsuryPerKm : PERCENTAGE := 0.83;
   MeanLitrePerKm : FLOAT := 0.68;
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
   --+ Cautious -> evaluation assuming 1/3 less than the gas given
   --+ Normal -> evaluation assuming 1/5 less than the gas given
   --+ Risky --> evaluation assuming exactly the same gas given
   --+ Fool --> evaluation assuming 1/7 more than the gas given
   StrategyFactor : FLOAT;

   procedure Init(Laps_In : in INTEGER;
                  CircuitLength_In : in FLOAT;
                  CompetitorId_In : in INTEGER;
                  BoxStrategy_In : in BOX_STRATEGY;
                  GasTankCapacity_In : FLOAT
                 ) is
   begin

      Laps := Laps_In;
      --TODO: decide wheter to you km or m for the circuit length and
      --+ keep this unit wherever.
      CircuitLength := CircuitLength_In/1000.00;
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

   task body UPDATE_RETRIEVER is

      Info_XMLStr : Unbounded_String.Unbounded_String;
      Info : COMPETITION_UPDATE_POINT;
      Time : FLOAT;
      CorbaInfo : CORBA.String;
      Sector : INTEGER := 1;
      Lap : INTEGER := 0;
      UpdateBuffer : SYNCH_COMPETITION_UPDATES_POINT := SharedBuffer;

      Radio : Competition_Monitor_Radio.Ref;
      RadioCorbaLOC : STRING := Unbounded_String.To_String(MonitorRadio_CorbaLOC.all);

      --Generic boolean
      Success : BOOLEAN := false;
   begin
      Ada.Text_IO.Put_Line("Monitor begin: " & Unbounded_String.To_String(MonitorRadio_CorbaLOC.all) & ", id: " & Common.IntegerToString(CompetitorID));
      --CORBA.ORB.Initialize("ORB");
      Corba.ORB.String_To_Object(CORBA.To_CORBA_String
                                 (RadioCorbaLOC) , Radio);

      if Competition_Monitor_Radio.Is_Nil(Radio) then
         Ada.Text_IO.Put_Line("Monitor radio down");

      end if;

      Ada.Text_IO.Put_Line("Monitor reference taken");

      Success := Competition_Monitor_Radio.Ready(Radio,CORBA.Short(CompetitorID));

      Ada.Text_IO.Put_Line("Successful!");
      -- Test init values to avoid warnings DEL
      Info := new COMPETITION_UPDATE;
      loop

         Ada.Text_IO.Put_Line("Getting info");
         Competition_Monitor_Radio.Get_CompetitorInfo
           (
            Radio,
            CORBA.Short(Lap),
            CORBA.Short(Sector),
            CORBA.Short(CompetitorID),
            CORBA.Float(Time),
            CorbaInfo);
         Info_XMLStr := Unbounded_String.To_Unbounded_String(CORBA.To_Standard_String(CorbaInfo));
         Ada.Text_IO.Put_Line("Info taken");
         Info := XML2CompetitionUpdate(Unbounded_String.To_String(Info_XMLStr),"competitor-" & Common.IntegerToString(CompetitorID) & "-update.xml");
         Info.Time := Time;
         Ada.Text_IO.Put_Line("Xml->update");
         Ada.Text_IO.Put_Line("---LAP N. " & Common.IntegerToString(Info.Lap));
         UpdateBuffer.Add_Data(Info);
         Ada.Text_IO.Put_Line("Buffer updated");
         Ada.Text_IO.Put_Line("Which sector?");
         if(Sector = Sector_Qty) then
            Sector := 0;
            Lap := Lap + 1;
         end if;

         exit when Info.Time = -1.0 or else Lap = Laps;

         Sector := Sector + 1;
      end loop;

      Ada.Text_IO.Put_Line("Competition over");


   end UPDATE_RETRIEVER;

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
        (( CurrentGasLevel + (CurrentGasLevel * StrategyFactor) )/
          MeanGasConsumption)/
            CircuitLength));
      --Ada.Text_IO.Put_Line("Remainin laps with gas " & INTEGER'IMAGE(RemainingDoableLaps_Gas));

      -- The MeanTyreUsury expresses how mouch the tyre was usured for each km.
      --+ The value it's calculated considering all the information up to now.
      RemainingDoableLaps_Tyre := INTEGER(FLOAT'Floor(
          (((100.00 - CurrentTyreUsury) +
          ((100.00 - CurrentTyreUsury)*(StrategyFactor/10.0)))/
            MeanTyreConsumption)/  -- StrategyFactor/10.0 because is more logic for the tyre usury
            CircuitLength));
      --Ada.Text_IO.Put_Line("Remainin laps with tyre " & INTEGER'IMAGE(RemainingDoableLaps_Tyre));

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
      NewGas : FLOAT;

      Laps2PitStop : INTEGER;
      Laps2End : INTEGER;
      RemainingLaps : INTEGER; -- the minimum between Laps2PitStop and Laps2end

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
         -- The reason is that the tyre needed mught be more then 100%
         --+ in some extreme situation. So to avoid a type error, it's
         --+ necessary to use float
         TyreNeeded : FLOAT;

      begin
         Ada.Text_IO.Put_Line("Calculate total gas mod");
         TotalStyleModifierGas := DrivingStyle1StepModifierGas * FLOAT(Common.Style_Distance(OldStyle,NewStyle));
         Ada.Text_IO.Put_Line("Calculate total gas mod");
         TotalStyleModifierTyre := DrivingStyle1StepModifierTyre * FLOAT(Common.Style_Distance(OldStyle,NewStyle));
         Ada.Text_IO.Put_Line("Calculate total gas needed");
         GasNeeded := (PreviousLapMeanGasConsumption + TotalStyleModifierGas) *
           (CircuitLength * FLOAT(Laps2Simulate));

         TyreNeeded :=
           (PreviousLapMeanTyreUsury + TotalStyleModifierTyre)
           * (CircuitLength * FLOAT(Laps2Simulate));
         Ada.Text_IO.Put_Line("Tyre needed " & FLOAT'IMAGE(TyreNeeded));
         Ada.Text_IO.Put_Line("Calculate minor");
         if ( GasNeeded > GasLevel_In ) then
            return false;
         elsif (TyreNeeded > (100.0 - TyreUsury_In) ) then
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
      Ada.Text_IO.Put_Line("Doable Laps: " & INTEGER'IMAGE(RemainingDoableLaps));
      Laps2PitStop := Old_Strategy.PitStopLaps - 1;

      if(Laps2PitStop = -1) then
         Laps2PitStop := RemainingDoableLaps;
      end if;

      Ada.Text_IO.Put_Line("Laps 2 Pitstop: " & INTEGER'IMAGE(Laps2PitStop));
      New_Strategy.PitStopLaps := Laps2PitStop;

      --NEW (Laps - 1)
      Laps2End := (Laps-1) - New_Info.Lap;
      if ( Laps2PitStop < Laps2end ) then
         RemainingLaps := Laps2PitStop;
      else
         RemainingLaps := Laps2End;
      end if;

      --Just to be sure that the new strategy is set.
      New_Strategy.Style := Old_Strategy.Style;

      if ( RemainingLaps /= 0 ) then
         Ada.Text_IO.Put_Line("Laps /= 0");
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
            Ada.Text_IO.Put_Line("LAps = less the foreseen");
            --Laps2Simulate := RemainingLaps;
            -- TODO: write this code better
            if( Old_Strategy.Style /= Common.CONSERVATIVE ) then
               Ada.Text_IO.Put_Line("No conservative");
               Style2Simulate := Common.CONSERVATIVE;
               Doable := SimulateDrivingStyleChange(Old_Strategy.Style,Style2Simulate, RemainingLaps, New_Info.GasLevel, New_Info.TyreUsury);
               if( Doable = true ) then
                  ChangeStyle := true;
                  Ada.Text_IO.Put_Line("Can be more conservative");
                  -- Try, if possible, to drive faster
                  if( Old_Strategy.Style /= Common.NORMAL ) then
                     Ada.Text_IO.Put_Line("Try to be NORMAL");
                     Style2Simulate := Common.NORMAL;
                     Doable := SimulateDrivingStyleChange(Old_Strategy.Style,Style2Simulate, RemainingLaps, New_Info.GasLevel, New_Info.TyreUsury);
                     if ( Doable /= true ) then
                        Ada.Text_IO.Put_Line("Can also do it!");
                        Style2Simulate := Common.CONSERVATIVE;
                     end if;
                  end if;
               else
                  Ada.Text_IO.Put_Line("Warning");
                  Warning := true;
               end if;
            end if;

         end if;

         if ( ChangeStyle = true ) then
            Ada.Text_IO.Put_Line("Style change");
            New_Strategy.Style := Style2Simulate;
         else
            if ( Warning = true and RemainingDoableLaps /= 0) then

               New_Strategy.PitStopLaps := RemainingDoableLaps - 1;
               Ada.Text_IO.Put_Line("Emergency, pit stop in " & INTEGER'IMAGE(New_Strategy.PitStopLaps));

            end if;
            New_Strategy.Style := Old_Strategy.Style;
         end if;
      end if;

      -- If the number of laps to the PitStop is 0, it means that the competitor is going to
      --+ have a pitstop, so it's necessary to calculate the amount of gas to refill and
      --+ the type o tyres tu put on the car
      if ( New_Strategy.PitStopLaps = 0 ) then
         Ada.Text_IO.Put_Line("Lap  = 0 now");

         --TODO: discuss about whether it would be better to
         --+ to refill totally the tank and finish the race without
         --+other stop or keep it half empty and do another stop
         --+For now the first solution is kept.
         if( Laps2End <= CalculateDoableLaps(CurrentGasLevel     => GasTankCapacity,
                                                        CurrentTyreUsury    => 0.0,
                                                        MeanGasConsumption  => PreviousLapMeanGasConsumption,
                                                        MeanTyreConsumption => PreviousLapMeanTyreUsury))
         then

            NewGas := GasTankCapacity;
            --So it will not stop til the end of the competition

         else

            -- Calculate the amount of gas needed to reach the next pitstop (set on the
            --+ half of the remaining laps).
            NewGas :=
              ( ( FLOAT( Laps2End / 2 ) * CircuitLength ) *
                 PreviousLapMeanGasConsumption ) *
                ( 1.0 - StrategyFactor ); -- explain why - StrategyFactor instead of +
            --Ada.Text_IO.Put_Line("New gas " & FLOAT'IMAGE(NewGas));

         end if;

         if(New_Info.GasLevel < NewGas ) then
            New_Strategy.GasLevel := NewGas;
         end if;

         -- Calculate the time needed to refill the gas tank
         New_Strategy.PitStopDelay :=  New_Strategy.GasLevel * TimePerLitre;

         -- The total delay at the box is the maximum time between gas refill
         --+ tyre change
         if ( New_Strategy.PitStopDelay < TyreChangeTime ) then
            New_Strategy.PitStopDelay := TyreChangeTime;
         end if;

         New_Strategy.Style := Common.NORMAL;--TODO find it

      else
         Ada.Text_IO.Put_Line("Lap /= 0 now");
         --HACK: Gas level used to compute the mean gas consumption by the
         --+ the box and not used by the competitor
         Ada.Text_IO.Put_Line("Updating gas");
         New_Strategy.GasLevel := New_Info.GasLevel;
         Ada.Text_IO.Put_Line("Updating pit delay");
         New_Strategy.PitStopDelay := 0.0;

      end if;

      -- TODO: implement different type of tyre depending on the weather
      New_Strategy.Type_Tyre := Old_Strategy.Type_Tyre;

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
      LatestLapMeanGasConsumption : FLOAT := MeanLitrePerKm;
      LatestLapMeanTyreUsury : FLOAT := MeanTyreUsuryPerKm;
      -- Variables used to calculate the means progressively
      PreviousSectorGasLevel : FLOAT := InitialGasLevel.all;
      PreviousSectorTyreUsury : FLOAT := 0.0;
      PartialGasConsumptionMean : FLOAT := MeanLitrePerKm;
      PartialTyreUsuryMean : FLOAT := MeanTyreUsuryPerKm;

      --it starts from 1 because the strategy is updated once the competitor reaches
      --+ sector previous to the last one. So the first lap strategy will be calculated
      --+ using only the firts 2 sectors.
      Sector : INTEGER := 2;

      Skip : INTEGER := 0;
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
         Ada.Text_IO.Put_Line("Waitin");
         UpdateBuffer.Get_Update(New_Info.all, Index);
         Ada.Text_IO.Put_Line("INFO GOT " &
                              " previous gas " & Common.FloatToString(PreviousSectorGasLevel) &
                              " new gas " & Common.FloatToString(New_Info.GasLevel));
         exit when New_Info.Time = -1.0 or else --The car is out
           (New_Info.Lap = Laps-1 and New_Info.Sector = 3); --The competition is over

         -- The following 7 lines handle the problem of the pitstop lap.
         --+ When the car does the pitstop, the statystics of bot the 3rd
         --+ and the 1st sectors get altered by the pitstop lane.
         --+ So, after the pitstop done, we use the latest consumption means
         --+ to compute the statystic for the lap following the pitstop one.
         --+ (for the sector before the box and the following one, the 2 sectors
         --+ affected.
         if( Skip /= 0 ) then
            Skip := Skip - 1;
            PartialGasConsumptionMean := PartialGasConsumptionMean +
              LatestLapMeanGasConsumption;
            PreviousSectorGasLevel := New_Info.GasLevel;

            PartialTyreUsuryMean := PartialTyreUsuryMean +
              LatestLapMeanTyreUsury;
            PreviousSectorTyreUsury := New_Info.TyreUsury;
         else

            Ada.Text_IO.Put_Line("Calculating partial mean");
            PartialGasConsumptionMean :=
              PartialGasConsumptionMean +
                ((PreviousSectorGasLevel - New_Info.GasLevel)/
                 (New_Info.PathLength/1000.0) -- We want the ratio in Km

              );

            Ada.Text_IO.Put_Line("Previous sector gas " &
                                 FLOAT'IMAGE(PreviousSectorGasLevel));

            PreviousSectorGasLevel := New_Info.GasLevel;
            Ada.Text_IO.Put_Line("Partial gas consumption mean " & Common.FloatToString(PartialGasConsumptionMean));

            PartialTyreUsuryMean :=
              PartialTyreUsuryMean +
                (New_Info.TyreUsury - PreviousSectorTyreUsury)/
                ((New_Info.PathLength/1000.0) -- We want the ratio in Km

              );

            PreviousSectorTyreUsury := New_Info.TyreUsury;
         end if;

         Index := Index + 1;

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

            --  "/3" because it's the sum of the mean of 3 sectors
            Ada.Text_IO.Put_Line("Calculating latest stuff");
            Ada.Text_IO.Put_Line("Partial gas cons " & FLOAT'IMAGE(PartialGasConsumptionMean));
            Ada.Text_IO.Put_Line("Parital tyre cons " & FLOAT'IMAGE(PartialTyreUsuryMean));
            LatestLapMeanGasConsumption := PartialGasConsumptionMean/3.0;
            LatestLapMeanTyreUsury := PartialTyreUsuryMean/3.0;

            Ada.Text_IO.Put_Line("Adding strategy");
            StrategyHistory.AddStrategy(Evolving_Strategy);
            Sector := 0;
            PartialGasConsumptionMean := 0.0;
            PartialTyreUsuryMean := 0.0;

            if(Evolving_Strategy.PitStopLaps = 0) then
               Ada.Text_IO.Put_Line("Gas set on strat (next prev sect): " &
                                    FLOAT'IMAGE(Evolving_Strategy.GasLevel));
               Skip := 2;
            end if;

         end if;


         Sector := Sector + 1;

      end loop;

      Ada.Text_IO.Put_Line("Competition over");

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
        ("<?xml version=""1.0""?>" &
         "<strategy>");

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
                                                         --"<meanSpeed>" & Common.FloatToString(update.MeanSpeed) & "</meanSpead> <!-- km/h --> " &
                                                         --"<meanGasConsumption>" & Common.FloatToString(update.MeanGasConsumption) & "</meanGasConsumption> <!-- l/h --> " &
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

   function XML2CompetitionUpdate(UpdateStr_In : STRING;
                                  Temporary_StringName : STRING) return COMPETITION_UPDATE_POINT is
      Update : COMPETITION_UPDATE_POINT := new COMPETITION_UPDATE;
      Doc : Document;
      Update_NodeList : Node_List;
      Current_Node : NODE;

      GasLevel : FLOAT;
      TyreUsury : PERCENTAGE;
  --    Time : FLOAT;
      Lap : INTEGER;
      Sector : INTEGER;
      PathLength : FLOAT;

      --Update_FileName : Unbounded_String.Unbounded_String := Unbounded_String.To_Unbounded_String("new_update.xml");
      Success : BOOLEAN := false;
   begin
      --TODO: handle the exception
      Ada.Text_IO.Put_Line("SAving file");
      Success := Common.SaveToFile(FileName => Temporary_StringName,
                        Content  => UpdateStr_In,
                        Path     => "");
      Ada.Text_IO.Put_Line("File saved");
      Doc := Common.Get_Document(Temporary_StringName);
      Ada.Text_IO.Put_Line("Document got");
      Update_NodeList := Get_Elements_By_Tag_Name(Doc,"update");
      Ada.Text_IO.Put_Line("Nodelist got");
      Current_Node := Item(Update_NodeList,0);
      Ada.Text_IO.Put_Line("Start saving values");
      GasLevel := FLOAT'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"gasLevel"))));
      Ada.Text_IO.Put_Line("Gas done");
      TyreUsury := FLOAT'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"tyreUsury"))));
      Ada.Text_IO.Put_Line("Tyre done");
      Lap := INTEGER'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"lap"))));
      Ada.Text_IO.Put_Line("Lap done");
      Sector := INTEGER'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"sector"))));
      Ada.Text_IO.Put_Line("Sector done");
--      Time := FLOAT'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"time"))));
--      Ada.Text_IO.Put_Line("Time done");
      PathLength := FLOAT'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"metres"))));
      Ada.Text_IO.Put_Line("Path lengt done");

      Update.GasLevel := GasLevel;
      Ada.Text_IO.Put_Line("Updating tyre usury");
      Update.TyreUsury := TyreUsury;
      Ada.Text_IO.Put_Line("Tyre usury done");
--      Update.Time := Time;
      Update.Lap := Lap;
      Update.Sector := Sector;
      Update.PathLength := PathLength;


      return Update;
   end XML2CompetitionUpdate;

end Box;
