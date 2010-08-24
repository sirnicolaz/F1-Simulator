/*
In this class we have more methods to connect one client to more server
every method connect return different type for different connection
*/
import java.util.Properties;
import org.omg.CORBA.ORB;
import org.omg.PortableServer.POA;
import org.omg.PortableServer.POAHelper;
import org.omg.CosNaming.NameComponent;
import org.omg.CosNaming.NamingContext;
import org.omg.CosNaming.NamingContextHelper;

public class Connection{
public static RegistrationHandler connectRH(String corbaloc){

	try {
System.out.println("Try to connect to Registration Handler");
String[] temp = {corbaloc};
	  ORB orb = ORB.init(temp, null);
System.out.println("ORB initialized");
           //Resolve MessageServer
	    org.omg.CORBA.Object obj = orb.string_to_object(temp[0]);
	    RegistrationHandler comp = RegistrationHandlerHelper.narrow(obj);
System.out.println("Comp initialized");
	    return comp;
	} catch (Exception e) {
	    e.printStackTrace();
	    return null;
	}
   }
public static Configurator connectC(String corbaloc){
	try {
System.out.println("Try to connect to configurator");
String[] temp = {corbaloc};
	  ORB orb = ORB.init(temp, null);
System.out.println("ORB initializes");
           //Resolve MessageServer
	    org.omg.CORBA.Object obj = orb.string_to_object(temp[0]);
	    Configurator conf = ConfiguratorHelper.narrow(obj);
System.out.println("Conf initialized");
	    return conf;
	} catch (Exception e) {
	    e.printStackTrace();
	    return null;
	}
   }
 
}