package broker.radio;


/**
* broker/radio/Competition_Monitor_RadioOperations.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from ../idl/radio.idl
* Thursday, September 23, 2010 6:33:06 PM CEST
*/

public interface Competition_Monitor_RadioOperations 
{
  String Get_CompetitorInfo (short lap, short sector, short id, org.omg.CORBA.FloatHolder time, org.omg.CORBA.FloatHolder metres);
  float[] Get_CompetitionInfo (float timeInstant, org.omg.CORBA.StringHolder xmlInfo);
  boolean ready (short competitorId);
  float Get_CompetitionConfiguration (org.omg.CORBA.StringHolder xmlConf);
  String Get_CompetitorConfiguration (short id);
} // interface Competition_Monitor_RadioOperations