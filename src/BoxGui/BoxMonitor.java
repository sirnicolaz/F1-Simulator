import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import javax.swing.table.*;
// import java.awt.Dialog.*;
import javax.swing.JDialog.*;
import java.awt.Rectangle;

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

public class BoxMonitor extends Thread{
private Integer i= new Integer(0);
private Integer laps;
private String id;
private JFrame parent;
private JTextArea outArea;

private JPanel outPanel;
private JPanel meanPanel;

private JScrollPane tablePanel;

private JTable outTable;

public DefaultTableModel model = new DefaultTableModel(); 

private GridBagConstraints meanPanelGrid;

private JTextField textBoxGas = new JTextField("",15);
private JTextField textBoxVel = new JTextField("",15);

private JLabel labelGas = new JLabel(" l / km ");
private JLabel labelVel = new JLabel(" km / h ");
private JLabel labelGasExpl = new JLabel("Mean Fuel Consumption");
private JLabel labelVelExpl = new JLabel("Mean Speed");

private String boxCorbaLoc;
private String monitorBoxCorbaLoc;
private String configuratorCorbaLoc;
private String monitorCorbaLoc;
private ORB orb;
private String ritorno = new String();

private Double gasLevelValue;
private Double tyreUsuryValue;
private Integer sectorValue;
private Integer lapsValue;
private Double metresValue;
private Double meanSpeedValue;
private Double meanTyreUsuryValue;
private Double meanGasConsumptionValue;
private String styleValue;
private String tyreValue;
private Double gasLevelStrategyValue;
private Integer pitstopLapValue;
private Double pitstopDelayValue;

public BoxMonitor(String id_In){
id=id_In;
parent = new JFrame("BoxMonitor n° "+id_In);
// init();
}

public void createBoxOutput(){
outPanel = new JPanel(new BorderLayout());
outPanel.setLayout(new FlowLayout());
outPanel.setBorder(BorderFactory.createTitledBorder(null, "Box Output", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
// boxConfigurationGrid = new GridBagConstraints();
// outArea = new JTextArea(35,30);
outArea = new JTextArea(25,20);
outPanel.add(outArea);
}
public void createConsumptionMeans(){

textBoxGas.setEditable(false);
textBoxVel.setEditable(false);
meanPanelGrid = new GridBagConstraints();
meanPanel = new JPanel(new BorderLayout());
meanPanel.setLayout(new GridBagLayout());
meanPanel.setBorder(BorderFactory.createTitledBorder(null, "Means", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));

meanPanelGrid.fill = GridBagConstraints.HORIZONTAL;
		meanPanelGrid.gridx = 0;
		meanPanelGrid.gridy = 0;
		meanPanelGrid.ipady = 5;
		meanPanel.add(labelGasExpl, meanPanelGrid);

meanPanelGrid.fill = GridBagConstraints.HORIZONTAL;
		meanPanelGrid.gridx = 0;
		meanPanelGrid.gridy = 1;
		meanPanelGrid.ipady = 5;
		meanPanel.add(textBoxGas, meanPanelGrid);
meanPanelGrid.fill = GridBagConstraints.HORIZONTAL;
		meanPanelGrid.gridx = 1;
		meanPanelGrid.gridy = 1;
		meanPanelGrid.ipady = 5;
		meanPanel.add(labelGas, meanPanelGrid);

meanPanelGrid.fill = GridBagConstraints.HORIZONTAL;
		meanPanelGrid.gridx = 0;
		meanPanelGrid.gridy = 2;
		meanPanelGrid.ipady = 5;
		meanPanel.add(labelVelExpl, meanPanelGrid);

meanPanelGrid.fill = GridBagConstraints.HORIZONTAL;
		meanPanelGrid.gridx = 0;
		meanPanelGrid.gridy = 3;
		meanPanelGrid.ipady = 5;
		meanPanel.add(textBoxVel, meanPanelGrid);
meanPanelGrid.fill = GridBagConstraints.HORIZONTAL;
		meanPanelGrid.gridx = 1;
		meanPanelGrid.gridy = 3;
		meanPanelGrid.ipady = 5;
		meanPanel.add(labelVel, meanPanelGrid);

}

public void createTableOutput(){
model.addColumn("Id Row");
model.addColumn("Id Comp"); 
model.addColumn("Lap");
model.addColumn("Sector");
model.addColumn("Fuel Level");
model.addColumn("Tyre Usury");
model.addColumn("Time");

outTable = new JTable(model);
// outTable = new JTable(0,5);
// outTable.setAutoResizeMode (JTable.AUTO_RESIZE_OFF);
tablePanel = new JScrollPane(outTable);
// tablePanel.getViewport().add(outTable);
tablePanel.setVerticalScrollBar(new JScrollBar());
// outTable.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
// tablePanel.validate();


}

public void run(){
createBoxOutput();
createConsumptionMeans();
createTableOutput();
parent.add(tablePanel, BorderLayout.EAST);
parent.add(outPanel,BorderLayout.WEST);
parent.add(meanPanel,BorderLayout.NORTH);

parent.pack();
parent.setVisible(true);
parent.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
try{
org.omg.CORBA.Object obj = orb.string_to_object(configuratorCorbaLoc);
outArea.setText("Pre narrow");
Configurator conf = ConfiguratorHelper.narrow(obj);
outArea.append("\nConf initialized, invoke configure");
conf.Configure("obj/boxConfig-"+id+".xml");
outArea.append("\nAfter configure");
outArea.append("\n pre string_to_object");
org.omg.CORBA.Object obj_radio = orb.string_to_object(monitorBoxCorbaLoc);
outArea.append("\n pre narrow box_monitor");
Box_Monitor_Radio comp_radio = Box_Monitor_RadioHelper.narrow(obj_radio);
outArea.append("\npre getupdate");
short i=1;
short qee=1;
org.omg.CORBA.FloatHolder j=new org.omg.CORBA.FloatHolder(0);
String temp;
while(i<=laps*3){
temp = comp_radio.GetUpdate(i,j);
readXml(temp);
if(j.value == -1){
model.insertRow(0,new Object[]{i,id,lapsValue,sectorValue,gasLevelValue,tyreUsuryValue, "RITIRED"});
ListSelectionModel selectionModel = outTable.getSelectionModel();
selectionModel.setSelectionInterval(0,0);
i=(short)((laps*3)+1);
}
else{model.insertRow(0,new Object[]{i,id,lapsValue, sectorValue, gasLevelValue, tyreUsuryValue, j.value});
ListSelectionModel selectionModel = outTable.getSelectionModel();
selectionModel.setSelectionInterval(0,0);
System.out.println(temp);
textBoxGas.setText(meanGasConsumptionValue.toString());//aggiorno consumo medio
textBoxVel.setText(meanSpeedValue.toString());//aggiorno velocità media
outArea.setText("Strategy:");
outArea.append("Laps to pitstop : "+pitstopLapValue.toString());
outArea.append("Style of guide : "+ styleValue);
i=(short)(i+1);
System.out.println("after run invoke");
this.sleep(1000);
// parent.repaint();
// }
}
 }
model.insertRow(0,new Object[]{"---", "---","---", "---", "---", "---", "---"});
ListSelectionModel selectionModel = outTable.getSelectionModel();
selectionModel.setSelectionInterval(0,0);

}
catch(NullPointerException e){
e.printStackTrace();
JOptionPane.showMessageDialog(parent, "Attention : NullPointerException", "Error", JOptionPane.ERROR_MESSAGE);
}
// catch()
catch (Exception e){
System.out.println("Eccezione");
JOptionPane.showMessageDialog(parent, "Attention : Exception", "Error", JOptionPane.ERROR_MESSAGE);
e.printStackTrace();
}
}


public void init(String boxCorbaLocIn, String monitorBoxCorbaLocIn, String configuratorCorbaLocIn, String monitorCorbaLocIn, ORB orbIn, short lapsIn){
System.out.println("BoxMonitor.init");
boxCorbaLoc = boxCorbaLocIn;
monitorBoxCorbaLoc = monitorBoxCorbaLocIn;
configuratorCorbaLoc = configuratorCorbaLocIn;
monitorCorbaLoc = monitorCorbaLocIn;
orb = orbIn;
laps = new Integer(lapsIn);
}

public void readXml(String xmlRecords){
// String xmlRecords ="<?xml version=\"1.0\"?><update><gasLevel>35.58887482</gasLevel><!--prova--><tyreUsury>17.07367134</tyreUsury><lap>18</lap><sector>3</sector><metres>686.00000000</metres></update>";
    try {
        DocumentBuilderFactory dbf =
            DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        InputSource is = new InputSource();
        is.setCharacterStream(new StringReader(xmlRecords));

        Document doc = db.parse(is);
        NodeList nodes = doc.getElementsByTagName("update");

	int i=1;
        Element element = (Element) nodes.item(i);
        NodeList gasLevel = element.getElementsByTagName("gasLevel");
        Element line = (Element) gasLevel.item(0);
	gasLevelValue = new Double(getCharacterDataFromElement(line));
System.out.println("gaslevelvalue : "+gasLevelValue);
        
	NodeList tyreUsury = element.getElementsByTagName("tyreUsury");
        line = (Element) tyreUsury.item(0);
	tyreUsuryValue = new Double(getCharacterDataFromElement(line));
System.out.println("tyre usury : "+tyreUsuryValue);

	NodeList lap = element.getElementsByTagName("lap");
        line = (Element) lap.item(0);
        System.out.println("lap: " + getCharacterDataFromElement(line));
	lapsValue = new Integer(getCharacterDataFromElement(line));
System.out.println("laps : "+lapsValue);

        NodeList sector = element.getElementsByTagName("sector");
        line = (Element) sector.item(0);
	sectorValue = new Integer(getCharacterDataFromElement(line));
System.out.println("sector : "+sectorValue);

        NodeList metres = element.getElementsByTagName("metres");
        line = (Element) metres.item(0);
	metresValue = new Double(getCharacterDataFromElement(line));
System.out.println("metres : "+metresValue);

	NodeList meanSpeed = element.getElementsByTagName("meanSpeed");
        line = (Element) meanSpeed.item(0);
	meanSpeedValue = new Double(getCharacterDataFromElement(line));
System.out.println("meanspeed : "+meanSpeedValue);

	NodeList meanGasConsumption = element.getElementsByTagName("meanGasConsumption");
        line = (Element) meanGasConsumption.item(0);
	meanGasConsumptionValue = new Double(getCharacterDataFromElement(line));
System.out.println("meanGasConsumption :"+meanGasConsumptionValue);
try{

        NodeList nodes2 = doc.getElementsByTagName("strategy");
	Element element2 = (Element) nodes2.item(i);

	NodeList tyreType = element2.getElementsByTagName("tyreType");
        line = (Element) tyreType.item(0);
	tyreValue = new String(getCharacterDataFromElement(line));

        NodeList style = element2.getElementsByTagName("style");
        line = (Element) style.item(0);
	styleValue = new String(getCharacterDataFromElement(line));

	NodeList gasLevel2 = element2.getElementsByTagName("gasLevel");
        line = (Element) gasLevel2.item(0);
	gasLevelStrategyValue = new Double(getCharacterDataFromElement(line));

	NodeList pitStopLaps = element2.getElementsByTagName("pitStopLaps");
        line = (Element) pitStopLaps.item(0);
	pitstopLapValue = new Integer(getCharacterDataFromElement(line));

	NodeList pitStopDelay = element2.getElementsByTagName("pitStopDelay");
        line = (Element) pitStopDelay.item(0);
	pitstopDelayValue = new Double(getCharacterDataFromElement(line));
}
catch(Exception e){
System.out.println("strategia non presente");}
    }
    catch (Exception e) {
        e.printStackTrace();
System.out.println("eccezione in readXml");
    }
}
  public static String getCharacterDataFromElement(Element e) {
    Node child = e.getFirstChild();
    if (child instanceof CharacterData) {
       CharacterData cd = (CharacterData) child;
       return cd.getData();
    }
    return "-";
  }
// public static void main(String[] args){
// BoxMonitor b = new BoxMonitor(args[0]);
// b.init();
// }
}