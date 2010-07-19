import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;

public class BoxAdminWindow implements AdminPanelInterface{
// private JFrame frame = new JFrame("Competitor");
//sezione JSlider
private JSlider slider;
private JSlider sliderSerbatoio;
private JLabel valoreProva;
private JSlider slider2;
private JSlider sliderVelocita;
//sezione JLabel
private JLabel label;
private JLabel valore;
private JLabel label2;
private JLabel valore2;
private JLabel valoreVelocita;
private JLabel labelTyre = new JLabel("Tyre type : ");
private JLabel labelStrategy = new JLabel("Driver Strategy after Pitstop : ");
private JLabel labelLap = new JLabel("PitStop lap : ");
private JLabel labelFuel = new JLabel("Pitsop Fuel : ");
private JLabel labelPitStop = new JLabel("Tyre Type at PitStop");
private JLabel labelName = new JLabel("Name : ");
private JLabel labelCognome = new JLabel("Surname : ");
private JLabel labelScuderia = new JLabel("Racing Stable : ");
private JLabel labelMescola = new JLabel("Mixture : ");
private JLabel labelTyrePitStop = new JLabel("Mixture pit stop : ");
private JLabel labelVel = new JLabel("Full Speed : ");
private JLabel labelCapacita = new JLabel("Fuel Capacity : ");
private JLabel labelstrps = new JLabel("Driver Strategy : ");
private JLabel labelAcc = new JLabel("Speedup : ");
private JLabel velLab = new JLabel(" km/h");
// private JLabel labelVel = new JLabel("Velocita' massima : ");
//sezione combobox
private JComboBox comboTyre;
private JComboBox comboStrategy;
private JComboBox comboPitStop;
private JComboBox comboTipoGomme;
private JComboBox comboTipoGommePS;
private JComboBox comboStrategypitstop;
//altri parametri
private int intTyre;
private int intStrategy;
//sezione spinner giro di fermata
private Integer valueLap;// = new Integer(12); 
private Integer minLap;// = new Integer(0);
private Integer maxLap;// = new Integer(100); 
private Integer step = new Integer(1);;// = new Integer(1); 
private SpinnerNumberModel modelLap;// = new SpinnerNumberModel(valueLap, minLap, maxLap, step); 
//sezione spinner Quantità di benzina
private Integer valueFuel;// = new Integer(100 - slider2.getValue()); 
private Integer minFuel;// = new Integer(0);
private Integer maxFuel;// = new Integer(100 - slider2.getValue()); 
private SpinnerNumberModel modelFuel;// = new SpinnerNumberModel(valueFuel, minFuel, maxFuel, step); private Integer valueLap;// = new Integer(12); 
//sezione spinner grandezza serbatoio
// private Integer valueSerbatorio = new Integer(12); 
private Integer minSerbatoio = new Integer(200);
private Integer maxSerbatoio= new Integer(400); 
private JLabel labelLSerb = new JLabel (" L (200..400)");
// private Integer step;// = new Integer(1); 
private SpinnerNumberModel modelSerbatoio;
private SpinnerNumberModel modelAcc;
private JLabel accLab = new JLabel(" m/s^2");
//sezione panel
private JPanel carPanel;
private JPanel strategyPanel;
private JPanel buttonPanel;
private JPanel dataPanel;
//sezione JSpinner
private JSpinner jsLap;// = new JSpinner(modelLap);
private JSpinner jsFuel;// = new JSpinner(modelFuel);
private JSpinner jsVelocita;
private JSpinner jsAcc;
//sezione GridBagConstraints
private GridBagConstraints c;
private GridBagConstraints d;
private GridBagConstraints f;
//Sezione button
private JButton resetButton;
private JButton startButton;
//sezione JTextField
private JTextField textNome = new JTextField("Pippo", 20);
private JTextField textCognome = new JTextField("Pluto", 20);
private JTextField textScuderia = new JTextField("Ferrari", 20);
//sezione stringhe per file xml
String scuderia = new String("<team>Ferrari</team>");
String nome = new String("<firstname>Pippo</firstname>");
String cognome = new String("<lastname>Pluto<lastname>");
Double valueUsuryDouble;
Integer valueFuelInt;
String tyreUsuryString = new String("<tyreusury>0.15</tyreusury>");
String gasolineString = new String ("<gasolinelevel>50</gasolinelevel>");

private String stringPitStop = new String("<pitstoptt>Sun</pitstoptt>");
private String stringTipoGomme = new String("<mixture>Soft Mixture</mixture>");
private String stringTipoGommePS = new String("<mixtureps>Soft Mixture</mixtureps>");
private String stringGomme = new String("<type_tyre>Sun</type_tyre>");
private String stringStrategy = new String("<engine>Normal</engine>");
// private String stringStrategyPS = new String("<engineps>Normal</engineps>");
private String stringStrategypitstop = new String("<engineps>Normal</engineps>");
private String gasolineStringPS = new String("<pitstopGasolineLevel>50</pitstopGasolineLevel>");
private String pitstopStringLap= new String("<pitstopLaps>12</pitstopLaps>");
private String stringSerbatoio = new String("<gastankcapacity>200</gastankcapacity>");
private String stringMaxAcc = new String("<maxacceleration>7.0</maxacceleration>");
private String stringMaxSpeed = new String("<maxspeed>300</maxspeed>");
// private String stringGommePS = new String("<tyrePS>Sun</tyrePS>");

public BoxAdminWindow(JFrame frame){
  init(frame);
}

class carConfigurationPanel{
public carConfigurationPanel(JPanel panel, GridBagConstraints c){
createCar(panel, c);
}
public void createCar(JPanel panel, GridBagConstraints c){
//impostazione capacità serbatioio
sliderSerbatoio = new JSlider(200,400);
sliderSerbatoio.setValue(200);
valoreProva = new JLabel ("200 L (200-400)");
sliderSerbatoio.addChangeListener(new MyChangeAction("L (200-400)", sliderSerbatoio, valoreProva));
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 0;
		c.ipady = 5;
		panel.add(labelCapacita, c);
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 0;
		c.ipady = 5;
		panel.add(sliderSerbatoio, c);
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 2;
		c.gridy = 0;
		c.ipady = 5;
		panel.add(valoreProva, c);
//sezione usura gomme
    slider = new JSlider();
    slider.setValue(15);
    valore = new JLabel("15% ");
    slider.addChangeListener(new MyChangeAction("%", slider, valore));
    label  = new JLabel("Tyre Usury");
    c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 1;
		c.ipady = 5;
		panel.add(label, c);
    c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 1;
		c.ipady = 5;
		panel.add(slider, c);
    c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 2;
		c.gridy = 1;
		c.ipady = 5;
		panel.add(valore, c);
//sezione valore benzina
    slider2 = new JSlider(0,(Integer)sliderSerbatoio.getValue());
    slider2.setValue(50);
    valore2 = new JLabel("50L ");
    slider2.addChangeListener(new MyChangeAction("L",slider2,  valore2));
    label2  = new JLabel("Gasoline Level");
    c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 2;
		c.ipady = 5;
		panel.add(label2, c);
    c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 2;
		c.ipady = 5;
		panel.add(slider2, c);
    c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 2;
		c.gridy = 2;
		c.ipady = 5;
		panel.add(valore2, c);
//sezione tipologia di gomme montate
String[] gomme = { "Sun", "Weak Rain", "Rain", "Hard Rain"};
		comboTyre = new JComboBox(gomme);
		comboTyre.setSelectedIndex(0);
		comboTyre.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JComboBox cb = (JComboBox)e.getSource();
				String s = (String)cb.getSelectedItem();
				stringGomme = new String("<type_tyre>"+s+"</type_tyre>");}
		});
    c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 3;
		c.ipady = 5;
		panel.add(labelTyre, c);
    c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 3;
		c.ipady = 5;
		panel.add(comboTyre, c);
//sezione mescola delle gomme montate
String[] tipoGomme = { "Soft Mixture", "Hard Mixture"};
		comboTipoGomme = new JComboBox(tipoGomme);
		comboTipoGomme.setSelectedIndex(0);
		comboTipoGomme.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JComboBox cb = (JComboBox)e.getSource();
				String s = (String)cb.getSelectedItem();
				stringTipoGomme = new String("<mixture>"+s+"</mixture>");}
		});
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 4;
		c.ipady = 5;
		panel.add(labelMescola, c);
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 4;
		c.ipady = 5;
		panel.add(comboTipoGomme, c);
//impostazione tipo strategia
String[] strategypitstop = {"Normal", "Save", "Aggressive"};
	comboStrategypitstop = new JComboBox(strategypitstop);
	comboStrategypitstop.setSelectedIndex(0);
	comboStrategypitstop.addActionListener(new ActionListener() {
		public void actionPerformed(ActionEvent e) {
			JComboBox cb = (JComboBox)e.getSource();
			String s = (String)cb.getSelectedItem();
			stringStrategypitstop = new String("<engineps>"+s+"</engineps>");
		}
	});
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 5;
		c.ipady = 5;
		panel.add(labelstrps, c);
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 5;
		c.ipady = 5;
		panel.add(comboStrategypitstop, c);
modelAcc = new SpinnerNumberModel(7.00,6.90, 7.10, 0.01);
jsAcc = new JSpinner(modelAcc);
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 6;
		c.ipady = 5;
		panel.add(labelAcc, c);
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 6;
		c.ipady = 5;
		panel.add(jsAcc, c);
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 2;
		c.gridy = 6;
		c.ipady = 5;
		panel.add(accLab, c);
//slider max velocita 250 - 400
sliderVelocita = new JSlider(200,400);
sliderVelocita.setValue(300);
valoreVelocita = new JLabel(" 300 km/h");
sliderVelocita.addChangeListener(new MyChangeAction(" km/h",sliderVelocita,  valoreVelocita));
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 7;
		c.ipady = 5;
		panel.add(labelVel, c);
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 7;
		c.ipady = 5;
		panel.add(sliderVelocita, c);
c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 2;
		c.gridy = 7;
		c.ipady = 5;
		panel.add(valoreVelocita, c);
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
      int value = sliderT.getValue();
      String str = Integer.toString(value);
      valoreT.setText(str+simboloT);
      Integer a = new Integer((Integer)sliderSerbatoio.getValue()-value);
      if (simboloT == "L") {
	  if (a < (Integer)jsFuel.getValue()){
	      jsFuel.setValue((Integer)sliderSerbatoio.getValue() - value);
	  }
modelFuel.setMaximum((Integer)sliderSerbatoio.getValue() - (Integer)slider2.getValue());	      
stringSerbatoio = new String("<gastankcapacity>"+Integer.toString((Integer)sliderSerbatoio.getValue())+"</gastankcapacity>");
      }
if(simboloT =="L (200-400)"){slider2.setMaximum((Integer)sliderT.getValue());
modelFuel.setMaximum((Integer)sliderSerbatoio.getValue() - (Integer)slider2.getValue());
 	
}
    }
  }
}

class driverConfigurationPanel{
driverConfigurationPanel(JPanel dataPanel, GridBagConstraints f){createData(dataPanel, f);}
public void createData(JPanel dataPanel, GridBagConstraints f){
f.fill = GridBagConstraints.HORIZONTAL;
		f.gridx = 0;
		f.gridy = 0;
		f.ipady = 5;
		dataPanel.add(labelName, f);
f.fill = GridBagConstraints.HORIZONTAL;
		f.gridx = 1;
		f.gridy = 0;
		f.ipady = 5;
		dataPanel.add(textNome, f);
f.fill = GridBagConstraints.HORIZONTAL;
		f.gridx = 0;
		f.gridy = 1;
		f.ipady = 5;
		dataPanel.add(labelCognome, f);
f.fill = GridBagConstraints.HORIZONTAL;
		f.gridx = 1;
		f.gridy = 1;
		f.ipady = 5;
		dataPanel.add(textCognome, f);
f.fill = GridBagConstraints.HORIZONTAL;
		f.gridx = 0;
		f.gridy = 2;
		f.ipady = 5;
		dataPanel.add(labelScuderia, f);
f.fill = GridBagConstraints.HORIZONTAL;
		f.gridx = 1;
		f.gridy = 2;
		f.ipady = 5;
		dataPanel.add(textScuderia, f);
}
}

class strategyConfigurationPanel{
public strategyConfigurationPanel(JPanel dataPanel, GridBagConstraints d){
createStrategy(dataPanel, d);
}
private void createStrategy(JPanel dataPanel, GridBagConstraints d){
//sezione spinner giro di fermata
valueLap = new Integer(12); 
minLap = new Integer(0);
maxLap = new Integer(100);  
modelLap = new SpinnerNumberModel(valueLap, minLap, maxLap, step); 
//sezione spinner Quantità di benzina
valueFuel = new Integer(200 - slider2.getValue()); 
minFuel = new Integer(0);
maxFuel = new Integer(200 - slider2.getValue()); 
// Integer step = new Integer(1); 
modelFuel = new SpinnerNumberModel(valueFuel, minFuel, maxFuel, step); 
jsLap = new JSpinner(modelLap);
jsFuel = new JSpinner(modelFuel);
// jsFuel.setEnabled(false); disabilito jspinner fuel prima di
String[] strategy = {"Normal", "Save", "Aggressive"};
	comboStrategy = new JComboBox(strategy);
	comboStrategy.setSelectedIndex(0);
	comboStrategy.addActionListener(new ActionListener() {
		public void actionPerformed(ActionEvent e) {
			JComboBox cb = (JComboBox)e.getSource();
			String s = (String)cb.getSelectedItem();
stringStrategy = new String("<engine>"+s+"</engine>");
		}
	});

String[] gommePitStop = { "Sun", "Weak Rain", "Rain", "Hard Rain"};
		comboPitStop = new JComboBox(gommePitStop);
		comboPitStop.setSelectedIndex(0);
		comboPitStop.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JComboBox cb = (JComboBox)e.getSource();
				String s = (String)cb.getSelectedItem();
				stringPitStop = new String("<pitstoptt>"+s+"</pitstoptt>");
			}
		});

///////////////tipo gomme pit stop
String[] tipoGommePitStop = { "Soft Mixture ", "Hard Mixture"};
		comboTipoGommePS = new JComboBox(tipoGommePitStop);
		comboTipoGommePS.setSelectedIndex(0);
		comboTipoGommePS.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JComboBox cb = (JComboBox)e.getSource();
				String s = (String)cb.getSelectedItem();
// 				if(s.equals("Mescola Morbida")) {
				stringTipoGommePS = new String("<mixtureps>"+s+"</mixtureps>");
// }
// 				else if(s.equals("Mescola Dura")) {stringTipoGomme = new String();}
			}
		});
//adding component to PitStop configuration
d.fill = GridBagConstraints.HORIZONTAL;
		d.gridx = 0;
		d.gridy = 0;
		d.ipady = 5;
		strategyPanel.add(labelStrategy, d);
d.fill = GridBagConstraints.HORIZONTAL;
		d.gridx = 1;
		d.gridy = 0;
		d.ipady = 5;
		strategyPanel.add(comboStrategy, d);

d.fill = GridBagConstraints.HORIZONTAL;
		d.gridx = 0;
		d.gridy = 1;
		d.ipady = 5;
		strategyPanel.add(labelLap, d);
d.fill = GridBagConstraints.HORIZONTAL;
		d.gridx = 1;
		d.gridy = 1;
		d.ipady = 5;
		strategyPanel.add(jsLap, d);
d.fill = GridBagConstraints.HORIZONTAL;
		d.gridx = 0;
		d.gridy = 2;
		d.ipady = 5;
		strategyPanel.add(labelFuel, d);
d.fill = GridBagConstraints.HORIZONTAL;
		d.gridx = 1;
		d.gridy = 2;
		d.ipady = 5;
		strategyPanel.add(jsFuel, d);

d.fill = GridBagConstraints.HORIZONTAL;
		d.gridx = 0;
		d.gridy = 3;
		d.ipady = 5;
		strategyPanel.add(labelPitStop, d);
d.fill = GridBagConstraints.HORIZONTAL;
		d.gridx = 1;
		d.gridy = 3;
		d.ipady = 5;
		strategyPanel.add(comboPitStop, d);
d.fill = GridBagConstraints.HORIZONTAL;
		d.gridx = 0;
		d.gridy = 4;
		d.ipady = 5;
		strategyPanel.add(labelTyrePitStop, d);
d.fill = GridBagConstraints.HORIZONTAL;
		d.gridx = 1;
		d.gridy = 4;
		d.ipady = 5;
		strategyPanel.add(comboTipoGommePS, d);

}
}

class buttonConfigurationPanel{
public buttonConfigurationPanel(JPanel buttonPanel){
createButton(buttonPanel);
}
public void createButton(JPanel buttonPanel){
startButton = new JButton("Join Competition");
		startButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			    System.out.println("Creazione file xml");
			    //comando per avviare la competizione.
			    scuderia = new String("<team>"+textScuderia.getText()+"</team>");			    
			    nome = new String("<firstname>"+textNome.getText()+"</firstname>");
			    cognome = new String("<lastname>"+textCognome.getText()+"</lastname>");
			    valueUsuryDouble = new Double ((double)slider.getValue() / (double)100);
			    valueFuelInt = new Integer((int)slider2.getValue());
			    tyreUsuryString = new String("<tyreusury>"+valueUsuryDouble.toString()+"</tyreusury>");
			    gasolineString = new String("<gasolinelevel>"+valueFuelInt.toString()+"</gasolinelevel>");
gasolineStringPS = new String("<pitstopGasolineLevel>"+jsFuel.getValue().toString()+"</pitstopGasolineLevel>");
pitstopStringLap= new String("<pitstopLaps>"+jsLap.getValue().toString()+"</pitstopLaps>");
stringMaxAcc = new String("<maxacceleration>"+jsAcc.getValue().toString()+"</maxacceleration>");
stringMaxSpeed = new String("<maxspeed>"+Integer.toString((Integer)sliderVelocita.getValue())+"</maxspeed>");
boolean ret = false;
ret = writerCompetitorXML();
if (ret=true) {System.out.println("Scrittura riuscita");}
else {System.out.println("Scrittura non riuscita");}
			}
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
GridBagConstraints d = new GridBagConstraints();
GridBagConstraints c = new GridBagConstraints();
dataPanel = new JPanel(new BorderLayout());
dataPanel.setLayout(new GridBagLayout());
dataPanel.setBorder(BorderFactory.createTitledBorder(null, "Competitor Data", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
f = new GridBagConstraints();

strategyPanel= new JPanel(new BorderLayout());
strategyPanel.setLayout(new GridBagLayout());
strategyPanel.setBorder(BorderFactory.createTitledBorder(null, "Pit Stop Strategy", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
d = new GridBagConstraints();

carPanel = new JPanel(new BorderLayout());
carPanel.setLayout(new GridBagLayout());
carPanel.setBorder(BorderFactory.createTitledBorder(null, "Car Configuration", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));

buttonPanel= new JPanel(new BorderLayout());
buttonPanel.setBorder(BorderFactory.createTitledBorder(null, "Submit & Undo", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
buttonPanel.setLayout(new FlowLayout());


// createDriver(JPanel driver, GridBagConstraints d);
// createCar(JPanel car, GridBagConstraints c);
// createStrategy(JPanel car, GridBagConstraints e);
carConfigurationPanel car = new carConfigurationPanel(carPanel, c);
driverConfigurationPanel driver = new driverConfigurationPanel(dataPanel, f);
strategyConfigurationPanel strategy = new strategyConfigurationPanel(strategyPanel, d);
buttonConfigurationPanel button = new buttonConfigurationPanel(buttonPanel);
frame.add(dataPanel,BorderLayout.NORTH);
frame.add(carPanel, BorderLayout.WEST);
frame.add(strategyPanel, BorderLayout.EAST);
frame.add(buttonPanel, BorderLayout.SOUTH);
frame.pack();
frame.setVisible(true);
frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
}
public boolean verifySetting(){return true;}
public void confirmSetting(){}
public void switchPanel(JPanel succPanel){}
public void resetInfo(){
			    System.out.println("Reset Field");
			      slider.setValue(15);//usura gomme
// 			      valore = new JLabel(" 15%"); //usura gomme
			      slider2.setValue(50);//benzina caricata
// 			      valore2 = new JLabel(" 50L");//benzina caricata
			      comboTyre.setSelectedIndex(0);//gomme montate
			      comboStrategy.setSelectedIndex(0);//tipo di guida
			      jsLap.setValue(12);//giro del pitstop
			      comboPitStop.setSelectedIndex(0); // gomme dopo il pitstop
			      comboTipoGomme.setSelectedIndex(0);//mescola gomme montate
			      comboTipoGommePS.setSelectedIndex(0);//mescola gomme pitstop
			      sliderSerbatoio.setValue(200);//capacità serbatoio
			      comboStrategypitstop.setSelectedIndex(0);//tipo di guida dopo il pitstop
			      jsAcc.setValue(7.0);//valore accelerazione
			      textNome.setText("Pippo");//nome predefinito
			      textCognome.setText("Pluto");//cognome predefinito
			      textScuderia.setText("Ferrari");//scuderia predefinita
			      sliderVelocita.setValue(300);
			      jsFuel.setValue(50);
}
public boolean writerCompetitorXML(){
try{
PrintWriter out;
File f = new File("car_driver.xml");
if (f.exists() == false ) {
out=new PrintWriter(new File("car_driver.xml"));
}
else {
out=new PrintWriter(f);
}
// String item=in.next();
// int number=in.nextInt();
out.println("<?xml version=\"1.0\"?>\n <car_driver>\n<driver>");
// out.println();
// in.close();
out.println(scuderia);
out.println(nome);
out.println(cognome);
out.println("</driver>");
out.println("<car>");
out.println(stringMaxSpeed);
out.println(stringMaxAcc);

// <maxspeed>350</maxspeed>\n<maxacceleration>1.2</maxacceleration>");
out.println(stringSerbatoio);
out.println(stringStrategy);  
out.println(tyreUsuryString);
out.println(gasolineString);
// out.println("<gasolinelevel>50.0</gasolinelevel>");
out.println(stringTipoGomme);
out.println("<model>michelin</model>");
out.println(stringGomme + "\n</car>\n<strategy_car>");
out.println(gasolineStringPS);
out.println(pitstopStringLap);
out.println(stringPitStop);
out.println(stringTipoGommePS);
out.println(stringStrategypitstop);
// out.println("<pitstopCondition>false</pitstopCondition>");
// out.println("<trim>1</trim>");
out.println("<pitstop>false</pitstop>\n</strategy_car>\n</car_driver>");
	

out.close();
return true;
}
catch(IOException e){
e.printStackTrace();
return false;
}
}

public static void main(String[] args){
JFrame j = new JFrame("Box Admin Window");
BoxAdminWindow boxWindow = new BoxAdminWindow(j);
}
}