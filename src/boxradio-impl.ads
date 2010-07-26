with CORBA;
with PortableServer;

with Box;

with Ada.Strings.Unbounded;

package BoxRadio.impl is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;

   procedure Init( StrategyHistory_Buffer : access Box.SYNCH_STRATEGY_HISTORY );

   function RequestStrategy( Self : access Object;
                            lap : CORBA.Short ) return CORBA.String;

   protected type SYNCH_CORBALOC is
      entry Get_CorbaLOC( corbaLoc_out : out Unbounded_String.Unbounded_String);
      procedure Set_CorbaLOC( corbaLoc_in : in STRING);
   private
      Initialized : BOOLEAN := False;
      CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
   end SYNCH_CORBALOC;

   type SYNCH_CORBALOC_POINT is access SYNCH_CORBALOC;

   task type Starter ( Corbaloc_Storage : SYNCH_CORBALOC_POINT ) is
   end Starter;

end BoxRadio.impl;
