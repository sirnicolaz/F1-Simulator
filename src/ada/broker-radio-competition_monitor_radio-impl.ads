with CORBA;
with PortableServer;

with Broker.Radio.Competition_Monitor_Radio;
use Broker.Radio.Competition_Monitor_Radio;

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
      metres : out CORBA.FLOAT;
      Returns : out CORBA.STRING);

   procedure Get_CompetitionConfiguration
     (Self : access Object;
      xmlConf : in out CORBA.String;
      Results : out CORBA.FLOAT);

   procedure Get_CompetitionInfo
     (Self : access Object;
      timeInstant : CORBA.FLOAT;
      xmlInfo : out CORBA.String;
      Returns : out Broker.Radio.Competition_Monitor_Radio.float_sequence );

   function Get_CompetitorConfiguration(Self : access Object;
                                        Id : CORBA.Short) return CORBA.STRING;

   procedure Set_Simulation_Speed(Self : access Object;
                                  Simulation_Speed_In : Corba.Float);


end Broker.Radio.Competition_Monitor_Radio.impl;
