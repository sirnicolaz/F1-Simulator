with Ada.Text_IO;

with Configurator.Skel;
pragma Warnings (Off, Configurator.Skel);
with CORBA;

with Ada.Strings.Unbounded;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes; use DOM.Core.Nodes;

with Common;

package body Configurator.Impl is

   protected body SYNCH_COMPETITION_SETTINGS is
      entry Get_Laps ( Laps_Out : out INTEGER) when Initialized is
      begin
         Laps_Out := Laps;
      end Get_Laps;

      entry Get_CompetitionMonitor_CorbaLOC ( CMon_CorbaLOC_Out : out Unbounded_String.Unbounded_String ) when Initialized is
      begin
         CMon_CorbaLOC_Out := CompetitionMonitor_CorbaLOC;
      end Get_CompetitionMonitor_CorbaLOC;

      procedure Set_Laps ( Laps_In : in INTEGER) is
      begin
         Laps := Laps_In;
         if ( CompetitionMonitor_CorbaLOC /= Unbounded_String.Null_Unbounded_String ) then
            Initialized := true;
         end if;
      end Set_Laps;

      procedure Set_CompetitionMonitor_CorbaLOC ( CMon_CorbaLoc_In : in Unbounded_String.Unbounded_String) is
      begin
         CompetitionMonitor_CorbaLOC := CMon_CorbaLoc_In;
         if( Laps /= -1) then
            Initialized := true;
         end if;
      end Set_CompetitionMonitor_CorbaLOC;
   end SYNCH_COMPETITION_SETTINGS;

   function Get_SettingsResource return access SYNCH_COMPETITION_SETTINGS is
   begin
      return Settings;
   end Get_SettingsResource;

   function Configure(Self : access Object;
                      config_file : CORBA.STRING) return CORBA.STRING is
      Name : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      MaxSpeed : FLOAT;
      PitStop : INTEGER;

      Config : Node_List;
      Current_Node : NODE;
      Config_Doc : DOCUMENT;
   begin
      Ada.Text_IO.Put_Line("Getting document");
      Config_Doc := Common.Get_Document(doc_file => CORBA.To_Standard_String(config_file));

      Config := Get_Elements_By_Tag_Name(Config_Doc,"config");
      Current_Node := Item(Config,0);

      Name := Unbounded_String.To_Unbounded_String(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"name"))));
      PitStop := POSITIVE'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"pitStop"))));
      MaxSpeed := FLOAT'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"maxSpeed"))));

      Settings.Set_Laps(10);
      Settings.Set_CompetitionMonitor_CorbaLOC(Unbounded_String.To_Unbounded_String("undefined"));

      return CORBA.To_CORBA_String("no ior yet");
   end Configure;


end Configurator.Impl;
