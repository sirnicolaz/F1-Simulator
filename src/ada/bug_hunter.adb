with Competition_Monitor_Radio.impl;
with Competition_Monitor_Radio;
with Competition_Monitor;
with CORBA.Impl;
with CORBA.Object;
with CORBA.ORB;

with PortableServer.POA.Helper;
with PortableServer.POAManager;

with PolyORB.CORBA_P.CORBALOC;

with PolyORB.Setup.No_Tasking_Server;
pragma Warnings (Off, PolyORB.Setup.No_Tasking_Server);

with Ada.Text_IO;

procedure Bug_Hunter is
   STP : Competition_Monitor.STARTSTOPHANDLER_POINT;
begin
   declare
      Argv : CORBA.ORB.Arg_List := CORBA.ORB.Command_Line_Arguments;
      Root_POA : PortableServer.POA.Local_Ref;

      Monitor_Ref : CORBA.Object.Ref;
      Monitor_Obj : constant CORBA.Impl.Object_Ptr := new Competition_Monitor_Radio.Impl.Object;
   begin
      CORBA.ORB.Init(CORBA.ORB.To_CORBA_STRING("ORB"), Argv);
      Root_POA := PortableServer.POA.Helper.To_Local_Ref
           (CORBA.ORB.Resolve_Initial_References
              (CORBA.ORB.To_CORBA_String("RootPOA")));

      Ada.Text_IO.Put_Line("Activating ROOT_POA...");
      PortableServer.POAManager.Activate
        (PortableServer.POA.Get_The_POAManager(Root_POA));

      Monitor_Ref := PortableServer.POA.Servant_To_Reference
        (Root_POA, PortableServer.Servant(Monitor_Obj));

      Ada.Text_IO.Put_Line
           ("MonitorHandler: '"
            & CORBA.To_Standard_String
            (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(Monitor_Ref))
            & "'");

      STP := Competition_Monitor.Init(CompetitorQty_In    => 3,
                                      GlobalStatistics_In => null);

      CORBA.ORB.Run;

   end;

end Bug_Hunter;
