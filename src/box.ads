with Common;
use Common;

--with Competitor;

with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;

with Box_Data;
use Box_Data;

package Box is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   type BOX_STRATEGY is (CAUTIOUS,NORMAL,RISKY,FOOL,NULL_STRATEGY);

   procedure Init(Laps_In : in INTEGER;
                  CircuitLength_In : in FLOAT;
                  CompetitorId_In : in INTEGER;
                  BoxStrategy_In : in BOX_STRATEGY;
                  GasTankCapacity_In : FLOAT);

   Interval : FLOAT; -- set after competition joining
   Sector_Qty : INTEGER := 3; --It's fixed in the f1 competitions
   Competitor_Id : INTEGER;

   -- This task is the responsible of getting the competition updates from the
   --+ remote server and putting them into the updated buffer shared with
   --+ the strategy updater
   task type UPDATE_RETRIEVER(SharedBuffer : SYNCH_COMPETITION_UPDATES_POINT;
                     MonitorRadio_CorbaLOC : Common.UNBOUNDED_STRING_POINT) is
   end UPDATE_RETRIEVER;

   -- The strategy updater takes new information about the competition
   --+ whenever they are available in the update buffer. Then it uses
   --+ them to compute the new startegy lap by lap.
   task type STRATEGY_UPDATER ( SharedBuffer : SYNCH_COMPETITION_UPDATES_POINT;
                               SharedHistory : SYNCH_STRATEGY_HISTORY_POINT;
                               InitialGasLevel : Common.FLOAT_POINT;
                               InitialTyreType : Common.STRING_POINT;
                               ALlInfo_Buffer : SYNCH_ALL_INFO_BUFFER_POINT) is
   end STRATEGY_UPDATER;

   --Temporary test function DEL
   function XML2CompetitionUpdate(UpdateStr_In : STRING;
                                  Temporary_StringName : STRING) return COMPETITION_UPDATE_POINT;
   -- Local methods --

end Box;
