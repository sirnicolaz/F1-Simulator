
/**
* RegistrationHandlerOperations.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from registrationHandler.idl
* Wednesday, July 21, 2010 2:33:10 PM CEST
*/

public interface RegistrationHandlerOperations 
{
  void Join_Competition (String competitorDescriptorFile, String boxCorbaLoc, org.omg.CORBA.StringHolder monitorCorbaLoc, org.omg.CORBA.ShortHolder competitorId);
  String Wait_Ready (short competitorId);
} // interface RegistrationHandlerOperations
