with CORBA.ORB;

with Broker.Radio.Competition_Monitor_Radio;

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

      Radio : Broker.Radio.Competition_Monitor_Radio.Ref;
      RadioCorbaLOC : STRING := Unbounded_String.To_String(MonitorRadio_CorbaLOC.all);

      --Generic boolean
      Success : BOOLEAN := false;
   begin
      
      --CORBA.ORB.Initialize("ORB");
      Corba.ORB.String_To_Object(CORBA.To_CORBA_String
                                 (RadioCorbaLOC) , Radio);

      if Broker.Radio.Competition_Monitor_Radio.Is_Nil(Radio) then
         Ada.Text_IO.Put_Line("Monitor radio down");

      end if;

      

      Success := Broker.Radio.Competition_Monitor_Radio.Ready(Radio,CORBA.Short(CompetitorID));

      
      -- Test init values to avoid warnings DEL
      Info := new COMPETITION_UPDATE;
      loop

         
         Broker.Radio.Competition_Monitor_Radio.Get_CompetitorInfo
           (
            Radio,
            CORBA.Short(Lap),
            CORBA.Short(Sector),
            CORBA.Short(CompetitorID),
            CORBA.Float(Time),
            CorbaInfo);
         Info_XMLStr := Unbounded_String.To_Unbounded_String(CORBA.To_Standard_String(CorbaInfo));
         
         Info := XML2CompetitionUpdate(Unbounded_String.To_String(Info_XMLStr),"../temp/competitor-" & Common.IntegerToString(CompetitorID) & "-update.xml");
         Info.Time := Time;
         
         
         UpdateBuffer.Add_Data(Info);
         
         
         if(Sector = Sector_Qty) then
            Sector := 0;
            Lap := Lap + 1;
         end if;

         exit when (Info.GasLevel <= 0.0 or Info.TyreUsury >= 100.0) or else Lap = Laps;

         Sector := Sector + 1;
      end loop;

      


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
      
      -- The MeanTyreUsury expresses how mouch the tyre was usured for each km.
      --+ The value it's calculated considering all the information up to now.
      RemainingDoableLaps_Tyre := INTEGER(FLOAT'Floor(
          (((100.00 - CurrentTyreUsury) +
          ((100.00 - CurrentTyreUsury)*(StrategyFactor/10.0)))/
            MeanTyreConsumption)/  -- StrategyFactor/10.0 because is more logic for the tyre usury
            CircuitLength));
      --

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
         
         TotalStyleModifierGas := DrivingStyle1StepModifierGas * FLOAT(Common.Style_Distance(OldStyle,NewStyle));
         
         TotalStyleModifierTyre := DrivingStyle1StepModifierTyre * FLOAT(Common.Style_Distance(OldStyle,NewStyle));
         
         GasNeeded := (PreviousLapMeanGasConsumption + TotalStyleModifierGas) *
           (CircuitLength * FLOAT(Laps2Simulate) * (1.0 - StrategyFactor));

         TyreNeeded :=
           (PreviousLapMeanTyreUsury + TotalStyleModifierTyre)
           * (CircuitLength * FLOAT(Laps2Simulate) * (1.0 - StrategyFactor/10.0));
         
         
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
      
      Laps2PitStop := Old_Strategy.PitStopLaps - 1;

      if(Laps2PitStop = -1) then
         Laps2PitStop := RemainingDoableLaps;
      end if;

      
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
      --Add the first statistic to the computer
--        compStats.Checkpoint := CurrentCheckpoint+1;
--        CurrentCheckpoint := CurrentCheckpoint+1;
--        compStats.LastCheckInSect := C_Checkpoint.Is_LastOfTheSector;
--        compStats.FirstCheckInSect := C_Checkpoint.Is_FirstOfTheSector;
--        compStats.Sector := C_Checkpoint.Get_SectorID;
--        compStats.GasLevel := carDriver.auto.GasolineLevel;
--        compStats.TyreUsury := carDriver.auto.TyreUsury;
--        compStats.Time := C_Checkpoint.Get_Time(id);
--        compStats.Lap := CurrentLap;
--        compStats.PathLength := lengthPath;
--
--        OnBoardComputer.Add_Data(Computer_In => carDriver.statsComputer,
--                                 Data        => compStats);


         
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
         


         --Calculate the amount of gas needed to reach the end of the race
         NewGas :=
           ( ( FLOAT( Laps2End ) * CircuitLength ) *
              PreviousLapMeanGasConsumption ) *
             ( 1.0 - StrategyFactor );

         --If it's more than the gas thank capacity, calculate the amount
         --+ to run until the half of the competition
         if(NewGas > GasTankCapacity) then

            NewGas :=
              ( ( FLOAT( Laps2End / 2 ) * CircuitLength ) *
                 PreviousLapMeanGasConsumption ) *
                ( 1.0 - StrategyFactor );
         end if;

         --Even if the refilled amount of gas is not enough for reaching the
         --+ foreseen number of laps, the pitstop lap will be calculated at the beginning
         --+ of the next invokation of the function considering the new amount of gas
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
         
         --HACK: Gas level used to compute the mean gas consumption by the
         --+ the box and not used by the competitor
         
         New_Strategy.GasLevel := New_Info.GasLevel;
         
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
      AllInfo : Box_Data.SYNCH_ALL_INFO_BUFFER_POINT := ALlInfo_Buffer;
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
      ExtendedInformation : EXT_COMPETITION_UPDATE;
   begin

      
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


         Box_Data.COMPETITION_UPDATE(ExtendedInformation) := New_Info.all;

         if( New_Info.GasLevel < 0.0 ) then
            New_Info.GasLevel := 0.0;
         end if;

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

            ExtendedInformation.MeanGasConsumption := LatestLapMeanGasConsumption;

            PartialTyreUsuryMean := PartialTyreUsuryMean +
              LatestLapMeanTyreUsury;
            PreviousSectorTyreUsury := New_Info.TyreUsury;

            ExtendedInformation.TyreUsury := LatestLapMeanTyreUsury;

            --TODO: don't use so stupid values for the means
         else

            
            PartialGasConsumptionMean :=
              PartialGasConsumptionMean +
                ((PreviousSectorGasLevel - New_Info.GasLevel)/
                 (New_Info.PathLength/1000.0) -- We want the ratio in Km

              );

            ExtendedInformation.MeanGasConsumption :=
              (PreviousSectorGasLevel - New_Info.GasLevel)/
              (New_Info.PathLength/1000.0);

           
            PreviousSectorGasLevel := New_Info.GasLevel;
            

            PartialTyreUsuryMean :=
              PartialTyreUsuryMean +
                (New_Info.TyreUsury - PreviousSectorTyreUsury)/
                ((New_Info.PathLength/1000.0) -- We want the ratio in Km

                );

            ExtendedInformation.MeanTyreUsury :=
              (New_Info.TyreUsury - PreviousSectorTyreUsury)/
                (New_Info.PathLength/1000.0);

            PreviousSectorTyreUsury := New_Info.TyreUsury;
         end if;

         Index := Index + 1;

         

         exit when (New_Info.GasLevel <= 0.0 or New_Info.TyreUsury >= 100.0) or else --The car is out
           (New_Info.Lap = Laps-1 and New_Info.Sector = 3); --The competition is over


         if(Sector = Sector_Qty) then

            Evolving_Strategy := Compute_Strategy(New_Info.all,
                                         Evolving_Strategy,
                                         LatestLapMeanGasConsumption,
                                         LatestLapMeanTyreUsury
                                                 );

            --  "/3" because it's the sum of the mean of 3 sectors
             LatestLapMeanGasConsumption := PartialGasConsumptionMean/3.0;
            LatestLapMeanTyreUsury := PartialTyreUsuryMean/3.0;


            StrategyHistory.AddStrategy(Evolving_Strategy);
            Sector := 0;
            PartialGasConsumptionMean := 0.0;
            PartialTyreUsuryMean := 0.0;

            AllInfo.Add_Info(Update_In   => ExtendedInformation,
                             Strategy_In => Evolving_Strategy);

            if(Evolving_Strategy.PitStopLaps = 0) then
               Skip := 2;
            end if;

         else

            AllInfo.Add_Info(Update_In   => ExtendedInformation);

         end if;


         Sector := Sector + 1;

      end loop;

      AllInfo.Add_Info(Update_In   => ExtendedInformation);



   end STRATEGY_UPDATER;

   --StrategyUpdater_Task : access STRATEGY_UPDATER;

   -- Used to send to the client interface the information concerning the competition
   function CompetitionUpdateToXML(update : COMPETITION_UPDATE) return STRING is

      Competitor_Qty : INTEGER := 0;

      XML_String : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;

      begin

      --Updating related to the classific are temporary removed.
      --if update.Classific /= null then
        -- Competitor_Qty := update.Classific'LENGTH;
      --end if;

      XML_String := Unbounded_String.To_Unbounded_String("<update>" &
                                                         "<gasLevel>" & Common.FloatToString(update.GasLevel) & "</gasLevel> <!-- % -->" &
                                                         "<tyreUsury>" & Common.FloatToString(update.TyreUsury) & "</tyreUsury> <!-- % -->" &
                                                         --"<meanSpeed>" & Common.FloatToString(update.MeanSpeed) & "</meanSpead> <!-- km/h --> " &
                                                         --"<meanGasConsumption>" & Common.FloatToString(update.MeanGasConsumption) & "</meanGasConsumption> <!-- l/h --> " &
                                                         "<lap>" & Common.IntegerToString(update.Lap) & "</lap> " &
                                                         "<sector>" & Common.IntegerToString(update.Sector) & "</sector>" &
                                                         "</update>" );-- &
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

      Success := Common.SaveToFile(FileName => Temporary_StringName,
                        Content  => UpdateStr_In,
                        Path     => "");

      Doc := Common.Get_Document(Temporary_StringName);

      Update_NodeList := Get_Elements_By_Tag_Name(Doc,"update");

      Current_Node := Item(Update_NodeList,0);

      GasLevel := FLOAT'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"gasLevel"))));

      TyreUsury := FLOAT'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"tyreUsury"))));

      Lap := INTEGER'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"lap"))));

      Sector := INTEGER'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"sector"))));

--      Time := FLOAT'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"time"))));

      PathLength := FLOAT'VALUE(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"metres"))));


      Update.GasLevel := GasLevel;

      Update.TyreUsury := TyreUsury;

--      Update.Time := Time;
      Update.Lap := Lap;
      Update.Sector := Sector;
      Update.PathLength := PathLength;


      return Update;
   end XML2CompetitionUpdate;

end Box;
