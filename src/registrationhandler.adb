pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  registrationHandler.idl
--  by IAC (IDL to Ada Compiler) GPL 2009-20090519 (rev. 144248).
---------------------------------------------------
--  Do NOT hand-modify this file, as your
--  changes will be lost when you re-run the
--  IDL to Ada compiler.
---------------------------------------------------
with PolyORB.Any.NVList;
with PolyORB.Types;
with PolyORB.Any;
with PolyORB.Requests;
with PolyORB.CORBA_P.Interceptors_Hooks;
with PolyORB.CORBA_P.Exceptions;

package body RegistrationHandler is

   Remote_Join_Arg_Name_competitorDescriptor_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorDescriptor");

   Remote_Join_Arg_Name_address_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("address");

   Remote_Join_Arg_Name_radioAddress_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("radioAddress");

   Remote_Join_Arg_Name_compId_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("compId");

   Remote_Join_Arg_Name_monitorSystemAddress_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("monitorSystemAddress");

   Remote_Join_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   --------------------------
   -- Remote_Join_Result_Ü --
   --------------------------

   function Remote_Join_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (Remote_Join_Result_Ü);
   begin
      return (Name => Remote_Join_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_Void),
      Arg_Modes => 0);
   end Remote_Join_Result_Ü;

   -----------------
   -- Remote_Join --
   -----------------

   procedure Remote_Join
     (Self : Ref;
      competitorDescriptor : CORBA.String;
      address : CORBA.String;
      radioAddress : out CORBA.String;
      compId : out CORBA.Short;
      monitorSystemAddress : out CORBA.String)
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Arg_CC_competitorDescriptor_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorDescriptor'Unrestricted_Access);
      Arg_Any_competitorDescriptor_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_String,
            Arg_CC_competitorDescriptor_Ü'Unchecked_Access);
      Arg_CC_address_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (address'Unrestricted_Access);
      Arg_Any_address_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_String,
            Arg_CC_address_Ü'Unchecked_Access);
      Arg_CC_radioAddress_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (radioAddress'Unrestricted_Access);
      Arg_Any_radioAddress_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_String,
            Arg_CC_radioAddress_Ü'Unchecked_Access);
      pragma Warnings (Off, radioAddress);
      Arg_CC_compId_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (compId'Unrestricted_Access);
      Arg_Any_compId_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_compId_Ü'Unchecked_Access);
      pragma Warnings (Off, compId);
      Arg_CC_monitorSystemAddress_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (monitorSystemAddress'Unrestricted_Access);
      Arg_Any_monitorSystemAddress_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_String,
            Arg_CC_monitorSystemAddress_Ü'Unchecked_Access);
      pragma Warnings (Off, monitorSystemAddress);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        Remote_Join_Result_Ü;
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
         Remote_Join_Arg_Name_competitorDescriptor_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorDescriptor_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Remote_Join_Arg_Name_address_Ü,
         PolyORB.Any.Any
           (Arg_Any_address_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Remote_Join_Arg_Name_radioAddress_Ü,
         PolyORB.Any.Any
           (Arg_Any_radioAddress_Ü),
         PolyORB.Any.ARG_OUT);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Remote_Join_Arg_Name_compId_Ü,
         PolyORB.Any.Any
           (Arg_Any_compId_Ü),
         PolyORB.Any.ARG_OUT);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Remote_Join_Arg_Name_monitorSystemAddress_Ü,
         PolyORB.Any.Any
           (Arg_Any_monitorSystemAddress_Ü),
         PolyORB.Any.ARG_OUT);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "Remote_Join",
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
   end Remote_Join;

   Remote_Ready_Arg_Name_compId_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("compId");

   Remote_Ready_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ---------------------------
   -- Remote_Ready_Result_Ü --
   ---------------------------

   function Remote_Ready_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (Remote_Ready_Result_Ü);
   begin
      return (Name => Remote_Ready_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_Boolean),
      Arg_Modes => 0);
   end Remote_Ready_Result_Ü;

   ------------------
   -- Remote_Ready --
   ------------------

   function Remote_Ready
     (Self : Ref;
      compId : CORBA.Short)
     return CORBA.Boolean
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Result_Ü : CORBA.Boolean;
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
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        Remote_Ready_Result_Ü;
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
         Remote_Ready_Arg_Name_compId_Ü,
         PolyORB.Any.Any
           (Arg_Any_compId_Ü),
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
         Operation => "Remote_Ready",
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
   end Remote_Ready;

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
         RegistrationHandler.Repository_Id)
         or else CORBA.Is_Equivalent
           (Logical_Type_Id,
            "IDL:omg.org/CORBA/Object:1.0"))
         or else False);
   end Is_A;

end RegistrationHandler;
