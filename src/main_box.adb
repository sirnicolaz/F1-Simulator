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

      Update_Buffer : access Box.SYNCH_COMPETITION_UPDATES := new Box.SYNCH_COMPETITION_UPDATES;
      History : access Box.SYNCH_STRATEGY_HISTORY;
      Updater : access Box.STRATEGY_UPDATER;
      Mon : access Box.MONITOR;
      Laps : INTEGER;
      BoxRadio_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Monitor_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Configurator_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Corbaloc_Storage : SYNCH_CORBALOC_POINT := new SYNCH_CORBALOC;
      Start : access Starter := new Starter(Corbaloc_Storage);

   begin
      Corbaloc_Storage.Get_CorbaLOC(BoxRadio_CorbaLOC, C_BOX_RADIO);
      Corbaloc_Storage.Get_CorbaLOC(Monitor_CorbaLOC, C_MONITOR);
      Corbaloc_Storage.Get_CorbaLOC(Configurator_CorbaLOC, C_CONFIGURATOR);
      Ada.Text_IO.Put_Line("Box Radio Corba LOC : " & Unbounded_String.To_String(BoxRadio_CorbaLOC));
      Ada.Text_IO.Put_Line("Monitor Corba LOC : " & Unbounded_String.To_String(Monitor_CorbaLOC));
      Ada.Text_IO.Put_Line("Configurato Corba LOC : " & Unbounded_String.To_String(Configurator_CorbaLOC));
      declare
         begin
         -- Init BoxRadio corba
         -- Take the corba loc
         -- Wait (through an accept) for the competitor information and the competition server
         -- CORBA loc
         -- Initialize the corba object for communicating with the server
         -- Invoke the RegisterNewCompetitor with all the required information
         -- Use the information obtained to initialize all the buffers needed and
         -- to initialize the monitor connection with the server (using the corbaloc
         -- of the competition monitor)
         History := new Box.SYNCH_STRATEGY_HISTORY;
         History.Init(Laps);
         Updater := new Box.STRATEGY_UPDATER(Update_Buffer);
         --Mon := new Box.MONITOR(Update_Buffer);
      end;
   end;
end Main_Box;
