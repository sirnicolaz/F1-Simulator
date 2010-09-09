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
with PolyORB.Std;
with CORBA.Object.Helper;
with PolyORB.Utils.Strings;
with PolyORB.Utils.Strings.Lists;
with PolyORB.Initialization;

package body Competition_Monitor_Radio.Helper is

   
   package body Internals is

      Competition_Monitor_Radio_Initialized : PolyORB.Std.Boolean :=
        False;

      ------------------------------------------
      -- Initialize_Competition_Monitor_Radio --
      ------------------------------------------

      procedure Initialize_Competition_Monitor_Radio is
         Name_Ü : constant CORBA.String :=
           CORBA.To_CORBA_String
              ("Competition_Monitor_Radio");
         Id_Ü : constant CORBA.String :=
           CORBA.To_CORBA_String
              ("IDL:Competition_Monitor_Radio:1.0");
      begin
         if not Competition_Monitor_Radio_Initialized
         then
            Competition_Monitor_Radio_Initialized :=
              True;
            Competition_Monitor_Radio.Helper.TC_Competition_Monitor_Radio :=
              CORBA.TypeCode.Internals.To_CORBA_Object
                 (PolyORB.Any.TypeCode.TC_Object);
            CORBA.Internals.Add_Parameter
              (TC_Competition_Monitor_Radio,
               CORBA.To_Any
                 (Name_Ü));
            CORBA.Internals.Add_Parameter
              (TC_Competition_Monitor_Radio,
               CORBA.To_Any
                 (Id_Ü));
            CORBA.TypeCode.Internals.Disable_Reference_Counting
              (Competition_Monitor_Radio.Helper.TC_Competition_Monitor_Radio);
         end if;
      end Initialize_Competition_Monitor_Radio;

      -------------------------------------
      -- IDL_SEQUENCE_float_Element_Wrap --
      -------------------------------------

      function IDL_SEQUENCE_float_Element_Wrap
        (X : access CORBA.Float)
        return PolyORB.Any.Content'Class
      is
      begin
         return CORBA.Wrap
           (X.all'Unrestricted_Access);
      end IDL_SEQUENCE_float_Element_Wrap;

      function Wrap
        (X : access Competition_Monitor_Radio.IDL_SEQUENCE_float.Sequence)
        return PolyORB.Any.Content'Class
        renames IDL_SEQUENCE_float_Helper.Wrap;

      IDL_SEQUENCE_float_Initialized : PolyORB.Std.Boolean :=
        False;

      -----------------------------------
      -- Initialize_IDL_SEQUENCE_float --
      -----------------------------------

      procedure Initialize_IDL_SEQUENCE_float is
      begin
         if not IDL_SEQUENCE_float_Initialized
         then
            IDL_SEQUENCE_float_Initialized :=
              True;
            Competition_Monitor_Radio.Helper.TC_IDL_SEQUENCE_float :=
              CORBA.TypeCode.Internals.Build_Sequence_TC
                 (CORBA.TC_Float,
                  0);
            CORBA.TypeCode.Internals.Disable_Reference_Counting
              (Competition_Monitor_Radio.Helper.TC_IDL_SEQUENCE_float);
            IDL_SEQUENCE_float_Helper.Initialize
              (Element_TC => CORBA.TC_Float,
               Sequence_TC => Competition_Monitor_Radio.Helper.TC_IDL_SEQUENCE_float);
         end if;
      end Initialize_IDL_SEQUENCE_float;

      float_sequence_Initialized : PolyORB.Std.Boolean :=
        False;

      -------------------------------
      -- Initialize_float_sequence --
      -------------------------------

      procedure Initialize_float_sequence is
         Name_Ü : constant CORBA.String :=
           CORBA.To_CORBA_String
              ("float_sequence");
         Id_Ü : constant CORBA.String :=
           CORBA.To_CORBA_String
              ("IDL:Competition_Monitor_Radio/float_sequence:1.0");
      begin
         if not float_sequence_Initialized
         then
            float_sequence_Initialized :=
              True;
            Competition_Monitor_Radio.Helper.Internals.Initialize_IDL_SEQUENCE_float;
            Competition_Monitor_Radio.Helper.TC_float_sequence :=
              CORBA.TypeCode.Internals.Build_Alias_TC
                 (Name => Name_Ü,
                  Id => Id_Ü,
                  Parent => Competition_Monitor_Radio.Helper.TC_IDL_SEQUENCE_float);
            CORBA.TypeCode.Internals.Disable_Reference_Counting
              (Competition_Monitor_Radio.Helper.TC_float_sequence);
         end if;
      end Initialize_float_sequence;

   end Internals;

   --------------
   -- From_Any --
   --------------

   function From_Any
     (Item : CORBA.Any)
     return Competition_Monitor_Radio.Ref
   is
   begin
      return To_Ref
        (CORBA.Object.Helper.From_Any
           (Item));
   end From_Any;

   ------------
   -- To_Any --
   ------------

   function To_Any
     (Item : Competition_Monitor_Radio.Ref)
     return CORBA.Any
   is
      A : CORBA.Any :=
        CORBA.Object.Helper.To_Any
           (CORBA.Object.Ref
              (Item));
   begin
      CORBA.Internals.Set_Type
        (A,
         TC_Competition_Monitor_Radio);
      return A;
   end To_Any;

   ----------------------
   -- Unchecked_To_Ref --
   ----------------------

   function Unchecked_To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return Competition_Monitor_Radio.Ref
   is
      Result : Competition_Monitor_Radio.Ref;
   begin
      Set
        (Result,
         CORBA.Object.Object_Of
           (The_Ref));
      return Result;
   end Unchecked_To_Ref;

   ------------
   -- To_Ref --
   ------------

   function To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return Competition_Monitor_Radio.Ref
   is
   begin
      if (CORBA.Object.Is_Nil
        (The_Ref)
         or else CORBA.Object.Is_A
           (The_Ref,
            Repository_Id))
      then
         return Unchecked_To_Ref
           (The_Ref);
      end if;
      CORBA.Raise_Bad_Param
        (CORBA.Default_Sys_Member);
   end To_Ref;

   function From_Any
     (Item : CORBA.Any)
     return Competition_Monitor_Radio.IDL_SEQUENCE_float.Sequence
     renames Competition_Monitor_Radio.Helper.Internals.IDL_SEQUENCE_float_Helper.From_Any;

   function To_Any
     (Item : Competition_Monitor_Radio.IDL_SEQUENCE_float.Sequence)
     return CORBA.Any
     renames Competition_Monitor_Radio.Helper.Internals.IDL_SEQUENCE_float_Helper.To_Any;

   --------------
   -- From_Any --
   --------------

   function From_Any
     (Item : CORBA.Any)
     return Competition_Monitor_Radio.float_sequence
   is
      Result : constant Competition_Monitor_Radio.IDL_SEQUENCE_float.Sequence :=
        Competition_Monitor_Radio.Helper.From_Any
           (Item);
   begin
      return Competition_Monitor_Radio.float_sequence
        (Result);
   end From_Any;

   ------------
   -- To_Any --
   ------------

   function To_Any
     (Item : Competition_Monitor_Radio.float_sequence)
     return CORBA.Any
   is
      Result : CORBA.Any :=
        Competition_Monitor_Radio.Helper.To_Any
           (Competition_Monitor_Radio.IDL_SEQUENCE_float.Sequence
              (Item));
   begin
      CORBA.Internals.Set_Type
        (Result,
         TC_float_sequence);
      return Result;
   end To_Any;

   -----------------------------
   -- Deferred_Initialization --
   -----------------------------

   procedure Deferred_Initialization is
   begin
      Competition_Monitor_Radio.Helper.Internals.Initialize_Competition_Monitor_Radio;
      Competition_Monitor_Radio.Helper.Internals.Initialize_IDL_SEQUENCE_float;
      Competition_Monitor_Radio.Helper.Internals.Initialize_float_sequence;
   end Deferred_Initialization;

begin
   declare
      use PolyORB.Utils.Strings;
      use PolyORB.Utils.Strings.Lists;
   begin
      PolyORB.Initialization.Register_Module
        (PolyORB.Initialization.Module_Info'
           (Name => +"Competition_Monitor_Radio.Helper",
            Conflicts => PolyORB.Utils.Strings.Lists.Empty,
            Depends => +"any",
            Provides => PolyORB.Utils.Strings.Lists.Empty,
            Implicit => False,
            Init => Deferred_Initialization'Access,
            Shutdown => null));
   end;
end Competition_Monitor_Radio.Helper;
