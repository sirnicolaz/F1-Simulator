package broker.init;

/**
* broker/init/BoxConfiguratorHolder.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from ../idl/init.idl
* martedì 28 settembre 2010 12.39.28 CEST
*/

public final class BoxConfiguratorHolder implements org.omg.CORBA.portable.Streamable
{
  public broker.init.BoxConfigurator value = null;

  public BoxConfiguratorHolder ()
  {
  }

  public BoxConfiguratorHolder (broker.init.BoxConfigurator initialValue)
  {
    value = initialValue;
  }

  public void _read (org.omg.CORBA.portable.InputStream i)
  {
    value = broker.init.BoxConfiguratorHelper.read (i);
  }

  public void _write (org.omg.CORBA.portable.OutputStream o)
  {
    broker.init.BoxConfiguratorHelper.write (o, value);
  }

  public org.omg.CORBA.TypeCode _type ()
  {
    return broker.init.BoxConfiguratorHelper.type ();
  }

}
