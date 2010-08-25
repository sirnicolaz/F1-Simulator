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
			//nodes_i = competitors,bestTimes. Use this loop to find the related indexes
			int competitorsIndex = 0;
			int bestTimesIndex = 0;
			
			for( int x = 0; x < nodes_i.getLength(); x++){
			  Node node_i = nodes_i.item(x);
				if(node_i.getNodeType() == Node.ELEMENT_NODE &&
				   ((Element) node_i).getTagName().equals("competitors")){
				      competitorsIndex = x;
				}
				if(node_i.getNodeType() == Node.ELEMENT_NODE &&
				   ((Element) node_i).getTagName().equals("bestTimes")){
				      bestTimesIndex = x;
				}
			}

			NodeList competitors = nodes_i.item(competitorsIndex).getChildNodes();
			NodeList bestTimes = nodes_i.item(bestTimesIndex).getChildNodes();


			//loop thorugh the children "competitor"
			for(int j = 0; j < competitors.getLength(); j++){
				Node node_i = competitors.item(j);
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
			
			//loop thorugh the children "best times"
			for(int j = 0; j < bestTimes.getLength(); j++){
				Node node_i = competitors.item(j);
				if(node_i.getNodeType() == Node.ELEMENT_NODE &&
				   ((Element) node_i).getTagName().equals("lap")){

					int id;
					int num;
					String timeLap;

					Element bestLap = (Element)node_i;
					num = Integer.parseInt(bestLap.getAttribute("num"));
					System.out.print("Best lap " + num + ":");


					NodeList bestLap_stuff = bestLap.getChildNodes();
					for( int featureIndex = 0; featureIndex < bestLap_stuff.getLength(); featureIndex++){
						Node feature = bestLap_stuff.item(featureIndex);
						if(feature.getNodeType()==Node.ELEMENT_NODE){
							//Pick up the name of the tag and the value
							Element featureElement = (Element)feature;
							NodeList featureNodes = featureElement.getChildNodes();
							System.out.print(featureElement.getTagName() + "= " + (featureNodes.item(0)).getNodeValue() + ",");
							
							//If it's a checkpoint, verify the attribute "compPosition"
						}
					}
					System.out.println();
				}
				if(node_i.getNodeType() == Node.ELEMENT_NODE &&
				   ((Element) node_i).getTagName().equals("sectors")){
					NodeList sectors = node_i.getChildNodes();
					for( int sectIndex = 0; sectIndex < sectors.getLength(); sectIndex++){
					    Node sector = sectors.item(sectIndex);
					    if(sector.getNodeType() == Node.ELEMENT_NODE &&
						((Element) sector).getTagName().equals("sector")){
						      int id;
						      int num;
						      String timeSect;
						      Element bestSector = (Element)sector;
						      num = Integer.parseInt(bestSector.getAttribute("num"));
						      System.out.print("Best sector " + num + ":");


						      NodeList bestSector_stuff = sector.getChildNodes();
						      for( int featureIndex = 0; featureIndex < bestSector_stuff.getLength(); featureIndex++){
							      Node feature = bestSector_stuff.item(featureIndex);
							      if(feature.getNodeType()==Node.ELEMENT_NODE){
								//Pick up the name of the tag and the value
								Element featureElement = (Element)feature;
								NodeList featureNodes = featureElement.getChildNodes();
								System.out.print(featureElement.getTagName() + "= " + (featureNodes.item(0)).getNodeValue() + ",");
								
								//If it's a checkpoint, verify the attribute "compPosition"
								}
						      }
						      System.out.println();
						      
						}
					
					}
				   
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
