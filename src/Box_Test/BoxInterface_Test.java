import java.io.*;

public class BoxInterface_Test{
        public static void main(String [] args){
                org.omg.CORBA.ORB orb = org.omg.CORBA.ORB.init(args,null);

		//Create a competitor descriptor xml string
		String competitorXML = "";
		String configCorbaLoc = "";
		String boxRadioCorbaLoc = "";


		try{
			BufferedReader compDescriptor = new BufferedReader(new FileReader("../obj/competitor-" + args[0] + ".xml"));
			while( compDescriptor.ready() ){
				competitorXML = competitorXML + compDescriptor.readLine();
			}
		

			//Pick up the boxCorbaLoc from the corbaLoc.txt
			BufferedReader corbaLocFile = new BufferedReader(new FileReader("../boxCorbaLoc-" + args[0] + ".txt"));
			configCorbaLoc = corbaLocFile.readLine() ;
			boxRadioCorbaLoc = corbaLocFile.readLine();
		}catch(Exception e){}

		//Take a reference to the RegistrationHandler and send him the information.
		org.omg.CORBA.Object regHandler_obj = orb.string_to_object(args[1]);
                RegistrationHandler regHandler = RegistrationHandlerHelper.narrow(regHandler_obj);

		org.omg.CORBA.ShortHolder comp_ID = new org.omg.CORBA.ShortHolder();
		org.omg.CORBA.ShortHolder laps = new org.omg.CORBA.ShortHolder();
		org.omg.CORBA.StringHolder monitor_corbaLoc = new org.omg.CORBA.StringHolder();
		org.omg.CORBA.FloatHolder circuitLength = new org.omg.CORBA.FloatHolder();
		

		System.out.println("Sending driver configuration..");
		regHandler.Join_Competition(competitorXML,boxRadioCorbaLoc,monitor_corbaLoc,comp_ID,circuitLength,laps);
		System.out.println("Competitor " + comp_ID.value + " registered.");

		//With the information obtained, create a configuration file whose name
		//has to be passed to the box Configurator:Configure
		String initialTyreType = "normal";
		Double gasTankCapacity = 150.0;
		String boxStrategy = "NORMAL";
		Double initialGasLevel = 70.0;

		String boxConfFile = "<?xml version=\"1.0\"?>" +
					"<config>" + 
					        "<monitorCorbaLoc>" + monitor_corbaLoc.value + "</monitorCorbaLoc>" +
						"<initialTyreType>" + initialTyreType + "</initialTyreType>" + 
						"<laps>" + laps.value + "</laps>" + 
						"<circuitLength>" +  circuitLength.value + "</circuitLength>" + 
						"<initialGasLevel>" + initialGasLevel + "</initialGasLevel>" +
						"<gasTankCapacity>" + gasTankCapacity + "</gasTankCapacity>" + 
						"<competitorID>" + comp_ID.value + "</competitorID>" + 
						"<boxStrategy>" + boxStrategy + "</boxStrategy>" + 
					"</config>";
		String configFileName = "boxConfig.xml";


		try{
			FileWriter stream = new FileWriter("../obj/" + configFileName);
			BufferedWriter out = new BufferedWriter(stream);
			out.write(boxConfFile);
			out.close();
		} catch(Exception e){}

		org.omg.CORBA.Object configurator_obj = orb.string_to_object(configCorbaLoc);
		System.out.println("Getting registration reference");
                BoxConfigurator config = BoxConfiguratorHelper.narrow(configurator_obj);

		config.Configure("obj/boxConfig.xml");

		//Done

//	try{
//                System.out.println("Getting configurator object");
//		BufferedReader in = new BufferedReader(new FileReader("../corbaLoc.txt"));
//		String configCorbaLoc = in.readLine() ;
//		System.out.println(configCorbaLoc);
//		org.omg.CORBA.Object configurator_obj = orb.string_to_object(configCorbaLoc);
//		System.out.println("Getting registration reference");		
  //              Configurator config = ConfiguratorHelper.narrow(configurator_obj);
    //       
//		System.out.println("Write the driver descriptor (xml format)");
//		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
//		
//		String configurationString = null;

//		try {
//		      configurationString = br.readLine();
//		} catch (IOException ioe) {
//			System.out.println("IO error trying to read your name!");
//			System.exit(1);
//		}


//		org.omg.CORBA.ShortHolder comp_ID = new org.omg.CORBA.ShortHolder();
//		Short comp_ID = 0;
//		org.omg.CORBA.StringHolder monitor_corbaLoc = new org.omg.CORBA.StringHolder();
//		String monitor_corbaLoc = "nulla";
//		System.out.println("Sending driver configuration..");
//		reg.Join_Competition(configurationString,"La merda",monitor_corbaLoc,comp_ID);
//		System.out.println("Competitor " + comp_ID.value + " registered.");

//		System.out.println(config.Configure("obj/test_config.xml"));

//		}
//		catch(Exception e){}

        }
}

