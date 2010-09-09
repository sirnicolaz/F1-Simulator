pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  boxConfigurator.idl
--  by IAC (IDL to Ada Compiler) GPL 2009-20090519 (rev. 144248).
---------------------------------------------------
--  Do NOT hand-modify this file, as your
--  changes will be lost when you re-run the
--  IDL to Ada compiler.
---------------------------------------------------
with BoxConfigurator.Impl;
with CORBA;
pragma Elaborate_All (CORBA);
with PolyORB.Any;
with CORBA.NVList;
with CORBA.ServerRequest;
with PolyORB.CORBA_P.IR_Hooks;
with CORBA.Object;
with CORBA.Object.Helper;
with PolyORB.CORBA_P.Domain_Management;
with PortableServer;
with PolyORB.Std;
with CORBA.ORB;
with PolyORB.CORBA_P.Exceptions;
with PolyORB.Qos.Exception_Informations;
with PolyORB.Utils.Strings;
with PolyORB.Utils.Strings.Lists;
with PolyORB.Initialization;

package body BoxConfigurator.Skel is

   Configure_Arg_Name_config_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("config");

   procedure Invoke
     (Self : PortableServer.Servant;
      Request : CORBA.ServerRequest.Object_Ptr);

   ------------
   -- Invoke --
   ------------

   procedure Invoke
     (Self : PortableServer.Servant;
      Request : CORBA.ServerRequest.Object_Ptr)
   is
      Operation_Ü : constant PolyORB.Std.String :=
        CORBA.To_Standard_String
           (CORBA.ServerRequest.Operation
              (Request.all));
      Argument_List_Ü : CORBA.NVList.Ref;
   begin
      CORBA.ORB.Create_List
        (0,
         Argument_List_Ü);
      begin
         if (Operation_Ü
            = "_is_a")
         then
            declare
               Type_Id_Ü : CORBA.String;
               Arg_Name_Type_Id_Ü : constant CORBA.Identifier :=
                 CORBA.To_CORBA_String
                    ("Type_Id_Ü");
               Argument_Type_Id_Ü : constant CORBA.Any :=
                 CORBA.To_Any
                    (Type_Id_Ü);
               Result_Ü : CORBA.Boolean;
            begin
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  Arg_Name_Type_Id_Ü,
                  Argument_Type_Id_Ü,
                  CORBA.ARG_IN);
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               Type_Id_Ü :=
                 CORBA.From_Any
                    (Argument_Type_Id_Ü);
               Result_Ü :=
                 Is_A
                    (CORBA.To_Standard_String
                       (Type_Id_Ü));
               CORBA.ServerRequest.Set_Result
                 (Request,
                  CORBA.To_Any
                    (Result_Ü));
            end;
         elsif (Operation_Ü
            = "Configure")
         then
            declare
               Argument_config_Ü : CORBA.String;
               pragma Warnings (Off, Argument_config_Ü);
               Arg_CC_config_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_config_Ü'Unrestricted_Access);
               Arg_Any_config_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_String,
                     Arg_CC_config_Ü'Unchecked_Access);
               Result_Ü : CORBA.String;
               pragma Warnings (Off, Result_Ü);
               Arg_CC_Result_Ü_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Result_Ü'Unrestricted_Access);
               Arg_Any_Result_Ü_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_String,
                     Arg_CC_Result_Ü_Ü'Unchecked_Access);
            begin
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  Configure_Arg_Name_config_Ü,
                  Arg_Any_config_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 BoxConfigurator.Impl.Configure
                    (BoxConfigurator.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_config_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "_interface")
         then
            CORBA.ServerRequest.Arguments
              (Request,
               Argument_List_Ü);
            CORBA.ServerRequest.Set_Result
              (Request,
               CORBA.Object.Helper.To_Any
                 (CORBA.Object.Ref
                    (PolyORB.CORBA_P.IR_Hooks.Get_Interface_Definition
                       (CORBA.To_CORBA_String
                          (Repository_Id)))));

         elsif (Operation_Ü
            = "_domain_managers")
         then
            CORBA.ServerRequest.Arguments
              (Request,
               Argument_List_Ü);
            CORBA.ServerRequest.Set_Result
              (Request,
               PolyORB.CORBA_P.Domain_Management.Get_Domain_Managers
                 (Self));

         elsif ((Operation_Ü
            = "_non_existent")
            or else (Operation_Ü
               = "_non_existent"))
         then
            CORBA.ServerRequest.Arguments
              (Request,
               Argument_List_Ü);
            CORBA.ServerRequest.Set_Result
              (Request,
               CORBA.To_Any
                 (CORBA.Boolean'
                    (False)));

         else
            CORBA.Raise_Bad_Operation
              (CORBA.Default_Sys_Member);
         end if;
      exception
         when E : others =>
            CORBA.ServerRequest.Set_Exception
              (Request,
               PolyORB.CORBA_P.Exceptions.System_Exception_To_Any
                 (E));
            PolyORB.Qos.Exception_Informations.Set_Exception_Information
              (Request,
               E);
      end;
   end Invoke;

   function Servant_Is_A
     (Obj : PortableServer.Servant)
     return Boolean;

   ------------------
   -- Servant_Is_A --
   ------------------

   function Servant_Is_A
     (Obj : PortableServer.Servant)
     return Boolean
   is
   begin
      return (Obj.all
         in BoxConfigurator.Impl.Object'Class);
   end Servant_Is_A;

   -----------------------------
   -- Deferred_Initialization --
   -----------------------------

   procedure Deferred_Initialization is
   begin
      PortableServer.Internals.Register_Skeleton
        (BoxConfigurator.Repository_Id,
         Servant_Is_A'Access,
         Is_A'Access,
         Invoke'Access);
   end Deferred_Initialization;

begin
   declare
      use PolyORB.Utils.Strings;
      use PolyORB.Utils.Strings.Lists;
   begin
      PolyORB.Initialization.Register_Module
        (PolyORB.Initialization.Module_Info'
           (Name => +"BoxConfigurator.Skel",
            Conflicts => PolyORB.Utils.Strings.Lists.Empty,
            Depends => PolyORB.Utils.Strings.Lists.Empty,
            Provides => PolyORB.Utils.Strings.Lists.Empty,
            Implicit => False,
            Init => Deferred_Initialization'Access,
            Shutdown => null));
   end;
end BoxConfigurator.Skel;
