import java.io.*;

public class ConfigurationInterface_Test{
        public static void main(String [] args){
                org.omg.CORBA.ORB orb = org.omg.CORBA.ORB.init(args,null);
                org.omg.CORBA.Object competition_obj = orb.string_to_object(args[0]);
                CompetitionConfiguration conf = CompetitionConfigurationHelper.narrow(competition_obj);
		System.out.println("Sending competition configuration..");
                String mess = conf.Configure("obj/comp_config.xml");
		System.out.println("Sent");

		System.out.println("Getting registration object");		
                org.omg.CORBA.Object registration_obj = orb.string_to_object(args[1]);

		System.out.println("Getting registration reference");		
                RegistrationHandler reg = RegistrationHandlerHelper.narrow(registration_obj);
           
		System.out.println("Write the driver descriptor (xml format)");
		String configurationString = 
		"<?xml version=\"1.0\"?><car_driver>	<driver>	  <team>Ferrari</team>	  <firstname>Fernando</firstname>	  <lastname>Burlin</lastname>	</driver>	<car>	  <maxspeed>400.0</maxspeed>	  <maxacceleration>1.3</maxacceleration>	  <gastankcapacity>1000</gastankcapacity>	  <engine>strong</engine>	  <tyreusury>0.0</tyreusury>	  <gasolinelevel>100</gasolinelevel>	  <mixture>morbida</mixture>	  <model>michelin</model>	  <type_tyre>rain</type_tyre>	</car>	<strategy_car>	 <pitstopGasolineLevel>250</pitstopGasolineLevel>	 <pitstopLaps>12</pitstopLaps>	 <pitstopCondition>false</pitstopCondition>	 <trim>1</trim>	 <pitstop>false</pitstop>	</strategy_car></car_driver>";
		
		org.omg.CORBA.ShortHolder comp_ID = new org.omg.CORBA.ShortHolder();
//		Short comp_ID = 0;
		org.omg.CORBA.StringHolder monitor_corbaLoc = new org.omg.CORBA.StringHolder();
//		String monitor_corbaLoc = "nulla";
		System.out.println("Sending driver configuration..");
		reg.Join_Competition(configurationString,"La merda",monitor_corbaLoc,comp_ID);
		System.out.println("Competitor " + comp_ID.value + " registered.");
		

        }
}

