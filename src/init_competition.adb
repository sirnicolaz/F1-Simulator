with Ada.Text_IO;

with CORBA.Impl;
with CORBA.Object;
with CORBA.ORB;

with PortableServer.POA.Helper;
with PortableServer.POAManager;

with PolyORB.CORBA_P.CORBALOC;

with PolyORB.Setup.No_Tasking_Server;
pragma Warnings (Off, PolyORB.Setup.No_Tasking_Server);

with Competition;
use Competition;

with RegistrationHandler.impl;
with CompetitionConfigurator.impl;
with Competition_Monitor_Radio.impl;

procedure Init_Competition is
begin
   Ada.Text_IO.Put_Line("Very beginning");

   --Declare the Competition remote object
   declare

      Argv : CORBA.ORB.Arg_List := CORBA.ORB.Command_Line_Arguments;
      The_Competition : Competition.SYNCH_COMPETITION_POINT := new Competition.SYNCH_COMPETITION;

      task type Starter(Comp_In : Competition.SYNCH_COMPETITION_POINT) is
      end Starter;

      task body Starter is
         Comp : Competition.SYNCH_COMPETITION_POINT := Comp_In;
      begin
            Competition.Ready(Comp,True);
      end Starter;

      Starter_Task : access Starter;

   begin
      CORBA.ORB.Init(CORBA.ORB.To_CORBA_STRING("ORB"), Argv);
      Ada.Text_IO.Put_Line("Configuring competition object...");
      CompetitionConfigurator.Impl.Init(The_Competition);
      Ada.Text_IO.Put_Line("Configuring registration handler object...");
      RegistrationHandler.impl.Init(The_Competition);
      Ada.Text_IO.Put_Line("Init ROOT_POA..");
      declare
         Root_POA : PortableServer.POA.Local_Ref;
         CompConfiguration_Ref : CORBA.Object.Ref;
         RegistrationHandler_Ref : CORBA.Object.Ref;
         Monitor_Ref : CORBA.Object.Ref;

         CompConfiguration_Obj : constant CORBA.Impl.Object_Ptr := new CompetitionConfigurator.Impl.Object;
         RegistrationHandler_Obj : constant CORBA.Impl.Object_Ptr := new RegistrationHandler.Impl.Object;
         Monitor_Obj : constant CORBA.Impl.Object_Ptr := new Competition_Monitor_Radio.impl.Object;

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

         -- Set up the CompetitionMonitor handler Object
         Monitor_Ref := PortableServer.POA.Servant_To_Reference
           (Root_POA, PortableServer.Servant(Monitor_Obj));
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

         The_Competition.Set_MonitorCorbaLOC
           (Unbounded_String.To_Unbounded_String
              (CORBA.To_Standard_String
                 (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(RegistrationHandler_Ref))));

         Ada.Text_IO.Put_Line("Initing starter");
         Starter_Task := new Starter(The_Competition);

         CORBA.ORB.Run;

      end;
   end;

end Init_Competition;
