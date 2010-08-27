import java.io.*;
import org.w3c.dom.*;
import org.xml.sax.*;
import org.xml.sax.helpers.*;
import javax.xml.parsers.*;

public class ClassificDisplay{

	static private DocumentBuilder builder;

        public static void main(String [] args){

		System.out.println("Starting...");
			
                org.omg.CORBA.ORB orb = org.omg.CORBA.ORB.init(args,null);

		//Get the competition reference
		System.out.println("Taking object");

		org.omg.CORBA.Object competition_obj = orb.string_to_object(args[1]);
		System.out.println("Taking reference");

                Competition_Monitor_Radio competition_mon = Competition_Monitor_RadioHelper.narrow(competition_obj);

		System.out.println("Done");

		//Get the refresh time
		float refreshTime = Float.parseFloat(args[0]);
		float time = refreshTime;
		int loops = Integer.parseInt(args[2]);

		//Loop until the competition end
		boolean exit = false;
		org.omg.CORBA.StringHolder newUpdate = new org.omg.CORBA.StringHolder();
		float[] classificationTimes;

		for(int i = 0; i<loops && exit==false; i++){
			classificationTimes = competition_mon.Get_CompetitionInfo(time,newUpdate);
			//float[] example = Competition_Monitor_RadioPackage.float_sequenceHelper.extract(classificationTimes);
			System.out.println("Taken");
			if(classificationTimes != null){
				for( int index = 0; index < classificationTimes.length; index++){
					System.out.print(classificationTimes[index] + ",");
				}
			}

			time = time + refreshTime;

		}
	}
}
