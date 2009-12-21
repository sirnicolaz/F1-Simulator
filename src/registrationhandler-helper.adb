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
with PolyORB.Std;
with PolyORB.Any;
with CORBA.Object.Helper;
with PolyORB.Utils.Strings;
with PolyORB.Utils.Strings.Lists;
with PolyORB.Initialization;

package body RegistrationHandler.Helper is

   
   package body Internals is

      RegistrationHandler_Initialized : PolyORB.Std.Boolean :=
        False;

      ------------------------------------
      -- Initialize_RegistrationHandler --
      ------------------------------------

      procedure Initialize_RegistrationHandler is
         Name_� : constant CORBA.String :=
           CORBA.To_CORBA_String
              ("RegistrationHandler");
         Id_� : constant CORBA.String :=
           CORBA.To_CORBA_String
              ("IDL:RegistrationHandler:1.0");
      begin
         if not RegistrationHandler_Initialized
         then
            RegistrationHandler_Initialized :=
              True;
            RegistrationHandler.Helper.TC_RegistrationHandler :=
              CORBA.TypeCode.Internals.To_CORBA_Object
                 (PolyORB.Any.TypeCode.TC_Object);
            CORBA.Internals.Add_Parameter
              (TC_RegistrationHandler,
               CORBA.To_Any
                 (Name_�));
            CORBA.Internals.Add_Parameter
              (TC_RegistrationHandler,
               CORBA.To_Any
                 (Id_�));
            CORBA.TypeCode.Internals.Disable_Reference_Counting
              (RegistrationHandler.Helper.TC_RegistrationHandler);
         end if;
      end Initialize_RegistrationHandler;

   end Internals;

   --------------
   -- From_Any --
   --------------

   function From_Any
     (Item : CORBA.Any)
     return RegistrationHandler.Ref
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
     (Item : RegistrationHandler.Ref)
     return CORBA.Any
   is
      A : CORBA.Any :=
        CORBA.Object.Helper.To_Any
           (CORBA.Object.Ref
              (Item));
   begin
      CORBA.Internals.Set_Type
        (A,
         TC_RegistrationHandler);
      return A;
   end To_Any;

   ----------------------
   -- Unchecked_To_Ref --
   ----------------------

   function Unchecked_To_Ref
     (The_Ref : CORBA.Object.Ref'Class)
     return RegistrationHandler.Ref
   is
      Result : RegistrationHandler.Ref;
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
     return RegistrationHandler.Ref
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

   -----------------------------
   -- Deferred_Initialization --
   -----------------------------

   procedure Deferred_Initialization is
   begin
      RegistrationHandler.Helper.Internals.Initialize_RegistrationHandler;
   end Deferred_Initialization;

begin
   declare
      use PolyORB.Utils.Strings;
      use PolyORB.Utils.Strings.Lists;
   begin
      PolyORB.Initialization.Register_Module
        (PolyORB.Initialization.Module_Info'
           (Name => +"RegistrationHandler.Helper",
            Conflicts => PolyORB.Utils.Strings.Lists.Empty,
            Depends => +"any",
            Provides => PolyORB.Utils.Strings.Lists.Empty,
            Implicit => False,
            Init => Deferred_Initialization'Access,
            Shutdown => null));
   end;
end RegistrationHandler.Helper;
