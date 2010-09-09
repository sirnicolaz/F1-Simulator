package GUI.TV;

import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import javax.swing.table.*;

import javax.swing.JDialog.*;
import java.awt.Rectangle;
import java.util.Vector;

import java.util.Properties;
import org.omg.CORBA.ORB;
import org.omg.PortableServer.POA;
import org.omg.PortableServer.POAHelper;
import broker.radio.*;
import org.omg.CosNaming.NameComponent;
import org.omg.CosNaming.NamingContext;
import org.omg.CosNaming.NamingContextHelper;


import java.lang.*;
import javax.xml.parsers.*;
import org.xml.sax.InputSource;
import org.w3c.dom.*;

import java.lang.reflect.Array;

public class screenTv extends Thread implements TvPanelInterface{
private String[] nome;
private String[] cognome;
private String[] scuderia;
private String circuitName;
private int tentativi = 5;
private boolean inWhile = true;
private boolean[] endRace;// =  new boolean[]{false,false,false}; TODO
private boolean[] ritRace;//=  new boolean[]{false,false,false}; TODO
private classificationTable classTable = new classificationTable();
// private logBox log = new logBox();
private bestPerformance best = new bestPerformance();
private Competition_Monitor_Radio monitor;
private org.omg.CORBA.Object obj;
private int[] provaArray;// = new int[10];
private arrayDati[] storicodatiArray;// = new arrayDati[10]; TODO
private dati[] datiArray;// = new dati[3]; TODO
// private dati[] datiOldArray = new dati[5];
private JFrame parent;
private JPanel logPanel;
private GridBagConstraints gridLog = new GridBagConstraints();
private competitorLog[] infos;
// private JPanel infoUp = new JPanel();
private float updTime;

// private Integer lapNum= new Integer(0);

private DefaultTableModel model_1 = new DefaultTableModel(); 
private DefaultTableModel model_2 = new DefaultTableModel(); 
// private DefaultTableModel modelAll = new DefaultTableModel(); 

private FlowLayout f = new FlowLayout();
private GridBagConstraints classificGrid = new GridBagConstraints();

private DefaultTableModel[] modelClassific = new DefaultTableModel[]{model_1, model_2};
private int current_index =0;

private String corbaloc;
private ORB orb;
private int numComp;
private int numLap;
// private org.omg.CORBA.FloatHolder circuitLength = new org.omg.CORBA.FloatHolder();
private float lenghtCircuit;

private float[] arrayInfo;
private float[] arrayOldInfo;

//parsing xml
private Integer idCompetitor;
private String stateValue;
private Integer checkpointValue;
private Integer sectorValue;

private int current_lap =0;
private boolean new_table = false;

public screenTv(String corbalocIn, Competition_Monitor_Radio monitorIn, String nameType, float updTimeIn){
System.out.println("screenTv : 0");
parent = new JFrame(nameType);

corbaloc = corbalocIn;
monitor = monitorIn;
updTime = updTimeIn;
//effettua la connessione
}

public void readConfiguration(){
String xmlConfString;
Float circuitLength;
org.omg.CORBA.StringHolder xmlConf = new org.omg.CORBA.StringHolder();
try {
System.out.println("readConfiguration : 0 monitor = "+monitor);
circuitLength = monitor.Get_CompetitionConfiguration((short)1,xmlConf);
// monitor.ready((short)1);
// System.out.println("chiamo la get competitor info ... \n");
// String tempStr = monitor.Get_CompetitorInfo((short)1,(short)1,(short)1, circuitLength);
// System.out.println(tempStr);
System.out.println("readConfiguration : 1");
lenghtCircuit = circuitLength;//new Float(circuitLength.value).floatValue();
System.out.println("readConfiguration : 2");
xmlConfString = xmlConf.value;
System.out.println("readConfiguration : 3");
System.out.println(xmlConf.value);
        DocumentBuilderFactory dbf =
        DocumentBuilderFactory.newInstance();

 DocumentBuilder db = dbf.newDocumentBuilder();
        InputSource is = new InputSource();
        is.setCharacterStream(new StringReader(xmlConfString));

        Document doc = db.parse(is);

	NodeList nodes = doc.getElementsByTagName("competitionConfiguration");
	Element upd = (Element) nodes.item(0);

	numLap = new Integer(getNode("laps", upd)).intValue();
	numComp = new Integer(getNode("competitors", upd)).intValue();
	circuitName = getNode("name", upd);

endRace = new boolean[numComp];
ritRace = new boolean[numComp];
storicodatiArray = new arrayDati[numLap];
datiArray = new dati[numComp];
infos = new competitorLog[numComp];
for(int number = 0; number <numComp; number++){
endRace[number]= false;
ritRace[number]= false;
}
}
catch(Exception eccIn){
eccIn.printStackTrace();
}
}
public void writeDati(String xmlComp, int numCompetitor){
try{
        DocumentBuilderFactory dbf =  DocumentBuilderFactory.newInstance();

	DocumentBuilder db = dbf.newDocumentBuilder();
        InputSource is = new InputSource();
        is.setCharacterStream(new StringReader(xmlComp));

        Document doc = db.parse(is);

	NodeList nodes = doc.getElementsByTagName("competitorConfiguration");
	Element upd = (Element) nodes.item(0);

	nome[numCompetitor] = getNode("name", upd); 
	cognome[numCompetitor] = getNode("surname", upd);
	scuderia[numCompetitor] = getNode("team", upd);
}
catch(Exception eccIn){
eccIn.printStackTrace();
}
}
public void addLogInfo(){
logPanel = new JPanel(new BorderLayout());
logPanel.setLayout(new GridBagLayout());
logPanel.setBorder(BorderFactory.createTitledBorder(null, "Log Competition", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
logPanel.setPreferredSize(new Dimension(0,30+35*numComp));

// logPanel.updateUI();
}


public void run(){
System.out.println("run : 1");
readConfiguration();
System.out.println("run : 2");
classTable.addTables(model_1, model_2, numComp);
// log.addTablesAll(modelAll, numComp);
best.addBest();
System.out.println("run : 3");
addLogInfo();
System.out.println("run : 4");
parent.add(classTable.panel1, BorderLayout.CENTER);
// parent.add(best.bestPanel,BorderLayout.NORTH);
parent.add(best.getInfoUp(), BorderLayout.NORTH);
// parent.add(log.tablePanel, BorderLayout.SOUTH);
parent.add(logPanel, BorderLayout.SOUTH);
parent.pack();
parent.setVisible(true);
parent.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

try{
nome = new String[numComp];
cognome = new String[numComp];
scuderia = new String[numComp];
String xmlComp;

for(int index = 0; index<numComp; index++){
try{
xmlComp = monitor.Get_CompetitorConfiguration((short)(index+1));
System.out.println(xmlComp);
writeDati(xmlComp, index);

infos[index] = new competitorLog(" Id "+(index+1)+"  "+cognome[index]+" ");

gridLog.fill = GridBagConstraints.HORIZONTAL;
		gridLog.gridx = 0;
		gridLog.gridy = index;
		gridLog.ipady = 5;
		logPanel.add(infos[index].getName(),gridLog);
gridLog.fill = GridBagConstraints.HORIZONTAL;
		gridLog.gridx = 1;
		gridLog.gridy = index;
		gridLog.ipady = 5;
		logPanel.add(infos[index].getState(),gridLog);

gridLog.fill = GridBagConstraints.HORIZONTAL;
		gridLog.gridx = 2;
		gridLog.gridy = index;
		gridLog.ipady = 5;
		logPanel.add(infos[index].getCheckpoint(),gridLog);
gridLog.fill = GridBagConstraints.HORIZONTAL;
		gridLog.gridx = 3;
		gridLog.gridy = index;
		gridLog.ipady = 5;
		logPanel.add(infos[index].getSector(),gridLog);
gridLog.fill = GridBagConstraints.HORIZONTAL;
		gridLog.gridx = 4;
		gridLog.gridy = index;
		gridLog.ipady = 5;
		logPanel.add(infos[index].getLap(),gridLog);
model_1.insertRow(index,new Object[]{index+1, "---","---","---","---"});
model_2.insertRow(index,new Object[]{index+1, "---","---","---","---"});
logPanel.updateUI();
}
catch(Exception debug){
// String temp = debug.getStackTrace();
JOptionPane.showMessageDialog(parent,debug.getStackTrace(), "Error",JOptionPane.ERROR_MESSAGE);
}
// modelAll.insertRow(index,new Object[]{(index+1)+" : "+cognome[index], "---","---","---","---","---"});
}

for(int i=0; i<Array.getLength(storicodatiArray);i++){
storicodatiArray[i] = new arrayDati(new dati[numComp]);
}
/*for(int numCompetitor =0; numCompetitor<numComp; numCompetitor++){

}*/
float interval = updTime;
current_lap=0;
// float q =(float)1.0;
int i=0;
// if(connect()!= true){
// System.out.println("ERRORE DI CONNESSIONE");
// inWhile=false;
// JOptionPane.showMessageDialog(parent, "Connection Error", "Error",JOptionPane.ERROR_MESSAGE);
// parent.dispose();
// }
while(inWhile){
try{
boolean exit=true;
org.omg.CORBA.StringHolder updateString = new org.omg.CORBA.StringHolder();
arrayInfo = monitor.Get_CompetitionInfo(updTime, updateString);
// lapNum = (int)q;
readXml(updateString.value);//, q);
best.setClock("Time "+convert(updTime));
for(int r=0; r<Array.getLength(datiArray);r++){
try{
System.out.println("DEBUG : ITERAZIONE r = "+r);
System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ --- datiArray["+r+"] .id= "+datiArray[r].id+" ,  lap = "+datiArray[r].lap+" , position = "+datiArray[r].position);
//se esiste la cella devo
//1-controllare di non averla già inserita
//2-se già inserite saltare, altrimenti scriverla
//3-se ho un nuovo lap scrivere i doppiati in quella del lap precedente
//4-inizializzare il nuovo campo dell'array
if(datiArray[r].lap == current_lap){
System.out.println("datiArray["+r+"].lap == current_lap ==" +current_lap);
System.out.println("lap "+datiArray[r].lap);
System.out.println(" id "+datiArray[r].id);
System.out.println("position "+datiArray[r].position);


storicodatiArray[current_lap].arrayD[r]=new dati(datiArray[r].lap, datiArray[r].id, datiArray[r].position);
System.out.println("dopo scrittura ");
}
if(datiArray[r].lap > current_lap){//qualcuno ha iniziato un nuovo giro
if(new_table==false){new_table=true;}
System.out.println("datiArray["+r+"].lap > current_lap ==" +current_lap);
if (storicodatiArray[current_lap].arrayD == null){storicodatiArray[current_lap].arrayD = new dati[3];}
//salvo il nuovo giroarrayD[3]
System.out.println("lap "+datiArray[r].lap);
System.out.println(" id "+datiArray[r].id);
System.out.println("position"+datiArray[r].position);
storicodatiArray[current_lap+1].arrayD[r]= new dati(datiArray[r].lap, datiArray[r].id, datiArray[r].position);
System.out.println("dopo scrittura ");
//salvo un boolean per sapere che devo scrivere i doppiati

}
if(datiArray[r].lap < current_lap && new_table == true){
if (storicodatiArray[current_lap].arrayD == null){storicodatiArray[current_lap].arrayD = new dati[3];}
System.out.println("datiArray["+r+"].lap < current_lap ==" +current_lap+" && new_table == true");
//inserisco i doppiati
System.out.println("lap "+datiArray[r].lap);
System.out.println(" id "+datiArray[r].id);
System.out.println("position"+datiArray[r].position);

// storicodatiArray[current_lap].arrayD[datiArray[r].position]=new dati(datiArray[r].lap, datiArray[r].id, datiArray[r].position);
storicodatiArray[current_lap].arrayD[r]=new dati(datiArray[r].lap, datiArray[r].id, datiArray[r].position);
System.out.println("dopo scrittura ");
}
}
catch(Exception e ){
System.out.println("ecc in salvataggio");
e.printStackTrace();
r=Array.getLength(datiArray) +1;
}
}

System.out.println("Classifica : ");
boolean new_table_temp = new_table;
for(int e=0; e<Array.getLength(storicodatiArray); e++){
// for(int w=0; w<=current_lap; w++){
try{
if(new_table_temp==true){
for(int w=modelClassific[current_index].getRowCount(); w<Array.getLength(storicodatiArray[current_lap].arrayD);w++){//scrivo tutta la classifica prima
try{

int lapGap = storicodatiArray[current_lap+1].arrayD[0].lap - storicodatiArray[current_lap].arrayD[w].lap;
if (lapGap == 1){
modelClassific[current_index].addRow(new Object[]{storicodatiArray[current_lap].arrayD[w].position,cognome[storicodatiArray[current_lap].arrayD[w].id]," + "+lapGap+" giro"});
}
else{
modelClassific[current_index].addRow(new Object[]{storicodatiArray[current_lap].arrayD[w].position,cognome[storicodatiArray[current_lap].arrayD[w].id]," + "+lapGap+" giri"});

}
}catch(Exception exx){
exx.printStackTrace();
}
}/*
		bestGrid.gridx = 4;
		bestGrid.gridy = 0;*/
classTable.invert(current_index, new Integer(current_lap+1));
current_index=(current_index+1)%2;
current_lap=current_lap+1;
new_table_temp = false;
for(int w=0; w<modelClassific[current_index].getRowCount();w++){//rimuovo la vecchia classifica scritta su questa tabella.
System.out.println("DEBUG : RIMOZIONE VECCHIA CLASSIFICA "+w);
modelClassific[current_index].removeRow(w);
}
}
modelClassific[current_index].insertRow(e,new Object[]{storicodatiArray[current_lap].arrayD[e].position,cognome[storicodatiArray[current_lap].arrayD[e].id-1],/*storicodatiArray[current_lap].arrayD[e].lap,*/ convert(arrayInfo[e])});

modelClassific[current_index].removeRow(e+1);

System.out.println("lap = "+current_lap+" , id = "+storicodatiArray[current_lap].arrayD[e].id);
}
catch(Exception ecc){System.out.println("ecc");
ecc.printStackTrace();
e= Array.getLength(storicodatiArray)+1;
}
}

if(new_table == true){
System.out.println("CURRENT LAP  +1 = (OLD)"+current_lap);
new_table = false;
}

// q=(float)(q+1);
updTime = updTime + interval;
// sleep(250);
for(int boolArray=0; boolArray<Array.getLength(endRace); boolArray++){
if(endRace[boolArray]==false){//controllo se tutti hanno finito la gara
exit=false;
boolArray=Array.getLength(endRace)+1;
}
}
if(exit==false){//se non tutti hanno finito continua altrimenti esci dal ciclo
inWhile=true;
}
else{inWhile=false;
JOptionPane.showMessageDialog(parent, "Race over", "Messagge from competition",JOptionPane.INFORMATION_MESSAGE);
};
}
catch(org.omg.CORBA.COMM_FAILURE connEcc){
JOptionPane.showMessageDialog(parent, "Attention : problem with connection..attend 3 seconds\n remaining attempts = "+tentativi,"Connection Error",JOptionPane.ERROR_MESSAGE);
if(tentativi == 0 ){
inWhile=false;
}
tentativi = tentativi -1;
this.sleep(3000);
}
}
}
catch(Exception e){e.printStackTrace();}
}
// parsing xml
public void readXml(String xmlRecords){//, float istant){
System.out.println("stringa da parsare : \n"+xmlRecords);
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

	Attr attributoComp =  line.getAttributeNode("id");//(Attr) attributiComp.item(0);

	Attr attributoCompEnd =  line.getAttributeNode("end");//(Attr) attributiComp.item(0);

	Attr attributoCompRit =  line.getAttributeNode("retired");//(Attr) attributiComp.item(0);

	System.out.println("attributo id : "+attributoComp.getNodeValue());
	
	NodeList check = element.getElementsByTagName("checkpoint");
        line = (Element) check.item(0);

	Attr attributoCheck =  line.getAttributeNode("compPosition");//(Attr) attributiCheck.item(0);
	System.out.println("attributo checkpoint "+getCharacterDataFromElement(line)+" : "+attributoCheck.getNodeValue());
String temp = attributoCheck.getNodeValue();
	Attr attributoCheck_2 = line.getAttributeNode("pitstop");
	System.out.println("attributo checkpoint "+getCharacterDataFromElement(line)+" : "+attributoCheck_2.getNodeValue());
	System.out.println("lap : "+getNode("lap", element));
	System.out.println("sector : "+getNode("sector", element));
if(attributoCheck_2.getNodeValue().equals("TRUE")){// sono al pitstop?
//JOptionPane.showMessageDialog(parent, "Competitor ai box!", "Messagge from competition",JOptionPane.INFORMATION_MESSAGE);
System.out.println("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
if(new Integer(getNode("checkpoint",element)).intValue() == 1){
if (temp.equals("arriving")){
// modelAll.removeRow(new Integer(attributoComp.getNodeValue()).intValue()-1);
/*modelAll.insertRow(new Integer(attributoComp.getNodeValue()).intValue()-1,new Object[]{cognome[new Integer(attributoComp.getNodeValue()).intValue()-1],getNode("checkpoint", element), "BOX", getNode("lap", element),  "leaving box", convert(istant)});*/
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setLap(getNode("lap", element));
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setState(" leaving box ");
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setCheckpoint(getNode("checkpoint", element));
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setSector(" Box ");
// JOptionPane.showMessageDialog(parent, "Competitor ai box!","Messagge from competition",JOptionPane.INFORMATION_MESSAGE);
}
else{
/*modelAll.removeRow(new Integer(attributoComp.getNodeValue()).intValue()-1);
modelAll.insertRow(new Integer(attributoComp.getNodeValue()).intValue()-1,new Object[]{cognome[new Integer(attributoComp.getNodeValue()).intValue()-1],getNode("checkpoint", element), "BOX", getNode("lap", element),  "in box", convert(istant)});
*/
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setLap(getNode("lap", element));
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setState(" in box ");
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setCheckpoint(getNode("checkpoint", element));
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setSector(" Box ");
// JOptionPane.showMessageDialog(parent, "Competitor ai box!", "Messagge from competition",JOptionPane.INFORMATION_MESSAGE);
}
}
}
// System.out.println("ATTRIBUTO END = "+attributoCompEnd.getValue());
int ind = new Integer(attributoComp.getNodeValue()).intValue();
if(attributoCompEnd.getValue().equals("TRUE")){
// System.out.println(" FINE GARA = TRUE ");
// JOptionPane.showMessageDialog(parent, "Concorrente "+attributoComp.getNodeValue()+" FINE GARA","Messagge from competition",JOptionPane.INFORMATION_MESSAGE);

// modelAll.removeRow(new Integer(attributoComp.getNodeValue()).intValue()-1);
// modelAll.insertRow(new Integer(attributoComp.getNodeValue()).intValue()-1,new Object[]{cognome[new Integer(attributoComp.getNodeValue()).intValue()-1],getNode("checkpoint",element),getNode("sector", element), getNode("lap", element), "FINE GARA ", convert(istant)});
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setLap(getNode("lap", element));
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setState(" End Race ");
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setCheckpoint(getNode("checkpoint", element));
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setSector(getNode("sector", element));

if(endRace[ind-1]== false){
//JOptionPane.showMessageDialog(parent, "Fine gara per il concorrente "+cognome[new Integer(attributoComp.getNodeValue()).intValue()-1],"Messagge from competition",JOptionPane.INFORMATION_MESSAGE);
endRace[ind-1] = true;
}
}
else {
if(attributoCompRit.getValue().equals("TRUE")){
if(ritRace[ind-1]== false){
//JOptionPane.showMessageDialog(parent, "Concorrente "+cognome[new Integer(attributoComp.getNodeValue()).intValue()-1]+" RITIRATO","Messagge from competition",JOptionPane.INFORMATION_MESSAGE);
ritRace[ind-1] = true;
}

// modelAll.removeRow(new Integer(attributoComp.getNodeValue()).intValue()-1);
// modelAll.insertRow(new Integer(attributoComp.getNodeValue()).intValue()-1,new Object[]{cognome[new Integer(attributoComp.getNodeValue()).intValue()-1],getNode("checkpoint", element), getNode("sector", element), getNode("lap", element), "RITIRATO", convert(istant)});
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setLap(getNode("lap", element));
if(temp.equals("arriving")){
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setState(" Ritired while arriving ");}
else{
if(temp.equals("passed")){
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setState(" Ritired after passing ");}
else{
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setState(" Ritired on ");}
}
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setCheckpoint(getNode("checkpoint", element));
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setSector(getNode("sector", element));
// JOptionPane.showMessageDialog(parent, "Concorrente "+attributoComp.getNodeValue()+" RITIRATO","Messagge from competition",JOptionPane.INFORMATION_MESSAGE);
}

else{
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setLap(getNode("lap", element));
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setState(temp);
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setCheckpoint(getNode("checkpoint", element));
infos[new Integer(attributoComp.getNodeValue()).intValue()-1].setSector(getNode("sector", element));
/*modelAll.removeRow(new Integer(attributoComp.getNodeValue()).intValue()-1);
modelAll.insertRow(new Integer(attributoComp.getNodeValue()).intValue()-1,new Object[]{cognome[new Integer(attributoComp.getNodeValue()).intValue()-1],getNode("checkpoint", element), getNode("sector", element), getNode("lap", element),  attributoCheck.getNodeValue(), convert(istant)});*/

// modelAll.removeRow(new Integer(attributoComp.getNodeValue()).intValue());
	}
}
}	
System.out.println("bestTimes");
	NodeList bestT = doc.getElementsByTagName("bestTimes");
        Element element = (Element)bestT.item(0);
	
	NodeList lap = element.getElementsByTagName("lap");
        Element line = (Element) lap.item(0);
	NamedNodeMap attributiLap =line.getAttributes();


	Attr attributoLap = (Attr) attributiLap.item(0);
	System.out.println("attributo lap "+getCharacterDataFromElement(line)+" : "+attributoLap.getNodeValue());
if(new Integer(attributoLap.getNodeValue()).intValue() !=-1){
Float f=new Float(getNode("time", element));

	best.setBestLap(attributoLap.getNodeValue(),convert(f.floatValue()), getNode("competitorId", element));
/*textBoxLap.setText(attributoLap.getNodeValue());
	System.out.println("time : "+getNode("time", element));
textBoxLapTime.setText(getNode("time", element));
	System.out.println("competitor Id : "+getNode("competitorId", element));
textBoxLapId.setText(getNode("competitorId", element));*/
}

	
	NodeList bestSector = doc.getElementsByTagName("sectors");
        element = (Element)bestSector.item(0);

	NodeList sector = element.getElementsByTagName("sector");
        line = (Element) sector.item(0);
	NamedNodeMap attributiSector =line.getAttributes();
	Attr attributoSector = (Attr) attributiSector.item(0);
	System.out.println("attributo sector 1 "+getCharacterDataFromElement(line)+" : "+attributoSector.getNodeValue());
	System.out.println("--time : "+getNode("time", line));

	System.out.println("--id : "+getNode("competitorId", line));
if(new Double(getNode("time",line)).intValue() !=-1.0){	
Float f=new Float(getNode("time", line));
best.setBestSector(1, getNode("competitorId", line), getNode("lap", line), convert(f.floatValue()));
/*textBoxSector1Id.setText(getNode("competitorId", line));
textBoxSector1Lap.setText(getNode("lap", line));
textBoxSector1Id.setText(getNode("competitorId", line));
textBoxSector1Time.setText(getNode("time", line));	*/
}
	sector = element.getElementsByTagName("sector");
        line = (Element) sector.item(1);
	attributiSector =line.getAttributes();
	attributoSector = (Attr) attributiSector.item(0);
	System.out.println("attributo sector 2 "+getCharacterDataFromElement(line)+" : "+attributoSector.getNodeValue());
	System.out.println("--time : "+getNode("time", line));
	System.out.println("--id : "+getNode("competitorId", line));
if(new Double(getNode("time",line)).intValue() !=-1.0){	
Float f=new Float(getNode("time", line));
best.setBestSector(2, getNode("competitorId", line), getNode("lap", line), convert(f.floatValue()));
	
	}
	sector = element.getElementsByTagName("sector");
        line = (Element) sector.item(2);
	attributiSector =line.getAttributes();
	attributoSector = (Attr) attributiSector.item(0);
	System.out.println("attributo sector 3"+getCharacterDataFromElement(line)+" : "+attributoSector.getNodeValue());
	System.out.println("--time : "+getNode("time", line));
	System.out.println("--id : "+getNode("competitorId", line));
if(new Double(getNode("time",line)).intValue() !=-1.0){	
Float f=new Float(getNode("time", line));
best.setBestSector(3, getNode("competitorId", line), getNode("lap", line), convert(f.floatValue()));
}
	try{
	NodeList cl = doc.getElementsByTagName("classification");
        Element elementTemp = (Element)cl.item(0);
	
	NodeList comp42 =elementTemp.getElementsByTagName("competitor");
        Element compEl = (Element) comp42.item(0);
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

}
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

// public boolean connect(){
// System.out.println("Try to connect to Competition");
// try{
//  String[] temp = {"ORB"};
// orb = ORB.init(temp, null);
// obj = orb.string_to_object(corbaloc);
// monitor = Competition_Monitor_RadioHelper.narrow(obj);
// return true;
// }
// catch (Exception e){
// System.out.println("Eccezione");
// e.printStackTrace();
// return false;
// }
// }

public String convert(float timeIn){

int ore = (int)(timeIn/3600);
int minuti = (int)(timeIn/60);
int secondi = (int)(timeIn-(minuti*60+ore*3600));
int millesimi = (int)((timeIn - (minuti*60+ore*3600+secondi))*1000);
String time;
if(minuti<10){
if(secondi <10){
if(millesimi<10){
time = new String("0"+ore+":0"+minuti+":0"+secondi+":00"+millesimi);}
else if(millesimi<100){
time = new String("0"+ore+":0"+minuti+":0"+secondi+":0"+millesimi);}
else{
time = new String("0"+ore+":0"+minuti+":0"+secondi+":"+millesimi);}
}
else{
if(millesimi<10){
time = new String("0"+ore+":0"+minuti+":"+secondi+":00"+millesimi);}
else if(millesimi<100){
time = new String("0"+ore+":0"+minuti+":"+secondi+":0"+millesimi);}
else{
time = new String("0"+ore+":0"+minuti+":"+secondi+":"+millesimi);}
}
}
else{
if(secondi <10){
if(millesimi<10){
time = new String("0"+ore+":"+minuti+":0"+secondi+":00"+millesimi);}
else if(millesimi<100){
time = new String("0"+ore+":"+minuti+":0"+secondi+":0"+millesimi);}
else{
time = new String("0"+ore+":"+minuti+":0"+secondi+":"+millesimi);}
}
else{
if(millesimi<10){
time = new String("0"+ore+":"+minuti+":"+secondi+":00"+millesimi);}
else if(millesimi<100){
time = new String("0"+ore+":"+minuti+":"+secondi+":0"+millesimi);}
else{
time = new String("0"+ore+":"+minuti+":"+secondi+":"+millesimi);}
}}

return time;
}

// public static void main(String[] args){
// screenTv s= new screenTv(args[0]);
// // corbaloc = args[0];
// s.start();
// }
}

class dati{
public int lap=-1;
public int id=-1;
public int position=-1;
public dati(int lapIn, int idIn, int positionIn){
lap = lapIn;
id = idIn;
position = positionIn;
}
}
class arrayDati{
public arrayDati(dati[] a){
arrayD=a;
}
public dati[] arrayD;
}
//oggetto tabella con classifiche
class classificationTable{
private int tabellaCorrente =1;
private JTable classific_1;
private JTable classific_2;
private JScrollPane panelCl_1;
private JPanel classificPanel;
private JScrollPane panelCl_2;
public JPanel panel1;
private JPanel panelClass1;
private JPanel panelClass2;
private GridBagConstraints gridPanel = new GridBagConstraints();
private GridBagConstraints gridPanel2 = new GridBagConstraints();
private JLabel lap1 = new JLabel("Lap 0");
private JLabel lap2 = new JLabel("-");
public void invert(int i, Integer lap){
if(i==1){
panel1.add(panelClass2, BorderLayout.WEST);
panel1.add(panelClass1, BorderLayout.EAST);
// lap2.setText();
lap1.setText("Lap "+lap.toString());
}
else{
panel1.add(panelClass1, BorderLayout.WEST);
panel1.add(panelClass2, BorderLayout.EAST);
// lap1.setText(lapsx.getText());
lap2.setText("Lap "+lap.toString());

}
panel1.updateUI();
}

public void addTables(DefaultTableModel model_1, DefaultTableModel model_2, int compNum){
model_1.addColumn("Position");
model_1.addColumn("Competitor"); 
// model_1.addColumn("Lap");
model_1.addColumn("Time");
model_2.addColumn("Position");
model_2.addColumn("Competitor"); 
// model_2.addColumn("Lap");
model_2.addColumn("Time");
classific_1 = new JTable(model_1);
classific_2 = new JTable(model_2);

TableColumn column = null;
column = classific_1.getColumnModel().getColumn(0);
column.setPreferredWidth(20);
TableColumn column2 = null;
column2 = classific_2.getColumnModel().getColumn(0);
column2.setPreferredWidth(20);

panelCl_1 = new JScrollPane(classific_1);
panelCl_1.setPreferredSize(new Dimension(300, 70));// TODO : 35 moltiplicato per il numero di concorrenti, farsi passare numero concorrenti

panelCl_2 = new JScrollPane(classific_2);

panelCl_2.setPreferredSize(new Dimension(300, 70));// TODO : 35 moltiplicato per il numero di concorrenti, farsi passare numero concorrenti
panelCl_1.setVerticalScrollBar(new JScrollBar());
panelCl_1.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);

panelCl_2.setVerticalScrollBar(new JScrollBar());
panelCl_2.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);


panel1 = new JPanel(new BorderLayout());
/*panelClass1 = new JPanel();
panelClass2 = new JPanel();*/
panelClass1 = new JPanel(new BorderLayout());
panelClass1.add(lap1, BorderLayout.NORTH);
panelClass1.add(panelCl_1, BorderLayout.CENTER);
panelClass2 = new JPanel(new BorderLayout());
panelClass2.add(lap2, BorderLayout.NORTH);
panelClass2.add(panelCl_2, BorderLayout.CENTER);
// panelClass1.setLayout(new GridBagLayout());
// .setBorder(BorderFactory.createTitledBorder(null, "Log Competition", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));

// gridPanel.fill = GridBagConstraints.HORIZONTAL;
// 		gridPanel.gridx = 0;
// 		gridPanel.gridy = 0;
// 		gridPanel.ipady = 5;
// 		panelClass1.add(lap1,gridPanel);
// gridPanel.fill = GridBagConstraints.HORIZONTAL;
// 		gridPanel.gridx = 0;
// 		gridPanel.gridy = 1;
// 		gridPanel.ipady = 5;
// 		panelClass1.add(panelCl_1,gridPanel);

// panelClass2.setLayout(new GridBagLayout());
// .setBorder(BorderFactory.createTitledBorder(null, "Log Competition", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));

// gridPanel2.fill = GridBagConstraints.HORIZONTAL;
// 		gridPanel2.gridx = 0;
// 		gridPanel2.gridy = 0;
// 		gridPanel2.ipady = 5;
// 		panelClass2.add(lap2,gridPanel2);
// gridPanel2.fill = GridBagConstraints.HORIZONTAL;
// 		gridPanel2.gridx = 0;
// 		gridPanel2.gridy = 1;
// 		gridPanel2.ipady = 5;
// 		panelClass2.add(panelCl_2,gridPanel2);

// panel1.setLayout(new FlowLayout());
panel1.setBorder(BorderFactory.createTitledBorder(null, "Classific", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
// JOptionPane.showMessageDialog(null, "panelCl_1.getWidth() = "+panelCl_1.getWidth()+", panelCl_2.getWidth() = "+panelCl_2.getWidth(),"Messagge from competition",JOptionPane.INFORMATION_MESSAGE);
panel1.setPreferredSize(new Dimension(620  , 30+37*compNum));// TODO : 35 moltiplicato per il numero di concorrenti, farsi passare numero concorrenti
panel1.add(panelClass1, BorderLayout.CENTER);
panel1.add(panelClass2, BorderLayout.WEST);

}
}

//oggetto tabella di log
/*class logBox{*/
// private JTable tableAll;
/*public JPanel logPanel;
public GridBagLayout gridLog = GridBagLayout();*/
// private JScrollPane tableSPanel;

// public void addTablesAll(DefaultTableModel modelAll,int numComp){
// modelAll.addColumn("Competitor");
// modelAll.addColumn("Checkpoint");
// modelAll.addColumn("Sector");
// modelAll.addColumn("Lap");
// modelAll.addColumn("State");
// modelAll.addColumn("Time (h:m:s:mll)");
// 
// tableAll = new JTable(modelAll);
// tablePanel = new JPanel(new BorderLayout());
// tablePanel.setBorder(BorderFactory.createTitledBorder(null, "Competition Log", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
// tableSPanel = new JScrollPane(tableAll);
// if(numComp<=15){tableSPanel.setPreferredSize(new Dimension(0, 25*numComp));// TODO : 35 moltiplicato per il numero di concorrenti, farsi passare numero concorrenti
// }
// tableSPanel.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED);
// tablePanel.add(tableSPanel, BorderLayout.CENTER);
// 
// }
// public void addInfo(JPanel panelIn, GridBagConstraints grid){
// logPanel = panelIn;
// logPanel.setLayout(new GridBagLayout);
// logPanel.setBorder(BorderFactory.createTitledBorder(null, "Competition Log", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
// 
// }
// }

class bestPerformance{
private JPanel bestPanel;
private JPanel infoUp;

private GridBagConstraints bestGrid = new GridBagConstraints();
private JTextField textBoxLap = new JTextField("-",3);
private JTextField textBoxLapId = new JTextField("-",2);
private JTextField textBoxLapTime = new JTextField("-",10);
private JLabel labelLap = new JLabel("Best lap n° : ");
private JLabel labelLapId = new JLabel(" by competitor : ");
private JLabel labelLapTime = new JLabel(" in time : ");

private JTextField textBoxSector1Lap = new JTextField("-",3);
private JTextField textBoxSector1Id = new JTextField("-",2);
private JTextField textBoxSector1Time = new JTextField("-",10);
private JLabel labelSector1 = new JLabel("Best Sector 1 at lap n° : ");
private JLabel labelSector1Id = new JLabel(" by competitor : ");
private JLabel labelSector1Time = new JLabel(" in time : ");


private JTextField textBoxSector2Lap = new JTextField("-",3);
private JTextField textBoxSector2Id = new JTextField("-",2);
private JTextField textBoxSector2Time = new JTextField("-",10);
private JLabel labelSector2 = new JLabel("Best Sector 2 at lap n° : ");
private JLabel labelSector2Id = new JLabel(" by competitor : ");
private JLabel labelSector2Time = new JLabel(" in time : ");


private JTextField textBoxSector3Lap = new JTextField("-",3);
private JTextField textBoxSector3Id = new JTextField("-",2);
private JTextField textBoxSector3Time = new JTextField("-",10);
private JLabel labelSector3 = new JLabel("Best Sector 3 at lap n° : ");
private JLabel labelSector3Id = new JLabel(" by competitor : ");
private JLabel labelSector3Time = new JLabel(" in time : ");

private JLabel labelClock = new JLabel("Time 00:00:00:000");

public JPanel getInfoUp(){
return infoUp;
}
public JPanel getBestPanel(){
return bestPanel;
}
public JLabel getClock(){
return labelClock;
}
public void setClock(String timeIn){
labelClock.setText(timeIn);
}
public void addBest(){
bestPanel = new JPanel(new BorderLayout());
infoUp = new JPanel(new BorderLayout());

bestPanel.setLayout(new GridBagLayout());
bestPanel.setBorder(BorderFactory.createTitledBorder(null, "Best Performance", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));

labelClock.setFont(new Font("Serif", Font.BOLD, 25));
// JLabel labelClockInfo = new JLabel(" ");
// labelClockInfo.setFont(new Font("Serif", Font.BOLD, 25));

// gridLog.fill = GridBagConstraints.HORIZONTAL;
// 		gridLog.gridx = 0;
// 		gridLog.gridy = numComp;
// 		gridLog.ipady = 5;
// // 		gridLog.gridwidth= 2;
// 		logPanel.add(labelClockInfo,gridLog);
// gridLog.fill = GridBagConstraints.HORIZONTAL;
// 		gridLog.gridx = 2;
// 		gridLog.gridy = numComp;
// 		gridLog.ipady = 5;
// 		gridLog.gridwidth= 2;
// 		logPanel.add(labelClock,gridLog);

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
infoUp.add(labelClock, BorderLayout.NORTH);
infoUp.add(bestPanel, BorderLayout.CENTER);
}

public void setBestLap(String lap,String  time,String  id){
textBoxLap.setText(lap);
textBoxLapTime.setText(time);
textBoxLapId.setText(id);

}
public void setBestSector(int sector, String id, String lap, String time){
if(sector == 1){
textBoxSector1Lap.setText(lap);
textBoxSector1Id.setText(id);
textBoxSector1Time.setText(time);
}
if(sector == 2){
textBoxSector2Lap.setText(lap);
textBoxSector2Id.setText(id);
textBoxSector2Time.setText(time);
}
if(sector == 3){
textBoxSector3Lap.setText(lap);
textBoxSector3Id.setText(id);
textBoxSector3Time.setText(time);
}


}
}

class competitorLog{
private JLabel checkpoint = new JLabel("");
private JLabel lap = new JLabel("");
private JLabel name;
private JLabel state = new JLabel(" Iscritto alla competizione ");
private JLabel sector = new JLabel("");
public void setSector(String sectorIn){
sector.setText(", sector "+sectorIn);
}
public void setCheckpoint(String checkIn){
int value = new Integer(checkIn).intValue();
if(value <10){checkpoint.setText(" checkpoint "+checkIn+" ");}
else{checkpoint.setText(" checkpoint "+checkIn);}
}
public JLabel getCheckpoint(){
return checkpoint;
}
public void setLap(String lapIn){
int value = new Integer(lapIn).intValue();
if(value <10){lap.setText(" during lap "+lapIn+" ");}
else{lap.setText(" during lap "+lapIn);}
}

public JLabel getState(){
return state;
}

public void setState(String stateIn){
if(stateIn.equals("arriving")){
  state.setText(stateIn +" to ");
}
else {
  state.setText(stateIn+"     ");
}
}

public JLabel getName(){
return name;
}
public JLabel getSector(){
return sector;
}
public JLabel getLap(){
return lap;
}
public competitorLog(String nameIn){
name= new JLabel(nameIn);
}
}
