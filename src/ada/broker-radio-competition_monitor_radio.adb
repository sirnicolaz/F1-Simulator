pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  ../idl/radio.idl
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
with broker.radio.Competition_Monitor_Radio.Helper;

package body broker.radio.Competition_Monitor_Radio is

   Get_CompetitorInfo_Arg_Name_lap_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("lap");

   Get_CompetitorInfo_Arg_Name_sector_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("sector");

   Get_CompetitorInfo_Arg_Name_id_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("id");

   Get_CompetitorInfo_Arg_Name_time_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("time");

   Get_CompetitorInfo_Arg_Name_metres_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("metres");

   Get_CompetitorInfo_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ---------------------------------
   -- Get_CompetitorInfo_Result_Ü --
   ---------------------------------

   function Get_CompetitorInfo_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (Get_CompetitorInfo_Result_Ü);
   begin
      return (Name => Get_CompetitorInfo_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end Get_CompetitorInfo_Result_Ü;

   ------------------------
   -- Get_CompetitorInfo --
   ------------------------

   procedure Get_CompetitorInfo
     (Self : Ref;
      lap : CORBA.Short;
      sector : CORBA.Short;
      id : CORBA.Short;
      time : out CORBA.Float;
      metres : out CORBA.Float;
      Returns : out CORBA.String)
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String
        renames Returns;
      pragma Warnings (Off, Returns);
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
      Arg_CC_time_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (time'Unrestricted_Access);
      Arg_Any_time_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Float,
            Arg_CC_time_Ü'Unchecked_Access);
      pragma Warnings (Off, time);
      Arg_CC_metres_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (metres'Unrestricted_Access);
      Arg_Any_metres_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Float,
            Arg_CC_metres_Ü'Unchecked_Access);
      pragma Warnings (Off, metres);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        Get_CompetitorInfo_Result_Ü;
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
         Get_CompetitorInfo_Arg_Name_lap_Ü,
         PolyORB.Any.Any
           (Arg_Any_lap_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Get_CompetitorInfo_Arg_Name_sector_Ü,
         PolyORB.Any.Any
           (Arg_Any_sector_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Get_CompetitorInfo_Arg_Name_id_Ü,
         PolyORB.Any.Any
           (Arg_Any_id_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Get_CompetitorInfo_Arg_Name_time_Ü,
         PolyORB.Any.Any
           (Arg_Any_time_Ü),
         PolyORB.Any.ARG_OUT);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Get_CompetitorInfo_Arg_Name_metres_Ü,
         PolyORB.Any.Any
           (Arg_Any_metres_Ü),
         PolyORB.Any.ARG_OUT);
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
         Operation => "Get_CompetitorInfo",
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
   end Get_CompetitorInfo;

   Get_CompetitionInfo_Arg_Name_timeInstant_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("timeInstant");

   Get_CompetitionInfo_Arg_Name_xmlInfo_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("xmlInfo");

   Get_CompetitionInfo_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ----------------------------------
   -- Get_CompetitionInfo_Result_Ü --
   ----------------------------------

   function Get_CompetitionInfo_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (Get_CompetitionInfo_Result_Ü);
   begin
      return (Name => Get_CompetitionInfo_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (broker.radio.Competition_Monitor_Radio.Helper.TC_float_sequence),
      Arg_Modes => 0);
   end Get_CompetitionInfo_Result_Ü;

   -------------------------
   -- Get_CompetitionInfo --
   -------------------------

   procedure Get_CompetitionInfo
     (Self : Ref;
      timeInstant : CORBA.Float;
      xmlInfo : out CORBA.String;
      Returns : out broker.radio.Competition_Monitor_Radio.float_sequence)
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : broker.radio.Competition_Monitor_Radio.float_sequence
        renames Returns;
      pragma Warnings (Off, Returns);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        broker.radio.Competition_Monitor_Radio.Helper.Internals.Wrap
           (broker.radio.Competition_Monitor_Radio.IDL_SEQUENCE_float.Sequence
              (Result_Ü)'Unrestricted_Access);
      Arg_CC_timeInstant_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (timeInstant'Unrestricted_Access);
      Arg_Any_timeInstant_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Float,
            Arg_CC_timeInstant_Ü'Unchecked_Access);
      Arg_CC_xmlInfo_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (xmlInfo'Unrestricted_Access);
      Arg_Any_xmlInfo_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_String,
            Arg_CC_xmlInfo_Ü'Unchecked_Access);
      pragma Warnings (Off, xmlInfo);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        Get_CompetitionInfo_Result_Ü;
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
         Get_CompetitionInfo_Arg_Name_timeInstant_Ü,
         PolyORB.Any.Any
           (Arg_Any_timeInstant_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Get_CompetitionInfo_Arg_Name_xmlInfo_Ü,
         PolyORB.Any.Any
           (Arg_Any_xmlInfo_Ü),
         PolyORB.Any.ARG_OUT);
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
         Operation => "Get_CompetitionInfo",
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
   end Get_CompetitionInfo;

   ready_Arg_Name_competitorId_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorId");

   ready_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   --------------------
   -- ready_Result_Ü --
   --------------------

   function ready_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (ready_Result_Ü);
   begin
      return (Name => ready_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_Boolean),
      Arg_Modes => 0);
   end ready_Result_Ü;

   -----------
   -- ready --
   -----------

   function ready
     (Self : Ref;
      competitorId : CORBA.Short)
     return CORBA.Boolean
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.Boolean;
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
        ready_Result_Ü;
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
         ready_Arg_Name_competitorId_Ü,
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
         Operation => "ready",
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
   end ready;

   Get_CompetitionConfiguration_Arg_Name_xmlConf_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("xmlConf");

   Get_CompetitionConfiguration_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   -------------------------------------------
   -- Get_CompetitionConfiguration_Result_Ü --
   -------------------------------------------

   function Get_CompetitionConfiguration_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (Get_CompetitionConfiguration_Result_Ü);
   begin
      return (Name => Get_CompetitionConfiguration_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_Float),
      Arg_Modes => 0);
   end Get_CompetitionConfiguration_Result_Ü;

   ----------------------------------
   -- Get_CompetitionConfiguration --
   ----------------------------------

   procedure Get_CompetitionConfiguration
     (Self : Ref;
      xmlConf : in out CORBA.String;
      Returns : out CORBA.Float)
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.Float
        renames Returns;
      pragma Warnings (Off, Returns);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_xmlConf_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (xmlConf'Unrestricted_Access);
      Arg_Any_xmlConf_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_String,
            Arg_CC_xmlConf_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        Get_CompetitionConfiguration_Result_Ü;
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
         Get_CompetitionConfiguration_Arg_Name_xmlConf_Ü,
         PolyORB.Any.Any
           (Arg_Any_xmlConf_Ü),
         PolyORB.Any.ARG_INOUT);
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
         Operation => "Get_CompetitionConfiguration",
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
   end Get_CompetitionConfiguration;

   Get_CompetitorConfiguration_Arg_Name_id_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("id");

   Get_CompetitorConfiguration_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ------------------------------------------
   -- Get_CompetitorConfiguration_Result_Ü --
   ------------------------------------------

   function Get_CompetitorConfiguration_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (Get_CompetitorConfiguration_Result_Ü);
   begin
      return (Name => Get_CompetitorConfiguration_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end Get_CompetitorConfiguration_Result_Ü;

   ---------------------------------
   -- Get_CompetitorConfiguration --
   ---------------------------------

   function Get_CompetitorConfiguration
     (Self : Ref;
      id : CORBA.Short)
     return CORBA.String
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.String;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Arg_CC_id_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (id'Unrestricted_Access);
      Arg_Any_id_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_id_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        Get_CompetitorConfiguration_Result_Ü;
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
         Get_CompetitorConfiguration_Arg_Name_id_Ü,
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
         Operation => "Get_CompetitorConfiguration",
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
   end Get_CompetitorConfiguration;

   Set_Simulation_Speed_Arg_Name_simulationSpeed_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("simulationSpeed");

   Set_Simulation_Speed_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   -----------------------------------
   -- Set_Simulation_Speed_Result_Ü --
   -----------------------------------

   function Set_Simulation_Speed_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (Set_Simulation_Speed_Result_Ü);
   begin
      return (Name => Set_Simulation_Speed_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_Void),
      Arg_Modes => 0);
   end Set_Simulation_Speed_Result_Ü;

   --------------------------
   -- Set_Simulation_Speed --
   --------------------------

   procedure Set_Simulation_Speed
     (Self : Ref;
      simulationSpeed : CORBA.Float)
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Arg_CC_simulationSpeed_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (simulationSpeed'Unrestricted_Access);
      Arg_Any_simulationSpeed_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Float,
            Arg_CC_simulationSpeed_Ü'Unchecked_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        Set_Simulation_Speed_Result_Ü;
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
         Set_Simulation_Speed_Arg_Name_simulationSpeed_Ü,
         PolyORB.Any.Any
           (Arg_Any_simulationSpeed_Ü),
         PolyORB.Any.ARG_IN);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "Set_Simulation_Speed",
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
   end Set_Simulation_Speed;

   Get_Latest_Time_Instant_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   --------------------------------------
   -- Get_Latest_Time_Instant_Result_Ü --
   --------------------------------------

   function Get_Latest_Time_Instant_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (Get_Latest_Time_Instant_Result_Ü);
   begin
      return (Name => Get_Latest_Time_Instant_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_Float),
      Arg_Modes => 0);
   end Get_Latest_Time_Instant_Result_Ü;

   -----------------------------
   -- Get_Latest_Time_Instant --
   -----------------------------

   function Get_Latest_Time_Instant
     (Self : Ref)
     return CORBA.Float
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.Float;
      pragma Warnings (Off, Result_Ü);
      Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_Ü'Unrestricted_Access);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        Get_Latest_Time_Instant_Result_Ü;
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
         Operation => "Get_Latest_Time_Instant",
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
   end Get_Latest_Time_Instant;

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
         broker.radio.Competition_Monitor_Radio.Repository_Id)
         or else CORBA.Is_Equivalent
           (Logical_Type_Id,
            "IDL:omg.org/CORBA/Object:1.0"))
         or else False);
   end Is_A;

end broker.radio.Competition_Monitor_Radio;
