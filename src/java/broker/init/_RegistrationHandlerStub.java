package broker.init;


/**
* broker/init/_RegistrationHandlerStub.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from ../idl/init.idl
* mercoledì 29 settembre 2010 17.09.51 CEST
*/

public class _RegistrationHandlerStub extends org.omg.CORBA.portable.ObjectImpl implements broker.init.RegistrationHandler
{

  public void Join_Competition (String competitorDescriptorFile, String boxCorbaLoc, org.omg.CORBA.StringHolder monitorCorbaLoc, org.omg.CORBA.ShortHolder competitorId, org.omg.CORBA.FloatHolder circuitLength, org.omg.CORBA.ShortHolder laps)
  {
            org.omg.CORBA.portable.InputStream $in = null;
            try {
                org.omg.CORBA.portable.OutputStream $out = _request ("Join_Competition", true);
                $out.write_string (competitorDescriptorFile);
                $out.write_string (boxCorbaLoc);
                $in = _invoke ($out);
                monitorCorbaLoc.value = $in.read_string ();
                competitorId.value = $in.read_short ();
                circuitLength.value = $in.read_float ();
                laps.value = $in.read_short ();
                return;
            } catch (org.omg.CORBA.portable.ApplicationException $ex) {
                $in = $ex.getInputStream ();
                String _id = $ex.getId ();
                throw new org.omg.CORBA.MARSHAL (_id);
            } catch (org.omg.CORBA.portable.RemarshalException $rm) {
                Join_Competition (competitorDescriptorFile, boxCorbaLoc, monitorCorbaLoc, competitorId, circuitLength, laps        );
            } finally {
                _releaseReply ($in);
            }
  } // Join_Competition

  // Type-specific CORBA::Object operations
  private static String[] __ids = {
    "IDL:broker/init/RegistrationHandler:1.0"};

  public String[] _ids ()
  {
    return (String[])__ids.clone ();
  }

  private void readObject (java.io.ObjectInputStream s) throws java.io.IOException
  {
     String str = s.readUTF ();
     String[] args = null;
     java.util.Properties props = null;
     org.omg.CORBA.Object obj = org.omg.CORBA.ORB.init (args, props).string_to_object (str);
     org.omg.CORBA.portable.Delegate delegate = ((org.omg.CORBA.portable.ObjectImpl) obj)._get_delegate ();
     _set_delegate (delegate);
  }

  private void writeObject (java.io.ObjectOutputStream s) throws java.io.IOException
  {
     String[] args = null;
     java.util.Properties props = null;
     String str = org.omg.CORBA.ORB.init (args, props).object_to_string (this);
     s.writeUTF (str);
  }
} // class _RegistrationHandlerStub
