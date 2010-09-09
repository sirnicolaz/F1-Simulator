pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  competitionConfigurator.idl
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

package CompetitionConfigurator is

   type Ref is
     new CORBA.Object.Ref with null record;

   Repository_Id : constant PolyORB.Std.String :=
     "IDL:CompetitionConfigurator:1.0";

   function Configure
     (Self : Ref;
      config : CORBA.String)
     return CORBA.String;

   Configure_Repository_Id : constant PolyORB.Std.String :=
     "IDL:CompetitionConfigurator/Configure:1.0";

   function Is_A
     (Self : Ref;
      Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

private
   function Is_A
     (Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

end CompetitionConfigurator;
