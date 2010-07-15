with Common;
use Common;

package Box is

   task type MONITOR is
   end MONITOR;

   task type STRATEGY_UPDATER is
   end STRATEGY_UPDATER;

   type COMPETITION_UPDATE is private;
   type INFO_NODE is private;
   type INFO_NODE_POINT is access INFO_NODE;
   type BOX_STRATEGY is private;

   Interval : FLOAT; -- set after competition joining
   Sector_Qty : INTEGER;
   Competitor_Id : INTEGER;

   protected type SYNCH_COMPETITION_UPDATES is
      procedure Init_Buffer;
      procedure Add_Data(CompetitionUpdate_In : COMPETITION_UPDATE);
      entry Wait(NewInfos : out COMPETITION_UPDATE);
      function IsUpdated return BOOLEAN;
   private
      Updates_Current : Info_Node_Point;
      Updates_Last : Info_Node_Point;
      Updated : BOOLEAN;
   end SYNCH_COMPETITION_UPDATES;

   -- BOX RADIO TYPES AND METHODS DEFINITION --
   type BOX_RADIO is private;

   -- Remote Methods --

   --This method is ought to establish a connection with the competition
   --+ server and communicate the new strategy to the competitor radio
   procedure SendStrategy(New_Strategy : BOX_STRATEGY);
   -- This remote procedure should be used by the competitor radio to
   --+ ask for a strategy update in case it hasn't arrived in time.
   procedure StrategyEmergencyRequest (Lap : INTEGER;
                                       Update : COMPETITION_UPDATE);

   -- Local methods --
   function GetLocalFrequency return INTEGER;
   function GetRemoteFrequency return INTEGER;
   --TODO: find out the purpose of this function
   procedure RequestPitstop;

private
   type COMPETITION_UPDATE is record
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
      This : COMPETITION_UPDATE;
   end record;

   type BOX_STRATEGY is record
      Type_Tyre : STRING(1..20);
      Style : DRIVING_STYLE;
      GasLevel : PERCENTAGE;
      PitStopLap : INTEGER;
      PitStopDelay : FLOAT;
   end record;

   type BOX_RADIO is record
      -- Frequency: metaphorical way to say "port number"
      Local_Frequency : INTEGER;
      Remote_Frequency : INTEGER;
      CompetitionAddress : IP_ADDRESS;
      -- TODO: add the IOR or whatelse is needed to connect to the competition
   end record;

end Box;
