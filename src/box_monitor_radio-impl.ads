with CORBA;
with PortableServer;

with Box;

package Box_Monitor_Radio.impl is

   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;

   procedure Init( CompetitionUpdates_Buffer : access Box.SYNCH_COMPETITION_UPDATES );

   function GetUpdate(Self : access Object;
                      num : in CORBA.Short) return CORBA.String;

end Box_Monitor_Radio.impl;
