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
with CORBA.Object;
with PolyORB.Std;
with CORBA;
pragma Elaborate_All (CORBA);

package Competition_Monitor_Radio is

   type Ref is
     new CORBA.Object.Ref with null record;

   Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor_Radio:1.0";

   function getInfo
     (Self : Ref;
      lap : CORBA.Short;
      sector : CORBA.Short;
      id : CORBA.Short)
     return CORBA.String;

   getInfo_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor_Radio/getInfo:1.0";

   function getBestLap
     (Self : Ref)
     return CORBA.String;

   getBestLap_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor_Radio/getBestLap:1.0";

   function getBestSector
     (Self : Ref;
      index : CORBA.Short)
     return CORBA.String;

   getBestSector_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor_Radio/getBestSector:1.0";

   function ready
     (Self : Ref;
      competitorId : CORBA.Short)
     return CORBA.Boolean;

   ready_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor_Radio/ready:1.0";

   function Is_A
     (Self : Ref;
      Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

private
   function Is_A
     (Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

end Competition_Monitor_Radio;
