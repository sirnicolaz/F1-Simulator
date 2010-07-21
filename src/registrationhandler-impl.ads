with CORBA;
with PortableServer;

package RegistrationHandler.impl is

   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;

   procedure Join_Competition(Self : access Object;
                              CompetitorDescriptor_File : in CORBA.STRING;
                              BoxCorbaLOC : in CORBA.STRING;
                              MonitorCorbaLOC : out CORBA.STRING;
                              Competitor_ID : out CORBA.Short);

   function Wait_Ready(Self : access Object;
                       CompetitorID : CORBA.Short) return CORBA.String;

end RegistrationHandler.impl;
