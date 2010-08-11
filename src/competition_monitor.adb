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
with PolyORB.Any.NVList;
with PolyORB.Any;
with PolyORB.Types;
with PolyORB.Requests;
with PolyORB.CORBA_P.Interceptors_Hooks;
with PolyORB.CORBA_P.Exceptions;

package body Competition_Monitor is

   getClassific_Arg_Name_idComp_In_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("idComp_In");

   getClassific_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ---------------------------
   -- getClassific_Result_Ü --
   ---------------------------

   function getClassific_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getClassific_Result_Ü);
   begin
      return (Name => getClassific_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getClassific_Result_Ü;

   ------------------
   -- getClassific --
   ------------------

   function getClassific
     (Self : Ref;
      idComp_In : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_idComp_In_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (idComp_In'Unrestricted_Access);
      Arg_Any_idComp_In_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_idComp_In_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getClassific_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getClassific_Arg_Name_idComp_In_Ü,
         PolyORB.Any.Any
           (Arg_Any_idComp_In_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getClassific",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getClassific;

   getInfo_Arg_Name_lap_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("lap");

   getInfo_Arg_Name_sector_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("sector");

   getInfo_Arg_Name_id_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("id");

   getInfo_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ----------------------
   -- getInfo_Result_Ü --
   ----------------------

   function getInfo_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getInfo_Result_Ü);
   begin
      return (Name => getInfo_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getInfo_Result_Ü;

   -------------
   -- getInfo --
   -------------

   function getInfo
     (Self : Ref;
      lap : CORBA.Short;
      sector : CORBA.Short;
      id : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_lap_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (lap'Unrestricted_Access);
      Arg_Any_lap_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_lap_Ü'Unchecked_Access);
      Arg_CC_sector_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (sector'Unrestricted_Access);
      Arg_Any_sector_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_sector_Ü'Unchecked_Access);
      Arg_CC_id_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (id'Unrestricted_Access);
      Arg_Any_id_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_id_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getInfo_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getInfo_Arg_Name_lap_Ü,
         PolyORB.Any.Any
           (Arg_Any_lap_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getInfo_Arg_Name_sector_Ü,
         PolyORB.Any.Any
           (Arg_Any_sector_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getInfo_Arg_Name_id_Ü,
         PolyORB.Any.Any
           (Arg_Any_id_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getInfo",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getInfo;

   getBestLap_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   -------------------------
   -- getBestLap_Result_Ü --
   -------------------------

   function getBestLap_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getBestLap_Result_Ü);
   begin
      return (Name => getBestLap_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getBestLap_Result_Ü;

   ----------------
   -- getBestLap --
   ----------------

   function getBestLap
     (Self : Ref)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getBestLap_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getBestLap",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getBestLap;

   getBestSector_Arg_Name_index_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("index");

   getBestSector_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ----------------------------
   -- getBestSector_Result_Ü --
   ----------------------------

   function getBestSector_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getBestSector_Result_Ü);
   begin
      return (Name => getBestSector_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getBestSector_Result_Ü;

   -------------------
   -- getBestSector --
   -------------------

   function getBestSector
     (Self : Ref;
      index : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_index_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (index'Unrestricted_Access);
      Arg_Any_index_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_index_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getBestSector_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getBestSector_Arg_Name_index_Ü,
         PolyORB.Any.Any
           (Arg_Any_index_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getBestSector",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getBestSector;

   getCondCar_Arg_Name_competitorIdIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorIdIn");

   getCondCar_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   -------------------------
   -- getCondCar_Result_Ü --
   -------------------------

   function getCondCar_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getCondCar_Result_Ü);
   begin
      return (Name => getCondCar_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getCondCar_Result_Ü;

   ----------------
   -- getCondCar --
   ----------------

   function getCondCar
     (Self : Ref;
      competitorIdIn : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorIdIn'Unrestricted_Access);
      Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorIdIn_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getCondCar_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getCondCar_Arg_Name_competitorIdIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorIdIn_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getCondCar",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getCondCar;

   getCompetitor_Arg_Name_competitorIdIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorIdIn");

   getCompetitor_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ----------------------------
   -- getCompetitor_Result_Ü --
   ----------------------------

   function getCompetitor_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getCompetitor_Result_Ü);
   begin
      return (Name => getCompetitor_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getCompetitor_Result_Ü;

   -------------------
   -- getCompetitor --
   -------------------

   function getCompetitor
     (Self : Ref;
      competitorIdIn : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorIdIn'Unrestricted_Access);
      Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorIdIn_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getCompetitor_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getCompetitor_Arg_Name_competitorIdIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorIdIn_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getCompetitor",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getCompetitor;

   getCompetitorTimeSector_Arg_Name_competitorIdIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorIdIn");

   getCompetitorTimeSector_Arg_Name_sectorIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("sectorIn");

   getCompetitorTimeSector_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   --------------------------------------
   -- getCompetitorTimeSector_Result_Ü --
   --------------------------------------

   function getCompetitorTimeSector_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getCompetitorTimeSector_Result_Ü);
   begin
      return (Name => getCompetitorTimeSector_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getCompetitorTimeSector_Result_Ü;

   -----------------------------
   -- getCompetitorTimeSector --
   -----------------------------

   function getCompetitorTimeSector
     (Self : Ref;
      competitorIdIn : CORBA.Short;
      sectorIn : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorIdIn'Unrestricted_Access);
      Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorIdIn_Ü'Unchecked_Access);
      Arg_CC_sectorIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (sectorIn'Unrestricted_Access);
      Arg_Any_sectorIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_sectorIn_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getCompetitorTimeSector_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getCompetitorTimeSector_Arg_Name_competitorIdIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorIdIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getCompetitorTimeSector_Arg_Name_sectorIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_sectorIn_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getCompetitorTimeSector",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getCompetitorTimeSector;

   getCompetitorTimeLap_Arg_Name_competitorIdIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorIdIn");

   getCompetitorTimeLap_Arg_Name_lapIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("lapIn");

   getCompetitorTimeLap_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   -----------------------------------
   -- getCompetitorTimeLap_Result_Ü --
   -----------------------------------

   function getCompetitorTimeLap_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getCompetitorTimeLap_Result_Ü);
   begin
      return (Name => getCompetitorTimeLap_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getCompetitorTimeLap_Result_Ü;

   --------------------------
   -- getCompetitorTimeLap --
   --------------------------

   function getCompetitorTimeLap
     (Self : Ref;
      competitorIdIn : CORBA.Short;
      lapIn : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorIdIn'Unrestricted_Access);
      Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorIdIn_Ü'Unchecked_Access);
      Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (lapIn'Unrestricted_Access);
      Arg_Any_lapIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_lapIn_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getCompetitorTimeLap_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getCompetitorTimeLap_Arg_Name_competitorIdIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorIdIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getCompetitorTimeLap_Arg_Name_lapIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_lapIn_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getCompetitorTimeLap",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getCompetitorTimeLap;

   getCompetitorTimeCheck_Arg_Name_competitorIdIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorIdIn");

   getCompetitorTimeCheck_Arg_Name_checkpointIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("checkpointIn");

   getCompetitorTimeCheck_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   -------------------------------------
   -- getCompetitorTimeCheck_Result_Ü --
   -------------------------------------

   function getCompetitorTimeCheck_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getCompetitorTimeCheck_Result_Ü);
   begin
      return (Name => getCompetitorTimeCheck_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getCompetitorTimeCheck_Result_Ü;

   ----------------------------
   -- getCompetitorTimeCheck --
   ----------------------------

   function getCompetitorTimeCheck
     (Self : Ref;
      competitorIdIn : CORBA.Short;
      checkpointIn : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorIdIn'Unrestricted_Access);
      Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorIdIn_Ü'Unchecked_Access);
      Arg_CC_checkpointIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (checkpointIn'Unrestricted_Access);
      Arg_Any_checkpointIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_checkpointIn_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getCompetitorTimeCheck_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getCompetitorTimeCheck_Arg_Name_competitorIdIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorIdIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getCompetitorTimeCheck_Arg_Name_checkpointIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_checkpointIn_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getCompetitorTimeCheck",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getCompetitorTimeCheck;

   getGas_Arg_Name_competitorIdIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorIdIn");

   getGas_Arg_Name_Sector_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Sector");

   getGas_Arg_Name_lapIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("lapIn");

   getGas_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ---------------------
   -- getGas_Result_Ü --
   ---------------------

   function getGas_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getGas_Result_Ü);
   begin
      return (Name => getGas_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getGas_Result_Ü;

   ------------
   -- getGas --
   ------------

   function getGas
     (Self : Ref;
      competitorIdIn : CORBA.Short;
      Sector : CORBA.Short;
      lapIn : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorIdIn'Unrestricted_Access);
      Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorIdIn_Ü'Unchecked_Access);
      Arg_CC_Sector_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Sector'Unrestricted_Access);
      Arg_Any_Sector_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_Sector_Ü'Unchecked_Access);
      Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (lapIn'Unrestricted_Access);
      Arg_Any_lapIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_lapIn_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getGas_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getGas_Arg_Name_competitorIdIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorIdIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getGas_Arg_Name_Sector_Ü,
         PolyORB.Any.Any
           (Arg_Any_Sector_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getGas_Arg_Name_lapIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_lapIn_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getGas",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getGas;

   getTyreUsury_Arg_Name_competitorIdIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorIdIn");

   getTyreUsury_Arg_Name_sectorIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("sectorIn");

   getTyreUsury_Arg_Name_lapIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("lapIn");

   getTyreUsury_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ---------------------------
   -- getTyreUsury_Result_Ü --
   ---------------------------

   function getTyreUsury_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getTyreUsury_Result_Ü);
   begin
      return (Name => getTyreUsury_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getTyreUsury_Result_Ü;

   ------------------
   -- getTyreUsury --
   ------------------

   function getTyreUsury
     (Self : Ref;
      competitorIdIn : CORBA.Short;
      sectorIn : CORBA.Short;
      lapIn : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorIdIn'Unrestricted_Access);
      Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorIdIn_Ü'Unchecked_Access);
      Arg_CC_sectorIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (sectorIn'Unrestricted_Access);
      Arg_Any_sectorIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_sectorIn_Ü'Unchecked_Access);
      Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (lapIn'Unrestricted_Access);
      Arg_Any_lapIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_lapIn_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getTyreUsury_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getTyreUsury_Arg_Name_competitorIdIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorIdIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getTyreUsury_Arg_Name_sectorIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_sectorIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getTyreUsury_Arg_Name_lapIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_lapIn_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getTyreUsury",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getTyreUsury;

   getMeanSpeed_Arg_Name_competitorIdIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorIdIn");

   getMeanSpeed_Arg_Name_sectorIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("sectorIn");

   getMeanSpeed_Arg_Name_lapIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("lapIn");

   getMeanSpeed_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ---------------------------
   -- getMeanSpeed_Result_Ü --
   ---------------------------

   function getMeanSpeed_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getMeanSpeed_Result_Ü);
   begin
      return (Name => getMeanSpeed_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getMeanSpeed_Result_Ü;

   ------------------
   -- getMeanSpeed --
   ------------------

   function getMeanSpeed
     (Self : Ref;
      competitorIdIn : CORBA.Short;
      sectorIn : CORBA.Short;
      lapIn : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorIdIn'Unrestricted_Access);
      Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorIdIn_Ü'Unchecked_Access);
      Arg_CC_sectorIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (sectorIn'Unrestricted_Access);
      Arg_Any_sectorIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_sectorIn_Ü'Unchecked_Access);
      Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (lapIn'Unrestricted_Access);
      Arg_Any_lapIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_lapIn_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getMeanSpeed_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getMeanSpeed_Arg_Name_competitorIdIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorIdIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getMeanSpeed_Arg_Name_sectorIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_sectorIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getMeanSpeed_Arg_Name_lapIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_lapIn_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getMeanSpeed",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getMeanSpeed;

   getTime_Arg_Name_competitorIdIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorIdIn");

   getTime_Arg_Name_sectorIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("sectorIn");

   getTime_Arg_Name_lapIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("lapIn");

   getTime_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ----------------------
   -- getTime_Result_Ü --
   ----------------------

   function getTime_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getTime_Result_Ü);
   begin
      return (Name => getTime_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getTime_Result_Ü;

   -------------
   -- getTime --
   -------------

   function getTime
     (Self : Ref;
      competitorIdIn : CORBA.Short;
      sectorIn : CORBA.Short;
      lapIn : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorIdIn'Unrestricted_Access);
      Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorIdIn_Ü'Unchecked_Access);
      Arg_CC_sectorIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (sectorIn'Unrestricted_Access);
      Arg_Any_sectorIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_sectorIn_Ü'Unchecked_Access);
      Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (lapIn'Unrestricted_Access);
      Arg_Any_lapIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_lapIn_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getTime_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getTime_Arg_Name_competitorIdIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorIdIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getTime_Arg_Name_sectorIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_sectorIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getTime_Arg_Name_lapIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_lapIn_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getTime",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getTime;

   getMeanGasConsumption_Arg_Name_competitorIdIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorIdIn");

   getMeanGasConsumption_Arg_Name_sectorIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("sectorIn");

   getMeanGasConsumption_Arg_Name_lapIn_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("lapIn");

   getMeanGasConsumption_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ------------------------------------
   -- getMeanGasConsumption_Result_Ü --
   ------------------------------------

   function getMeanGasConsumption_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getMeanGasConsumption_Result_Ü);
   begin
      return (Name => getMeanGasConsumption_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getMeanGasConsumption_Result_Ü;

   ---------------------------
   -- getMeanGasConsumption --
   ---------------------------

   function getMeanGasConsumption
     (Self : Ref;
      competitorIdIn : CORBA.Short;
      sectorIn : CORBA.Short;
      lapIn : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorIdIn'Unrestricted_Access);
      Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorIdIn_Ü'Unchecked_Access);
      Arg_CC_sectorIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (sectorIn'Unrestricted_Access);
      Arg_Any_sectorIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_sectorIn_Ü'Unchecked_Access);
      Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (lapIn'Unrestricted_Access);
      Arg_Any_lapIn_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_lapIn_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getMeanGasConsumption_Result_Ü;
   begin
      if CORBA.Object.Is_Nil
        (CORBA.Object.Ref
           (Self))
      then
         CORBA.Raise_Inv_Objref
           (CORBA.Default_Sys_Member);
      end if;
      --  Create the Argument list
      PolyORB.Any.NVList.Create
        (Argument_List_Ü);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getMeanGasConsumption_Arg_Name_competitorIdIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorIdIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getMeanGasConsumption_Arg_Name_sectorIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_sectorIn_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getMeanGasConsumption_Arg_Name_lapIn_Ü,
         PolyORB.Any.Any
           (Arg_Any_lapIn_Ü),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_Ü.Argument).all,
         Arg_CC_Result_Ü_Ü'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "getMeanGasConsumption",
         Arg_List => Argument_List_Ü,
         Result => Result_Nv_Ü,
         Req => Request_Ü);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_Ü,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_Ü);
      PolyORB.Requests.Destroy_Request
        (Request_Ü);
      --  Return value
      return Result_Ü;
   end getMeanGasConsumption;

   ----------
   -- Is_A --
   ----------

   function Is_A
     (Self : Ref;
      Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean
   is
   begin
      return (False
         or else (Is_A
           (Logical_Type_Id)
            or else CORBA.Object.Is_A
              (CORBA.Object.Ref
                 (Self),
               Logical_Type_Id)));
   end Is_A;

   ----------
   -- Is_A --
   ----------

   function Is_A
     (Logical_Type_Id : PolyORB.Std.String)
     return CORBA.Boolean
   is
   begin
      return ((CORBA.Is_Equivalent
        (Logical_Type_Id,
         Competition_Monitor.Repository_Id)
         or else CORBA.Is_Equivalent
           (Logical_Type_Id,
            "IDL:omg.org/CORBA/Object:1.0"))
         or else False);
   end Is_A;

end Competition_Monitor;
