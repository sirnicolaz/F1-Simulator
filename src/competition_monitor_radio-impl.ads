with CORBA;
with PortableServer;

package Competition_Monitor_Radio.impl is

   type Object is new PortableServer.Servant_Base with null record;
   type Object_Acc is access Object;

   function Ready( Self : access Object;
                  CompetitorID : Corba.SHORT) return BOOLEAN;

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

--   procedure Get_CompetitionConfiguration
--     (Self : access Object;
--      xmlConf : out CORBA.String);

end Competition_Monitor_Radio.impl;
