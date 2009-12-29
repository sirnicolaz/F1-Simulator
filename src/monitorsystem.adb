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
with PolyORB.Any.NVList;
with PolyORB.Any;
with PolyORB.Types;
with PolyORB.Requests;
with PolyORB.CORBA_P.Interceptors_Hooks;
with PolyORB.CORBA_P.Exceptions;

package body MonitorSystem is

   getCompetitorInfo_Arg_Name_competitorId_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorId");

   getCompetitorInfo_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   --------------------------------
   -- getCompetitorInfo_Result_Ü --
   --------------------------------

   function getCompetitorInfo_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getCompetitorInfo_Result_Ü);
   begin
      return (Name => getCompetitorInfo_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getCompetitorInfo_Result_Ü;

   -----------------------
   -- getCompetitorInfo --
   -----------------------

   function getCompetitorInfo
     (Self : Ref;
      competitorId : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorId_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorId'Unrestricted_Access);
      Arg_Any_competitorId_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorId_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getCompetitorInfo_Result_Ü;
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
         getCompetitorInfo_Arg_Name_competitorId_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorId_Ü),
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
         Operation => "getCompetitorInfo",
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
   end getCompetitorInfo;

   getCompetitionInfo_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ---------------------------------
   -- getCompetitionInfo_Result_Ü --
   ---------------------------------

   function getCompetitionInfo_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getCompetitionInfo_Result_Ü);
   begin
      return (Name => getCompetitionInfo_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getCompetitionInfo_Result_Ü;

   ------------------------
   -- getCompetitionInfo --
   ------------------------

   function getCompetitionInfo
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
        getCompetitionInfo_Result_Ü;
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
         Operation => "getCompetitionInfo",
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
   end getCompetitionInfo;

   getEverything_Arg_Name_competitorId_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorId");

   getEverything_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ----------------------------
   -- getEverything_Result_Ü --
   ----------------------------

   function getEverything_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getEverything_Result_Ü);
   begin
      return (Name => getEverything_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getEverything_Result_Ü;

   -------------------
   -- getEverything --
   -------------------

   function getEverything
     (Self : Ref;
      competitorId : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_competitorId_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorId'Unrestricted_Access);
      Arg_Any_competitorId_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorId_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getEverything_Result_Ü;
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
         getEverything_Arg_Name_competitorId_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorId_Ü),
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
         Operation => "getEverything",
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
   end getEverything;

   getClassification_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   --------------------------------
   -- getClassification_Result_Ü --
   --------------------------------

   function getClassification_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getClassification_Result_Ü);
   begin
      return (Name => getClassification_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getClassification_Result_Ü;

   -----------------------
   -- getClassification --
   -----------------------

   function getClassification
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
        getClassification_Result_Ü;
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
         Operation => "getClassification",
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
   end getClassification;

   getStatsBySect_Arg_Name_compId_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("compId");

   getStatsBySect_Arg_Name_sector_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("sector");

   getStatsBySect_Arg_Name_lap_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("lap");

   getStatsBySect_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   -----------------------------
   -- getStatsBySect_Result_Ü --
   -----------------------------

   function getStatsBySect_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (getStatsBySect_Result_Ü);
   begin
      return (Name => getStatsBySect_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end getStatsBySect_Result_Ü;

   --------------------
   -- getStatsBySect --
   --------------------

   function getStatsBySect
     (Self : Ref;
      compId : CORBA.Short;
      sector : CORBA.Short;
      lap : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_compId_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (compId'Unrestricted_Access);
      Arg_Any_compId_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_compId_Ü'Unchecked_Access);
      Arg_CC_sector_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (sector'Unrestricted_Access);
      Arg_Any_sector_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_sector_Ü'Unchecked_Access);
      Arg_CC_lap_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (lap'Unrestricted_Access);
      Arg_Any_lap_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_lap_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        getStatsBySect_Result_Ü;
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
         getStatsBySect_Arg_Name_compId_Ü,
         PolyORB.Any.Any
           (Arg_Any_compId_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getStatsBySect_Arg_Name_sector_Ü,
         PolyORB.Any.Any
           (Arg_Any_sector_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         getStatsBySect_Arg_Name_lap_Ü,
         PolyORB.Any.Any
           (Arg_Any_lap_Ü),
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
         Operation => "getStatsBySect",
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
   end getStatsBySect;

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
         MonitorSystem.Repository_Id)
         or else CORBA.Is_Equivalent
           (Logical_Type_Id,
            "IDL:omg.org/CORBA/Object:1.0"))
         or else False);
   end Is_A;

end MonitorSystem;
