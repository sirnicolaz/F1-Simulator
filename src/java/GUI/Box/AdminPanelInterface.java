package GUI.Box;

import javax.swing.JPanel;
import javax.swing.JFrame;
public interface AdminPanelInterface{
    public void init(JFrame frame);
    public void switchPanel();
    public void resetInfo();
    public void connect(String corbaloc);
}
