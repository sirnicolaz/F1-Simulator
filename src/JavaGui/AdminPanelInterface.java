import javax.swing.JPanel;
import javax.swing.JFrame;
public interface AdminPanelInterface{
  public void init(JFrame frame);//dovrà essere un JFrame
  //public boolean verifySetting();
  //public void confirmSetting();
  public void switchPanel(JPanel succPanel);//dovrà essere un JPanel
  public void resetInfo();
  public boolean connect();
}