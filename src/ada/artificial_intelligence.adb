package body Artificial_Intelligence is

   -- Depending on the driving style, the mean kilometres per litre
   --+ will change. 1 step is like moving from NORMAL to AGGRESSIVE.
   --+ If the style switch from AGGRESSIVE to conservative, the
   --+ total modifier it's (0.2 * 2) * -1 (it's 2 steps backward)
   Driving_Style_Step_Modifier_Gas : constant Float := 0.2;
   Driving_Style_Step_Modifier_Tyre : constant Float := 0.03;

   -- Time needed at the box to refill the gas tank by one litre (seconds)
   Seconds_Per_Litre : constant Float := 0.083;
   -- Time needed at the box to change the tyres (seconds)
   Tyre_Switch_Seconds : constant Float := 1.2;

   -- Car details
   Gas_Tank_Capacity : Float;
   Tyre_Type : Unbounded_String.Unbounded_String;

   -- The strategy factor depends on the box strategy. More risky
   --+ is the strategy, more optimistic is the evaluation of the
   --+ doable laps with the given gas level and tyre usury.
   --+ Cautious -> evaluation assuming 1/3 gas level less
   --+ Normal -> evaluation assuming 1/5 gas level less
   --+ Risky --> evaluation assuming exactly the gas level
   --+ Fool --> evaluation assuming 1/7 gas level more
   Strategy_Factor : Float;

   -- Total laps
   Laps : Integer := 0;

   -- Circuit length. Initialised after the competitor registration
   Circuit_Length : Float := 6.0;


   protected body Synch_Pitstop_Handler is
      procedure Force_Pitstop ( Force : Boolean ) is
      begin
         Pitstop_Requested := Force;
      end Force_PitStop;

      procedure Is_Pitstop_Requested ( Requested : out Boolean ) is
      begin
         Requested := Pitstop_Requested;
         Pitstop_Requested := False;
      end Is_Pitstop_Requested;
   end Synch_Pitstop_Handler;

   -- Configure the static parameters
   procedure Configure(Laps_In : Integer;
                       Box_Strategy_In : Box_Strategy;
                       Gas_Tank_Capacity_In : Float;
                       Circuit_Length_In : Float) is
   begin

      Laps := Laps_In;
      Circuit_Length := Circuit_Length_In;
      Gas_Tank_Capacity := Gas_Tank_Capacity_In;

      case Box_Strategy_In is
         when CAUTIOUS =>
            Strategy_Factor := -0.2;
         when NORMAL | NULL_STRATEGY =>
            Strategy_Factor := -0.1;
         when RISKY =>
            Strategy_Factor := 0.0;
         when FOOL =>
            Strategy_Factor := 0.2;
      end case;

   end Configure;


   function Calculate_Doable_Laps(Current_Gas_Level : Float;
                                  Current_Tyre_Usury : PERCENTAGE;
                                  Mean_Gas_Consumption : Float;
                                  Mean_Tyre_Consumption : PERCENTAGE) return Integer is

      Remaining_Doable_Laps_With_Gas : Integer;
      Remaining_Doable_Laps_With_Tyre : Integer;

      Doable_Laps : Integer;

   begin

      -- Calculate how many laps are still doable with the given gas and tyre usury
      -- MeanGasConsuption is the amount of litres of gas used for 1 km calculated
      --+ against all the information obtained up to now.
      --+ Depending on the Global Strategy, the box will be more or less optimistic
      --+ calculating the number remaining laps.

      Remaining_Doable_Laps_With_Gas := Integer(Float'Floor(
        (( Current_Gas_Level + (Current_Gas_Level * Strategy_Factor) )/
          Mean_Gas_Consumption)/
            Circuit_Length));

      -- The MeanTyreUsury expresses how mouch the tyre was usured for each km.
      --+ The value it's calculated considering all the information up to now.
      Remaining_Doable_Laps_With_Tyre := Integer(Float'Floor(
        (((100.00 - Current_Tyre_Usury) +
        ((100.00 - Current_Tyre_Usury)*(Strategy_Factor/5.0)))/
          Mean_Tyre_Consumption)/  -- Strategy_Factor/10.0 because is more logic for the tyre usury
            Circuit_Length));

      if( Remaining_Doable_Laps_With_Gas < Remaining_Doable_Laps_With_Tyre) then
         Doable_Laps := Remaining_Doable_Laps_With_Gas;
      else
         Doable_Laps := Remaining_Doable_Laps_With_Tyre;
      end if;

      return Doable_Laps;

   end Calculate_Doable_Laps;

   function Simulate_Driving_Style_Change(Old_Style : Common.DRIVING_STYLE;
                                       NewStyle : Common.DRIVING_STYLE;
                                       Laps_To_Simulate : Integer;
                                       Gas_Level_In : Float;
                                       Tyre_Usury_In : PERCENTAGE;
                                       Previous_Lap_Mean_Gas_Consumption : Float;
                                       Previous_Lap_Mean_Tyre_Usury : Float) return BOOLEAN is
      Total_Style_Modifier_Gas : Float;
      Total_Style_Modifier_Tyre : Float;
      Gas_Needed : Float;
      -- In this case the Tyre_Needed is Float and not Percentage because it might be over 100%
      --+ in some extreme situation. So to avoid a type error, it's
      --+ necessary to use Float
      Tyre_Needed : Float;

   begin

      Total_Style_Modifier_Gas := Driving_Style_Step_Modifier_Gas * Float(Common.Style_Distance(Old_Style,NewStyle));

      Total_Style_Modifier_Tyre := Driving_Style_Step_Modifier_Tyre * Float(Common.Style_Distance(Old_Style,NewStyle));

      Gas_Needed := (Previous_Lap_Mean_Gas_Consumption + Total_Style_Modifier_Gas) *
        (Circuit_Length * Float(Laps_To_Simulate) * (1.0 - Strategy_Factor));

      Tyre_Needed :=
        (Previous_Lap_Mean_Tyre_Usury + Total_Style_Modifier_Tyre)
        * (Circuit_Length * Float(Laps_To_Simulate) * (1.0 - Strategy_Factor/10.0));


      if ( Gas_Needed > Gas_Level_In ) then
         return false;
      elsif (Tyre_Needed > (100.0 - Tyre_Usury_In) ) then
         return false;
      else
         return true;
      end if;

   end Simulate_Driving_Style_Change;

   function Try_More_Aggressive(Old_Style : Common.Driving_Style;
                                Remaining_Laps : Integer;
                                Gas_Level : Float;
                                Tyre_Usury : Percentage;
                                Previous_Lap_Mean_Gas_Consumption : Float;
                                Previous_Lap_Mean_Tyre_Usury : Float) return Common.Driving_Style is

      Style_To_Simulate : Common.Driving_Style;
      New_Style : Common.Driving_Style := Old_Style;
      Doable : Boolean;

   begin
      -- Calculate how many laps would be doable with a more aggressive driving style
      --+ (if it's not already the most aggressive one)

      --If the old driving style was not the most aggressive one, try to simulate that one
      if( Old_Style /= Common.AGGRESSIVE ) then
         Style_To_Simulate := Common.AGGRESSIVE;
         Doable := Simulate_Driving_Style_Change(Old_Style,
                                              Style_To_Simulate,
                                              Remaining_Laps,
                                              Gas_Level,
                                              Tyre_Usury,
                                              Previous_Lap_Mean_Gas_Consumption,
                                              Previous_Lap_Mean_Tyre_Usury);

         --If the most aggressive style is not doable and if the old style was conservative,
         --+ it's possible to try to simulate the NORMAL driving style
         if( Doable = false and then Old_Style /= Common.NORMAL) then

            Style_To_Simulate := Common.NORMAL;
            Doable := Simulate_Driving_Style_Change(Old_Style,
                                                 Style_To_Simulate,
                                                 Remaining_Laps,
                                                 Gas_Level,
                                                 Tyre_Usury,
                                                 Previous_Lap_Mean_Gas_Consumption,
                                                 Previous_Lap_Mean_Tyre_Usury);

            --If at least the NORMAL style is doable, that will be the new style, otherwise
            --+ the style must not change.
            if ( Doable = true ) then
               New_Style := Style_To_Simulate;
            end if;

         else
            --The new style can be the most aggressive one
            New_Style := Style_To_Simulate;
         end if;

      end if;

      return New_Style;

   end Try_More_Aggressive;

   function Try_More_Conservative(Old_Style : Common.Driving_Style;
                                  Remaining_Laps : Integer;
                                  Gas_Level : Float;
                                  Tyre_Usury : Percentage;
                                  Previous_Lap_Mean_Gas_Consumption : Float;
                                  Previous_Lap_Mean_Tyre_Usury : Float) return Common.Driving_Style is

      Style_To_Simulate : Common.Driving_Style;
      New_Style : Common.Driving_Style := Old_Style;
      Doable : Boolean;
   begin

      --First of all, try the most conservative style, then, if possible, simulate
      --+ a more aggressive one
      if( Old_Style /= Common.CONSERVATIVE ) then

         Style_To_Simulate := Common.CONSERVATIVE;
         Doable := Simulate_Driving_Style_Change(Old_Style,
                                              Style_To_Simulate,
                                              Remaining_Laps,
                                              Gas_Level,
                                              Tyre_Usury,
                                              Previous_Lap_Mean_Gas_Consumption,
                                              Previous_Lap_Mean_Tyre_Usury);

         if( Doable = true ) then

            New_Style := Style_To_Simulate;

            -- The most conservative is set. Now, if possible, let's try to be one level more
            --+ aggressive (that is NORMAL)
            if( Old_Style /= Common.NORMAL ) then

               -- Try, if possible, to drive faster
               Style_To_Simulate := Common.NORMAL;
               Doable := Simulate_Driving_Style_Change(Old_Style,
                                                    Style_To_Simulate,
                                                    Remaining_Laps,
                                                    Gas_Level,
                                                    Tyre_Usury,
                                                    Previous_Lap_Mean_Gas_Consumption,
                                                    Previous_Lap_Mean_Tyre_Usury);

               if ( Doable = true ) then
                  New_Style := Style_To_Simulate;
               end if;

            end if;

         end if;

      end if;

      --If the new style was alraedy CONSERVATIVE it can't be set less aggressive

      return New_Style;

   end Try_More_Conservative;

   function Calculate_New_Gas_Amount(Current_Gas_Amount : Float;
                                     Laps_To_End_Race : Integer;
                                     Previous_Lap_Mean_Gas_Consumption : Float) return Float is

      New_Gas_Amount : Float;

   begin

      --Calculate the gas amount needed to reach the end of the race
      New_Gas_Amount :=
        ( ( Float( Laps_To_End_Race ) * Circuit_Length ) *
           Previous_Lap_Mean_Gas_Consumption ) *
          ( 1.0 - Strategy_Factor );

      --If it's more than the gas tank capacity, calculate the necessary amount
      --+ to run until the half of the competition
      if(New_Gas_Amount > Gas_Tank_Capacity) then
         New_Gas_Amount :=
           ( ( Float( Laps_To_End_Race / 2 ) * Circuit_Length ) *
              Previous_Lap_Mean_Gas_Consumption ) *
             ( 1.0 - Strategy_Factor );
      end if;

      --Even if the refilled amount of gas is not enough for reaching the
      --+ foreseen number of laps, the pitstop lap will be calculated at the beginning
      --+ of the next invokation of the function considering the new amount of gas
      if(Current_Gas_Amount < New_Gas_Amount ) then
         return New_Gas_Amount;
      else
         --This means that the amount of gas remains the same
         return -1.0;
      end if;

   end Calculate_New_Gas_Amount;

   function Update_Laps_To_Pitstop(Old_Laps_To_Pitstop : Integer;
                                   Doable_Laps : Integer) return Integer is

      Laps_To_Pitstop : Integer;
      Forced_Pitstop : Boolean;

   begin

      -- Verify if any external entity asked for a pitstop
      Pitstop_Handler.Is_Pitstop_Requested(Forced_Pitstop);
      if(Forced_Pitstop = True) then
         return 0;
      end if;

      Laps_To_Pitstop := Old_Laps_To_Pitstop - 1;

      -- Reset the Laps_To_Pitstop field when the pitstop is done ( when the pitstop is done
      --+ the Laps_To_Pitstop is set to -1)
      if(Laps_To_Pitstop = -1) then
         Laps_To_Pitstop := Doable_Laps;
      end if;

      return Laps_To_Pitstop;

   end Update_Laps_To_Pitstop;

   function Compute_Strategy(New_Info : COMPETITION_UPDATE;
                             Old_Strategy : STRATEGY;
                             Previous_Lap_Mean_Gas_Consumption : Float;
                             Previous_Lap_Mean_Tyre_Usury : Float) return STRATEGY is

      New_Strategy : STRATEGY;

      Doable_Laps : Integer;
      Laps_To_Pitstop : Integer;
      Laps_To_End_Race : Integer;
      Remaining_Laps : Integer; -- the minimum between Laps_To_Pitstop and Laps_To_End_Race

      Warning : BOOLEAN := false;
      New_Driving_Style : Common.DRIVING_STYLE;

   begin

      Doable_Laps := Calculate_Doable_Laps(Current_Gas_Level     => New_Info.Gas_Level,
                                           Current_Tyre_Usury    => New_Info.Tyre_Usury,
                                           Mean_Gas_Consumption  => Previous_Lap_Mean_Gas_Consumption,
                                           Mean_Tyre_Consumption => Previous_Lap_Mean_Tyre_Usury);

      -- Calculate the remaining number of laps til either the pitstop or the
      --+ end of the competition.

      Laps_To_Pitstop := Update_Laps_To_Pitstop(Old_Strategy.Laps_To_Pitstop,
                                                Doable_Laps);

      Laps_To_End_Race := ( Laps-1 ) - New_Info.Lap;

      if ( Laps_To_Pitstop < Laps_To_End_Race ) then
         Remaining_Laps := Laps_To_Pitstop;
      else
         Remaining_Laps := Laps_To_End_Race;
      end if;

      --Just to be sure that the new strategy is set.
      New_Strategy.Style := Old_Strategy.Style;

      if ( Remaining_Laps /= 0 ) then

         --If the number of doable laps is enough to either finish the comeptition
         --+ or to reach the next pitstop, try to see if it's possible to change the driving
         --+ style to a more aggressive one

         if ( Doable_Laps >= Remaining_Laps ) then
            Warning := false;

            New_Driving_Style := Try_More_Aggressive(Old_Strategy.Style,
                                                     Remaining_Laps,
                                                     New_Info.Gas_Level,
                                                     New_Info.Tyre_Usury,
                                                     Previous_Lap_Mean_Gas_Consumption,
                                                     Previous_Lap_Mean_Tyre_Usury);

         else

            -- If the laps the competitor can do are less then the remaining laps (either
            --+ to the pitstop or to the end of the competition), calculate whether with a more
            --+ conservative driving style it's possible to reach the target or not
            New_Driving_Style := Try_More_Conservative(Old_Strategy.Style,
                                                       Remaining_Laps,
                                                       New_Info.Gas_Level,
                                                       New_Info.Tyre_Usury,
                                                       Previous_Lap_Mean_Gas_Consumption,
                                                       Previous_Lap_Mean_Tyre_Usury);

            -- It means that the competitor can't theoretically ride for the reamining laps,
            --+ so the warning is set to allow the next part of the function to evaluate
            --+ a plan b
            if(New_Driving_Style = Old_Strategy.Style) then
               Warning := true;
            end if;

         end if;

         if ( Warning = true and Doable_Laps /= 0) then
            Laps_To_Pitstop := Doable_Laps - 1;
         end if;

      end if;

      New_Strategy.Style := New_Driving_Style;
      New_Strategy.Laps_To_Pitstop := Laps_To_Pitstop;

      --This is to avoid the end of the competititon to the pitstop, it makes no sense considering that pitstop = goal
      if( ( Laps-1 ) - New_Info.Lap = 0) then
	    New_Strategy.Laps_To_Pitstop := 1;
      end if;

      -- If the number of laps to the PitStop is 0, it means that the competitor is going to
      --+ have a pitstop, so it's necessary to calculate the amount of gas to refill and
      --+ the type o tyres tu put on the car
      if ( New_Strategy.Laps_To_Pitstop = 0 ) then

         New_Strategy.Gas_Level := Calculate_New_Gas_Amount(New_Info.Gas_Level,
                                                            Laps_To_End_Race,
                                                            Previous_Lap_Mean_Gas_Consumption);

         -- Calculate the time needed to refill the gas tank
         New_Strategy.Pit_Stop_Delay :=  New_Strategy.Gas_Level * Seconds_Per_Litre;

         -- The total delay at the box is the maximum time between gas refill and
         --+ tyre switch
         if ( New_Strategy.Pit_Stop_Delay < Tyre_Switch_Seconds ) then
            New_Strategy.Pit_Stop_Delay := Tyre_Switch_Seconds;
         end if;

      else

         --HACK: Gas level used to compute the mean gas consumption by the
         --+ the box and not used by the competitor
         New_Strategy.Gas_Level := New_Info.Gas_Level;
         New_Strategy.Pit_Stop_Delay := 0.0;

      end if;

      New_Strategy.Tyre_Type := Old_Strategy.Tyre_Type;

      return New_Strategy;

   end Compute_Strategy;

end Artificial_Intelligence;
