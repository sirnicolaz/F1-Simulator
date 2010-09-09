with CORBA;
with PortableServer;

with Corba.Radio.Box_Monitor_Radio;

package Corba.Radio.Box_Monitor_Radio.impl is

   type Object is new PortableServer.Servant_Base with null record;

   type Object_Acc is access Object;

   procedure GetUpdate(Self : access Object;
                       num : in CORBA.Short;
                       time : out CORBA.Float;
                       Returns : out CORBA.String);

end Corba.Radio.Box_Monitor_Radio.impl;
