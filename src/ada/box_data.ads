with Common;
use Common;

with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;

package Box_Data is

   type INFO_NODE is private;
   type INFO_NODE_POINT is access INFO_NODE;

   type COMPETITION_UPDATE is tagged record
      GasLevel : FLOAT;
      TyreUsury : PERCENTAGE;
      Time : FLOAT;
      Lap : INTEGER;
      Sector : INTEGER;
      PathLength : FLOAT;
      --For now it's not necessary. In the future there might be an improvement
      --+ in the strategy computation considering the classific too.
      --Classific : access COMPETITOR_LIST := new COMPETITOR_LIST(1..competitor_qty);
   end record;

   type EXT_COMPETITION_UPDATE is new COMPETITION_UPDATE
   with
      record
         MeanSpeed : FLOAT; -- km/h
         MeanGasConsumption : FLOAT; -- l/h
         MeanTyreUsury : PERCENTAGE;
      end record;

   type COMPETITION_UPDATE_POINT is access COMPETITION_UPDATE;

   type STRATEGY_HISTORY is array(INTEGER range <>) of STRATEGY;

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
   end SYNCH_STRATEGY_HISTORY;

   type SYNCH_STRATEGY_HISTORY_POINT is access SYNCH_STRATEGY_HISTORY;

   --All the information available packed.
   type ALL_INFO is private;

   type ALL_INFO_ARRAY is array(POSITIVE range <>) of ALL_INFO;

   --This buffer is supposed to be used between strategy updater and
   --+ the box
   protected type SYNCH_ALL_INFO_BUFFER is
      procedure Init( Size : POSITIVE);
      entry Get_Info( Num : POSITIVE; Info : out ALL_INFO );
      entry Wait( Num : POSITIVE; Info : out ALL_INFO );

      procedure Add_Info(Update_In : EXT_COMPETITION_UPDATE );
      procedure Add_Info(Update_In : EXT_COMPETITION_UPDATE;
                         Strategy_In : STRATEGY);

   private
      Updated : BOOLEAN := false;
      Info_Qty : INTEGER := 0;
      Info_List : access ALL_INFO_ARRAY;
      Ready : BOOLEAN := FALSE;
   end SYNCH_ALL_INFO_BUFFER;

   type SYNCH_ALL_INFO_BUFFER_POINT is access SYNCH_ALL_INFO_BUFFER;

   function Get_StrategyXML( Data : ALL_INFO ) return Unbounded_String.Unbounded_String;

   function Get_UpdateXML( Data : ALL_INFO ) return Unbounded_String.Unbounded_String;

   function Get_Time ( Data : ALL_INFO ) return FLOAT;
   function Get_Metres ( Data : ALL_INFO ) return FLOAT;

   function BoxStrategyToXML(Strategy_in : STRATEGY) return STRING;

private

    type Info_Node is record
      Index : INTEGER;
      Previous : INFO_NODE_POINT;
      Next : INFO_NODE_POINT;
      This : COMPETITION_UPDATE_POINT;
   end record;

   type ALL_INFO is record
      PerSectorUpdate : access EXT_COMPETITION_UPDATE;
      StrategyUpdate : access Common.STRATEGY;
   end record;

end Box_Data;
