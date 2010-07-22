with Ada.Text_IO;

with CORBA.Impl;
with CORBA.Object;
with CORBA.ORB;

with PortableServer.POA.Helper;
with PortableServer.POAManager;

with BoxRadio.impl;
with PolyORB.CORBA_P.CORBALOC;

with PolyORB.Setup.No_Tasking_Server;
pragma Warnings (Off, PolyORB.Setup.No_Tasking_Server);

procedure Main_Box is

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
      Argv : CORBA.ORB.Arg_List := CORBA.ORB.Command_Line_Arguments;
   begin
      CORBA.ORB.Init(CORBA.ORB.To_CORBA_STRING("ORB"), Argv);
      declare
         Root_POA : PortableServer.POA.Local_Ref;
         BoxRadio_Ref : CORBA.Object.Ref;
         BoxRadio_Obj : constant CORBA.Impl.Object_Ptr := new BoxRadio.Impl.Object;
      begin
         -- Retrieve the Root POA
         Ada.Text_IO.Put_Line("Retrieving ROOT_POA...");
         Root_POA := PortableServer.POA.Helper.To_Local_Ref
           (CORBA.ORB.Resolve_Initial_References
              (CORBA.ORB.To_CORBA_String("RootPOA")));

         Ada.Text_IO.Put_Line("Activating ROOT_POA...");
         PortableServer.POAManager.Activate
           (PortableServer.POA.Get_The_POAManager(Root_POA));

         -- Set up the CompetitionConfigurationObject
         BoxRadio'_Ref := PortableServer.POA.Servant_To_Reference
           (Root_POA, PortableServer.Servant(BoxRadio_Obj));

      end;
   end;
end Main_Box;
