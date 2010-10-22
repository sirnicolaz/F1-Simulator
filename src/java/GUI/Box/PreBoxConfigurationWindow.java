package GUI.Box;

import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import javax.swing.JDialog.*;

import javax.swing.JPanel;
import javax.swing.JFrame;


public class PreBoxConfigurationWindow{
    private JLabel labelFile = new JLabel("1: Competitor file : ");
    private boolean selected = false;
    private JTextField fileCompetitor;
    private String fileName;//
    private JFrame parent;
    private JButton openButton;
    private JButton startButton;
    private String argument;
    private JCheckBox checkConf = new JCheckBox("Caricare configurazione da file", true);
    // private JButton undoButton;
    private JButton resetButton;
    private boolean uploadConfig = true;
    private void init(){
	fileCompetitor = new JTextField("competitor-"+argument+".xml",20);
	//parent=p;
	JPanel buttonPane = new JPanel(new BorderLayout());
	JPanel contentPane = new JPanel(new BorderLayout());
	checkConf.addItemListener(new ItemListener() {
		public void itemStateChanged(ItemEvent e) {
		    //Object source = e.getItemSelectable();
		    if(e.getStateChange() == ItemEvent.DESELECTED){
			fileCompetitor.setEnabled(false);
			openButton.setEnabled(false);
			uploadConfig = false;
		    }
		    else{
			fileCompetitor.setEnabled(true);
			openButton.setEnabled(true);
			uploadConfig = true;
		    }
		}
	    }
	    );
	openButton = new JButton("Sfoglia...");
	//azione per il bottone sfoglia. viene cosi selezionato il circuito.
	openButton.addActionListener(new ActionListener() {
		public void actionPerformed(ActionEvent e) {
		    JFileChooser fc = new JFileChooser("configuration-competitors/");
		    fc.setAcceptAllFileFilterUsed(false);
		    int returnVal = fc.showOpenDialog(parent);
		    if (returnVal == JFileChooser.APPROVE_OPTION) {
			try {
			    fileCompetitor.setText(fc.getSelectedFile().getName());
			    fileName = fc.getSelectedFile().getCanonicalPath();
			    System.out.println("FileName = "+fileName);
			    selected = true;
			} catch(Exception ecc) {
			    // 					    ecc.printStackTrace();
			}
		    }
		}
	    });

	fileCompetitor.addActionListener( new ActionListener(){
		public void actionPerformed( ActionEvent e ){
		    System.out.println( fileCompetitor.getText() );
		    fileName = fileCompetitor.getText();
		}
	    });


	startButton = new JButton("Carica Impostazione Box");
	startButton.addActionListener(new ActionListener() {
		public void actionPerformed(ActionEvent e) {
		    JFrame j = new JFrame("Box Admin Window n° "+ argument);
		    if(fileCompetitor.isEnabled() == true){
			if(selected != true){
			    fileName = "configuration-competitors/"+fileCompetitor.getText();
			    uploadConfig= true;
			}
		    }
		    else{
		      fileName = "configuration-competitors/competitor-1.xml";
		      uploadConfig=false;
		    }
		    System.out.println("FileName = "+fileName);
		    BoxConfigurationWindow boxWindow = new BoxConfigurationWindow(j, argument, uploadConfig, fileName);
		    boxWindow.init(j);
		    parent.dispose();
		}
	    }
	    );
	resetButton = new JButton("Ripristina predefinito");
	resetButton.addActionListener(new ActionListener() {
		public void actionPerformed(ActionEvent e) {
		    fileCompetitor.setText("competitor-1.xml");
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
	contentPane.add(checkConf, c);
	c.fill = GridBagConstraints.HORIZONTAL;
	c.gridx = 0;
	c.gridy = 1;
	c.ipady = 5;
	contentPane.add(labelFile, c);
	c.fill = GridBagConstraints.HORIZONTAL;
	c.gridx = 1;
	c.gridy = 1;
	c.ipady = 5;
	contentPane.add(fileCompetitor, c);
	c.fill = GridBagConstraints.HORIZONTAL;
	c.gridx = 2;
	c.gridy = 1;
	c.ipady = 5;
	contentPane.add(openButton, c);
	//BUTTON PANEL
	buttonPane.setLayout(new FlowLayout());
	buttonPane.add(resetButton);
	buttonPane.add(startButton);
	parent.add(contentPane, BorderLayout.PAGE_START);
	parent.add(buttonPane, BorderLayout.PAGE_END);

    }

    public PreBoxConfigurationWindow(JFrame frame, String arg){
	parent = frame;
	argument = arg;
	parent.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	init();
	parent.pack();
	parent.setVisible(true);
    }

    public static void main(String[] args) {
	JFrame frame = new JFrame("Init Box");
	PreBoxConfigurationWindow p=new PreBoxConfigurationWindow(frame, args[0]);

    }
}
