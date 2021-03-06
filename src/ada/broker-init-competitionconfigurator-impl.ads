with CORBA;
with PortableServer;

with Broker.Init.CompetitionConfigurator;

with Competition;
use Competition;

package Broker.Init.CompetitionConfigurator.impl is

   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;

   procedure Init( Comp_In : in SYNCH_COMPETITION_POINT );

   function Configure(Self : access Object;
                      config_file : CORBA.STRING) return CORBA.STRING;

end Broker.Init.CompetitionConfigurator.impl;
