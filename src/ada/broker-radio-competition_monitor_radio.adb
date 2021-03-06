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

   Get_CompetitorInfo_Arg_Name_lap_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("lap");

   Get_CompetitorInfo_Arg_Name_sector_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("sector");

   Get_CompetitorInfo_Arg_Name_id_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("id");

   Get_CompetitorInfo_Arg_Name_time_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("time");

   Get_CompetitorInfo_Arg_Name_metres_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("metres");

   Get_CompetitorInfo_Result_Name_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ---------------------------------
   -- Get_CompetitorInfo_Result_� --
   ---------------------------------

   function Get_CompetitorInfo_Result_� return PolyORB.Any.NamedValue is
      pragma Inline (Get_CompetitorInfo_Result_�);
   begin
      return (Name => Get_CompetitorInfo_Result_Name_�,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end Get_CompetitorInfo_Result_�;

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
      Argument_List_� : PolyORB.Any.NVList.Ref;
      Result_� : CORBA.String
        renames Returns;
      pragma Warnings (Off, Returns);
      Arg_CC_Result_�_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_�'Unrestricted_Access);
      Arg_CC_lap_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (lap'Unrestricted_Access);
      Arg_Any_lap_� : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_lap_�'Unchecked_Access);
      Arg_CC_sector_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (sector'Unrestricted_Access);
      Arg_Any_sector_� : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_sector_�'Unchecked_Access);
      Arg_CC_id_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (id'Unrestricted_Access);
      Arg_Any_id_� : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_id_�'Unchecked_Access);
      Arg_CC_time_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (time'Unrestricted_Access);
      Arg_Any_time_� : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Float,
            Arg_CC_time_�'Unchecked_Access);
      pragma Warnings (Off, time);
      Arg_CC_metres_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (metres'Unrestricted_Access);
      Arg_Any_metres_� : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Float,
            Arg_CC_metres_�'Unchecked_Access);
      pragma Warnings (Off, metres);
      Request_� : PolyORB.Requests.Request_Access;
      Result_Nv_� : PolyORB.Any.NamedValue :=
        Get_CompetitorInfo_Result_�;
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
        (Argument_List_�);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_�,
         Get_CompetitorInfo_Arg_Name_lap_�,
         PolyORB.Any.Any
           (Arg_Any_lap_�),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_�,
         Get_CompetitorInfo_Arg_Name_sector_�,
         PolyORB.Any.Any
           (Arg_Any_sector_�),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_�,
         Get_CompetitorInfo_Arg_Name_id_�,
         PolyORB.Any.Any
           (Arg_Any_id_�),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_�,
         Get_CompetitorInfo_Arg_Name_time_�,
         PolyORB.Any.Any
           (Arg_Any_time_�),
         PolyORB.Any.ARG_OUT);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_�,
         Get_CompetitorInfo_Arg_Name_metres_�,
         PolyORB.Any.Any
           (Arg_Any_metres_�),
         PolyORB.Any.ARG_OUT);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_�.Argument).all,
         Arg_CC_Result_�_�'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "Get_CompetitorInfo",
         Arg_List => Argument_List_�,
         Result => Result_Nv_�,
         Req => Request_�);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_�,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_�);
      PolyORB.Requests.Destroy_Request
        (Request_�);
   end Get_CompetitorInfo;

   Get_CompetitionInfo_Arg_Name_timeInstant_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("timeInstant");

   Get_CompetitionInfo_Arg_Name_xmlInfo_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("xmlInfo");

   Get_CompetitionInfo_Result_Name_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ----------------------------------
   -- Get_CompetitionInfo_Result_� --
   ----------------------------------

   function Get_CompetitionInfo_Result_� return PolyORB.Any.NamedValue is
      pragma Inline (Get_CompetitionInfo_Result_�);
   begin
      return (Name => Get_CompetitionInfo_Result_Name_�,
      Argument => CORBA.Internals.Get_Empty_Any
        (broker.radio.Competition_Monitor_Radio.Helper.TC_float_sequence),
      Arg_Modes => 0);
   end Get_CompetitionInfo_Result_�;

   -------------------------
   -- Get_CompetitionInfo --
   -------------------------

   procedure Get_CompetitionInfo
     (Self : Ref;
      timeInstant : CORBA.Float;
      xmlInfo : out CORBA.String;
      Returns : out broker.radio.Competition_Monitor_Radio.float_sequence)
   is
      Argument_List_� : PolyORB.Any.NVList.Ref;
      Result_� : broker.radio.Competition_Monitor_Radio.float_sequence
        renames Returns;
      pragma Warnings (Off, Returns);
      Arg_CC_Result_�_� : aliased PolyORB.Any.Content'Class :=
        broker.radio.Competition_Monitor_Radio.Helper.Internals.Wrap
           (broker.radio.Competition_Monitor_Radio.IDL_SEQUENCE_float.Sequence
              (Result_�)'Unrestricted_Access);
      Arg_CC_timeInstant_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (timeInstant'Unrestricted_Access);
      Arg_Any_timeInstant_� : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Float,
            Arg_CC_timeInstant_�'Unchecked_Access);
      Arg_CC_xmlInfo_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (xmlInfo'Unrestricted_Access);
      Arg_Any_xmlInfo_� : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_String,
            Arg_CC_xmlInfo_�'Unchecked_Access);
      pragma Warnings (Off, xmlInfo);
      Request_� : PolyORB.Requests.Request_Access;
      Result_Nv_� : PolyORB.Any.NamedValue :=
        Get_CompetitionInfo_Result_�;
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
        (Argument_List_�);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_�,
         Get_CompetitionInfo_Arg_Name_timeInstant_�,
         PolyORB.Any.Any
           (Arg_Any_timeInstant_�),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_�,
         Get_CompetitionInfo_Arg_Name_xmlInfo_�,
         PolyORB.Any.Any
           (Arg_Any_xmlInfo_�),
         PolyORB.Any.ARG_OUT);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_�.Argument).all,
         Arg_CC_Result_�_�'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "Get_CompetitionInfo",
         Arg_List => Argument_List_�,
         Result => Result_Nv_�,
         Req => Request_�);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_�,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_�);
      PolyORB.Requests.Destroy_Request
        (Request_�);
   end Get_CompetitionInfo;

   ready_Arg_Name_competitorId_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorId");

   ready_Result_Name_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   --------------------
   -- ready_Result_� --
   --------------------

   function ready_Result_� return PolyORB.Any.NamedValue is
      pragma Inline (ready_Result_�);
   begin
      return (Name => ready_Result_Name_�,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_Boolean),
      Arg_Modes => 0);
   end ready_Result_�;

   -----------
   -- ready --
   -----------

   function ready
     (Self : Ref;
      competitorId : CORBA.Short)
     return CORBA.Boolean
   is
      Argument_List_� : PolyORB.Any.NVList.Ref;
      Result_� : CORBA.Boolean;
      pragma Warnings (Off, Result_�);
      Arg_CC_Result_�_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_�'Unrestricted_Access);
      Arg_CC_competitorId_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorId'Unrestricted_Access);
      Arg_Any_competitorId_� : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorId_�'Unchecked_Access);
      Request_� : PolyORB.Requests.Request_Access;
      Result_Nv_� : PolyORB.Any.NamedValue :=
        ready_Result_�;
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
        (Argument_List_�);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_�,
         ready_Arg_Name_competitorId_�,
         PolyORB.Any.Any
           (Arg_Any_competitorId_�),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_�.Argument).all,
         Arg_CC_Result_�_�'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "ready",
         Arg_List => Argument_List_�,
         Result => Result_Nv_�,
         Req => Request_�);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_�,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_�);
      PolyORB.Requests.Destroy_Request
        (Request_�);
      --  Return value
      return Result_�;
   end ready;

   Get_CompetitionConfiguration_Arg_Name_xmlConf_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("xmlConf");

   Get_CompetitionConfiguration_Result_Name_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   -------------------------------------------
   -- Get_CompetitionConfiguration_Result_� --
   -------------------------------------------

   function Get_CompetitionConfiguration_Result_� return PolyORB.Any.NamedValue is
      pragma Inline (Get_CompetitionConfiguration_Result_�);
   begin
      return (Name => Get_CompetitionConfiguration_Result_Name_�,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_Float),
      Arg_Modes => 0);
   end Get_CompetitionConfiguration_Result_�;

   ----------------------------------
   -- Get_CompetitionConfiguration --
   ----------------------------------

   procedure Get_CompetitionConfiguration
     (Self : Ref;
      xmlConf : in out CORBA.String;
      Returns : out CORBA.Float)
   is
      Argument_List_� : PolyORB.Any.NVList.Ref;
      Result_� : CORBA.Float
        renames Returns;
      pragma Warnings (Off, Returns);
      Arg_CC_Result_�_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_�'Unrestricted_Access);
      Arg_CC_xmlConf_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (xmlConf'Unrestricted_Access);
      Arg_Any_xmlConf_� : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_String,
            Arg_CC_xmlConf_�'Unchecked_Access);
      Request_� : PolyORB.Requests.Request_Access;
      Result_Nv_� : PolyORB.Any.NamedValue :=
        Get_CompetitionConfiguration_Result_�;
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
        (Argument_List_�);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_�,
         Get_CompetitionConfiguration_Arg_Name_xmlConf_�,
         PolyORB.Any.Any
           (Arg_Any_xmlConf_�),
         PolyORB.Any.ARG_INOUT);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_�.Argument).all,
         Arg_CC_Result_�_�'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "Get_CompetitionConfiguration",
         Arg_List => Argument_List_�,
         Result => Result_Nv_�,
         Req => Request_�);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_�,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_�);
      PolyORB.Requests.Destroy_Request
        (Request_�);
   end Get_CompetitionConfiguration;

   Get_CompetitorConfiguration_Arg_Name_id_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("id");

   Get_CompetitorConfiguration_Result_Name_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ------------------------------------------
   -- Get_CompetitorConfiguration_Result_� --
   ------------------------------------------

   function Get_CompetitorConfiguration_Result_� return PolyORB.Any.NamedValue is
      pragma Inline (Get_CompetitorConfiguration_Result_�);
   begin
      return (Name => Get_CompetitorConfiguration_Result_Name_�,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end Get_CompetitorConfiguration_Result_�;

   ---------------------------------
   -- Get_CompetitorConfiguration --
   ---------------------------------

   function Get_CompetitorConfiguration
     (Self : Ref;
      id : CORBA.Short)
     return CORBA.String
   is
      Argument_List_� : PolyORB.Any.NVList.Ref;
      Result_� : CORBA.String;
      pragma Warnings (Off, Result_�);
      Arg_CC_Result_�_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_�'Unrestricted_Access);
      Arg_CC_id_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (id'Unrestricted_Access);
      Arg_Any_id_� : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_id_�'Unchecked_Access);
      Request_� : PolyORB.Requests.Request_Access;
      Result_Nv_� : PolyORB.Any.NamedValue :=
        Get_CompetitorConfiguration_Result_�;
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
        (Argument_List_�);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_�,
         Get_CompetitorConfiguration_Arg_Name_id_�,
         PolyORB.Any.Any
           (Arg_Any_id_�),
         PolyORB.Any.ARG_IN);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_�.Argument).all,
         Arg_CC_Result_�_�'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "Get_CompetitorConfiguration",
         Arg_List => Argument_List_�,
         Result => Result_Nv_�,
         Req => Request_�);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_�,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_�);
      PolyORB.Requests.Destroy_Request
        (Request_�);
      --  Return value
      return Result_�;
   end Get_CompetitorConfiguration;

   Set_Simulation_Speed_Arg_Name_simulationSpeed_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("simulationSpeed");

   Set_Simulation_Speed_Result_Name_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   -----------------------------------
   -- Set_Simulation_Speed_Result_� --
   -----------------------------------

   function Set_Simulation_Speed_Result_� return PolyORB.Any.NamedValue is
      pragma Inline (Set_Simulation_Speed_Result_�);
   begin
      return (Name => Set_Simulation_Speed_Result_Name_�,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_Void),
      Arg_Modes => 0);
   end Set_Simulation_Speed_Result_�;

   --------------------------
   -- Set_Simulation_Speed --
   --------------------------

   procedure Set_Simulation_Speed
     (Self : Ref;
      simulationSpeed : CORBA.Float)
   is
      Argument_List_� : PolyORB.Any.NVList.Ref;
      Arg_CC_simulationSpeed_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (simulationSpeed'Unrestricted_Access);
      Arg_Any_simulationSpeed_� : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Float,
            Arg_CC_simulationSpeed_�'Unchecked_Access);
      Request_� : PolyORB.Requests.Request_Access;
      Result_Nv_� : PolyORB.Any.NamedValue :=
        Set_Simulation_Speed_Result_�;
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
        (Argument_List_�);
      --  Fill the Argument list
      PolyORB.Any.NVList.Add_Item
        (Argument_List_�,
         Set_Simulation_Speed_Arg_Name_simulationSpeed_�,
         PolyORB.Any.Any
           (Arg_Any_simulationSpeed_�),
         PolyORB.Any.ARG_IN);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "Set_Simulation_Speed",
         Arg_List => Argument_List_�,
         Result => Result_Nv_�,
         Req => Request_�);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_�,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_�);
      PolyORB.Requests.Destroy_Request
        (Request_�);
   end Set_Simulation_Speed;

   Get_Latest_Time_Instant_Result_Name_� : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   --------------------------------------
   -- Get_Latest_Time_Instant_Result_� --
   --------------------------------------

   function Get_Latest_Time_Instant_Result_� return PolyORB.Any.NamedValue is
      pragma Inline (Get_Latest_Time_Instant_Result_�);
   begin
      return (Name => Get_Latest_Time_Instant_Result_Name_�,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_Float),
      Arg_Modes => 0);
   end Get_Latest_Time_Instant_Result_�;

   -----------------------------
   -- Get_Latest_Time_Instant --
   -----------------------------

   function Get_Latest_Time_Instant
     (Self : Ref)
     return CORBA.Float
   is
      Argument_List_� : PolyORB.Any.NVList.Ref;
      Result_� : CORBA.Float;
      pragma Warnings (Off, Result_�);
      Arg_CC_Result_�_� : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (Result_�'Unrestricted_Access);
      Request_� : PolyORB.Requests.Request_Access;
      Result_Nv_� : PolyORB.Any.NamedValue :=
        Get_Latest_Time_Instant_Result_�;
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
        (Argument_List_�);
      --  Setting the result value
      PolyORB.Any.Set_Value
        (PolyORB.Any.Get_Container
           (Result_Nv_�.Argument).all,
         Arg_CC_Result_�_�'Unrestricted_Access);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "Get_Latest_Time_Instant",
         Arg_List => Argument_List_�,
         Result => Result_Nv_�,
         Req => Request_�);
      --  Invoking the request (synchronously or asynchronously)
      PolyORB.CORBA_P.Interceptors_Hooks.Client_Invoke
        (Request_�,
         PolyORB.Requests.Flags
           (0));
      --  Raise exception, if needed
      PolyORB.CORBA_P.Exceptions.Request_Raise_Occurrence
        (Request_�);
      PolyORB.Requests.Destroy_Request
        (Request_�);
      --  Return value
      return Result_�;
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
