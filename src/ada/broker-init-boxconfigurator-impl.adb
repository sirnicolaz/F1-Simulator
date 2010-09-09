with Ada.Text_IO;

with Broker.Init.BoxConfigurator.Skel;
pragma Warnings (Off, Broker.Init.BoxConfigurator.Skel);

use Broker.Init.BoxConfigurator;

with CORBA;
with Ada.Strings.Unbounded;
with Sax.Readers; use Sax.Readers;
with DOM.Readers; use DOM.Readers;
with DOM.Core; use DOM.Core;
with DOM.Core.Documents; use DOM.Core.Documents;
with DOM.Core.Nodes; use DOM.Core.Nodes;

with Common;

package body Broker.Init.BoxConfigurator.Impl is

   protected body SYNCH_COMPETITION_SETTINGS is
      entry Get_Laps ( Laps_Out : out INTEGER) when Initialized is
      begin
         Laps_Out := Laps;
      end Get_Laps;

      entry Get_CompetitionMonitor_CorbaLOC ( CMon_CorbaLOC_Out : out Unbounded_String.Unbounded_String ) when Initialized is
      begin
         CMon_CorbaLOC_Out := CompetitionMonitor_CorbaLOC;
      end Get_CompetitionMonitor_CorbaLOC;

      entry Get_CircuitLength ( CircuitLength_Out : out Standard.FLOAT ) when Initialized is
      begin
         CircuitLength_Out := CircuitLength;
      end Get_CircuitLength;

      entry Get_CompetitorID ( CompetitorID_out : out INTEGER ) when Initialized is
      begin
         CompetitorID_out := CompetitorID;
      end Get_CompetitorID;

      entry Get_BoxStrategy ( BoxStrategy_out : out Box.BOX_STRATEGY ) when Initialized is
      begin
         BoxStrategy_out := BoxStrategy;
      end Get_BoxStrategy;

      entry Get_GasTankCapacity ( GasTankCapacity_Out : out Standard.FLOAT)  when Initialized is
      begin
         GasTankCapacity_out := GasTankCapacity;
      end Get_GasTankCapacity;

      entry Get_InitialGasLevel ( InitialGasLevel_Out : out Standard.FLOAT)  when Initialized is
      begin
         InitialGasLevel_out := InitialGasLevel;
      end Get_InitialGasLevel;

      entry Get_InitialTyreType ( InitialTyreType_Out : out Unbounded_String.Unbounded_String)  when Initialized is
      begin
         InitialTyreType_out := InitialTyreType;
      end Get_InitialTyreType;

      procedure Set_Laps ( Laps_In : in INTEGER) is
      begin
         Laps := Laps_In;
         ConfiguredParameters := ConfiguredParameters + 1;
         if ( ConfiguredParameters = 8) then
            Initialized := true;
         end if;
      end Set_Laps;

      procedure Set_CompetitorID ( CompetitorID_In : in INTEGER) is
      begin
         CompetitorID := CompetitorID_In;
         ConfiguredParameters := ConfiguredParameters + 1;
         if ( ConfiguredParameters = 8)  then
            Initialized := true;
         end if;
      end Set_CompetitorID;

      procedure Set_CircuitLength ( CircuitLength_In : in Standard.FLOAT) is
      begin
         CircuitLength := CircuitLength_In;
         ConfiguredParameters := ConfiguredParameters + 1;
         if ( ConfiguredParameters = 8) then
            Initialized := true;
         end if;
      end Set_CircuitLength;

      procedure Set_CompetitionMonitor_CorbaLOC ( CMon_CorbaLoc_In : in Unbounded_String.Unbounded_String) is
      begin
         CompetitionMonitor_CorbaLOC := CMon_CorbaLoc_In;
         ConfiguredParameters := ConfiguredParameters + 1;
         if ( ConfiguredParameters = 8) then
            Initialized := true;
         end if;
      end Set_CompetitionMonitor_CorbaLOC;

      procedure Set_BoxStrategy( BoxStrategy_In : in Box.BOX_STRATEGY ) is
      begin
         BoxStrategy := BoxStrategy_In;
         ConfiguredParameters := ConfiguredParameters + 1;
         if ( ConfiguredParameters = 8)  then
            Initialized := true;
         end if;
      end Set_BoxStrategy;

      procedure Set_GasTankCapacity ( GasTankCapacity_in : in Standard.FLOAT) is
      begin
         GasTankCapacity := GasTankCapacity_In;
         ConfiguredParameters := ConfiguredParameters + 1;
         if ( ConfiguredParameters = 8)  then
            Initialized := true;
         end if;
      end Set_GasTankCapacity;

      procedure Set_InitialGasLevel ( InitialGasLevel_in : in Standard.FLOAT) is
      begin
         InitialGasLevel := InitialGasLevel_In;
         ConfiguredParameters := ConfiguredParameters + 1;
         if ( ConfiguredParameters = 8)  then
            Initialized := true;
         end if;
      end Set_InitialGasLevel;

      procedure Set_InitialTyreType ( InitialTyreType_in : in Unbounded_String.Unbounded_String) is
      begin
         InitialTyreType := InitialTyreType_In;
         ConfiguredParameters := ConfiguredParameters + 1;
         if ( ConfiguredParameters = 8)  then
            Initialized := true;
         end if;
      end Set_InitialTyreType;

   end SYNCH_COMPETITION_SETTINGS;

   function Get_SettingsResource return access SYNCH_COMPETITION_SETTINGS is
   begin
      return Settings;
   end Get_SettingsResource;

   function Configure(Self : access Object;
                      config_file : CORBA.STRING) return CORBA.STRING is
      CompetitionMonitor_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      BoxStrategy_Str : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      BoxStrategy : Box.BOX_STRATEGY;
      InitialTyreType : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      CircuitLength : Standard.FLOAT;
      InitialGasLevel : Standard.FLOAT;
      GasTankCapacity : Standard.FLOAT;
      CompetitorID : INTEGER;
      Laps : POSITIVE;

      Config : Node_List;
      Current_Node : NODE;
      Config_Doc : DOCUMENT;
   begin
      Ada.Text_IO.Put_Line("Getting document: " & CORBA.To_Standard_String(config_file));
      Config_Doc := Common.Get_Document(doc_file => CORBA.To_Standard_String(config_file));
      Ada.Text_IO.Put_Line("Document got");
      Config := Get_Elements_By_Tag_Name(Config_Doc,"config");
      Current_Node := Item(Config,0);

      Ada.Text_IO.Put_Line("Initing variables");
      CompetitionMonitor_CorbaLOC := Unbounded_String.To_Unbounded_String(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"monitorCorbaLoc"))));
      InitialTyreType := Unbounded_String.To_Unbounded_String(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"initialTyreType"))));
      Laps := POSITIVE'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"laps"))));
      CircuitLength := Standard.FLOAT'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"circuitLength"))));
      GasTankCapacity := Standard.FLOAT'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"gasTankCapacity"))));
      InitialGasLevel := Standard.FLOAT'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"initialGasLevel"))));
      CompetitorID := INTEGER'Value(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"competitorID"))));
      BoxStrategy_Str := Unbounded_String.To_Unbounded_String(Node_Value(First_Child(Common.Get_Feature_Node(Current_Node,"boxStrategy"))));

      if(BoxStrategy_Str = "CAUTIOUS" ) then
         BoxStrategy := Box.CAUTIOUS;
      elsif ( BoxStrategy_Str = "RISKY" ) then
         BoxStrategy := Box.RISKY;
      elsif (BoxStrategy_Str = "FOOL") then
         BoxStrategy := Box.FOOL;
      else
         BoxStrategy := Box.NORMAL;
      end if;

      Ada.Text_IO.Put_Line("Setting stuff for competitor " & Common.IntegerToString(CompetitorID));

      Settings.Set_Laps(Laps);
      Settings.Set_CompetitionMonitor_CorbaLOC(CompetitionMonitor_CorbaLOC);
      Settings.Set_CompetitorID(CompetitorID);
      Settings.Set_CircuitLength(CircuitLength);
      Settings.Set_BoxStrategy(BoxStrategy);
      Settings.Set_GasTankCapacity(GasTankCapacity);
      Settings.Set_InitialGasLevel(InitialGasLevel);
      Settings.Set_InitialTyreType(InitialTyreType);

      return CORBA.To_CORBA_String(Unbounded_String.To_String(CompetitionMonitor_CorbaLOC));

   end Configure;


end Broker.Init.BoxConfigurator.Impl;
