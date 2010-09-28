package broker.radio;


/**
* broker/radio/_Competition_Monitor_RadioStub.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from ../idl/radio.idl
* Tuesday, September 28, 2010 11:55:22 AM CEST
*/

public class _Competition_Monitor_RadioStub extends org.omg.CORBA.portable.ObjectImpl implements broker.radio.Competition_Monitor_Radio
{

  public String Get_CompetitorInfo (short lap, short sector, short id, org.omg.CORBA.FloatHolder time, org.omg.CORBA.FloatHolder metres)
  {
            org.omg.CORBA.portable.InputStream $in = null;
            try {
                org.omg.CORBA.portable.OutputStream $out = _request ("Get_CompetitorInfo", true);
                $out.write_short (lap);
                $out.write_short (sector);
                $out.write_short (id);
                $in = _invoke ($out);
                String $result = $in.read_string ();
                time.value = $in.read_float ();
                metres.value = $in.read_float ();
                return $result;
            } catch (org.omg.CORBA.portable.ApplicationException $ex) {
                $in = $ex.getInputStream ();
                String _id = $ex.getId ();
                throw new org.omg.CORBA.MARSHAL (_id);
            } catch (org.omg.CORBA.portable.RemarshalException $rm) {
                return Get_CompetitorInfo (lap, sector, id, time, metres        );
            } finally {
                _releaseReply ($in);
            }
  } // Get_CompetitorInfo

  public float[] Get_CompetitionInfo (float timeInstant, org.omg.CORBA.StringHolder xmlInfo)
  {
            org.omg.CORBA.portable.InputStream $in = null;
            try {
                org.omg.CORBA.portable.OutputStream $out = _request ("Get_CompetitionInfo", true);
                $out.write_float (timeInstant);
                $in = _invoke ($out);
                float $result[] = broker.radio.Competition_Monitor_RadioPackage.float_sequenceHelper.read ($in);
                xmlInfo.value = $in.read_string ();
                return $result;
            } catch (org.omg.CORBA.portable.ApplicationException $ex) {
                $in = $ex.getInputStream ();
                String _id = $ex.getId ();
                throw new org.omg.CORBA.MARSHAL (_id);
            } catch (org.omg.CORBA.portable.RemarshalException $rm) {
                return Get_CompetitionInfo (timeInstant, xmlInfo        );
            } finally {
                _releaseReply ($in);
            }
  } // Get_CompetitionInfo

  public boolean ready (short competitorId)
  {
            org.omg.CORBA.portable.InputStream $in = null;
            try {
                org.omg.CORBA.portable.OutputStream $out = _request ("ready", true);
                $out.write_short (competitorId);
                $in = _invoke ($out);
                boolean $result = $in.read_boolean ();
                return $result;
            } catch (org.omg.CORBA.portable.ApplicationException $ex) {
                $in = $ex.getInputStream ();
                String _id = $ex.getId ();
                throw new org.omg.CORBA.MARSHAL (_id);
            } catch (org.omg.CORBA.portable.RemarshalException $rm) {
                return ready (competitorId        );
            } finally {
                _releaseReply ($in);
            }
  } // ready

  public float Get_CompetitionConfiguration (org.omg.CORBA.StringHolder xmlConf)
  {
            org.omg.CORBA.portable.InputStream $in = null;
            try {
                org.omg.CORBA.portable.OutputStream $out = _request ("Get_CompetitionConfiguration", true);
                $out.write_string (xmlConf.value);
                $in = _invoke ($out);
                float $result = $in.read_float ();
                xmlConf.value = $in.read_string ();
                return $result;
            } catch (org.omg.CORBA.portable.ApplicationException $ex) {
                $in = $ex.getInputStream ();
                String _id = $ex.getId ();
                throw new org.omg.CORBA.MARSHAL (_id);
            } catch (org.omg.CORBA.portable.RemarshalException $rm) {
                return Get_CompetitionConfiguration (xmlConf        );
            } finally {
                _releaseReply ($in);
            }
  } // Get_CompetitionConfiguration

  public String Get_CompetitorConfiguration (short id)
  {
            org.omg.CORBA.portable.InputStream $in = null;
            try {
                org.omg.CORBA.portable.OutputStream $out = _request ("Get_CompetitorConfiguration", true);
                $out.write_short (id);
                $in = _invoke ($out);
                String $result = $in.read_string ();
                return $result;
            } catch (org.omg.CORBA.portable.ApplicationException $ex) {
                $in = $ex.getInputStream ();
                String _id = $ex.getId ();
                throw new org.omg.CORBA.MARSHAL (_id);
            } catch (org.omg.CORBA.portable.RemarshalException $rm) {
                return Get_CompetitorConfiguration (id        );
            } finally {
                _releaseReply ($in);
            }
  } // Get_CompetitorConfiguration

  // Type-specific CORBA::Object operations
  private static String[] __ids = {
    "IDL:broker/radio/Competition_Monitor_Radio:1.0"};

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
} // class _Competition_Monitor_RadioStub
