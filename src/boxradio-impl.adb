with BoxRadio.Skel;
pragma Warnings (Off, BoxRadio.Skel);

package body BoxRadio.impl is

   StrategyHistory : access Box.SYNCH_STRATEGY_HISTORY;

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
