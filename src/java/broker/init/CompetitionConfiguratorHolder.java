package broker.init;

/**
* broker/init/CompetitionConfiguratorHolder.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from ../idl/init.idl
* Thursday, September 23, 2010 6:33:05 PM CEST
*/

public final class CompetitionConfiguratorHolder implements org.omg.CORBA.portable.Streamable
{
  public broker.init.CompetitionConfigurator value = null;

  public CompetitionConfiguratorHolder ()
  {
  }

  public CompetitionConfiguratorHolder (broker.init.CompetitionConfigurator initialValue)
  {
    value = initialValue;
  }

  public void _read (org.omg.CORBA.portable.InputStream i)
  {
    value = broker.init.CompetitionConfiguratorHelper.read (i);
  }

  public void _write (org.omg.CORBA.portable.OutputStream o)
  {
    broker.init.CompetitionConfiguratorHelper.write (o, value);
  }

  public org.omg.CORBA.TypeCode _type ()
  {
    return broker.init.CompetitionConfiguratorHelper.type ();
  }

}
