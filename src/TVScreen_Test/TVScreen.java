import java.io.*;
import org.w3c.dom.*;
import org.xml.sax.*;
import org.xml.sax.helpers.*;
import javax.xml.parsers.*;

public class TVScreen{

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
		String newUpdate = "";
		int loops = Integer.parseInt(args[2]);
		Document document;
		NodeList nodes_i;

		//Loop until the competition end
		boolean exit = false;
		for(int i = 0; i<loops && exit==false; i++){
			newUpdate = competition_mon.Get_CompetitionInfo(time);

			//Write new info to file
			try{
				FileWriter fstream = new FileWriter("newInfo.xml");
				BufferedWriter out = new BufferedWriter(fstream);
				out.write(newUpdate);
				out.close();
				builder = (DocumentBuilderFactory.newInstance()).newDocumentBuilder();
				System.out.println("Opening file");
				document = builder.parse("newInfo.xml");
				System.out.println("File opened");

			//Take the root node "competitionStatus"
			nodes_i = document.getDocumentElement().getChildNodes(); 

			//loop thorugh the children "competitor"
			for(int j = 0; j < nodes_i.getLength(); j++){
				Node node_i = nodes_i.item(j);
				if(node_i.getNodeType() == Node.ELEMENT_NODE &&
				   ((Element) node_i).getTagName().equals("competitor")){

					int id;
					int checkPoint;
					int lap;
					int sector;
					String position;

					Element competitor = (Element)node_i;
					id = Integer.parseInt(competitor.getAttribute("id"));
					System.out.println("Competitor " + id + ":");


					NodeList competitor_stuff = competitor.getChildNodes();
					for( int featureIndex = 0; featureIndex < competitor_stuff.getLength(); featureIndex++){
						Node feature = competitor_stuff.item(featureIndex);
						if(feature.getNodeType()==Node.ELEMENT_NODE){
							//Pick up the name of the tag and the value
							Element featureElement = (Element)feature;
							NodeList featureNodes = featureElement.getChildNodes();
							System.out.print(featureElement.getTagName() + ": " + (featureNodes.item(0)).getNodeValue() + ",");
							
							//If it's a checkpoint, verify the attribute "compPosition"
						}
					}
					System.out.println();
				}
			}
			System.out.println("-----------------------------------------");
			time = refreshTime + time;

			Thread.sleep(500);

			}catch(Exception e){
				System.out.println("Error saving file" + e.getMessage());
				exit = true;
			}


		}
	}

}
