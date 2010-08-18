import java.io.*;

public class ConfigurationInterface_Test{
        public static void main(String [] args){
                org.omg.CORBA.ORB orb = org.omg.CORBA.ORB.init(args,null);

		String configCorbaLoc="";
		try{
		BufferedReader corbaLocFile = new BufferedReader(new FileReader("../competition_corbaLoc.txt"));
                configCorbaLoc = corbaLocFile.readLine() ;
		}catch(Exception e){}

                org.omg.CORBA.Object competition_obj = orb.string_to_object(configCorbaLoc);
                CompetitionConfigurator conf = CompetitionConfiguratorHelper.narrow(competition_obj);
		System.out.println("Sending competition configuration..");
                String mess = conf.Configure("obj/comp_config.xml");
		System.out.println("Done");

        }
}

