package broker.radio.Competition_Monitor_RadioPackage;


/**
* broker/radio/Competition_Monitor_RadioPackage/float_sequenceHolder.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from ../idl/radio.idl
* mercoledì 29 settembre 2010 0.59.20 CEST
*/

public final class float_sequenceHolder implements org.omg.CORBA.portable.Streamable
{
  public float value[] = null;

  public float_sequenceHolder ()
  {
  }

  public float_sequenceHolder (float[] initialValue)
  {
    value = initialValue;
  }

  public void _read (org.omg.CORBA.portable.InputStream i)
  {
    value = broker.radio.Competition_Monitor_RadioPackage.float_sequenceHelper.read (i);
  }

  public void _write (org.omg.CORBA.portable.OutputStream o)
  {
    broker.radio.Competition_Monitor_RadioPackage.float_sequenceHelper.write (o, value);
  }

  public org.omg.CORBA.TypeCode _type ()
  {
    return broker.radio.Competition_Monitor_RadioPackage.float_sequenceHelper.type ();
  }

}
