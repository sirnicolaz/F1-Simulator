with CORBA;
with PortableServer;

with Competition;
use Competition;


package RegistrationHandler.Impl is

   type Object is new PortableServer.Servant_Base with null record;
   type Object_Acc is access Object;

   -- Il monitor di sistema è temporaneamente solo un riferimento all'oggetto
   MonitorSystem :

   procedure Remote_Join (
                   Self : access Object;
                   CompetitorDescriptor_In  : CORBA.String;
                   Address_In : CORBA.String;
                   RadioAddress_out : out CORBA.String;
                   CompId_out : CORBA.Short;
                   MonitorSystemAddress : out CORBA.String);

   function Remote_Ready (
                   Self : access Object;
                   CompetitorId_In: CORBA.Short ) return CORBA.Boolean;


   procedure Join(
                  CompetitorDescriptor_In  : STRING;
                  Address_In : STRING;
                  RadioAddress_out : out STRING;
                  CompId_out : INTEGER;
                  MonitorSystemAddress : out STRING);

   function Ready (
                   CompetitorId_In: INTEGER ) return BOOLEAN;

end RegistrationHandler.Impl;
