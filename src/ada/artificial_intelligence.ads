with Common;
use Common;

with Box_Data;
use Box_Data;

package Artificial_Intelligence is

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
