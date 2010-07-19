with CORBA;
with PortableServer;

with Box;

package BoxRadio.impl is

   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;

   procedure Init( StrategyHistory_Buffer : access Box.SYNCH_STRATEGY_HISTORY );

   function RequestStrategy( Self : access Object;
                            lap : CORBA.Short ) return CORBA.String;

end BoxRadio.impl;
