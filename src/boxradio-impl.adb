with BoxRadio.Skel;
pragma Warnings (Off, BoxRadio.Skel);

with CORBA.Impl;
with CORBA.Object;
with CORBA.ORB;

with PortableServer.POA.Helper;
with PortableServer.POAManager;

with PolyORB.CORBA_P.CORBALOC;

with PolyORB.Setup.No_Tasking_Server;
pragma Warnings (Off, PolyORB.Setup.No_Tasking_Server);

with Ada.Text_IO;

package body BoxRadio.impl is


   StrategyHistory : access Box.SYNCH_STRATEGY_HISTORY;

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
         begin
            -- Retrieve the Root POA
            Root_POA := PortableServer.POA.Helper.To_Local_Ref
              (CORBA.ORB.Resolve_Initial_References
                 (CORBA.ORB.To_CORBA_String("RootPOA")));


            PortableServer.POAManager.Activate
              (PortableServer.POA.Get_The_POAManager(Root_POA));

            -- Set up the BoxRadio Object
            BoxRadio_Ref := PortableServer.POA.Servant_To_Reference
              (Root_POA, PortableServer.Servant(BoxRadio_Obj));

            Corbaloc_Storage.Set_CorbaLOC
              (CORBA.To_Standard_String
                 (PolyORB.CORBA_P.CORBALOC.Object_To_Corbaloc(BoxRadio_Ref)));

            CORBA.ORB.Run;
         end;
      end;
   end Starter;

   protected body SYNCH_CORBALOC is
      entry Get_CorbaLOC( corbaLoc_out : out Unbounded_String.Unbounded_String) when Initialized is
      begin
         corbaLoc_out := CorbaLOC;
      end Get_CorbaLOC;

      procedure Set_CorbaLOC(corbaLoc_in : in STRING) is
      begin
         CorbaLOC := Unbounded_String.To_Unbounded_String(corbaLoc_in);
         Initialized := true;
      end Set_CorbaLOC;

   end SYNCH_CORBALOC;

   procedure Init( StrategyHistory_Buffer : access Box.SYNCH_STRATEGY_HISTORY ) is
   begin
      StrategyHistory := StrategyHistory_Buffer;
   end Init;

   function RequestStrategy( Self : access Object;
                            lap : CORBA.Short) return CORBA.String is

      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);

      NewStrategy : Box.BOX_STRATEGY;

   begin
      StrategyHistory.Get_Strategy(NewStrategy,INTEGER(lap));
      return CORBA.To_CORBA_String(Box.BoxStrategyToXML(NewStrategy));
   end RequestStrategy;

end BoxRadio.impl;
