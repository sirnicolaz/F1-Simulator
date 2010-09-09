with CORBA;
with PortableServer;

with Broker.Init.BoxConfigurator;

with Ada.Strings.Unbounded;
with Box;
use Box;

package Broker.Init.BoxConfigurator.Impl is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;

   protected type SYNCH_COMPETITION_SETTINGS is
      entry Get_Laps ( Laps_Out : out INTEGER);
      entry Get_CompetitorID ( CompetitorID_Out : out INTEGER);
      entry Get_CircuitLength ( CircuitLength_Out : out Standard.FLOAT);
      entry Get_CompetitionMonitor_CorbaLOC ( CMon_CorbaLOC_Out : out Unbounded_String.Unbounded_String );
      entry Get_BoxStrategy ( BoxStrategy_out : out Box.BOX_STRATEGY );
      entry Get_GasTankCapacity ( GasTankCapacity_Out : out Standard.FLOAT);
      entry Get_InitialGasLevel ( InitialGasLevel_Out : out Standard.FLOAT);
      entry Get_InitialTyreType ( InitialTyreType_Out : out Unbounded_String.Unbounded_String);
      procedure Set_Laps ( Laps_In : in INTEGER);
      procedure Set_CompetitorID ( CompetitorID_In : in INTEGER);
      procedure Set_CircuitLength ( CircuitLength_In : in Standard.FLOAT);
      procedure Set_CompetitionMonitor_CorbaLOC ( CMon_CorbaLoc_In : in Unbounded_String.Unbounded_String);
      procedure Set_BoxStrategy( BoxStrategy_In : in Box.BOX_STRATEGY);
      procedure Set_GasTankCapacity ( GasTankCapacity_in : in Standard.FLOAT);
      procedure Set_InitialGasLevel ( InitialGasLevel_in : in Standard.FLOAT);
      procedure Set_InitialTyreType ( InitialTyreType_in : in Unbounded_String.Unbounded_String);
   private
      Laps : INTEGER := -1;
      CompetitionMonitor_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      CompetitorID : INTEGER := -1;
      CircuitLength : Standard.FLOAT := -1.0;
      BoxStrategy : Box.BOX_STRATEGY := Box.NULL_STRATEGY;
      GasTankCapacity : Standard.FLOAT := -1.0;
      InitialGasLevel : Standard.FLOAT := -1.0;
      InitialTyreType : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      ConfiguredParameters : INTEGER := 0;
      Initialized : BOOLEAN := FALSE;
   end SYNCH_COMPETITION_SETTINGS;

   Settings : access SYNCH_COMPETITION_SETTINGS := new SYNCH_COMPETITION_SETTINGS;

   function Get_SettingsResource return access SYNCH_COMPETITION_SETTINGS;

   function Configure(Self : access Object;
                      config_file : CORBA.STRING) return CORBA.STRING;
end Broker.Init.BoxConfigurator.Impl;
