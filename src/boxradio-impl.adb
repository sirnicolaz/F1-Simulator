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

with Common;
use Common;

package body BoxRadio.impl is

   StrategyHistory : Box.SYNCH_STRATEGY_HISTORY_POINT;


   procedure Init( StrategyHistory_Buffer : Box.SYNCH_STRATEGY_HISTORY_POINT ) is
   begin
      StrategyHistory := StrategyHistory_Buffer;
   end Init;

   function RequestStrategy( Self : access Object;
                            lap : CORBA.Short) return CORBA.String is

      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);

      NewStrategy : Common.STRATEGY;

   begin
      StrategyHistory.Get_Strategy(NewStrategy,INTEGER(lap));

      return CORBA.To_CORBA_String(Box.BoxStrategyToXML(NewStrategy));
      --return CORBA.To_CORBA_STRING("Merda");
   end RequestStrategy;

end BoxRadio.impl;
