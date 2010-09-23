package broker.init;


/**
* broker/init/CompetitionConfiguratorHelper.java .
* Generated by the IDL-to-Java compiler (portable), version "3.2"
* from ../idl/init.idl
* Thursday, September 23, 2010 6:33:05 PM CEST
*/

abstract public class CompetitionConfiguratorHelper
{
  private static String  _id = "IDL:broker/init/CompetitionConfigurator:1.0";

  public static void insert (org.omg.CORBA.Any a, broker.init.CompetitionConfigurator that)
  {
    org.omg.CORBA.portable.OutputStream out = a.create_output_stream ();
    a.type (type ());
    write (out, that);
    a.read_value (out.create_input_stream (), type ());
  }

  public static broker.init.CompetitionConfigurator extract (org.omg.CORBA.Any a)
  {
    return read (a.create_input_stream ());
  }

  private static org.omg.CORBA.TypeCode __typeCode = null;
  synchronized public static org.omg.CORBA.TypeCode type ()
  {
    if (__typeCode == null)
    {
      __typeCode = org.omg.CORBA.ORB.init ().create_interface_tc (broker.init.CompetitionConfiguratorHelper.id (), "CompetitionConfigurator");
    }
    return __typeCode;
  }

  public static String id ()
  {
    return _id;
  }

  public static broker.init.CompetitionConfigurator read (org.omg.CORBA.portable.InputStream istream)
  {
    return narrow (istream.read_Object (_CompetitionConfiguratorStub.class));
  }

  public static void write (org.omg.CORBA.portable.OutputStream ostream, broker.init.CompetitionConfigurator value)
  {
    ostream.write_Object ((org.omg.CORBA.Object) value);
  }

  public static broker.init.CompetitionConfigurator narrow (org.omg.CORBA.Object obj)
  {
    if (obj == null)
      return null;
    else if (obj instanceof broker.init.CompetitionConfigurator)
      return (broker.init.CompetitionConfigurator)obj;
    else if (!obj._is_a (id ()))
      throw new org.omg.CORBA.BAD_PARAM ();
    else
    {
      org.omg.CORBA.portable.Delegate delegate = ((org.omg.CORBA.portable.ObjectImpl)obj)._get_delegate ();
      broker.init._CompetitionConfiguratorStub stub = new broker.init._CompetitionConfiguratorStub ();
      stub._set_delegate(delegate);
      return stub;
    }
  }

  public static broker.init.CompetitionConfigurator unchecked_narrow (org.omg.CORBA.Object obj)
  {
    if (obj == null)
      return null;
    else if (obj instanceof broker.init.CompetitionConfigurator)
      return (broker.init.CompetitionConfigurator)obj;
    else
    {
      org.omg.CORBA.portable.Delegate delegate = ((org.omg.CORBA.portable.ObjectImpl)obj)._get_delegate ();
      broker.init._CompetitionConfiguratorStub stub = new broker.init._CompetitionConfiguratorStub ();
      stub._set_delegate(delegate);
      return stub;
    }
  }

}
