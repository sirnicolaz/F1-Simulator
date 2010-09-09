with CORBA;
with PortableServer;

with Broker.Init.RegistrationHandler;

with Competition;
use Competition;

package Broker.Init.RegistrationHandler.impl is

   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;

   procedure Init(Competition_In : in Competition.SYNCH_COMPETITION_POINT);

   procedure Join_Competition(Self : access Object;
                              CompetitorDescriptor : in CORBA.STRING;
                              BoxCorbaLOC : in CORBA.STRING;
                              MonitorCorbaLOC : out CORBA.STRING;
                              Competitor_ID : out CORBA.Short;
                              CircuitLength : out CORBA.Float;
                              Laps : out CORBA.Short);

end Broker.Init.RegistrationHandler.impl;
