with CORBA;
with PortableServer;

with Ada.Strings.Unbounded;


package Configurator.Impl is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;

   protected type SYNCH_COMPETITION_SETTINGS is
      entry Get_Laps ( Laps_Out : out INTEGER);
      entry Get_CompetitionMonitor_CorbaLOC ( CMon_CorbaLOC_Out : out Unbounded_String.Unbounded_String );
      procedure Set_Laps ( Laps_In : in INTEGER);
      procedure Set_CompetitionMonitor_CorbaLOC ( CMon_CorbaLoc_In : in Unbounded_String.Unbounded_String);
   private
      Laps : INTEGER := -1;
      CompetitionMonitor_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Initialized : BOOLEAN := FALSE;
   end SYNCH_COMPETITION_SETTINGS;

   Settings : access SYNCH_COMPETITION_SETTINGS := new SYNCH_COMPETITION_SETTINGS;

   function Get_SettingsResource return access SYNCH_COMPETITION_SETTINGS;

   function Configure(Self : access Object;
                      config_file : CORBA.STRING) return CORBA.STRING;
end Configurator.Impl;
