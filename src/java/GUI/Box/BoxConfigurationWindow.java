package GUI.Box;

import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import javax.swing.JDialog.*;

import java.util.Properties;
import org.omg.CORBA.ORB;
import org.omg.PortableServer.POA;
import org.omg.PortableServer.POAHelper;
import org.omg.CosNaming.NameComponent;
import org.omg.CosNaming.NamingContext;
import org.omg.CosNaming.NamingContextHelper;
import broker.radio.*;
import broker.init.*;

import javax.swing.JPanel;
import javax.swing.JFrame;

public class BoxConfigurationWindow implements AdminPanelInterface{
    //informazioni per la Join Competition
    private String boxRadioCorbaLoc;
    private String monitorBoxCorbaLoc;
    private String configuratorCorbaLoc;
    private org.omg.CORBA.ShortHolder competitorId = new org.omg.CORBA.ShortHolder();
    private org.omg.CORBA.FloatHolder circuitLength = new org.omg.CORBA.FloatHolder();
    private org.omg.CORBA.ShortHolder laps = new org.omg.CORBA.ShortHolder();
    private org.omg.CORBA.StringHolder monitorCorbaLoc = new org.omg.CORBA.StringHolder();
    private ORB orb;
    //sezione JSlider
    private JSlider sliderTyreUsury;
    private JSlider sliderFuelTank;
    private JSlider sliderGasLevel;
    private JSlider sliderSpeed;
    //sezione JLabel
    private JLabel valueFuelTank;
    private JLabel labelUsuryTyre;
    private JLabel valuePerCentUsury;
    private JLabel labelGasLevel;
    private JLabel valueLevelFuel;
    private JLabel valueSpeed;
    private JLabel labelBox = new JLabel("Box Strategy");
    private JLabel labelName = new JLabel("Name");
    private JLabel labelSurname = new JLabel("Surname");
    private JLabel labelStable = new JLabel("Racing Stable");
    private JLabel labelMixture = new JLabel("Mixture");
    private JLabel labelVel = new JLabel("Full Speed");
    private JLabel labelCapacityFuel = new JLabel("Tank Capacity");
    private JLabel labelstrps = new JLabel("Driver Strategy");
    private JLabel labelAcc = new JLabel("Speedup");
    private JLabel velLab = new JLabel("km/h");
    private JLabel labelTank = new JLabel (" L (200..400)");
    private JLabel valueAcc = new JLabel("m/s^2");
    private JLabel labelHelp = new JLabel("CorbaLoc of Registration Handler");
    private JLabel labelCorbaloc = new JLabel("Corbaloc of Registration Hanlder");

    //sezione combobox
    private JComboBox comboTyre;
    private JComboBox comboStrategy;
    private JComboBox comboPitStop;
    private JComboBox comboTypeTyre;
    private JComboBox comboBox;
    private JComboBox comboStrategypitstop;

    //sezione spinner giro di fermata
    //sezione spinner Quantità di benzina
    private Integer valueFuel; 
    private Integer minFuel;
    private Integer maxFuel; 
    private SpinnerNumberModel modelFuel;
    //sezione spinner grandezza serbatoio
    // private Integer valueSerbatorio = new Integer(12); 
    private Integer minTank = new Integer(200);
    private Integer maxTank= new Integer(400); 
    private SpinnerNumberModel modelTank;
    private SpinnerNumberModel modelAcc;
    //sezione panel
    private JPanel carPanel;
    private JPanel boxPanel;
    private JPanel buttonPanel;
    private JPanel dataPanel;
    //sezione JSpinner
    private JSpinner jsLap;
    private JSpinner jsFuel;
    private JSpinner jsVelocita;
    private JSpinner jsAcc;
    //sezione GridBagConstraints
    private GridBagConstraints carConfigurationGrid;
    private GridBagConstraints boxConfigurationGrid;
    private GridBagConstraints driverConfigurationGrid;
    //Sezione button
    private JButton resetButton;
    private JButton startButton;
    //sezione JTextField
    private JTextField textName = new JTextField("Pippo", 10);
    private JTextField textSurname = new JTextField("Pluto", 10);
    private JTextField textTeam = new JTextField("Ferrari", 10);
    private JTextField textCorbaloc = new JTextField("", 5);

    //sezione stringhe per file xml
    private String scuderia = new String("<team>Ferrari</team>");
    private String nome = new String("<firstname>Pippo</firstname>");
    private String cognome = new String("<lastname>Pluto<lastname>");
    private String tyreUsuryString = new String("<tyreusury>0.0</tyreusury>");
    private String gasolineString = new String ("<gasolinelevel>50</gasolinelevel>");
    private String stringTipoGomme = new String("<mixture>Soft</mixture>");
    private String stringGomme = new String("<type_tyre>Sun</type_tyre>");
    private String stringStyle = new String("<engine>NORMAL</engine>");
    private String stringStrategy = new String("<boxStrategy>NORMAL</boxStrategy>");
    private String stringSerbatoio = new String("<gastankcapacity>200.0</gastankcapacity>");
    private String stringMaxAcc = new String("<maxacceleration>7.0</maxacceleration>");
    private String stringMaxSpeed = new String("<maxspeed>300.0</maxspeed>");
    private String gasolineStringBox = new String("<initialGasLevel>50.0</initialGasLevel>");
    private String gasolineTankStringBox = new String("<gasTankCapacity>200.0</gasTankCapacity>");
    private String stringGommeBox = new String("<initialTyreType>Sun</initialTyreType>");
    private String stringModelGomme = new String("<model>michelin</model>");
    private String stringId;
    private String competitorXML;

    public JFrame parent;
    //altri parametri
    private int intTyre;
    private int intStrategy;
    private Double valueUsuryDouble;
    private Integer valueFuelInt;
    public BoxConfigurationWindow(JFrame frame, String param){
	stringId = param;
	parent=frame;
	try{
	    // LETTURA CORBALOC DA FILE
	    FileReader doc=new FileReader("../temp/boxCorbaLoc-"+stringId+".txt");
	    BufferedReader bufRead = new BufferedReader(doc);
	    //read configuratorCorbaloc
	    configuratorCorbaLoc= bufRead.readLine();
	    System.out.println("corbaloc configurator : "+configuratorCorbaLoc);
	    //read boxRadioCorbaloc
	    boxRadioCorbaLoc= bufRead.readLine();
	    System.out.println("corbaloc boxRadio : "+ boxRadioCorbaLoc);

	    //read monitorBoxCorbaloc
	    monitorBoxCorbaLoc= bufRead.readLine();
	    System.out.println("corbaloc monitorBox : "+monitorBoxCorbaLoc);

	    bufRead.close();

	}
	catch (IOException e ){
// System.out.println("costruttore : errore di apertura/chiusura del file");
}
	catch (Exception e){
// System.out.println("costruttore : problemi con la lettura del file");
}
    }

    class carConfigurationPanel{
	public carConfigurationPanel(JPanel panel, GridBagConstraints carConfigurationGrid){
	    createCar(panel, carConfigurationGrid);
	}
	public void createCar(JPanel panel, GridBagConstraints carConfigurationGrid){
	    //impostazione capacità serbatioio
	    sliderFuelTank = new JSlider(200,400);
	    sliderFuelTank.setValue(200);
	    valueFuelTank = new JLabel ("200 L(200-400)");
	    sliderFuelTank.addChangeListener(new MyChangeAction("L(200-400)", sliderFuelTank, valueFuelTank));
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 0;
	    carConfigurationGrid.gridy = 0;
	    carConfigurationGrid.ipady = 5;
	    panel.add(labelCapacityFuel, carConfigurationGrid);
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 1;
	    carConfigurationGrid.gridy = 0;
	    carConfigurationGrid.ipady = 5;
	    panel.add(sliderFuelTank, carConfigurationGrid);
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 2;
	    carConfigurationGrid.gridy = 0;
	    carConfigurationGrid.ipady = 5;
	    panel.add(valueFuelTank, carConfigurationGrid);
	
    sliderGasLevel = new JSlider(0,(Integer)sliderFuelTank.getValue());
	    sliderGasLevel.setValue(50);
	    valueLevelFuel = new JLabel("50L");
	    sliderGasLevel.addChangeListener(new MyChangeAction("L",sliderGasLevel,  valueLevelFuel));
	    labelGasLevel  = new JLabel("Gasoline Level");
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 0;
	    carConfigurationGrid.gridy = 1;
	    carConfigurationGrid.ipady = 5;
	    panel.add(labelGasLevel, carConfigurationGrid);
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 1;
	    carConfigurationGrid.gridy = 1;
	    carConfigurationGrid.ipady = 5;
	    panel.add(sliderGasLevel, carConfigurationGrid);
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 2;
	    carConfigurationGrid.gridy = 1;
	    carConfigurationGrid.ipady = 5;
	    panel.add(valueLevelFuel, carConfigurationGrid);
	    //sezione tipologia di gomme montate
	    
	    //sezione mescola delle gomme montate
	    String[] tipoGomme = { "Soft", "Hard"};
	    comboTypeTyre = new JComboBox(tipoGomme);
	    comboTypeTyre.setSelectedIndex(0);
	    comboTypeTyre.addActionListener(new ActionListener() {
		    public void actionPerformed(ActionEvent e) {
			JComboBox cb = (JComboBox)e.getSource();
			String s = (String)cb.getSelectedItem();
			stringTipoGomme = new String("<mixture>"+s+"</mixture>");}
		});
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 0;
	    carConfigurationGrid.gridy = 2;
	    carConfigurationGrid.ipady = 5;
	    panel.add(labelMixture, carConfigurationGrid);
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 1;
	    carConfigurationGrid.gridy = 2;
	    carConfigurationGrid.ipady = 5;
	    panel.add(comboTypeTyre, carConfigurationGrid);
	    //impostazione tipo strategia
	    String[] strategypitstop = {"Normal", "Save", "Aggressive"};
	    comboStrategypitstop = new JComboBox(strategypitstop);
	    comboStrategypitstop.setSelectedIndex(0);
	    comboStrategypitstop.addActionListener(new ActionListener() {
		    public void actionPerformed(ActionEvent e) {
			JComboBox cb = (JComboBox)e.getSource();
			String s = (String)cb.getSelectedItem();
 			stringStyle = new String("<engine>"+s.toUpperCase()+"</engine>");
		    }
		});
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 0;
	    carConfigurationGrid.gridy = 3;
	    carConfigurationGrid.ipady = 5;
	    panel.add(labelstrps, carConfigurationGrid);
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 1;
	    carConfigurationGrid.gridy = 3;
	    carConfigurationGrid.ipady = 5;
	    panel.add(comboStrategypitstop, carConfigurationGrid);
	    modelAcc = new SpinnerNumberModel(12.000,11.01, 12.99, 0.01);
	    jsAcc = new JSpinner(modelAcc);
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 0;
	    carConfigurationGrid.gridy = 4;
	    carConfigurationGrid.ipady = 5;
	    panel.add(labelAcc, carConfigurationGrid);
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 1;
	    carConfigurationGrid.gridy = 4;
	    carConfigurationGrid.ipady = 5;
	    panel.add(jsAcc, carConfigurationGrid);
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 2;
	    carConfigurationGrid.gridy = 4;
	    carConfigurationGrid.ipady = 5;
	    panel.add(valueAcc, carConfigurationGrid);
	    //slider max velocita 250 - 400
	    sliderSpeed = new JSlider(200,400);
	    sliderSpeed.setValue(300);
	    valueSpeed = new JLabel("300 km/h");
	    sliderSpeed.addChangeListener(new MyChangeAction("km/h",sliderSpeed,  valueSpeed));
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 0;
	    carConfigurationGrid.gridy = 5;
	    carConfigurationGrid.ipady = 5;
	    panel.add(labelVel, carConfigurationGrid);
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 1;
	    carConfigurationGrid.gridy = 5;
	    carConfigurationGrid.ipady = 5;
	    panel.add(sliderSpeed, carConfigurationGrid);
	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 2;
	    carConfigurationGrid.gridy = 5;
	    carConfigurationGrid.ipady = 5;
	    panel.add(valueSpeed, carConfigurationGrid);


	    carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 0;
	    carConfigurationGrid.gridy = 6;
	    carConfigurationGrid.ipady = 5;
	    carConfigurationGrid.gridwidth= 2;
	    panel.add(labelCorbaloc, carConfigurationGrid);
	    // carConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    carConfigurationGrid.gridx = 0;
	    carConfigurationGrid.gridy = 7;
	    carConfigurationGrid.ipady = 5;
	    carConfigurationGrid.gridwidth= 3;
	    panel.add(textCorbaloc, carConfigurationGrid);
	    try{
		BufferedReader corbaLocFile = new BufferedReader(new FileReader("../temp/competition_corbaLoc.txt"));
		corbaLocFile.readLine() ;
		corbaLocFile.readLine();
		textCorbaloc.setText(corbaLocFile.readLine());
	    }catch(Exception e){
// 		System.out.println("File non presente");
	    }

	}
	public class MyChangeAction implements ChangeListener{
	    private String simboloT;
	    private JSlider sliderT;
	    private JLabel valoreT;
	    MyChangeAction(String p_simbolo, JSlider p_slider, JLabel p_valore){
		simboloT = p_simbolo;
		sliderT = p_slider;
		valoreT = p_valore;
	    }
	    public void stateChanged(ChangeEvent ce){
		Integer value = sliderT.getValue();
		String str = Integer.toString(value);
		valoreT.setText(str+simboloT);
		Integer a = new Integer((Integer)sliderFuelTank.getValue()-value);
		if (simboloT == "L") {
		    stringSerbatoio = new String("<gastankcapacity>"+Integer.toString((Integer)sliderFuelTank.getValue())+".0</gastankcapacity>");
		    gasolineString = new String("<gasolinelevel>"+value.toString()+".0</gasolinelevel>");
		    gasolineStringBox = new String("<initialGasLevel>"+value.toString()+".0</initialGasLevel>");
		    gasolineTankStringBox = new String("<gasTankCapacity>"+value.toString()+".0</gasTankCapacity>");

		}
		if(simboloT =="L(200-400)"){sliderGasLevel.setMaximum((Integer)sliderT.getValue());
 	
		}
	    }
	}
    }

    class driverConfigurationPanel{
	driverConfigurationPanel(JPanel dataPanel, GridBagConstraints driverConfigurationGrid){createData(dataPanel, driverConfigurationGrid);}
	public void createData(JPanel dataPanel, GridBagConstraints driverConfigurationGrid){
	    driverConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    driverConfigurationGrid.gridx = 0;
	    driverConfigurationGrid.gridy = 0;
	    driverConfigurationGrid.ipady = 5;
	    dataPanel.add(labelName, driverConfigurationGrid);
	    driverConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    driverConfigurationGrid.gridx = 1;
	    driverConfigurationGrid.gridy = 0;
	    driverConfigurationGrid.ipady = 5;
	    dataPanel.add(textName, driverConfigurationGrid);
	    driverConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    driverConfigurationGrid.gridx = 0;
	    driverConfigurationGrid.gridy = 1;
	    driverConfigurationGrid.ipady = 5;
	    dataPanel.add(labelSurname, driverConfigurationGrid);
	    driverConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    driverConfigurationGrid.gridx = 1;
	    driverConfigurationGrid.gridy = 1;
	    driverConfigurationGrid.ipady = 5;
	    dataPanel.add(textSurname, driverConfigurationGrid);
	    driverConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    driverConfigurationGrid.gridx = 0;
	    driverConfigurationGrid.gridy = 2;
	    driverConfigurationGrid.ipady = 5;
	    dataPanel.add(labelStable, driverConfigurationGrid);
	    driverConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    driverConfigurationGrid.gridx = 1;
	    driverConfigurationGrid.gridy = 2;
	    driverConfigurationGrid.ipady = 5;
	    dataPanel.add(textTeam, driverConfigurationGrid);
	}
    }

    class boxConfigurationPanel{
	public boxConfigurationPanel(JPanel dataPanel, GridBagConstraints boxConfigurationGrid){
	    createStrategy(dataPanel, boxConfigurationGrid);
	}
	private void createStrategy(JPanel dataPanel, GridBagConstraints boxConfigurationGrid){
	    String[] strategy = {"Normal", "Cautious", "Risky", "Fool"};
	    comboBox = new JComboBox(strategy);
	    comboBox.setSelectedIndex(0);
	    comboBox.addActionListener(new ActionListener() {
		    public void actionPerformed(ActionEvent e) {
			JComboBox cb = (JComboBox)e.getSource();
			String s = (String)cb.getSelectedItem();
			s=s.toUpperCase();
			stringStrategy = new String("<boxStrategy>"+s+"</boxStrategy>");
			System.out.println(s);
		    }
		});
	    
	    boxConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    boxConfigurationGrid.gridx = 0;
	    boxConfigurationGrid.gridy = 0;
	    boxConfigurationGrid.ipady = 5;
	    boxPanel.add(labelName, boxConfigurationGrid);
	    boxConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    boxConfigurationGrid.gridx = 1;
	    boxConfigurationGrid.gridy = 0;
	    boxConfigurationGrid.ipady = 5;
	    boxPanel.add(textName, boxConfigurationGrid);
	    boxConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    boxConfigurationGrid.gridx = 0;
	    boxConfigurationGrid.gridy = 1;
	    boxConfigurationGrid.ipady = 5;
	    boxPanel.add(labelSurname, boxConfigurationGrid);
	    boxConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    boxConfigurationGrid.gridx = 1;
	    boxConfigurationGrid.gridy = 1;
	    boxConfigurationGrid.ipady = 5;
	    boxPanel.add(textSurname, boxConfigurationGrid);
	    boxConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    boxConfigurationGrid.gridx = 0;
	    boxConfigurationGrid.gridy = 2;
	    boxConfigurationGrid.ipady = 5;
	    boxPanel.add(labelStable, boxConfigurationGrid);
	    boxConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    boxConfigurationGrid.gridx = 1;
	    boxConfigurationGrid.gridy = 2;
	    boxConfigurationGrid.ipady = 5;
	    boxPanel.add(textTeam, boxConfigurationGrid);
	    boxConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    boxConfigurationGrid.gridx = 0;
	    boxConfigurationGrid.gridy = 3;
	    boxConfigurationGrid.ipady = 5;
	    boxPanel.add(labelBox, boxConfigurationGrid);
	    boxConfigurationGrid.fill = GridBagConstraints.HORIZONTAL;
	    boxConfigurationGrid.gridx = 1;
	    boxConfigurationGrid.gridy = 3;
	    boxConfigurationGrid.ipady = 5;
	    boxPanel.add(comboBox, boxConfigurationGrid);
	}
    }

    class buttonConfigurationPanel{
	public buttonConfigurationPanel(JPanel buttonPanel){
	    createButton(buttonPanel);
	}
	public void createButton(JPanel buttonPanel){
	    startButton = new JButton("Configure Competition");
	    startButton.addActionListener(new ActionListener() {
		    public void actionPerformed(ActionEvent e) {
			System.out.println("Creazione file xml");
			//comando per avviare la competizione.
			scuderia = new String("<team>"+textTeam.getText()+"</team>");			    
			nome = new String("<firstname>"+textName.getText()+"</firstname>");
			cognome = new String("<lastname>"+textSurname.getText()+"</lastname>");
			valueFuelInt = new Integer((int)sliderGasLevel.getValue());
			gasolineString = new String("<gasolinelevel>"+valueFuelInt.toString()+".0</gasolinelevel>");
			stringMaxAcc = new String("<maxacceleration>"+jsAcc.getValue().toString()+"</maxacceleration>");
			stringMaxSpeed = new String("<maxspeed>"+Integer.toString((Integer)sliderSpeed.getValue())+".0</maxspeed>");
			boolean ret = false;
			ret = writerCompetitorXML();
			if (ret=true) {System.out.println("Scrittura riuscita");}
			else {System.out.println("Scrittura non riuscita");}
			String corbaLocValue = textCorbaloc.getText();
			System.out.println(corbaLocValue);
			System.out.println("textCorbaloc.getText() = "+textCorbaloc.getText()+"...");
			if (corbaLocValue.equals("")){
			    System.out.println("corbaloc vuoto");
			    JOptionPane.showMessageDialog(parent, "Attention : you MUST write CorbaLoc", "Error", JOptionPane.ERROR_MESSAGE);
			    System.out.println("corbaloc vuoto");
			}
			else{ //prendo il corbaloc impostato
			    System.out.println(corbaLocValue);
			    System.out.println("corbaloc non vuoto");
			    connect(corbaLocValue);}			}
		});
	    resetButton = new JButton("Reset Field");
	    resetButton.addActionListener(new ActionListener() {
		    public void actionPerformed(ActionEvent e) {
			resetInfo();			}
		});
	    //adding button to buttonPane
	    buttonPanel.add(startButton);
	    buttonPanel.add(resetButton);
	    
	}
    }

    public void init(JFrame frame){
	// GridBagConstraints 
	carConfigurationGrid = new GridBagConstraints();

	boxPanel= new JPanel(new BorderLayout());
	boxPanel.setLayout(new GridBagLayout());
	boxPanel.setBorder(BorderFactory.createTitledBorder(null, "Driver & Box", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
	boxConfigurationGrid = new GridBagConstraints();

	carPanel = new JPanel(new BorderLayout());
	carPanel.setLayout(new GridBagLayout());
	carPanel.setBorder(BorderFactory.createTitledBorder(null, "Car Configuration", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));

	buttonPanel= new JPanel(new BorderLayout());
	buttonPanel.setBorder(BorderFactory.createTitledBorder(null, "Submit & Undo", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
	buttonPanel.setLayout(new FlowLayout());

	carConfigurationPanel car = new carConfigurationPanel(carPanel, carConfigurationGrid);
	boxConfigurationPanel box = new boxConfigurationPanel(boxPanel, boxConfigurationGrid);
	buttonConfigurationPanel button = new buttonConfigurationPanel(buttonPanel);
	frame.add(carPanel, BorderLayout.WEST);
	frame.add(boxPanel, BorderLayout.NORTH);
	frame.add(buttonPanel, BorderLayout.SOUTH);
	frame.pack();
	frame.setVisible(true);
	frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
   
    public void resetInfo(){
	System.out.println("Reset Field");
	sliderGasLevel.setValue(50);//benzina caricata
	comboBox.setSelectedIndex(0);//tipo di guida
	comboTypeTyre.setSelectedIndex(0);//mescola gomme montate
	sliderFuelTank.setValue(200);//capacità serbatoio
	jsAcc.setValue(12.000);//valore accelerazione
	textName.setText("Pippo");//nome predefinito
	textSurname.setText("Pluto");//cognome predefinito
	textTeam.setText("Ferrari");//scuderia predefinita
	sliderSpeed.setValue(300);
    }
    public boolean writerCompetitorXML(){
	try{
	    PrintWriter out;
	    File f = new File("competitor-"+stringId+".xml");
	    if (f.exists() == false ) {
		out=new PrintWriter(new File("competitor-"+stringId+".xml"));
	    }
	    else {
		out=new PrintWriter(f);
	    }
	    out.println("<?xml version=\"1.0\"?>\n <car_driver>\n<driver>");
	    competitorXML = new String("<?xml version=\"1.0\"?>\n <car_driver>\n<driver>");
	    out.println(scuderia);
	    out.println(nome);
	    out.println(cognome);
	    competitorXML = competitorXML + '\n' + scuderia + '\n' +  nome + '\n' + cognome;
	    out.println("</driver>");
	    out.println("<car>");
	    competitorXML = competitorXML +new String("</driver>\n<car>");
	    out.println(stringMaxSpeed);
	    out.println(stringMaxAcc);
	    out.println(stringSerbatoio);
	    out.println(stringStyle);  
	    out.println(tyreUsuryString);
	    out.println(gasolineString);
	    out.println(stringTipoGomme);
	    out.println(stringModelGomme);
	    competitorXML = competitorXML + stringMaxSpeed +'\n'+ stringMaxAcc +'\n'+ stringSerbatoio +'\n'+ stringStyle +'\n'+ tyreUsuryString +'\n'+ gasolineString +'\n'+ stringTipoGomme +'\n'+ stringModelGomme + '\n' + stringGomme + "\n</car>\n </car_driver>";
	    out.println(stringGomme + "\n</car>");
	    out.println("</car_driver>");	
	    out.close();
	    return true;
	}
	catch(IOException e){
// 	   e.printStackTrace();
	    return false;
	}
    }

    public boolean writerBoxXML(){
	try{
	    PrintWriter out;
	    File f = new File("../temp/boxConfig-"+stringId+".xml");
	    if (f.exists() == false ) {
		out=new PrintWriter(new File("../temp/boxConfig-"+stringId+".xml"));
	    }
	    else {
		out=new PrintWriter(f);
	    }
	    out.println("<?xml version=\"1.0\"?>\n<config>");
	    out.println("<monitorCorbaLoc>"+monitorCorbaLoc.value+"</monitorCorbaLoc>");
	    out.println(stringGommeBox);
	    out.println("<laps>"+laps.value+"</laps>");
	    out.println("<circuitLength>"+circuitLength.value+"</circuitLength>");
	    out.println(gasolineStringBox);
	    out.println(gasolineTankStringBox);
	    out.println("<competitorID>"+competitorId.value+"</competitorID>");
	    out.println(stringStrategy);
	    out.println("</config>");
	    out.close();
	    return true;

	}
	catch(IOException e){
// 	    e.printStackTrace();
	    return false;
	}
    }

    public void switchPanel(){
	BoxScreen p = new BoxScreen(stringId, competitorXML);
	System.out.println("id del BoxScreen : "+stringId);
	parent.dispose();
	p.init(boxRadioCorbaLoc, monitorBoxCorbaLoc, configuratorCorbaLoc, monitorCorbaLoc.value, orb, laps.value);
	p.start();
    }

    public void connect(String corbaloc){
	try {
	    // RegistrationHandler comp = Connection.connectRH(corbaloc);
	    System.out.println("Try to connect to Registration Handler");
	    String[] temp = {"ORB"};
	    orb = ORB.init(temp, null);
	    System.out.println("ORB initialized");
	    //Resolve MessageServer
	    org.omg.CORBA.Object obj = orb.string_to_object(corbaloc);
	    RegistrationHandler comp = RegistrationHandlerHelper.narrow(obj);
	    System.out.println("Comp initialized");
	    if (comp != null) {
		System.out.println("Comp != null");
		System.out.println(competitorXML);
		// il metodo di connessione è riuscito a connettersi
		System.out.println(boxRadioCorbaLoc);
		comp.Join_Competition(competitorXML, boxRadioCorbaLoc, monitorCorbaLoc, competitorId, circuitLength, laps);
		System.out.println("After Join Competition");
		//con i metodi di ritorno della Join competition costruisco il file obj/boxConfig-<id>.xml
		writerBoxXML();
		System.out.println("After writerBoxXML");
		//connessione configurator
		System.out.println("Try to connect to configurator with corbaloc : "+configuratorCorbaLoc);
		org.omg.CORBA.Object conf_obj = orb.string_to_object(configuratorCorbaLoc);
		System.out.println("chiamo ConfiguratorHelper.narrow");
		//qua va effettuato lo switch panel.
		switchPanel();

	    }
	    else {
		System.out.println("Connessione con il RegistrationHandler rifiutata");
		JOptionPane.showMessageDialog(parent, "Attention : connection refused by RegistrationHandler", "Error", JOptionPane.ERROR_MESSAGE);
	    }
	} catch (Exception e) {
// 	    JOptionPane.showMessageDialog(parent, "Exception : "+e.getMessage().toString(), "Error", JOptionPane.ERROR_MESSAGE);
	    e.printStackTrace();
	}
    }

    public static void main(String[] args){
	JFrame j = new JFrame("Box Admin Window n° "+ args[0]);
	BoxConfigurationWindow boxWindow = new BoxConfigurationWindow(j, args[0]);
	boxWindow.init(j);

    }
}
