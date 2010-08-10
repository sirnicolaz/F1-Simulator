with Ada.Text_IO;

with Box;
with BoxRadio.impl;
with Monitor.impl;
with Configurator.Impl;
--with Configurator.Impl.Competitor;

with Ada.Strings.Unbounded;

with CORBA.ORB;
with PortableServer;
with PortableServer.POA;
with CORBA.Object;
with CORBA.Impl;
with PortableServer.POA.Helper;
with PortableServer.POAManager;
with PolyORB.CORBA_P.CORBALOC;
with Common;

procedure Main_Box is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;
   -- Declare:
   --+ -the box registration handler
   --+ -the local box package:
   --+      - the synch_strategy_history
   --+      - the tasks strategy_updater and monitor
   --+      - the updates buffer
   --+
   --+ -the monitor ought to remotely communicate with the competition
   --+ -the box radio
   --+
   --+ Task Initialiser
--   task Initialiser is
--      entry Submit_Configuration( Configuration : STRING );
--      entry
begin
   --Declare the BoxRadio remote object
   declare

      type CorbaLOC_Type is (C_MONITOR,C_CONFIGURATOR,C_BOX_RADIO);

      protected type SYNCH_CORBALOC is

         entry Get_CorbaLOC( corbaLoc_out : out Unbounded_String.Unbounded_String;
                            cloc_type : in CorbaLOC_Type);
         procedure Set_CorbaLOC( corbaLoc_in : in STRING;
                                cloc_type : in CorbaLOC_Type);
      private
         Initialized : BOOLEAN := False;
         Monitor_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
         Configurator_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
         BoxRadio_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      end SYNCH_CORBALOC;

      type SYNCH_CORBALOC_POINT is access SYNCH_CORBALOC;

      protected body SYNCH_CORBALOC is
         entry Get_CorbaLOC(corbaLoc_out : out Unbounded_String.Unbounded_String;
                            cloc_type : in CorbaLOC_Type) when Initialized is
         begin
            case cloc_type is
               when C_MONITOR =>
                  corbaLoc_out := Monitor_CorbaLOC;
               when C_BOX_RADIO =>
                  corbaLoc_out := BoxRadio_CorbaLOC;
               when C_CONFIGURATOR =>
                  corbaLoc_out := Configurator_CorbaLOC;
            end case;

         end Get_CorbaLOC;

         procedure Set_CorbaLOC(corbaLoc_in : in STRING;
                                cloc_type : in CorbaLOC_Type) is
         begin

            case cloc_type is
               when C_MONITOR =>
                  Monitor_CorbaLOC := Unbounded_String.To_Unbounded_String(corbaLoc_in);
               when C_BOX_RADIO =>
                  BoxRadio_CorbaLOC := Unbounded_String.To_Unbounded_String(corbaLoc_in);
               when C_CONFIGURATOR =>
                  Configurator_CorbaLOC := Unbounded_String.To_Unbounded_String(corbaLoc_in);
            end case;

            if( Configurator_CorbaLOC /= Unbounded_String.Null_Unbounded_String and
                 Monitor_CorbaLOC /= Unbounded_String.Null_Unbounded_String and
                   BoxRadio_CorbaLOC /= Unbounded_String.Null_Unbounded_String ) then
               Initialized := true;
            end if;

         end Set_CorbaLOC;

      end SYNCH_CORBALOC;

      task type Starter ( Corbaloc_Storage : SYNCH_CORBALOC_POINT ) is
      end Starter;

      task body Starter is
      begin
         declare
            Argv : CORBA.ORB.Arg_List := CORBA.ORB.Command_Line_Arguments;
         begin
            CORBA.ORB.Init(CORBA.ORB.To_CORBA_STRING("ORB"), Argv);
            declare
               Root_POA : PortableServer.POA.Local_Ref;
               BoxRadio_Ref : CORBA.Object.Ref;
               BoxRadio_Obj : constant CORBA.Impl.Object_Ptr := new BoxRadio.Impl.Object;
               Monitor_Ref : CORBA.Object.Ref;
               Monitor_Obj : constant CORBA.Impl.Object_Ptr := new Monitor.Impl.Object;
               Configurator_Ref : CORBA.Object.Ref;
               Configurator_Obj : constant CORBA.Impl.Object_Ptr := new Configurator.Impl.Object;
            begin
               -- Retrieve the Root POA
               Root_POA := PortableServer.POA.Helper.To_Local_Ref
                 (CORBA.ORB.Resolve_Initial_References
                    (CORBA.ORB.To_CORBA_String("RootPOA")));


               PortableServer.POAManager.Activate
                 (PortableServer.POA.Get_The_POAManager(Root_POA));

               -- Set up the BoxRadio, Monitor and Competitor Configurator Objects
               BoxRadio_Ref := PortableServer.POA.Servant_To_Reference
                 (Root_POA, PortableServer.Servant(BoxRadio_Obj));
               Monitor_Ref := PortableServer.POA.Servant_To_Reference
                 (Root_POA, PortableServer.Servant(Monitor_Obj));
               Configurator_Ref := PortableServer.POA.Servant_To_Reference
                 (Root_POA, PortableServer.Servant(Configurator_Obj));

               Corbaloc_Storage.Set_CorbaLOC
                 (CORBA.To_Standard_String
                    (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(BoxRadio_Ref)),C_BOX_RADIO);
               Corbaloc_Storage.Set_CorbaLOC
                 (CORBA.To_Standard_String
                    (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(Monitor_Ref)), C_MONITOR);
               Corbaloc_Storage.Set_CorbaLOC
                 (CORBA.To_Standard_String
                    (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(Configurator_Ref)), C_CONFIGURATOR);

               CORBA.ORB.Run;
            end;
         end;
      end Starter;

      BoxRadio_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Monitor_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Configurator_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Corbaloc_Storage : SYNCH_CORBALOC_POINT := new SYNCH_CORBALOC;
      Start : access Starter := new Starter(Corbaloc_Storage);

      Update_Buffer : Box.SYNCH_COMPETITION_UPDATES_POINT;
      History : Box.SYNCH_STRATEGY_HISTORY_POINT;
      -- Resources for writing corbalocs into file
      CorbaLOC_File : Ada.Text_IO.FILE_TYPE;

      --Settings resource (shared with the configurator)
      Settings : access Configurator.Impl.SYNCH_COMPETITION_SETTINGS;
      --Settings
      CompetitionMonitor_CorbaLOC : access Unbounded_String.Unbounded_String := new Unbounded_String.Unbounded_String;
      Laps : INTEGER := -1;
      CircuitLength : FLOAT := -1.0;
      CompetitorID : INTEGER := -1;
      BoxStrategy : Box.BOX_STRATEGY := Box.NULL_STRATEGY;
      InitialGasLevel : Common.FLOAT_POINT := new FLOAT;
      InitialTyreType : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      InitialTyreType_StdStr : Common.STRING_POINT;
      GasTankCapacity : FLOAT := -1.0;

   begin
      Corbaloc_Storage.Get_CorbaLOC(BoxRadio_CorbaLOC, C_BOX_RADIO);
      Corbaloc_Storage.Get_CorbaLOC(Monitor_CorbaLOC, C_MONITOR);
      Corbaloc_Storage.Get_CorbaLOC(Configurator_CorbaLOC, C_CONFIGURATOR);

      -- Saving the CorbaLOCS into file
      -- First we create the file
      Ada.Text_IO.Create(CorbaLOC_File, Ada.Text_IO.Out_File, "corbaLoc.txt");
      -- Then we write to it
      Ada.Text_IO.Put_Line(CorbaLOC_File, Unbounded_String.To_String(Configurator_CorbaLOC));
      Ada.Text_IO.Put_Line(CorbaLOC_File, Unbounded_String.To_String(BoxRadio_CorbaLOC));
      Ada.Text_IO.Put_Line(CorbaLOC_File, Unbounded_String.To_String(Monitor_CorbaLOC));

      Ada.Text_IO.Close(CorbaLOC_File);

      Settings := Configurator.Impl.Get_SettingsResource;
      Ada.Text_IO.Put_Line("Getting parameters");
      Settings.Get_CompetitionMonitor_CorbaLOC(CompetitionMonitor_CorbaLOC.all);
      Ada.Text_IO.Put_Line("Corbaloc got: " & Unbounded_String.To_String(CompetitionMonitor_CorbaLOC.all));
      Settings.Get_Laps(Laps);
      Ada.Text_IO.Put_Line("Laps got: " & INTEGER'IMAGE(Laps));
      Settings.Get_CompetitorID(CompetitorID);
      Ada.Text_IO.Put_Line("Competitor ID got: " & INTEGER'IMAGE(CompetitorID));
      Settings.Get_CircuitLength(CircuitLength);
      Ada.Text_IO.Put_Line("Circuit length got: " & FLOAT'IMAGE(CircuitLength));
      Settings.Get_BoxStrategy(BoxStrategy);
      Ada.Text_IO.Put_Line("Box Strategy got");
      Settings.Get_GasTankCapacity(GasTankCapacity);
      Settings.Get_InitialGasLevel(InitialGasLevel.all);
      Settings.Get_InitialTyreType(InitialTyreType);
      InitialTyreType_StdStr := new STRING(1..Unbounded_String.Length(InitialTyreType));
      InitialTyreType_StdStr.all := Unbounded_String.To_String(InitialTyreType);

      Box.Init(Laps,CircuitLength,CompetitorID,BoxStrategy,GasTankCapacity);
      Ada.Text_IO.Put_Line("Box package initialized");

      -- Resourced shared between tasks
      Update_Buffer := new Box.SYNCH_COMPETITION_UPDATES;
      History := new Box.SYNCH_STRATEGY_HISTORY;
      Ada.Text_IO.Put_Line("init History");
      History.Init(Laps);
      -- TODO: initialize the Box with Init

      -- Initialize all the resources and tasks needed box side.
      --It's very important the init order in this case. The BoxRadio has to be
      --+ initialised with the shared Strategy history protected resource before
      --+ the competition starts. The competition will start after the BoxMonitor
      --+ will be started (the box monitor sends a ready signal to the competition).
      --+ This is necessary because when the competition starts, the competitor associated
      --+ to the Box radio will start to request new strategies. When the method
      --+ Request_NewStrategy is invoked, the Box Radio tries to access the resource
      --+ StrategyHistory. If such resource is not already initialized before the beginning
      --+ of the competition, there would be a access violation.
      Ada.Text_IO.Put_Line("Init BoxRadio");
      BoxRadio.impl.Init(History);
      Ada.Text_IO.Put_Line("Start Updater");

      declare

         Updater : access Box.STRATEGY_UPDATER := new Box.STRATEGY_UPDATER(Update_Buffer,
                                                                           History,
                                                                           InitialGasLevel,
                                                                           InitialTyreType_StdStr
                                                                          );
         BoxMonitor : access Box.MONITOR := new Box.MONITOR(Update_Buffer,
                                                            CompetitionMonitor_CorbaLOC);

      begin
         --Delay(Standard.Duration(40000));
         null;
      end;
   end;
end Main_Box;
