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

public class TvConfigurationWindow{
    private JFrame parent;
    private JPanel configPanel;
    private JPanel buttonPanel;
    private JLabel labelCorbaloc = new JLabel("Insert competition corbaloc : ");
    private JLabel labelRefresh = new JLabel("Insert updating refresh time : ");
    private JTextField textCorbaloc = new JTextField("",20);
    private JTextField textRefresh = new JTextField("1.0",5);
    private JButton startButton;
    private JButton resetButton;
    private Competition_Monitor_Radio monitor;
    private org.omg.CORBA.Object obj;
    private ORB orb;
    private String corbaloc;
    private ScreenTv screen;
    private float floatRefresh;
    private JPanel refreshPanel;
    // public TvConfigurationWindow(JFrame p){
    // parent = p;
    // }

    public void init(){
	parent = new JFrame("Tv Screen Configuration");
	parent.setLayout(new BorderLayout());
	// addConfigPanel(configPanel);
	try{
	    BufferedReader corbaLocFile = new BufferedReader(new FileReader("../temp/competition_corbaLoc.txt"));
	    corbaLocFile.readLine();
	    textCorbaloc.setText(corbaLocFile.readLine()) ;
	}catch(Exception e){}
	configPanel = new JPanel(new BorderLayout());
	configPanel.setBorder(BorderFactory.createTitledBorder(null, "Corbaloc", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
	configPanel.setLayout(new FlowLayout());

	configPanel.add(labelCorbaloc);
	configPanel.add(textCorbaloc);

	refreshPanel = new JPanel(new BorderLayout());
	refreshPanel.setBorder(BorderFactory.createTitledBorder(null, "Refresh rate (seconds)", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
	refreshPanel.setLayout(new FlowLayout());
	
	refreshPanel.add(labelRefresh);
	refreshPanel.add(textRefresh);

	// addButtonPanel(buttonPanel);
	buttonPanel= new JPanel(new BorderLayout());
	buttonPanel.setBorder(BorderFactory.createTitledBorder(null, "Submit & Undo", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION));
	buttonPanel.setLayout(new FlowLayout());

	startButton = new JButton("Connect to competition");
	startButton.addActionListener(new ActionListener() {
		public void actionPerformed(ActionEvent e) {
		    corbaloc=textCorbaloc.getText();
		    try{
			floatRefresh = new Float(textRefresh.getText()).floatValue();
			if(connect()==true){
			    screen = new ScreenTv(corbaloc, monitor, "Tv Screen", floatRefresh);
			    screen.start();
			    parent.dispose();
			}
		    }
		    catch(Exception exc){
			JOptionPane.showMessageDialog(parent, "Attention : error in format refresh time (use 1.0 for example, not 1,0)", "Error", JOptionPane.ERROR_MESSAGE);
		    }
		    // else{
		    // JOptionPane.showMessageDialog(parent, "Attention : yout MUST insert corbaloc to continue", "Warning", JOptionPane.WARNING_MESSAGE);
		    // }
		}
	    });

	resetButton = new JButton("Reset Field");
	resetButton.addActionListener(new ActionListener() {
		public void actionPerformed(ActionEvent e) {
		    resetInfo();			}
	    });

	buttonPanel.add(startButton);
	buttonPanel.add(resetButton);
	// parent.add(panel, BorderLayout.WEST);
	parent.add(configPanel, BorderLayout.NORTH);
	parent.add(refreshPanel, BorderLayout.CENTER);
	parent.add(buttonPanel, BorderLayout.SOUTH);
	parent.pack();
	parent.setVisible(true);
	parent.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }

    public void resetInfo(){
	System.out.println("Reset Field");
	textCorbaloc.setText("");
	textRefresh.setText("1.0");
    }

    public boolean connect(){
	System.out.println("Try to connect to Competition");
	try{
	    String[] temp = {"ORB"};
	    orb = ORB.init(temp, null);
	    obj = orb.string_to_object(textCorbaloc.getText());
	    monitor = Competition_Monitor_RadioHelper.narrow(obj);
	    // JOptionPane.showMessageDialog(parent, "return true", "Error", JOptionPane.WARNING_MESSAGE);

	    return true;
	}
	catch (Exception e){
	    System.out.println("Eccezione");
	    JOptionPane.showMessageDialog(parent, "Attention : connection error", "Error", JOptionPane.ERROR_MESSAGE);
	    e.printStackTrace();
	    return false;
	}
    }

    public static void main(String[] args){
	// JFrame frame = new JFrame("Tv Screen Configuration");
	TvConfigurationWindow cs = new TvConfigurationWindow();
	cs.init();
    }
}
