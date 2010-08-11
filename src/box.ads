with Common;
use Common;

--with Competitor;

with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;

package Box is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   type INFO_NODE is private;
   type INFO_NODE_POINT is access INFO_NODE;

   type BOX_STRATEGY is (CAUTIOUS,NORMAL,RISKY,FOOL,NULL_STRATEGY);

   procedure Init(Laps_In : in INTEGER;
                  CircuitLength_In : in FLOAT;
                  CompetitorId_In : in INTEGER;
                  BoxStrategy_In : in BOX_STRATEGY;
                  GasTankCapacity_In : FLOAT);

   type COMPETITION_UPDATE( competitor_qty : INTEGER) is record
      GasLevel : FLOAT;
      TyreUsury : PERCENTAGE;
      MeanSpeed : FLOAT; -- km/h
      MeanGasConsumption : FLOAT; -- l/h
      Time : FLOAT;
      Lap : INTEGER;
      Sector : INTEGER;
      Classific : access COMPETITOR_LIST := new COMPETITOR_LIST(1..competitor_qty);
   end record;

   type COMPETITION_UPDATE_POINT is access COMPETITION_UPDATE;

   type STRATEGY_HISTORY is array(POSITIVE range <>) of STRATEGY;

   Interval : FLOAT; -- set after competition joining
   Sector_Qty : INTEGER := 3; --It's fixed in the f1 competitions
   Competitor_Id : INTEGER;

   protected type SYNCH_COMPETITION_UPDATES is
      procedure Add_Data(CompetitionUpdate_In : COMPETITION_UPDATE_POINT);
      entry Wait(NewInfo : out COMPETITION_UPDATE;
                 Num : in INTEGER);
      entry Get_Update( NewInfo : out COMPETITION_UPDATE;
                       Num : INTEGER );
      function IsUpdated return BOOLEAN;
   private
      Updates_Current : Info_Node_Point;
      Updates_Last : Info_Node_Point;
      Updated : BOOLEAN := False;
   end SYNCH_COMPETITION_UPDATES;

   type SYNCH_COMPETITION_UPDATES_POINT is access SYNCH_COMPETITION_UPDATES;
   -- This task is the responsible of getting the competition updates from the
   --+ remote server and putting them into the updated buffer shared with
   --+ the strategy updater
   task type MONITOR(SharedBuffer : SYNCH_COMPETITION_UPDATES_POINT;
                     MonitorRadio_CorbaLOC : Common.UNBOUNDED_STRING_POINT) is
   end MONITOR;

   --The resource handle the mutually exclusive access to the
   --+ strategy history. The resource is written by the
   --+ strategy updated that add new strategies to the history
   --+ everytime it calculates a new one.
   --+ The task responsible for the remote interface of the Box
   --+ (used by the competitor to ask for a new strategy) uses
   --+ this resources to search for the up-to-date strategy.

   protected type SYNCH_STRATEGY_HISTORY is

      procedure Init( Lap_Qty : in INTEGER );

      procedure AddStrategy( Strategy_in : in STRATEGY );

      entry Get_Strategy( NewStrategy : out STRATEGY;
                         Lap : in INTEGER);

      -- It returns the pit stops already done.
      function Get_PitStopDone return INTEGER;


   private
      history : access STRATEGY_HISTORY;
      history_size : INTEGER := 0;
      Updated : BOOLEAN := false;
      --TODO: evaluate whether to put a PitStopDone field or not
   end SYNCH_STRATEGY_HISTORY;

   type SYNCH_STRATEGY_HISTORY_POINT is access SYNCH_STRATEGY_HISTORY;

   -- The strategy updater takes new information about the competition
   --+ whenever they are available in the update buffer. Then it uses
   --+ them to compute the new startegy lap by lap.
   task type STRATEGY_UPDATER ( SharedBuffer : SYNCH_COMPETITION_UPDATES_POINT;
                               SharedHistory : SYNCH_STRATEGY_HISTORY_POINT;
                               InitialGasLevel : Common.FLOAT_POINT;
                               InitialTyreType : Common.STRING_POINT) is
   end STRATEGY_UPDATER;

   -- BOX RADIO TYPES AND METHODS DEFINITION --
   type BOX_RADIO is private;

   --Temporary test function DEL
   function BoxStrategyToXML(Strategy_in : STRATEGY) return STRING;
   function CompetitionUpdateToXML(update : COMPETITION_UPDATE) return STRING;
   -- Local methods --

private
--     type COMPETITION_UPDATE is record
--        GasLevel : PERCENTAGE;
--        TyreUsury : PERCENTAGE;
--        MeanSpeed : FLOAT; -- km/h
--        MeanGasConsumption : FLOAT; -- l/h
--        Time : FLOAT;
--        Lap : INTEGER;
--        Sector : INTEGER;
--        -- Classific : decidere come esprimerla;
--     end record;

   type Info_Node is record
      Index : INTEGER;
      Previous : INFO_NODE_POINT;
      Next : INFO_NODE_POINT;
      This : COMPETITION_UPDATE_POINT;
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
