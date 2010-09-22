pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  ../idl/init.idl
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

package broker.init.RegistrationHandler is

   type Ref is
     new CORBA.Object.Ref with null record;

   Repository_Id : constant PolyORB.Std.String :=
     "IDL:broker/init/RegistrationHandler:1.0";

   procedure Join_Competition
     (Self : Ref;
      competitorDescriptorFile : CORBA.String;
      boxCorbaLoc : CORBA.String;
      monitorCorbaLoc : out CORBA.String;
      competitorId : out CORBA.Short;
      circuitLength : out CORBA.Float;
      laps : out CORBA.Short);

   Join_Competition_Repository_Id : constant PolyORB.Std.String :=
     "IDL:broker/init/RegistrationHandler/Join_Competition:1.0";

   function Is_A
     (Self : Ref;
      Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

private
   function Is_A
     (Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

end broker.init.RegistrationHandler;
