
/**
* Competition_Monitor_RadioOperations.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from competition_monitor_radio.idl
* Wednesday, August 25, 2010 9:51:31 AM CEST
*/

public interface Competition_Monitor_RadioOperations 
{
  String Get_CompetitorInfo (short lap, short sector, short id, org.omg.CORBA.FloatHolder time);
  String Get_CompetitionInfo (float timeInstant);
  String getBestLap ();
  String getBestSector (short index);
  boolean ready (short competitorId);
} // interface Competition_Monitor_RadioOperations