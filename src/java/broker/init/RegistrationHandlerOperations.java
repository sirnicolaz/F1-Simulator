package broker.init;


/**
* broker/init/RegistrationHandlerOperations.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from ../idl/init.idl
* Tuesday, September 28, 2010 11:55:22 AM CEST
*/

public interface RegistrationHandlerOperations 
{
  void Join_Competition (String competitorDescriptorFile, String boxCorbaLoc, org.omg.CORBA.StringHolder monitorCorbaLoc, org.omg.CORBA.ShortHolder competitorId, org.omg.CORBA.FloatHolder circuitLength, org.omg.CORBA.ShortHolder laps);
} // interface RegistrationHandlerOperations
