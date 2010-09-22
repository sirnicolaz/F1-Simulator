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

package body broker.radio.Box_Monitor_Radio is

   GetUpdate_Arg_Name_num_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("num");

   GetUpdate_Arg_Name_time_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("time");

   GetUpdate_Arg_Name_metres_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("metres");

   GetUpdate_Result_Name_Ü : constant PolyORB.Types.Identifier :=
     PolyORB.Types.To_PolyORB_String
        ("Result");

   ------------------------
   -- GetUpdate_Result_Ü --
   ------------------------

   function GetUpdate_Result_Ü return PolyORB.Any.NamedValue is
      pragma Inline (GetUpdate_Result_Ü);
   begin
      return (Name => GetUpdate_Result_Name_Ü,
      Argument => CORBA.Internals.Get_Empty_Any
        (CORBA.TC_String),
      Arg_Modes => 0);
   end GetUpdate_Result_Ü;

   ---------------
   -- GetUpdate --
   ---------------

   procedure GetUpdate
     (Self : Ref;
      num : CORBA.Short;
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
      Arg_CC_num_Ü : aliased PolyORB.Any.Content'Class :=
        CORBA.Wrap
           (num'Unrestricted_Access);
      Arg_Any_num_Ü : constant CORBA.Any :=
        CORBA.Internals.Get_Wrapper_Any
           (CORBA.TC_Short,
            Arg_CC_num_Ü'Unchecked_Access);
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
        GetUpdate_Result_Ü;
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
         GetUpdate_Arg_Name_num_Ü,
         PolyORB.Any.Any
           (Arg_Any_num_Ü),
         PolyORB.Any.ARG_IN);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         GetUpdate_Arg_Name_time_Ü,
         PolyORB.Any.Any
           (Arg_Any_time_Ü),
         PolyORB.Any.ARG_OUT);
      PolyORB.Any.NVList.Add_Item
        (Argument_List_Ü,
         GetUpdate_Arg_Name_metres_Ü,
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
         Operation => "GetUpdate",
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
   end GetUpdate;

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
         broker.radio.Box_Monitor_Radio.Repository_Id)
         or else CORBA.Is_Equivalent
           (Logical_Type_Id,
            "IDL:omg.org/CORBA/Object:1.0"))
         or else False);
   end Is_A;

end broker.radio.Box_Monitor_Radio;
