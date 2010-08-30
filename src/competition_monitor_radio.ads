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
with CORBA.Sequences.Unbounded;
with CORBA;
pragma Elaborate_All (CORBA);

package Competition_Monitor_Radio is

   type Ref is
     new CORBA.Object.Ref with null record;

   Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor_Radio:1.0";

   package IDL_SEQUENCE_float is
     new CORBA.Sequences.Unbounded
        (CORBA.Float);

   type float_sequence is
     new Competition_Monitor_Radio.IDL_SEQUENCE_float.Sequence;

   float_sequence_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor_Radio/float_sequence:1.0";

   procedure Get_CompetitorInfo
     (Self : Ref;
      lap : CORBA.Short;
      sector : CORBA.Short;
      id : CORBA.Short;
      time : out CORBA.Float;
      Returns : out CORBA.String);

   Get_CompetitorInfo_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor_Radio/Get_CompetitorInfo:1.0";

   procedure Get_CompetitionInfo
     (Self : Ref;
      timeInstant : CORBA.Float;
      xmlInfo : out CORBA.String;
      Returns : out Competition_Monitor_Radio.float_sequence);

   Get_CompetitionInfo_Repository_Id : constant PolyORB.Std.String :=
     "IDL:Competition_Monitor_Radio/Get_CompetitionInfo:1.0";

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
