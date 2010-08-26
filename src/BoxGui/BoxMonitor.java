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
private JTextField textBoxTyre = new JTextField("",15);

private JLabel labelGas = new JLabel(" l / km ");
private JLabel labelTyre = new JLabel(" % / km ");
private JLabel labelGasExpl = new JLabel("Mean Fuel Consumption");
private JLabel labelTyreExpl = new JLabel("Mean Tyre Consumption");

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
private Double meandSpeedValue;
private Double meanTyreUsuryValue;
private Double meanGasConsumption;

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
textBoxTyre.setEditable(false);
meanPanelGrid = new GridBagConstraints();
meanPanel = new JPanel(new BorderLayout());
meanPanel.setLayout(new GridBagLayout());
meanPanel.setBorder(BorderFactory.createTitledBorder(null, "Consumption means", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));

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
		meanPanel.add(labelTyreExpl, meanPanelGrid);

meanPanelGrid.fill = GridBagConstraints.HORIZONTAL;
		meanPanelGrid.gridx = 0;
		meanPanelGrid.gridy = 3;
		meanPanelGrid.ipady = 5;
		meanPanel.add(textBoxTyre, meanPanelGrid);
meanPanelGrid.fill = GridBagConstraints.HORIZONTAL;
		meanPanelGrid.gridx = 1;
		meanPanelGrid.gridy = 3;
		meanPanelGrid.ipady = 5;
		meanPanel.add(labelTyre, meanPanelGrid);

}

public void createTableOutput(){
// tablePanel = new JScrollPane();
// ScrollPaneLayout o = new ScrollPaneLayout();
// tablePanel.setLayout(o);
// outTable = new JTable(model);
// // Create a couple of columns 
model.addColumn("Id Row");
model.addColumn("Id Comp"); 
model.addColumn("Lap");
model.addColumn("Sector");
model.addColumn("Fuel Level");
model.addColumn("Tyre Usury");
model.addColumn("Time");
// // Append a row 
// model.addRow(new Object[]{"v1", "v2"}); 
// // there are now 2 rows with 2 columns 
// // Append a row with fewer values than columns. 
// // The left-most fields in the new row are populated 
// // with the supplied values (left-to-right) and fields 
// // without values are set to null. 
// // model.addRow(new Object[]{"v1"}); 
// // there are now 3 rows with 2 columns 
// // Append a row with more values than columns. 
// // The extra values are ignored. 
// /*model.addRow(new Object[]{"v1", "v2", "v3"});*/ 
// o.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED );
// o.addLayoutComponent(JScrollPane.COLUMN_HEADER ,outTable);

outTable = new JTable(model);
// outTable = new JTable(0,5);
// outTable.setAutoResizeMode (JTable.AUTO_RESIZE_OFF);
tablePanel = new JScrollPane(outTable);
// tablePanel.getViewport().add(outTable);
tablePanel.setVerticalScrollBar(new JScrollBar());
// outTable.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
// tablePanel.validate();


}

// public void addInfo(Box_Monitor_Radio comp_radio, short i, org.omg.CORBA.FloatHolder j){
// while(true){
// String temp = comp_radio.GetUpdate(i,j);
// // outArea.append("\ntemp = "+temp);
// model.insertRow(0,new Object[]{temp, "1",j.value, "", "150.3", "10.0 %", "150.0"});
// // model.addRow(new Object[]{i.toString(), "1","2"});
// ListSelectionModel selectionModel = outTable.getSelectionModel();
// selectionModel.setSelectionInterval(0,0);
// i=(short)(i+1);
// }
// }

public void run(){
createBoxOutput();
createConsumptionMeans();
createTableOutput();
parent.add(tablePanel, BorderLayout.EAST);
parent.add(outPanel,BorderLayout.WEST);
parent.add(meanPanel,BorderLayout.NORTH);
// JButton startButton = new JButton("Aggiungi Riga");
// 		startButton.addActionListener(new ActionListener() {
// 			public void actionPerformed(ActionEvent e) {
// Integer t = new Integer(i/3);
// Integer q = new Integer(i%3);
// model.insertRow(0,new Object[]{i.toString(), "1",t.toString(), q.toString(), "150.3", "10.0 %", "150.0"});
// // model.addRow(new Object[]{i.toString(), "1","2"});
// ListSelectionModel selectionModel = outTable.getSelectionModel();
// selectionModel.setSelectionInterval(0,0);
// 
// System.out.println("casnio");
// i=i+1;
// 			}
// 		});
// parent.add(startButton, BorderLayout.SOUTH);

parent.pack();
parent.setVisible(true);
parent.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
try{
org.omg.CORBA.Object obj = orb.string_to_object(configuratorCorbaLoc);
outArea.setText("Pre narrow");
// Box_Monitor_Radio comp = Box_Monitor_RadioHelper.narrow(obj);
Configurator conf = ConfiguratorHelper.narrow(obj);
outArea.append("\nConf initialized, invoke configure");
// System.out.println("Conf init");
//invoco il metodo configure
// if (conf != null){
// System.out.println("Conf != null");
conf.Configure("obj/boxConfig-"+id+".xml");
// }
// System.out.println("After configure");
outArea.append("\nAfter configure");
// for(short i=0; i<100; i++){
// // ritorno = comp.GetUpdate(i);
// Short s = new Short(i);
// model.insertRow(0,new Object[]{s.toString(), "1","t.toString()", "q.toString()", "150.3", "10.0 %", ritorno});
// // model.addRow(new Object[]{i.toString(), "1","2"});
// ListSelectionModel selectionModel = outTable.getSelectionModel();
// selectionModel.setSelectionInterval(0,0);
// 
// System.out.println("casnio");
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
catch (Exception e){
System.out.println("Connessione con il BoxRadioHelper rifiutata");
JOptionPane.showMessageDialog(parent, "Attention : connection refused by BoxRadioHelper", "Error", JOptionPane.ERROR_MESSAGE);
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

	int i=0;
        Element element = (Element) nodes.item(i);
        NodeList gasLevel = element.getElementsByTagName("gasLevel");
        Element line = (Element) gasLevel.item(0);
//            System.out.println("gasLevel: " + getCharacterDataFromElement(line));
	gasLevelValue = new Double(getCharacterDataFromElement(line));
        
	NodeList tyreUsury = element.getElementsByTagName("tyreUsury");
        line = (Element) tyreUsury.item(0);
//            System.out.println("tyreUsury: " + getCharacterDataFromElement(line));
	tyreUsuryValue = new Double(getCharacterDataFromElement(line));

	NodeList lap = element.getElementsByTagName("lap");
        line = (Element) lap.item(0);
        System.out.println("lap: " + getCharacterDataFromElement(line));
	lapsValue = new Integer(getCharacterDataFromElement(line));

        NodeList sector = element.getElementsByTagName("sector");
        line = (Element) sector.item(0);
//            System.out.println("sector: " + getCharacterDataFromElement(line));
	sectorValue = new Integer(getCharacterDataFromElement(line));

        NodeList metres = element.getElementsByTagName("metres");
        line = (Element) metres.item(0);
//            System.out.println("metres: " + getCharacterDataFromElement(line));
	metresValue = new Double(getCharacterDataFromElement(line));
/*
	NodeList meanSpeed = element.getElementsByTagName("meandSpeed");
        line = (Element) meandSpeed.item(0);
//            System.out.println("metres: " + getCharacterDataFromElement(line));
	meanSpeedValue = new Double(getCharacterDataFromElement(line));

	NodeList meanTyreUsury = element.getElementsByTagName("meanTyreUsury");
        line = (Element) meandSpeed.item(0);
//            System.out.println("metres: " + getCharacterDataFromElement(line));
	meanTyreUsuryValue = new Double(getCharacterDataFromElement(line));

	NodeList meanGasConsumption = element.getElementsByTagName("meanGasConsumption");
        line = (Element) meandSpeed.item(0);
//            System.out.println("metres: " + getCharacterDataFromElement(line));
	meanGasConsumptionValue = new Double(getCharacterDataFromElement(line));*/

    }
    catch (Exception e) {
        e.printStackTrace();
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