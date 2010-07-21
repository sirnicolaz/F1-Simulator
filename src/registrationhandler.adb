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

   Join_Competition_Arg_Name_competitorDescriptorFile_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorDescriptorFile");

   Join_Competition_Arg_Name_boxCorbaLoc_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("boxCorbaLoc");

   Join_Competition_Arg_Name_monitorCorbaLoc_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("monitorCorbaLoc");

   Join_Competition_Arg_Name_competitorId_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorId");

   Join_Competition_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   -------------------------------
   -- Join_Competition_Result_Ü --
   -------------------------------

   function Join_Competition_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (Join_Competition_Result_Ü);
   begin
      return (Name => Join_Competition_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_Void),
      Arg_Modes => 0);
   end Join_Competition_Result_Ü;

   ----------------------
   -- Join_Competition --
   ----------------------

   procedure Join_Competition
     (Self : Ref;
      competitorDescriptorFile : CORBA.String;
      boxCorbaLoc : CORBA.String;
      monitorCorbaLoc : out CORBA.String;
      competitorId : out CORBA.Short)
   is
      Argument_List_Ü : PolyORB.Any.NVList.Ref;
      Arg_CC_competitorDescriptorFile_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorDescriptorFile'Unrestricted_Access);
      Arg_Any_competitorDescriptorFile_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_String,
            Arg_CC_competitorDescriptorFile_Ü'Unchecked_Access);
      Arg_CC_boxCorbaLoc_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (boxCorbaLoc'Unrestricted_Access);
      Arg_Any_boxCorbaLoc_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_String,
            Arg_CC_boxCorbaLoc_Ü'Unchecked_Access);
      Arg_CC_monitorCorbaLoc_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (monitorCorbaLoc'Unrestricted_Access);
      Arg_Any_monitorCorbaLoc_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_String,
            Arg_CC_monitorCorbaLoc_Ü'Unchecked_Access);
      pragma Warnings (Off, monitorCorbaLoc);
      Arg_CC_competitorId_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (competitorId'Unrestricted_Access);
      Arg_Any_competitorId_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_competitorId_Ü'Unchecked_Access);
      pragma Warnings (Off, competitorId);
      Request_Ü : PolyORB.Requests.Request_Access;
      Result_Nv_Ü : PolyORB.Any.NamedValue :=
        Join_Competition_Result_Ü;
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
         Join_Competition_Arg_Name_competitorDescriptorFile_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorDescriptorFile_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Join_Competition_Arg_Name_boxCorbaLoc_Ü,
         PolyORB.Any.Any
           (Arg_Any_boxCorbaLoc_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Join_Competition_Arg_Name_monitorCorbaLoc_Ü,
         PolyORB.Any.Any
           (Arg_Any_monitorCorbaLoc_Ü),
         PolyORB.Any.ARG_OUT);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Join_Competition_Arg_Name_competitorId_Ü,
         PolyORB.Any.Any
           (Arg_Any_competitorId_Ü),
         PolyORB.Any.ARG_OUT);
      --  Creating the request
      PolyORB.Requests.Create_Request
        (Target => CORBA.Object.Internals.To_PolyORB_Ref
           (CORBA.Object.Ref
              (Self)),
         Operation => "Join_Competition",
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
   end Join_Competition;

   Wait_Ready_Arg_Name_competitorId_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("competitorId");

   Wait_Ready_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   -------------------------
   -- Wait_Ready_Result_Ü --
   -------------------------

   function Wait_Ready_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (Wait_Ready_Result_Ü);
   begin
      return (Name => Wait_Ready_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end Wait_Ready_Result_Ü;

   ----------------
   -- Wait_Ready --
   ----------------

   function Wait_Ready
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
        Wait_Ready_Result_Ü;
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
         Wait_Ready_Arg_Name_competitorId_Ü,
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
         Operation => "Wait_Ready",
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
   end Wait_Ready;

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
