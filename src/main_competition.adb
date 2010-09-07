with Ada.Text_IO;

with Common;

with RegistrationHandler.impl;
with CompetitionConfigurator.impl;
with Competition_Monitor_Radio.impl;

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

with Competition;
use Competition;

procedure Main_Competition is
begin
   Ada.Text_IO.Put_Line("Very beginning");

   --Declare the Competition remote object
   declare

      Argv : CORBA.ORB.Arg_List := CORBA.ORB.Command_Line_Arguments;
      The_Competition : SYNCH_COMPETITION_POINT := new SYNCH_COMPETITION;

      task type Starter(Comp_In : Competition.SYNCH_COMPETITION_POINT) is
      end Starter;

      task body Starter is
         Comp : Competition.SYNCH_COMPETITION_POINT := Comp_In;
      begin
           Competition.Ready(Comp,True);
      end Starter;

      Starter_Task : access Starter;
      CorbaLOC_File : Ada.Text_IO.FILE_TYPE;

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

         if(Common.SaveToFile(FileName => "registrationHandler_corbaLoc.txt",
                              Content  => CORBA.To_Standard_String
                                (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(RegistrationHandler_Ref))
                              ,
                              Path     => "")) then
            Ada.Text_IO.Put_Line("Registration handler corba loc saved");
         end if;

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

         Ada.Text_IO.Put_Line
           ("Competition Monitor Radio: '"
            & CORBA.To_Standard_String
            (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(Monitor_Ref))
            & "'");

         --Store the corbaloc in a file to be read by the java app
         Ada.Text_IO.Create(CorbaLOC_FIle, Ada.Text_IO.Out_File, "competition_corbaLoc.txt");
         Ada.Text_IO.Put_Line(CorbaLOC_File,CORBA.To_Standard_String
                              (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(CompConfiguration_Ref)));
         Ada.Text_IO.Put_Line(CorbaLOC_File,CORBA.To_Standard_String
                              (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(Monitor_Ref)));
         Ada.Text_IO.Close(CorbaLOC_File);

         The_Competition.Set_MonitorCorbaLOC
           (Unbounded_String.To_Unbounded_String
              (CORBA.To_Standard_String
                 (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(Monitor_Ref))));
         --  Launch the server

         Ada.Text_IO.Put_Line("Initing starter");
         Starter_Task := new Starter(The_Competition);

         CORBA.ORB.Run;

      end;
   end;

end Main_Competition;
