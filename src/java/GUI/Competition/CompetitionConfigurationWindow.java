package GUI.Competition;

import GUI.TV.ScreenTv;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.SwingUtilities;
import javax.swing.filechooser.*;
import java.io.*;

import java.util.Properties;
import org.omg.CORBA.ORB;
import org.omg.PortableServer.POA;
import org.omg.PortableServer.POAHelper;
import org.omg.CosNaming.NameComponent;
import org.omg.CosNaming.NamingContext;
import org.omg.CosNaming.NamingContextHelper;
import broker.init.*;
import broker.radio.*;

public class CompetitionConfigurationWindow {
private String corbalocMonitor;
private Competition_Monitor_Radio monitor;
private ScreenTv screen;
private org.omg.CORBA.ORB orb;
private CompetitionConfigurator conf;
private JLabel labelFile = new JLabel("1: Racetrack file : ");
private JLabel labelCompetitor = new JLabel("2: Competitors : ");
private JLabel labelLap = new JLabel("3: Laps  : ");
private JLabel labelName = new JLabel("4: Circuit name : ");
private JTextField fileRacetrack = new JTextField("../../race_tracks/indianapolis.xml", 20);
private JFrame parent;
private JTextField textName = new JTextField("Indianapolis", 10);
private JButton openButton;
private JButton startButton;
// private JButton undoButton;
private JButton resetButton;
private int intName=0;
SpinnerNumberModel modelConc = new SpinnerNumberModel(3, 1, 20, 1); 
SpinnerNumberModel modelLap = new SpinnerNumberModel(10, 1, 100, 1);
private JSpinner jsConc = new JSpinner(modelConc);
private JSpinner jsLap = new JSpinner(modelLap);
private void init(JFrame p){
parent=p;


JPanel buttonPane = new JPanel(new BorderLayout());
JPanel contentPane = new JPanel(new BorderLayout());
openButton = new JButton("Sfoglia...");

//azione per il bottone sfoglia. viene cosi selezionato il circuito.
	openButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			JFileChooser fc = new JFileChooser("../../race_tracks/");
		        fc.setAcceptAllFileFilterUsed(false);
				int returnVal = fc.showOpenDialog(parent);
				if (returnVal == JFileChooser.APPROVE_OPTION) {
					try {
						fileRacetrack.setText(fc.getSelectedFile().getCanonicalPath());
					} catch(Exception ecc) {
// 					    ecc.printStackTrace();
					}
				}
			}
		});
		startButton = new JButton("Avvia Competizione");
		startButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			    System.out.println("Competizione avviata");
if(writexml()== true){
raceFileCreator();
parent.dispose();
conf.Configure("comp_config.xml");
screen = new ScreenTv(corbalocMonitor, monitor, "Monitor of Competition", (float)1.0);
screen.start();
}
			}
		});
		resetButton = new JButton("Ripristina predefinito");
		resetButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			    fileRacetrack.setText("../../race_tracks/indianapolis.xml");
			    jsLap.setValue(10);
			    jsConc.setValue(3);
			    textName.setText("Indianapolis");
// 			    jsRefresh.setValue(43);
			    
		}
		});

		contentPane.setLayout(new GridBagLayout());
		contentPane.setBorder(BorderFactory.createTitledBorder(null, "Impostazioni generali", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
		GridBagConstraints c = new GridBagConstraints();	
		//selezione file
		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 0;
		c.ipady = 5;
		contentPane.add(labelFile, c);
 		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 0;
		c.ipady = 5;
		contentPane.add(fileRacetrack, c);
 		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 2;
		c.gridy = 0;
		c.ipady = 5;
		contentPane.add(openButton, c);
		// numero massimo concorrenti
		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 1;
		c.ipady = 5;
		contentPane.add(labelCompetitor, c);
 		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 1;
		c.ipady = 5;
		contentPane.add(jsConc, c);
		// numero giri pista
		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 2;
		c.ipady = 5;
		contentPane.add(labelLap, c);
 		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 2;
		c.ipady = 5;
		contentPane.add(jsLap, c);
		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 3;
		c.ipady = 5;
		contentPane.add(labelName, c);
		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 3;
		c.ipady = 5;
		contentPane.add(textName, c);
//BUTTON PANEL
		buttonPane.setLayout(new FlowLayout());
		buttonPane.add(resetButton);
		buttonPane.add(startButton);
		p.add(contentPane, BorderLayout.PAGE_START);
		p.add(buttonPane, BorderLayout.PAGE_END);
}

    public CompetitionConfigurationWindow(String[] args){
try{

orb = org.omg.CORBA.ORB.init(args,null);

String configCorbaLoc="";
corbalocMonitor = "";
try{
BufferedReader corbaLocFile = new BufferedReader(new FileReader("../temp/competition_corbaLoc.txt"));
              configCorbaLoc = corbaLocFile.readLine() ;
System.out.println(configCorbaLoc);
	      corbalocMonitor= corbaLocFile.readLine();
System.out.println(corbalocMonitor);
}catch(Exception e){
System.out.println("Eccezione leggendo il corbalocMonitor = "+corbalocMonitor);
}
      org.omg.CORBA.Object competition_obj = orb.string_to_object(configCorbaLoc);
System.out.println("CompetitionConfigurationWindow : 1");
      conf = CompetitionConfiguratorHelper.narrow(competition_obj);
System.out.println("CompetitionConfigurationWindow : 2");
      org.omg.CORBA.Object monitor_obj = orb.string_to_object(corbalocMonitor);
System.out.println("CompetitionConfigurationWindow : 3");
      monitor = Competition_Monitor_RadioHelper.narrow(monitor_obj);
System.out.println("CompetitionConfigurationWindow : 4");
      JFrame frame = new JFrame("Configure Competition");
      frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      init(frame);
//      frame.getContentPane().add(p_label, BorderLayout.CENTER);
      frame.pack();
      frame.setVisible(true);
}
catch(Exception e){
// e.printStackTrace();
// System.out.println("CompetitionConfigurationWindow : Ecc");
}
}

public boolean writexml(){
try{
PrintWriter out;
File f = new File("../temp/comp_config.xml");
if (f.exists() == false ) {
out=new PrintWriter(new File("../temp/comp_config.xml"));
}
else {
out=new PrintWriter(f);
}
out.println("<?xml version=\"1.0\"?>\n<config>\n<name>");
out.print(textName.getText());
out.print("</name>\n<circuitConfigFile>");
out.print("race.xml");
out.print("</circuitConfigFile>\n<competitorQty>");
out.print(jsConc.getValue());
out.print("</competitorQty>\n<laps>");
out.print(jsLap.getValue());	
out.print("</laps>\n</config>");
out.close();
return true;
}
catch(IOException e){
// e.printStackTrace();
return false;
}
}

public void raceFileCreator(){
try{
BufferedReader raceTrackFile = new BufferedReader(new FileReader(fileRacetrack.getText()));
//              configCorbaLoc = corbaLocFile.readLine() ;
PrintWriter out;
File f = new File("../temp/race.xml");
if (f.exists() == false ) {
out=new PrintWriter(new File("../temp/race.xml"));
}
else {
out=new PrintWriter(f);
}
System.out.println("Start printing");
while(raceTrackFile.ready()){
out.println(raceTrackFile.readLine());
}
out.close();
}catch(Exception e){
// e.printStackTrace();
}

}

    public static void main(String[] args) {
String[]temp = {};
    CompetitionConfigurationWindow p=new CompetitionConfigurationWindow(temp);

}
}



