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
with CORBA.Object;
with PolyORB.Std;
with CORBA;
pragma Elaborate_All (CORBA);

package MonitorSystem is

   type Ref is
     new CORBA.Object.Ref with null record;

   Repository_Id : constant PolyORB.Std.String :=
     "IDL:MonitorSystem:1.0";

   function getCompetitorInfo
     (Self : Ref;
      competitorId : CORBA.Short)
     return CORBA.String;

   getCompetitorInfo_Repository_Id : constant PolyORB.Std.String :=
     "IDL:MonitorSystem/getCompetitorInfo:1.0";

   function getCompetitionInfo
     (Self : Ref)
     return CORBA.String;

   getCompetitionInfo_Repository_Id : constant PolyORB.Std.String :=
     "IDL:MonitorSystem/getCompetitionInfo:1.0";

   function getEverything
     (Self : Ref;
      competitorId : CORBA.Short)
     return CORBA.String;

   getEverything_Repository_Id : constant PolyORB.Std.String :=
     "IDL:MonitorSystem/getEverything:1.0";

   function getClassification
     (Self : Ref)
     return CORBA.String;

   getClassification_Repository_Id : constant PolyORB.Std.String :=
     "IDL:MonitorSystem/getClassification:1.0";

   function getStatsBySect
     (Self : Ref;
      compId : CORBA.Short;
      sector : CORBA.Short;
      lap : CORBA.Short)
     return CORBA.String;

   getStatsBySect_Repository_Id : constant PolyORB.Std.String :=
     "IDL:MonitorSystem/getStatsBySect:1.0";

   function Is_A
     (Self : Ref;
      Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

private
   function Is_A
     (Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

end MonitorSystem;
