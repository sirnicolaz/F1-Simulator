with Common;
use Common;

with Box_Data;
use Box_Data;

package Artificial_Intelligence is


   -- This resource is ought to be used to handler to forced pitstop
   --+ requests coming from the "outside"
   protected type Synch_Pitstop_Handler is
      procedure Force_Pitstop ( Force : Boolean );

      procedure Is_Pitstop_Requested ( Requested : out Boolean );

   private
      Pitstop_Requested : Boolean := False;
   end Synch_Pitstop_Handler;

   Pitstop_Handler : Synch_Pitstop_Handler;

   type Box_Strategy is (CAUTIOUS,NORMAL,RISKY,FOOL,NULL_STRATEGY);

   function Compute_Strategy(New_Info : Competition_Update;
                             Old_Strategy : Strategy;
                             Previous_Lap_Mean_Gas_Consumption : Float;
                             Previous_Lap_Mean_Tyre_Usury : Float) return Strategy;

   procedure Configure(Laps_In : Integer;
                       Box_Strategy_In : Box_Strategy;
                       Gas_Tank_Capacity_In : Float;
                       Circuit_Length_In : Float);

   function Calculate_Doable_Laps(Current_Gas_Level : Float;
                                  Current_Tyre_Usury : Percentage;
                                  Mean_Gas_Consumption : Float;
                                  Mean_Tyre_Consumption : Percentage) return Integer;

end Artificial_Intelligence;
