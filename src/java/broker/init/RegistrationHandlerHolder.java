package broker.init;

/**
* broker/init/RegistrationHandlerHolder.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from ../idl/init.idl
* martedì 28 settembre 2010 12.39.28 CEST
*/

public final class RegistrationHandlerHolder implements org.omg.CORBA.portable.Streamable
{
  public broker.init.RegistrationHandler value = null;

  public RegistrationHandlerHolder ()
  {
  }

  public RegistrationHandlerHolder (broker.init.RegistrationHandler initialValue)
  {
    value = initialValue;
  }

  public void _read (org.omg.CORBA.portable.InputStream i)
  {
    value = broker.init.RegistrationHandlerHelper.read (i);
  }

  public void _write (org.omg.CORBA.portable.OutputStream o)
  {
    broker.init.RegistrationHandlerHelper.write (o, value);
  }

  public org.omg.CORBA.TypeCode _type ()
  {
    return broker.init.RegistrationHandlerHelper.type ();
  }

}
