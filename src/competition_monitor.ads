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
with CORBA.Object;
with PolyORB.Std;
with CORBA;
pragma Elaborate_All (CORBA);

package Competition_Monitor is

   type Ref is
     new CORBA.Object.Ref with null record;

   Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor:1.0";

   function getClassific
     (Self : Ref)
     return CORBA.String;

   getClassific_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getClassific:1.0";

   function getBestLap
     (Self : Ref)
     return CORBA.String;

   getBestLap_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getBestLap:1.0";

   function getBestSector
     (Self : Ref;
      index : CORBA.Short)
     return CORBA.String;

   getBestSector_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getBestSector:1.0";

   function getCondCar
     (Self : Ref;
      competitorID : CORBA.Short)
     return CORBA.String;

   getCondCar_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getCondCar:1.0";

   function getCompetitor
     (Self : Ref;
      competitorID : CORBA.Short)
     return CORBA.String;

   getCompetitor_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getCompetitor:1.0";

   function getCompetitorTimeSector
     (Self : Ref;
      competitorID : CORBA.Short;
      sectorIn : CORBA.Short)
     return CORBA.String;

   getCompetitorTimeSector_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getCompetitorTimeSector:1.0";

   function getCompetitorTimeLap
     (Self : Ref;
      competitorID : CORBA.Short;
      lapIn : CORBA.Short)
     return CORBA.String;

   getCompetitorTimeLap_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getCompetitorTimeLap:1.0";

   function getCompetitorTimeCheck
     (Self : Ref;
      competitorID : CORBA.Short;
      checkpoint : CORBA.Short)
     return CORBA.String;

   getCompetitorTimeCheck_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getCompetitorTimeCheck:1.0";

   function getGas
     (Self : Ref;
      Competitor_Id : CORBA.Short;
      Sector : CORBA.Short;
      Lap : CORBA.Short)
     return CORBA.String;

   getGas_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getGas:1.0";

   function getTyreUsury
     (Self : Ref;
      Competitor_Id : CORBA.Short;
      Sector : CORBA.Short;
      Lap : CORBA.Short)
     return CORBA.String;

   getTyreUsury_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getTyreUsury:1.0";

   function getMeanSpeed
     (Self : Ref;
      Competitor_Id : CORBA.Short;
      Sector : CORBA.Short;
      Lap : CORBA.Short)
     return CORBA.String;

   getMeanSpeed_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getMeanSpeed:1.0";

   function getTime
     (Self : Ref;
      Competitor_Id : CORBA.Short;
      Sector : CORBA.Short;
      Lap : CORBA.Short)
     return CORBA.String;

   getTime_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getTime:1.0";

   function getMeanGasConsumption
     (Self : Ref;
      Competitor_Id : CORBA.Short;
      Sector : CORBA.Short;
      Lap : CORBA.Short)
     return CORBA.String;

   getMeanGasConsumption_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor/getMeanGasConsumption:1.0";

   function Is_A
     (Self : Ref;
      Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

private
   function Is_A
     (Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean;

end Competition_Monitor;
