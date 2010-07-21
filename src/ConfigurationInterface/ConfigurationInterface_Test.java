import java.io.*;

public class ConfigurationInterface_Test{
        public static void main(String [] args){
                org.omg.CORBA.ORB orb = org.omg.CORBA.ORB.init(args,null);
                org.omg.CORBA.Object competition_obj = orb.string_to_object(args[0]);
                CompetitionConfiguration conf = CompetitionConfigurationHelper.narrow(competition_obj);
		System.out.println("Sending competition configuration..");
                String mess = conf.Configure("obj/comp_config.xml");
		System.out.println("Sent");

                org.omg.CORBA.Object registration_obj = orb.string_to_object(args[1]);
                RegistrationHandler reg = RegistrationHandlerHelper.narrow(registration_obj);
           
		System.out.println("Write the driver descriptor (xml format)");
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		String configurationString = null;

		try {
        		 configurationString = br.readLine();
		      } catch (IOException ioe) {
	         System.out.println("IO error trying to read your name!");
        	 System.exit(1);
      		}
		org.omg.CORBA.ShortHolder comp_ID = new org.omg.CORBA.ShortHolder();
//		Short comp_ID = 0;
		org.omg.CORBA.StringHolder monitor_corbaLoc = new org.omg.CORBA.StringHolder();
//		String monitor_corbaLoc = "nulla";
		System.out.println("Sending driver configuration..");
		reg.Join_Competition(configurationString,"La merda",monitor_corbaLoc,comp_ID);
		System.out.println("Competitor " + comp_ID + " registered.");
		

        }
}

