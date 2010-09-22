pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  ../idl/radio.idl
--  by IAC (IDL to Ada Compiler) GPL 2009-20090519 (rev. 144248).
---------------------------------------------------
--  Do NOT hand-modify this file, as your
--  changes will be lost when you re-run the
--  IDL to Ada compiler.
---------------------------------------------------
with CORBA;
pragma Elaborate_All (CORBA);
with CORBA.Object;

package broker.radio.Box_Monitor_Radio.Helper is

   TC_Box_Monitor_Radio : CORBA.TypeCode.Object;

   function From_Any
     (Item : CORBA.Any)
     return broker.radio.Box_Monitor_Radio.Ref;

   function To_Any
     (Item : broker.radio.Box_Monitor_Radio.Ref)
     return CORBA.Any;

   function Unchecked_To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return broker.radio.Box_Monitor_Radio.Ref;

   function To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return broker.radio.Box_Monitor_Radio.Ref;

   
   package Internals is

      procedure Initialize_Box_Monitor_Radio;

   end Internals;

end broker.radio.Box_Monitor_Radio.Helper;
