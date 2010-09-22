pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  ../idl/init.idl
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

package body broker.init.RegistrationHandler is

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

   Join_Competition_Arg_Name_circuitLength_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("circuitLength");

   Join_Competition_Arg_Name_laps_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("laps");

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
      competitorId : out CORBA.Short;
      circuitLength : out CORBA.Float;
      laps : out CORBA.Short)
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
      Arg_CC_circuitLength_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (circuitLength'Unrestricted_Access);
      Arg_Any_circuitLength_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Float,
            Arg_CC_circuitLength_Ü'Unchecked_Access);
      pragma Warnings (Off, circuitLength);
      Arg_CC_laps_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (laps'Unrestricted_Access);
      Arg_Any_laps_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_laps_Ü'Unchecked_Access);
      pragma Warnings (Off, laps);
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
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Join_Competition_Arg_Name_circuitLength_Ü,
         PolyORB.Any.Any
           (Arg_Any_circuitLength_Ü),
         PolyORB.Any.ARG_OUT);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         Join_Competition_Arg_Name_laps_Ü,
         PolyORB.Any.Any
           (Arg_Any_laps_Ü),
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
         broker.init.RegistrationHandler.Repository_Id)
         or else CORBA.Is_Equivalent
           (Logical_Type_Id,
            "IDL:omg.org/CORBA/Object:1.0"))
         or else False);
   end Is_A;

end broker.init.RegistrationHandler;
