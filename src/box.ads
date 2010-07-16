with Common;
use Common;

with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;

package Box is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   task type MONITOR is
   end MONITOR;

   task type STRATEGY_UPDATER is
   end STRATEGY_UPDATER;

   type COMPETITION_UPDATE is private;
   type INFO_NODE is private;
   type INFO_NODE_POINT is access INFO_NODE;

   --Temporary public type. It has to be private DEL
   --   type BOX_STRATEGY is private;
   type BOX_STRATEGY is record
      Type_Tyre : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Style : DRIVING_STYLE;
      GasLevel : PERCENTAGE;
      PitStopLap : INTEGER;
      PitStopDelay : FLOAT;
   end record;

   type STRATEGY_HISTORY is array(POSITIVE range <>) of BOX_STRATEGY;

   Interval : FLOAT; -- set after competition joining
   Sector_Qty : INTEGER;
   Competitor_Id : INTEGER;

   protected type SYNCH_COMPETITION_UPDATES is
      procedure Init_Buffer;
      procedure Add_Data(CompetitionUpdate_In : COMPETITION_UPDATE);
      entry Wait(NewInfo : out COMPETITION_UPDATE);
      function IsUpdated return BOOLEAN;
   private
      Updates_Current : Info_Node_Point;
      Updates_Last : Info_Node_Point;
      Updated : BOOLEAN;
   end SYNCH_COMPETITION_UPDATES;

   --The resource handle the mutually exclusive access to the
   --+ strategy history. The resource is written by the
   --+ strategy updated that add new strategies to the history
   --+ everytime it calculates a new one.
   --+ The task responsible for the remote interface of the Box
   --+ (used by the competitor to ask for a new strategy) uses
   --+ this resources to search for the up-to-date strategy.

   protected type SYNCH_STRATEGY_HISTORY is

      procedure AddStrategy( Strategy : in BOX_STRATEGY );

      entry Wait( NewStrategy : out BOX_STRATEGY;
                 Lap : in INTEGER);

   private
      history : access STRATEGY_HISTORY;
      Updated : BOOLEAN := false;
   end SYNCH_STRATEGY_HISTORY;


   -- BOX RADIO TYPES AND METHODS DEFINITION --
   type BOX_RADIO is private;

   -- Remote Methods --

   function RequestStrategy( lap : in INTEGER ) return STRING;

   --Temporary test function DEL
   function BoxStrategyToXML(strategy : BOX_STRATEGY) return STRING;

   -- Local methods --

private
   type COMPETITION_UPDATE is record
      GasLevel : PERCENTAGE;
      TyreUsury : PERCENTAGE;
      MeanSpeed : FLOAT; -- km/h
      MeanGasConsumption : FLOAT; -- l/h
      Time : FLOAT;
      Lap : INTEGER;
      Sector : INTEGER;
      -- Classific : decidere come esprimerla;
   end record;

   type Info_Node is record
      Index : POSITIVE;
      Previous : INFO_NODE_POINT;
      Next : INFO_NODE_POINT;
      This : COMPETITION_UPDATE;
   end record;

--     type BOX_STRATEGY is record
--        Type_Tyre : STRING(1..20);
--        Style : DRIVING_STYLE;
--        GasLevel : PERCENTAGE;
--        PitStopLap : INTEGER;
--        PitStopDelay : FLOAT;
--     end record;

   type BOX_RADIO is record
      CompetitionAddress : IP_ADDRESS;
      -- TODO: add the IOR or whatelse is needed to connect to the competition
   end record;

end Box;
