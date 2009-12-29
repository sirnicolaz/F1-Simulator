pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  monitorSystem.idl
--  by IAC (IDL to Ada Compiler) GPL 2009-20090519 (rev. 144248).
---------------------------------------------------
--  Do NOT hand-modify this file, as your
--  changes will be lost when you re-run the
--  IDL to Ada compiler.
---------------------------------------------------
with CORBA;
pragma Elaborate_All (CORBA);
with CORBA.Object;

package MonitorSystem.Helper is

   TC_MonitorSystem : CORBA.TypeCode.Object;

   function From_Any
     (Item : CORBA.Any)
     return MonitorSystem.Ref;

   function To_Any
     (Item : MonitorSystem.Ref)
     return CORBA.Any;

   function Unchecked_To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return MonitorSystem.Ref;

   function To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return MonitorSystem.Ref;

   
   package Internals is

      procedure Initialize_MonitorSystem;

   end Internals;

end MonitorSystem.Helper;
