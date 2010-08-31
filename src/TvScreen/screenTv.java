import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import javax.swing.table.*;
// import java.awt.Dialog.*;
import javax.swing.JDialog.*;
import java.awt.Rectangle;
import java.util.Vector;

import java.util.Properties;
import org.omg.CORBA.ORB;
import org.omg.PortableServer.POA;
import org.omg.PortableServer.POAHelper;
import org.omg.CosNaming.NameComponent;
import org.omg.CosNaming.NamingContext;
import org.omg.CosNaming.NamingContextHelper;

import java.lang.*;
import javax.xml.parsers.*;
import org.xml.sax.InputSource;
import org.w3c.dom.*;

import java.lang.reflect.Array;

public class screenTv extends Thread{
private int[] provaArray = new int[10];
private dati[] datiArray = new dati[3];
private dati[] datiOldArray = new dati[3];
private int tabellaCorrente =1;
private JTable classific_1;
private JTable classific_2;
private JScrollPane panelCl_1;
private JPanel classificPanel;
private JScrollPane panelCl_2;
private JPanel bestPanel;
private JFrame parent;
private JScrollPane tablePanel;
private JTable tableAll;

private Integer lapNum= new Integer(0);

private DefaultTableModel model_1 = new DefaultTableModel(); 
private DefaultTableModel model_2 = new DefaultTableModel(); 

private DefaultTableModel modelAll = new DefaultTableModel(); 
private FlowLayout f = new FlowLayout();
private GridBagConstraints classificGrid = new GridBagConstraints();
private GridBagConstraints bestGrid = new GridBagConstraints();
private JTextField textBoxLap = new JTextField("",3);
private JTextField textBoxLapId = new JTextField("",2);
private JTextField textBoxLapTime = new JTextField("",10);
private JLabel labelLap = new JLabel("Best lap n° : ");
private JLabel labelLapId = new JLabel(" by competitor : ");
private JLabel labelLapTime = new JLabel(" in time : ");

private JTextField textBoxSector1Lap = new JTextField("",3);
private JTextField textBoxSector1Id = new JTextField("",2);
private JTextField textBoxSector1Time = new JTextField("",10);
private JLabel labelSector1 = new JLabel("Best Sector 1 at lap n° : ");
private JLabel labelSector1Id = new JLabel(" by competitor : ");
private JLabel labelSector1Time = new JLabel(" in time : ");



private JTextField textBoxSector2Lap = new JTextField("",3);
private JTextField textBoxSector2Id = new JTextField("",2);
private JTextField textBoxSector2Time = new JTextField("",10);
private JLabel labelSector2 = new JLabel("Best Sector 2 at lap n° : ");
private JLabel labelSector2Id = new JLabel(" by competitor : ");
private JLabel labelSector2Time = new JLabel(" in time : ");


private JTextField textBoxSector3Lap = new JTextField("",3);
private JTextField textBoxSector3Id = new JTextField("",2);
private JTextField textBoxSector3Time = new JTextField("",10);
private JLabel labelSector3 = new JLabel("Best Sector 3 at lap n° : ");
private JLabel labelSector3Id = new JLabel(" by competitor : ");
private JLabel labelSector3Time = new JLabel(" in time : ");

private String corbaloc;
private ORB orb;
private int numComp;
private float[] arrayInfo;
private float[] arrayOldInfo;

//parsing xml
private Integer idCompetitor;
private String stateValue;
private Integer checkpointValue;
private Integer sectorValue;

private int current_lap =0;
private boolean new_table = false;

public screenTv(String corbalocIn){
parent = new JFrame("TV Monitor");
corbaloc = corbalocIn;
//effettua la connessione
System.out.println("Try to connect to Competition");
try{
 String[] temp = {"ORB"};
orb = ORB.init(temp, null);
}
catch (Exception e){
System.out.println("Eccezione");
e.printStackTrace();
}
}
public void addTables(){
model_1.addColumn("Position");
model_1.addColumn("Id Comp"); 
model_1.addColumn("Lap");
model_1.addColumn("Time");
model_2.addColumn("Position");
model_2.addColumn("Id Comp"); 
model_2.addColumn("Lap");
model_2.addColumn("Time");
classific_1 = new JTable(model_1);
classific_2 = new JTable(model_2);

panelCl_1 = new JScrollPane(classific_1);
panelCl_2 = new JScrollPane(classific_2);
// panelCl_2 = new JScrollPane(classific_2);//classific_1);
/*classificPanel = new JPanel(new BorderLayout());
classificPanel.setLayout(new GridBagLayout());
classificPanel.setBorder(BorderFactory.createTitledBorder(null, "Classific", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
classificGrid.fill = GridBagConstraints.HORIZONTAL;
		classificGrid.gridx = 0;
		classificGrid.gridy = 0;
		classificGrid.ipady = 5;
		classificPanel.add(panelCl_1, classificGrid);*/
/*classificGrid.fill = GridBagConstraints.HORIZONTAL;
		classificGrid.gridx = 1;
		classificGrid.gridy = 0;
		classificGrid.ipady = 5;
		classificPanel.add(panelCl_2, classificGrid);*/
}
public void addBest(){
bestPanel = new JPanel(new BorderLayout());
bestPanel.setLayout(new GridBagLayout());
bestPanel.setBorder(BorderFactory.createTitledBorder(null, "Best Performance", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));

bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 0;
		bestGrid.gridy = 0;
		bestGrid.ipady = 5;
		bestPanel.add(labelLap,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 1;
		bestGrid.gridy = 0;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxLap,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 2;
		bestGrid.gridy = 0;
		bestGrid.ipady = 5;
		bestPanel.add(labelLapId,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 3;
		bestGrid.gridy = 0;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxLapId,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 4;
		bestGrid.gridy = 0;
		bestGrid.ipady = 5;
		bestPanel.add(labelLapTime,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 5;
		bestGrid.gridy = 0;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxLapTime,bestGrid);
//best sector

bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 0;
		bestGrid.gridy = 1;
		bestGrid.ipady = 5;
		bestPanel.add(labelSector1,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 1;
		bestGrid.gridy = 1;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxSector1Lap,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 2;
		bestGrid.gridy = 1;
		bestGrid.ipady = 5;
		bestPanel.add(labelSector1Id,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 3;
		bestGrid.gridy = 1;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxSector1Id,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 4;
		bestGrid.gridy = 1;
		bestGrid.ipady = 5;
		bestPanel.add(labelSector1Time,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 5;
		bestGrid.gridy = 1;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxSector1Time,bestGrid);


bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 0;
		bestGrid.gridy = 2;
		bestGrid.ipady = 5;
		bestPanel.add(labelSector2,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 1;
		bestGrid.gridy = 2;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxSector2Lap,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 2;
		bestGrid.gridy = 2;
		bestGrid.ipady = 5;
		bestPanel.add(labelSector2Id,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 3;
		bestGrid.gridy = 2;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxSector2Id,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 4;
		bestGrid.gridy = 2;
		bestGrid.ipady = 5;
		bestPanel.add(labelSector2Time,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 5;
		bestGrid.gridy = 2;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxSector2Time,bestGrid);


bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 0;
		bestGrid.gridy = 3;
		bestGrid.ipady = 5;
		bestPanel.add(labelSector3,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 1;
		bestGrid.gridy = 3;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxSector3Lap,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 2;
		bestGrid.gridy = 3;
		bestGrid.ipady = 5;
		bestPanel.add(labelSector3Id,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 3;
		bestGrid.gridy = 3;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxSector3Id,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 4;
		bestGrid.gridy = 3;
		bestGrid.ipady = 5;
		bestPanel.add(labelSector3Time,bestGrid);
bestGrid.fill = GridBagConstraints.HORIZONTAL;
		bestGrid.gridx = 5;
		bestGrid.gridy = 3;
		bestGrid.ipady = 5;
		bestPanel.add(textBoxSector3Time,bestGrid);

}

public void addTablesAll(){
modelAll.addColumn("Id competitor");
modelAll.addColumn("Checkpoint");
modelAll.addColumn("Sector");
modelAll.addColumn("Lap");
modelAll.addColumn("State");
modelAll.addColumn("Time (h:m:s:mll)");

tableAll = new JTable(modelAll);
tablePanel = new JScrollPane(tableAll);
tablePanel.setVerticalScrollBar(new JScrollBar());
tablePanel.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);

}
public void run(){
// readXml()
addTables();
addBest();
addTablesAll();
parent.add(panelCl_1, BorderLayout.EAST);
parent.add(panelCl_2, BorderLayout.WEST);
parent.add(bestPanel,BorderLayout.NORTH);
parent.add(tablePanel, BorderLayout.SOUTH);
// readXml("<?xml version=\"1.0\"?><competitionUpdate><competitors><competitor id=\"1\"><checkpoint compPosition=\"passed\" >12</checkpoint><lap>42</lap><sector>3</sector></competitor><competitor id=\"2\"><checkpoint compPosition=\"passed\" >13</checkpoint><lap>43</lap><sector>2</sector> </competitor></competitors><bestTimes><lap num=\"3\"><time>34.0000</time><competitorId>4</competitorId></lap><sectors><sector num=\"1\"><time>10.0</time><competitorId>3</competitorId><lap>45</lap></sector><sector num=\"2\"><time>15.1</time><competitorId>4</competitorId><lap>99</lap></sector><sector num=\"3\"><time>5.3</time><competitorId>5</competitorId><lap>66</lap></sector></sectors></bestTimes>"
// +"<classification><competitor id=\"3\"><lap>4</lap></competitor><competitor id=\"5\"><lap>3</lap></competitor><competitor id=\"1\"><lap>2</lap></competitor></classification></competitionUpdate>");

parent.pack();
parent.setVisible(true);
parent.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

try{
for(int index = 0; index<1; index++){
model_1.insertRow(index,new Object[]{index, "---","---","---","---",});
model_2.insertRow(index,new Object[]{index, "---","---","---","---",});

}
float q =(float)1.0;
org.omg.CORBA.Object obj = orb.string_to_object(corbaloc);
Competition_Monitor_Radio monitor = Competition_Monitor_RadioHelper.narrow(obj);
while(true){
org.omg.CORBA.StringHolder updateString = new org.omg.CORBA.StringHolder();
arrayInfo = monitor.Get_CompetitionInfo(q, updateString);
lapNum = (int)q;
readXml(updateString.value, q);
//ho l'array con la classifica letta, provo a stamparla.

for(int y=0; y<Array.getLength(datiArray); y++){
try{
System.out.println("dati["+y+"].id="+datiArray[y].id+", lap = "+datiArray[y].lap+", position = "+datiArray[y].position);
model_1.addRow(new Object[]{y,datiArray[y].id, datiArray[y].lap, arrayInfo[y]});
}
catch(Exception e){
y=Array.getLength(datiArray)+1;
e.printStackTrace();
}

}

//stampo le classifiche del giro pari su cl_1 e quelle dei giri dispari su cl_2
// for(int y=0; y<Array.getLength(datiArray); y++){
// try{
// if(datiArray[y].lap%2==0){
// if(datiArray[y].position < model_1.getRowCount()){
// model_1.removeRow(datiArray[y].position);}
// model_1.insertRow(datiArray[y].position,new Object[]{y, datiArray[y].id, datiArray[y].lap, arrayInfo[y]});
// }
// else{
// if(datiArray[y].position < model_1.getRowCount()){
// model_2.removeRow(datiArray[y].position);}
// model_2.insertRow(datiArray[y].position,new Object[]{datiArray[y].position, datiArray[y].id, datiArray[y].lap, arrayInfo[y]});
// }
// }
// catch(Exception e){
// y=Array.getLength(datiArray)+1;
// }
// }
//ho i dati nell'array dati
// if(q>20.0){
// for(int y=0; y<Array.getLength(datiArray); y++){
// try{
// if(datiArray[y].lap == current_lap){
// new_table=false;
// System.out.println("Length array = "+Array.getLength(datiArray));
// System.out.println("dati["+y+"].id="+datiArray[y].id);
// // model_1.removeRow(y);
// model_1.insertRow(0,new Object[]{y, datiArray[y].id, datiArray[y].lap, arrayInfo[y]});
// datiOldArray[y]= datiArray[y];
// arrayOldInfo[y]=arrayInfo[y];
// }
// else{
// if(datiArray[y].lap > current_lap){
// //copiare dati vecchi nella nuova tabella
// // for(int r=0; r<Array.getLength(datiArray); r++){
// // model_2.removeRow(r);}
// for(int x=0 ; x<Array.getLength(datiOldArray); x++){
// // model_2 = insertRow(x, model_1.getRow(x));
// // Object[] obj1 = {(classific_1, 0, 0), GetData(classific_1, 0, 1),GetData(classific_1, 0, 2),GetData(classific_1, 0, 3)};
// model_2.insertRow(x, new Object[]{y, datiOldArray[x].id, datiOldArray[x].lap, arrayOldInfo[x]});
// model_1.removeRow(0);
// }
// //scrivere nuovi dati nella nuova tabella
// model_1.insertRow(y,new Object[]{y, datiArray[y].id, datiArray[y].lap, arrayInfo[y]});
// new_table=true;
// }
// }
// if(new_table == true){
// current_lap = current_lap +1;
// }
// }
// catch(Exception e){
// y=Array.getLength(datiArray)+1;
// }
// }
q=(float)(q+1);
sleep(500);
}
}
catch(Exception e){e.printStackTrace();}
}

// parsing xml
public void readXml(String xmlRecords, float istant){
System.out.println("stringa da parsare : \n"+xmlRecords);
// String xmlRecords ="<?xml version=\"1.0\"?><update><gasLevel>35.58887482</gasLevel><!--prova--><tyreUsury>17.07367134</tyreUsury><lap>18</lap><sector>3</sector><metres>686.00000000</metres></update>";
 try {
        DocumentBuilderFactory dbf =
        DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        InputSource is = new InputSource();
        is.setCharacterStream(new StringReader(xmlRecords));

        Document doc = db.parse(is);

	NodeList nodes32 = doc.getElementsByTagName("competitors");
	Element prova32 = (Element) nodes32.item(0);

	NodeList nodes = prova32.getElementsByTagName("competitor");
	Element prova = (Element) nodes.item(0);

//qua conto i figli

	for (int i=0; i < nodes.getLength(); i++) {

        Element element = (Element) nodes.item(i);
        NodeList comp = doc.getElementsByTagName("competitor");
        Element line = (Element) comp.item(i);
	System.out.println("competitor: " + getCharacterDataFromElement(line)+" length ="+nodes.getLength());

	NamedNodeMap attributiComp =line.getAttributes();

	Attr attributoComp = (Attr) attributiComp.item(0);
	System.out.println("attributo id : "+attributoComp.getNodeValue());
	
	NodeList check = element.getElementsByTagName("checkpoint");
        line = (Element) check.item(0);
	NamedNodeMap attributiCheck =line.getAttributes();

	Attr attributoCheck = (Attr) attributiCheck.item(0);
	System.out.println("attributo checkpoint "+getCharacterDataFromElement(line)+" : "+attributoCheck.getNodeValue());
	System.out.println("lap : "+getNode("lap", element));
/*lap = new Integer(getNode("lap", element));*/
	System.out.println("sector : "+getNode("sector", element));
// try{
// modelAll.removeRow(new Integer(attributoComp.getNodeValue()).intValue());
// }catch(Exception e) {}
// modelAll.removeRow(i);
modelAll.insertRow(i,new Object[]{attributoComp.getNodeValue(),getNode("checkpoint", element), getNode("sector", element), getNode("lap", element),  attributoCheck.getNodeValue(), istant});
// ListSelectionModel selectionModel = tableAll.getSelectionModel();
// selectionModel.setSelectionInterval(0,0);
	}
	
System.out.println("bestTimes");
	NodeList best = doc.getElementsByTagName("bestTimes");
        Element element = (Element)best.item(0);
	
	NodeList lap = element.getElementsByTagName("lap");
        Element line = (Element) lap.item(0);
	NamedNodeMap attributiLap =line.getAttributes();


	Attr attributoLap = (Attr) attributiLap.item(0);
	System.out.println("attributo lap "+getCharacterDataFromElement(line)+" : "+attributoLap.getNodeValue());
	
textBoxLap.setText(attributoLap.getNodeValue());
	System.out.println("time : "+getNode("time", element));
textBoxLapTime.setText(getNode("time", element));
	System.out.println("competitor Id : "+getNode("competitorId", element));
textBoxLapId.setText(getNode("competitorId", element));

	
	NodeList bestSector = doc.getElementsByTagName("sectors");
        element = (Element)bestSector.item(0);

	NodeList sector = element.getElementsByTagName("sector");
        line = (Element) sector.item(0);
	NamedNodeMap attributiSector =line.getAttributes();
	Attr attributoSector = (Attr) attributiSector.item(0);
	System.out.println("attributo sector 1 "+getCharacterDataFromElement(line)+" : "+attributoSector.getNodeValue());
	System.out.println("--time : "+getNode("time", line));

	System.out.println("--id : "+getNode("competitorId", line));
textBoxSector1Id.setText(getNode("competitorId", line));
textBoxSector1Lap.setText(getNode("lap", line));
textBoxSector1Id.setText(getNode("competitorId", line));
textBoxSector1Time.setText(getNode("time", line));	

	sector = element.getElementsByTagName("sector");
        line = (Element) sector.item(1);
	attributiSector =line.getAttributes();
	attributoSector = (Attr) attributiSector.item(0);
	System.out.println("attributo sector 2 "+getCharacterDataFromElement(line)+" : "+attributoSector.getNodeValue());
	System.out.println("--time : "+getNode("time", line));
	System.out.println("--id : "+getNode("competitorId", line));
textBoxSector2Id.setText(getNode("competitorId", line));
textBoxSector2Lap.setText(getNode("lap", line));
textBoxSector2Id.setText(getNode("competitorId", line));
textBoxSector2Time.setText(getNode("time", line));	
	
	sector = element.getElementsByTagName("sector");
        line = (Element) sector.item(2);
	attributiSector =line.getAttributes();
	attributoSector = (Attr) attributiSector.item(0);
	System.out.println("attributo sector 3"+getCharacterDataFromElement(line)+" : "+attributoSector.getNodeValue());
	System.out.println("--time : "+getNode("time", line));
	System.out.println("--id : "+getNode("competitorId", line));
textBoxSector3Id.setText(getNode("competitorId", line));
textBoxSector3Lap.setText(getNode("lap", line));
textBoxSector3Id.setText(getNode("competitorId", line));
textBoxSector3Time.setText(getNode("time", line));	

	try{
	NodeList cl = doc.getElementsByTagName("classification");
        Element elementTemp = (Element)cl.item(0);
	
	NodeList comp42 =elementTemp.getElementsByTagName("competitor");
        Element compEl = (Element) comp42.item(0);
// int row = model_1.getRowCount();
// classific_1.removeColumnSelectionInterval(0,row-1);
// int row2 = model_2.getRowCount();
// classific_2.removeColumnSelectionInterval(0,row2-1);
for(int y=0; y<Array.getLength(datiArray); y++){
datiArray[y] = null;
}
	for (int i=0; i < comp42.getLength(); i++) {

        element = (Element) comp42.item(i);
//         NodeList compIn = comp42.getElementsByTagName("competitor");
         line = (Element) comp42.item(i);
	System.out.println("----competitor: " + getCharacterDataFromElement(line)+" length ="+comp42.getLength());
	NamedNodeMap attributiComp =line.getAttributes();

	Attr attributoComp = (Attr) attributiComp.item(0);
	System.out.println("------attributo id : "+attributoComp.getNodeValue());
	
	System.out.println("------lap : "+getNode("lap", line));
datiArray[i] = new dati(new Integer(getNode("lap", line)).intValue(), new Integer(attributoComp.getNodeValue()).intValue(), i);
// model_1.insertRow(0,new Object[]{i, attributoComp.getNodeValue(), getNode("lap", line), arrayInfo[i]});
// if(new Integer(getNode("lap", line)).intValue()==current_lap){
// // model_1.removeRow(i);
// model_1.insertRow(i,new Object[]{i, attributoComp.getNodeValue(), getNode("lap", line), arrayInfo[i]});
// }
// else{
// if(new Integer(getNode("lap", line)).intValue()>current_lap){
// //devo aggiornare il boolean, devo copiare la tabella vecchia e scrivere quella nuova
// new_table = true;
// //copio la vecchia tabella
// Vector data = model_1.getDataVector();
// for(int w=0; w<classific_1.getRowCount();w++){
// // model_2.removeRow(w);
// // model_1.moveRow(w, w, model_2.getRowCount());
// model_2.insertRow(w,new Object[]{data.get(w)});
// }
// model_1 = new DefaultTableModel();
// model_1.insertRow(i,new Object[]{i, attributoComp.getNodeValue(), getNode("lap", line), arrayInfo[i]});
// }
// else {//il valore è minore
// if(new_table ==  true){
// model_2.addRow(new Object[]{i, attributoComp.getNodeValue(), getNode("lap", line), arrayInfo[i]});}
// else{
// model_1.addRow(new Object[]{i, attributoComp.getNodeValue(), getNode("lap", line), arrayInfo[i]});}
// }
//   }


}
// if(new_table == true){
// current_lap = current_lap+1;
// new_table =false;
// }
	}
	catch (Exception e){
	System.out.println("classification non presente");
	}
	
    }
    catch (Exception e) {
        e.printStackTrace();
System.out.println("eccezione in readXml");
    }
}
public static String getNode(String tag, Element element){
	NodeList compId = element.getElementsByTagName(tag);
        Element line = (Element) compId.item(0);
// 	System.out.println("Id Comp : "+getCharacterDataFromElement(line));
	return getCharacterDataFromElement(line);
}
 public static String getCharacterDataFromElement(Element e) {
    Node child = e.getFirstChild();
    if (child instanceof CharacterData) {
       CharacterData cd = (CharacterData) child;
       return cd.getData();
    }
    return "-";
  }

public void connect(){

}

public static void main(String[] args){
screenTv s= new screenTv(args[0]);
// corbaloc = args[0];
s.start();
}
}

class dati{
public int lap;
public int id;
public int position;
public dati(int lapIn, int idIn, int positionIn){
lap = lapIn;
id = idIn;
position = positionIn;

}
}
