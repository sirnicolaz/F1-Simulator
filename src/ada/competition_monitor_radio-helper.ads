pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  competition_monitor_radio.idl
--  by IAC (IDL to Ada Compiler) GPL 2009-20090519 (rev. 144248).
---------------------------------------------------
--  Do NOT hand-modify this file, as your
--  changes will be lost when you re-run the
--  IDL to Ada compiler.
---------------------------------------------------
with CORBA;
pragma Elaborate_All (CORBA);
with CORBA.Object;
with PolyORB.Any;
with PolyORB.Sequences.Unbounded.CORBA_Helper;
pragma Elaborate_All (PolyORB.Sequences.Unbounded.CORBA_Helper);

package Competition_Monitor_Radio.Helper is

   TC_Competition_Monitor_Radio : CORBA.TypeCode.Object;

   function From_Any
     (Item : CORBA.Any)
     return Competition_Monitor_Radio.Ref;

   function To_Any
     (Item : Competition_Monitor_Radio.Ref)
     return CORBA.Any;

   function Unchecked_To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return Competition_Monitor_Radio.Ref;

   function To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return Competition_Monitor_Radio.Ref;

   TC_IDL_SEQUENCE_float : CORBA.TypeCode.Object;

   function From_Any
     (Item : CORBA.Any)
     return Competition_Monitor_Radio.IDL_SEQUENCE_float.Sequence;

   function To_Any
     (Item : Competition_Monitor_Radio.IDL_SEQUENCE_float.Sequence)
     return CORBA.Any;

   TC_float_sequence : CORBA.TypeCode.Object;

   function From_Any
     (Item : CORBA.Any)
     return Competition_Monitor_Radio.float_sequence;

   function To_Any
     (Item : Competition_Monitor_Radio.float_sequence)
     return CORBA.Any;

   
   package Internals is

      procedure Initialize_Competition_Monitor_Radio;

      function IDL_SEQUENCE_float_Element_Wrap
        (X : access CORBA.Float)
        return PolyORB.Any.Content'Class;

      function Wrap
        (X : access Competition_Monitor_Radio.IDL_SEQUENCE_float.Sequence)
        return PolyORB.Any.Content'Class;

      package IDL_SEQUENCE_float_Helper is
        new Competition_Monitor_Radio.IDL_SEQUENCE_float.CORBA_Helper
           (Element_From_Any => CORBA.From_Any,
            Element_To_Any => CORBA.To_Any,
            Element_Wrap => Competition_Monitor_Radio.Helper.Internals.IDL_SEQUENCE_float_Element_Wrap);

      procedure Initialize_IDL_SEQUENCE_float;

      procedure Initialize_float_sequence;

   end Internals;

end Competition_Monitor_Radio.Helper;
