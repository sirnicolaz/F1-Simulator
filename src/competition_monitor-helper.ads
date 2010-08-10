pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  competition_monitor.idl
--  by IAC (IDL to Ada Compiler) GPL 2009-20090519 (rev. 144248).
---------------------------------------------------
--  Do NOT hand-modify this file, as your
--  changes will be lost when you re-run the
--  IDL to Ada compiler.
---------------------------------------------------
with CORBA;
pragma Elaborate_All (CORBA);
with CORBA.Object;

package Competition_Monitor.Helper is

   TC_Competition_Monitor : CORBA.TypeCode.Object;

   function From_Any
     (Item : CORBA.Any)
     return Competition_Monitor.Ref;

   function To_Any
     (Item : Competition_Monitor.Ref)
     return CORBA.Any;

   function Unchecked_To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return Competition_Monitor.Ref;

   function To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return Competition_Monitor.Ref;

   
   package Internals is

      procedure Initialize_Competition_Monitor;

   end Internals;

end Competition_Monitor.Helper;
