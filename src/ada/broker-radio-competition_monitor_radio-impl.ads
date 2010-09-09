with CORBA;
with PortableServer;

with Broker.Radio.Competition_Monitor_Radio;

package Broker.Radio.Competition_Monitor_Radio.impl is

   type Object is new PortableServer.Servant_Base with null record;
   type Object_Acc is access Object;

   function Ready( Self : access Object;
                  CompetitorID : CORBA.SHORT) return BOOLEAN;

    -- metodo che ritorna le informazioni in base a giro, settore e id concorrente (metodo invocato da remoto)
   procedure Get_CompetitorInfo
     (Self : access Object;
      lap : CORBA.Short;
      sector : CORBA.Short ;
      id : CORBA.Short;
      time : out CORBA.FLOAT;
      Returns : out CORBA.STRING);

   procedure Get_CompetitionInfo
     (Self : access Object;
      timeInstant : CORBA.FLOAT;
      xmlInfo : out CORBA.String;
      Returns : out Competition_Monitor_Radio.float_sequence );

   procedure Get_CompetitionConfiguration
     (Self : access Object;
      circuitLength : out CORBA.FLOAT;
      xmlConf : out CORBA.String);

   function Get_CompetitorConfiguration(Self : access Object;
                                        Id : CORBA.Short) return CORBA.STRING;


end Broker.Radio.Competition_Monitor_Radio.impl;
