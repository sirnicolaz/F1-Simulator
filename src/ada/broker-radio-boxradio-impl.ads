with CORBA;
with PortableServer;

with Broker.Radio.BoxRadio;

with Box;
with Box_Data;

with Ada.Strings.Unbounded;

package Broker.Radio.BoxRadio.impl is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;

   procedure Init( StrategyHistory_Buffer : Box_Data.SYNCH_STRATEGY_HISTORY_POINT );

   function RequestStrategy( Self : access Object;
                            lap : CORBA.Short ) return CORBA.String;

end Broker.Radio.BoxRadio.impl;
