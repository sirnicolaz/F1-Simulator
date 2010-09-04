import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.SwingUtilities;
import javax.swing.filechooser.*;


public class StartCompetition {
private org.omg.CORBA.ORB orb;
private CompetitionConfigurator conf;
private JLabel labelFile = new JLabel("1: File della pista : ");
private JLabel labelCompetitor = new JLabel("2: Numero massimo concorrenti : ");
private JLabel labelLap = new JLabel("3: Numero di giri per la gara : ");
private JLabel labelName = new JLabel("4: Nome del circuito : ");
/*private JLabel p_label5 = new JLabel("5 SConfigura la competizione");
private JLabel p_label6 = new JLabel("6 SConfigura la competizione");*/
private JTextField fileRacetrack = new JTextField("../obj/racetrack.xml", 15);
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
SpinnerNumberModel modelConc = new SpinnerNumberModel(5, 1, 20, 1); 
SpinnerNumberModel modelLap = new SpinnerNumberModel(10, 1, 100, 1);
private JSpinner jsConc = new JSpinner(modelConc);
private JSpinner jsLap = new JSpinner(modelLap);
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
conf.Configure("obj/comp_config.xml");
//avvio competizione
}
			    //comando per avviare la competizione.
			    //avvio pannelli della competizione
			}
		});

/*contentPane.add(p_label, BorderLayout.CENTER);
contentPane.add(p_label2, BorderLayout.PAGE_END);*/

// 		String[] meteo = { "Sun", "Weak Rain", "Rain", "Hard Rain"};
// 		comboName = new JComboBox(meteo);
// 		comboName.setSelectedIndex(0);
// 		comboName.addActionListener(new ActionListener() {
// 			public void actionPerformed(ActionEvent e) {
// 				JComboBox cb = (JComboBox)e.getSource();
// 				String s = (String)cb.getSelectedItem();
// 				if(s.equals("Sun")) {intName = 0;}
// 				else if(s.equals("Weak Rain")) {intName = 1;}
// 				else if(s.equals("Rain")) {intName = 2;}
// 				else if(s.equals("Hard Rain")) {intName = 3;}
// 			}
// 		});


		resetButton = new JButton("Ripristina predefinito");
		resetButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			    fileRacetrack.setText("../obj/racetrack.xml");
			    jsLap.setValue(10);
			    jsConc.setValue(5);
			    textName.setText("Monza");
			    
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


//BUTTON PANEL
		buttonPane.setLayout(new FlowLayout());
		buttonPane.add(resetButton);
		buttonPane.add(startButton);
		p.add(contentPane, BorderLayout.PAGE_START);
		p.add(buttonPane, BorderLayout.PAGE_END);
}

    public StartCompetition(){
      JFrame frame = new JFrame("Configure Competition");
      frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      init(frame);
//      frame.getContentPane().add(p_label, BorderLayout.CENTER);
      frame.pack();
      frame.setVisible(true);
}

public boolean writexml(){
try{
PrintWriter out;
File f = new File("obj/comp_config.xml");
if (f.exists() == false ) {
out=new PrintWriter(new File("obj/comp_config.xml"));
}
else {
out=new PrintWriter(f);
}
out.println("<?xml version=\"1.0\"?>\n<config>\n<name>");
out.println(textName.getText());
out.println("</name>\n<circuitConfigFile>");
out.println(fileRacetrack.getText());
out.println("</circuitConfigFile>\n<competitorQty>");
out.println(jsConc.getValue());
out.println("</competitorQty>\n<lap>");
out.println(jsLap.getValue());	
out.close("</lap></config>");
return true;
}
catch(IOException e){
e.printStackTrace();
return false;
}
}

    public static void main(String[] args) {
try{
//    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
// UIManager.setLookAndFeel("javax.swing.plaf.metal.MetalLookAndFeel");
// UIManager.setLookAndFeel("com.sun.java.swing.plaf.motif.MotifLookAndFeel");

orb = org.omg.CORBA.ORB.init(args,null);

String configCorbaLoc="";
try{
BufferedReader corbaLocFile = new BufferedReader(new FileReader("../competition_corbaLoc.txt"));
              configCorbaLoc = corbaLocFile.readLine() ;
}catch(Exception e){}
               org.omg.CORBA.Object competition_obj = orb.string_to_object(configCorbaLoc);
               conf = CompetitionConfiguratorHelper.narrow(competition_obj);

    StartCompetition p=new StartCompetition();
}
catch(Exception e){
e.printStackTrace();
}
}
}



