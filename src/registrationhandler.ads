pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  registrationHandler.idl
--  by IAC (IDL to Ada Compiler) GPL 2009-20090519 (rev. 144248).
---------------------------------------------------
--  Do NOT hand-modify this file, as your
--  changes will be lost when you re-run the
--  IDL to Ada compiler.
---------------------------------------------------
with CORBA.Object;
with PolyORB.Std;
with CORBA;
pragma Elaborate_All (CORBA);

package RegistrationHandler is

   type Ref is
     new CORBA.Object.Ref with null record;

   Repository_Id : constant PolyORB.Std.String :=
     "IDL:RegistrationHandler:1.0";

   procedure Remote_Join
     (Self : Ref;
      competitorDescriptor : CORBA.String;
      address : CORBA.String;
      radioAddress : out CORBA.String;
      compId : out CORBA.Short;
      monitorSystemAddress : out CORBA.String);

   Remote_Join_Repository_Id : constant PolyORB.Std.String :=
     "IDL:RegistrationHandler/Remote_Join:1.0";

   function Remote_Ready
     (Self : Ref;
      compId : CORBA.Short)
     return CORBA.Boolean;

   Remote_Ready_Repository_Id : constant PolyORB.Std.String :=
     "IDL:RegistrationHandler/Remote_Ready:1.0";

   function Is_A
     (Self : Ref;
      Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

private
   function Is_A
     (Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

end RegistrationHandler;
