with CORBA;
with PortableServer;

with Stats;
use Stats;

with OnboardComputer;

package MonitorSystem.Impl is

   type COMPETITORS_COMPUTERS is array(INTEGER range <>) of OnboardComputer.COMPUTER_POINT;
   type COMPETITORS_COMPUTERS_POINT is access COMPETITORS_COMPUTERS;

   Computers : COMPETITORS_COMPUTERS_POINT;
   GlobalStatistics : Stats.S_GLOB_STATS_POINT;

   type Object is new PortableServer.Servant_Base with null record;
   type Object_Acc is access Object;

   procedure Init_Monitor(CompetitorQty_In : INTEGER; RefreshInterval : FLOAT);
   procedure Add_Computer(Computer_In : OnboardComputer.COMPUTER_POINT);

   function GetCompetitorInfo (Self : access Object;
                               CompetitorId : CORBA.Short) return Corba.STRING;

   function GetCompetitionInfo (Self : access Object) return Corba.STRING;

   function GetEverything(Self : access Object;
                          CompetitorId : CORBA.Short) return Corba.STRING;

   function GetClassification (Self : access Object) return Corba.STRING;

   function GetStatsBySect(Self : access Object;
                           CompId : CORBA.Short;
                           Sector : CORBA.Short;
                           Lap : CORBA.Short) return CORBA.String;

end MonitorSystem.Impl;
