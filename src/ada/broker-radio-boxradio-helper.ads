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

package broker.radio.BoxRadio.Helper is

   TC_BoxRadio : CORBA.TypeCode.Object;

   function From_Any
     (Item : CORBA.Any)
     return broker.radio.BoxRadio.Ref;

   function To_Any
     (Item : broker.radio.BoxRadio.Ref)
     return CORBA.Any;

   function Unchecked_To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return broker.radio.BoxRadio.Ref;

   function To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return broker.radio.BoxRadio.Ref;

   
   package Internals is

      procedure Initialize_BoxRadio;

   end Internals;

end broker.radio.BoxRadio.Helper;
