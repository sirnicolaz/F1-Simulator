with Competition;
use Competition;

with CompetitionConfiguration.impl;
with RegistrationHandler.impl;

with CORBA.Impl;
with CORBA.Object;
with CORBA.ORB;

with PortableServer.POA.Helper;
with PortableServer.POAManager;

with PolyORB.CORBA_P.CORBALOC;

with PolyORB.Setup.No_Tasking_Server;
pragma Warnings (Off, PolyORB.Setup.No_Tasking_Server);

with Ada.Text_IO;

procedure Init is
begin
   -- Declare the Competition remote object
   declare
      Argv : CORBA.ORB.Arg_List := CORBA.ORB.Command_Line_Arguments;
      The_Competition : Competition.SYNCH_COMPETITION_POINT := new Competition.SYNCH_COMPETITION;
   begin
      CORBA.ORB.Init(CORBA.ORB.To_CORBA_STRING("ORB"), Argv);
      Ada.Text_IO.Put_Line("Configuring competition object...");
      CompetitionConfiguration.Impl.Init(The_Competition);
      Ada.Text_IO.Put_Line("Configuring registration handler object...");
      RegistrationHandler.impl.Init(The_Competition);
      Ada.Text_IO.Put_Line("Init ROOT_POA..");
      declare
         Root_POA : PortableServer.POA.Local_Ref;
         CompConfiguration_Ref : CORBA.Object.Ref;
         RegistrationHandler_Ref : CORBA.Object.Ref;
         --Monitor_Ref : CORBA.Object.Ref;

         CompConfiguration_Obj : constant CORBA.Impl.Object_Ptr := new CompetitionConfiguration.Impl.Object;
         RegistrationHandler_Obj : constant CORBA.Impl.Object_Ptr := new RegistrationHandler.Impl.Object;
         --Monitor_Obj : constant CORBA.Impl.Object_Ptr := new Monitor.impl.Object;

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
         CompConfiguration_Ref := PortableServer.POA.Servant_To_Reference
           (Root_POA, PortableServer.Servant(CompConfiguration_Obj));

         -- Set up the Registration handler Object
         RegistrationHandler_Ref := PortableServer.POA.Servant_To_Reference
           (Root_POA, PortableServer.Servant(RegistrationHandler_Obj));

         -- CompetitionConfiguration corbaloc
         Ada.Text_IO.Put_Line
           ("CompetitionConfiguration: '"
            & CORBA.To_Standard_String
            (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(CompConfiguration_Ref))
            & "'");

         -- RegistrationHandler corbaloc
         Ada.Text_IO.Put_Line
           ("RegistrationHandler: '"
            & CORBA.To_Standard_String
            (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(RegistrationHandler_Ref))
            & "'");
         --  Launch the server

         CORBA.ORB.Run;

      end;
   end;

end Init;
