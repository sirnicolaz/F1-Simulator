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


public class StartCompetition {
private String corbalocMonitor;
private Competition_Monitor_Radio monitor;
private screenTv screen;
private org.omg.CORBA.ORB orb;
private CompetitionConfigurator conf;
private JLabel labelFile = new JLabel("1: File of racetrack : ");
private JLabel labelCompetitor = new JLabel("2: Maximum number of competitor : ");
private JLabel labelLap = new JLabel("3: Number  : ");
private JLabel labelName = new JLabel("4: Name of circuit : ");
private JLabel labelRefresh = new JLabel("5 : Refresh Time : ");
/*private JLabel p_label5 = new JLabel("5 SConfigura la competizione");
private JLabel p_label6 = new JLabel("6 SConfigura la competizione");*/
private JTextField fileRacetrack = new JTextField("obj/race.xml", 15);
/*private JTextField  numCompetitor = new JTextField("6");
private JTextField numLap = new JTextField("10");*/
/*private JTextField p_Text4 = new JTextField("testo 4");
private JTextField p_Text5 = new JTextField("testo 5");
private JTextField p_Text6 = new JTextField("testo 6");*/
private JFrame parent;
private JTextField textName = new JTextField("Monza", 10);
private JButton openButton;
private JButton startButton;
// private JButton undoButton;
private JButton resetButton;
private int intName=0;
SpinnerNumberModel modelConc = new SpinnerNumberModel(3, 1, 20, 1); 
SpinnerNumberModel modelLap = new SpinnerNumberModel(10, 1, 100, 1);
SpinnerNumberModel modelRefresh = new SpinnerNumberModel(43,35,50,1);
private JSpinner jsConc = new JSpinner(modelConc);
private JSpinner jsLap = new JSpinner(modelLap);
private JSpinner jsRefresh = new JSpinner(modelRefresh);
private void init(JFrame p){
parent=p;


JPanel buttonPane = new JPanel(new BorderLayout());
JPanel contentPane = new JPanel(new BorderLayout());
// contentPane.setLayout(new GridLayout(0, 1));
// contentPane.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
//JFileChooser fc = new JFileChooser(".");
openButton = new JButton("Sfoglia...");
//openButton.addActionListener(this);
//azione per il bottone sfoglia. viene cosi selezionato il circuito.
	openButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			JFileChooser fc = new JFileChooser("../obj/");
		        fc.setAcceptAllFileFilterUsed(false);
				int returnVal = fc.showOpenDialog(parent);
				if (returnVal == JFileChooser.APPROVE_OPTION) {
					try {
						fileRacetrack.setText(fc.getSelectedFile().getCanonicalPath());
					} catch(Exception ecc) {
					    ecc.printStackTrace();
					}
				}
			}
		});
		startButton = new JButton("Avvia Competizione");
		startButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			    System.out.println("Competizione avviata");
if(writexml()== true){
parent.dispose();
conf.Configure("obj/comp_config.xml");
screen = new screenTv(corbalocMonitor, monitor);
screen.start();
}
			}
		});
		resetButton = new JButton("Ripristina predefinito");
		resetButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			    fileRacetrack.setText("obj/race.xml");
			    jsLap.setValue(10);
			    jsConc.setValue(5);
			    textName.setText("Monza");
			    jsRefresh.setValue(43);
			    
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

// p.getContentPane().add(contentPane);

		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 0;
		c.gridy = 4;
		c.ipady = 5;
		contentPane.add(labelRefresh, c);
		c.fill = GridBagConstraints.HORIZONTAL;
		c.gridx = 1;
		c.gridy = 4;
		c.ipady = 5;
		contentPane.add(jsRefresh, c);

//BUTTON PANEL
		buttonPane.setLayout(new FlowLayout());
		buttonPane.add(resetButton);
		buttonPane.add(startButton);
		p.add(contentPane, BorderLayout.PAGE_START);
		p.add(buttonPane, BorderLayout.PAGE_END);
}

    public StartCompetition(String[] args){
try{
//    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
// UIManager.setLookAndFeel("javax.swing.plaf.metal.MetalLookAndFeel");
// UIManager.setLookAndFeel("com.sun.java.swing.plaf.motif.MotifLookAndFeel");

orb = org.omg.CORBA.ORB.init(args,null);

String configCorbaLoc="";
corbalocMonitor = "";
try{
BufferedReader corbaLocFile = new BufferedReader(new FileReader("../competition_corbaLoc.txt"));
              configCorbaLoc = corbaLocFile.readLine() ;
System.out.println(configCorbaLoc);
	      corbalocMonitor= corbaLocFile.readLine();
System.out.println(corbalocMonitor);
}catch(Exception e){}
      org.omg.CORBA.Object competition_obj = orb.string_to_object(configCorbaLoc);

      conf = CompetitionConfiguratorHelper.narrow(competition_obj);

      org.omg.CORBA.Object monitor_obj = orb.string_to_object(corbalocMonitor);
      monitor = Competition_Monitor_RadioHelper.narrow(monitor_obj);
      JFrame frame = new JFrame("Configure Competition");
      frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      init(frame);
//      frame.getContentPane().add(p_label, BorderLayout.CENTER);
      frame.pack();
      frame.setVisible(true);
}
catch(Exception e){
e.printStackTrace();
}
}

public boolean writexml(){
try{
PrintWriter out;
File f = new File("../obj/comp_config.xml");
if (f.exists() == false ) {
out=new PrintWriter(new File("../obj/comp_config.xml"));
}
else {
out=new PrintWriter(f);
}
out.println("<?xml version=\"1.0\"?>\n<config>\n<name>");
out.print(textName.getText());
out.print("</name>\n<circuitConfigFile>");
out.print(fileRacetrack.getText());
out.print("</circuitConfigFile>\n<classificRefreshTime>"+jsRefresh.getValue()+".0</classificRefreshTime>\n<competitorQty>");
out.print(jsConc.getValue());
out.print("</competitorQty>\n<laps>");
out.print(jsLap.getValue());	
out.print("</laps>\n</config>");
out.close();
return true;
}
catch(IOException e){
e.printStackTrace();
return false;
}
}

    public static void main(String[] args) {
String[]temp = {};
    StartCompetition p=new StartCompetition(temp);

}
}



