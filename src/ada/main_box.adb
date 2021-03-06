with Ada.Text_IO;
with Ada.Command_Line;

with Box;
with Box_Data;
with Box_Monitor;
with Artificial_Intelligence;

with Broker.Radio.BoxRadio.impl;
use Broker.Radio.BoxRadio.impl;

with Broker.Radio.Box_Monitor_Radio.impl;
use Broker.Radio.Box_Monitor_Radio.impl;

with Broker.Init.BoxConfigurator.Impl;
use Broker.Init.BoxConfigurator.Impl;

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

with PolyORB.Setup.Thread_Pool_Server;
pragma Warnings (Off, PolyORB.Setup.Thread_Pool_Server);

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
            CORBA.ORB.Initialize("ORB");
--            CORBA.ORB.Init(CORBA.ORB.To_CORBA_STRING("ORB"), Argv);
            declare
               Root_POA : PortableServer.POA.Local_Ref;
               BoxRadio_Ref : CORBA.Object.Ref;
               BoxRadio_Obj : constant CORBA.Impl.Object_Ptr := new Broker.Radio.BoxRadio.Impl.Object;
               Monitor_Ref : CORBA.Object.Ref;
               Monitor_Obj : constant CORBA.Impl.Object_Ptr := new Broker.Radio.Box_Monitor_Radio.Impl.Object;
               Configurator_Ref : CORBA.Object.Ref;
               Configurator_Obj : constant CORBA.Impl.Object_Ptr := new Broker.Init.BoxConfigurator.Impl.Object;
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

      Update_Buffer : Box_Data.SYNCH_COMPETITION_UPDATES_POINT;
      History : Box_Data.SYNCH_STRATEGY_HISTORY_POINT;
      AllInfo_Buffer : Box_Data.SYNCH_ALL_INFO_BUFFER_POINT;
      -- Resources for writing corbalocs into file
      CorbaLOC_File : Ada.Text_IO.FILE_TYPE;

      --Settings resource (shared with the configurator)
      Settings : access Broker.Init.BoxConfigurator.Impl.SYNCH_COMPETITION_SETTINGS;
      --Settings
      CompetitionMonitor_CorbaLOC : Common.UNBOUNDED_STRING_POINT := new Unbounded_String.Unbounded_String;
      Laps : INTEGER := -1;
      CircuitLength : FLOAT := -1.0;
      CompetitorID : INTEGER := -1;
      BoxStrategy : Artificial_Intelligence.BOX_STRATEGY := Artificial_Intelligence.NULL_STRATEGY;
      InitialGasLevel : Common.FLOAT_POINT := new FLOAT;
      InitialTyreType : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      InitialTyreType_StdStr : Common.STRING_POINT;
      GasTankCapacity : FLOAT := -1.0;

   begin

      Update_Buffer := new Box_Data.SYNCH_COMPETITION_UPDATES;
      AllInfo_Buffer := new Box_Data.SYNCH_ALL_INFO_BUFFER;

      Box_Monitor.Init(CompetitionUpdates_Buffer => AllInfo_Buffer);


      Corbaloc_Storage.Get_CorbaLOC(BoxRadio_CorbaLOC, C_BOX_RADIO);
      Corbaloc_Storage.Get_CorbaLOC(Monitor_CorbaLOC, C_MONITOR);
      Corbaloc_Storage.Get_CorbaLOC(Configurator_CorbaLOC, C_CONFIGURATOR);

      -- Saving the CorbaLOCS into file
      -- First we create the file
      Ada.Text_IO.Create(CorbaLOC_File, Ada.Text_IO.Out_File, "../temp/boxCorbaLoc-" & Ada.Command_Line.Argument (1) & ".txt");
      -- Then we write to it
      Ada.Text_IO.Put_Line(CorbaLOC_File, Unbounded_String.To_String(Configurator_CorbaLOC));
      Ada.Text_IO.Put_Line(CorbaLOC_File, Unbounded_String.To_String(BoxRadio_CorbaLOC));
      Ada.Text_IO.Put_Line(CorbaLOC_File, Unbounded_String.To_String(Monitor_CorbaLOC));

      Ada.Text_IO.Close(CorbaLOC_File);

      Settings := Broker.Init.BoxConfigurator.Impl.Get_SettingsResource;

      Settings.Get_CompetitionMonitor_CorbaLOC(CompetitionMonitor_CorbaLOC.all);

      Settings.Get_Laps(Laps);

      Settings.Get_CompetitorID(CompetitorID);

      Settings.Get_CircuitLength(CircuitLength);

      Settings.Get_BoxStrategy(BoxStrategy);

      Settings.Get_GasTankCapacity(GasTankCapacity);
      Settings.Get_InitialGasLevel(InitialGasLevel.all);
      Settings.Get_InitialTyreType(InitialTyreType);
      InitialTyreType_StdStr := new STRING(1..Unbounded_String.Length(InitialTyreType));
      InitialTyreType_StdStr.all := Unbounded_String.To_String(InitialTyreType);

      Box.Init(Laps,CircuitLength,CompetitorID,BoxStrategy,GasTankCapacity);
      Ada.Text_IO.Put_Line("Box package initialized");

      -- Resourced shared between tasks
      History := new Box_Data.SYNCH_STRATEGY_HISTORY;

      History.Init(Laps);

      AllInfo_Buffer.Init(Laps*3);
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

      Broker.Radio.BoxRadio.impl.Init(History);


      declare

         Updater : access Box.STRATEGY_UPDATER := new Box.STRATEGY_UPDATER(Update_Buffer,
                                                                           History,
                                                                           InitialGasLevel,
                                                                           InitialTyreType_StdStr,
                                                                           AllInfo_Buffer
                                                                          );

         BoxMonitor : access Box.UPDATE_RETRIEVER := new Box.UPDATE_RETRIEVER(Update_Buffer,
                                                                              CompetitionMonitor_CorbaLOC);

      begin
         --Delay(Standard.Duration(40000));
         null;
      end;
   end;
end Main_Box;
