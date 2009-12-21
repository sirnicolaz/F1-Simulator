with Common;
use Common;

package Box is

   task type MONITOR is
   end MONITOR;

   task type STRATEGY_CALCULATOR is
   end STRATEGY_CALCULATOR;


   type Competition_Infos is private;
   type Info_Node is private;
   type INFO_NODE_POINT is access INFO_NODE;
   type BOX_STRATEGY is private;

   Interval : FLOAT; -- set after competition joining
   Sector_Qty : INTEGER;
   Competitor_Id : INTEGER;

   protected type SYNCH_UPDATES_BUFFER is
      procedure Init_Buffer;
      procedure Add_Data(Competition_Infos_In : COMPETITION_INFOS);
      entry Wait(NewInfos : out COMPETITION_INFOS);
      function IsUpdated return BOOLEAN;
   private
      Updates_Current : Info_Node_Point;
      Updates_Last : Info_Node_Point;
      Updated : BOOLEAN;
   end SYNCH_UPDATES_BUFFER;

private
   type Competition_Infos is record
      GasLevel : PERCENTAGE;
      TyreUsury : PERCENTAGE;
      MeanSpeed : FLOAT; -- km/h
      MeanGasConsumption : FLOAT; -- l/h
      Time : FLOAT;
      -- Classific : decidere come esprimerla;
   end record;

   type Info_Node is record
      Index : POSITIVE;
      Previous : INFO_NODE_POINT;
      Next : INFO_NODE_POINT;
      This : Competition_Infos;
   end record;

   type BOX_STRATEGY is record
      Type_Tyre : STRING(1..20);
      Style : DRIVING_STYLE;
      GasLevel : PERCENTAGE;
      PitStopLap : INTEGER;
      PitStopDelay : FLOAT;
   end record;

end Box;
