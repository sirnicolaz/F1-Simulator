pragma Style_Checks ("NM32766");
---------------------------------------------------
--  This file has been generated automatically from
--  competition_monitor.idl
--  by IAC (IDL to Ada Compiler) GPL 2009-20090519 (rev. 144248).
---------------------------------------------------
--  Do NOT hand-modify this file, as your
--  changes will be lost when you re-run the
--  IDL to Ada compiler.
---------------------------------------------------
with Competition_Monitor.Impl;
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

package body Competition_Monitor.Skel is

   getClassific_Arg_Name_idComp_In_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("idComp_In");

   getInfo_Arg_Name_lap_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("lap");

   getInfo_Arg_Name_sector_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("sector");

   getInfo_Arg_Name_id_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("id");

   getBestSector_Arg_Name_index_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("index");

   getCondCar_Arg_Name_competitorIdIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("competitorIdIn");

   getCompetitor_Arg_Name_competitorIdIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("competitorIdIn");

   getCompetitorTimeSector_Arg_Name_competitorIdIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("competitorIdIn");

   getCompetitorTimeSector_Arg_Name_sectorIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("sectorIn");

   getCompetitorTimeLap_Arg_Name_competitorIdIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("competitorIdIn");

   getCompetitorTimeLap_Arg_Name_lapIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("lapIn");

   getCompetitorTimeCheck_Arg_Name_competitorIdIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("competitorIdIn");

   getCompetitorTimeCheck_Arg_Name_checkpointIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("checkpointIn");

   getGas_Arg_Name_competitorIdIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("competitorIdIn");

   getGas_Arg_Name_Sector_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("Sector");

   getGas_Arg_Name_lapIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("lapIn");

   getTyreUsury_Arg_Name_competitorIdIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("competitorIdIn");

   getTyreUsury_Arg_Name_sectorIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("sectorIn");

   getTyreUsury_Arg_Name_lapIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("lapIn");

   getMeanSpeed_Arg_Name_competitorIdIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("competitorIdIn");

   getMeanSpeed_Arg_Name_sectorIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("sectorIn");

   getMeanSpeed_Arg_Name_lapIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("lapIn");

   getTime_Arg_Name_competitorIdIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("competitorIdIn");

   getTime_Arg_Name_sectorIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("sectorIn");

   getTime_Arg_Name_lapIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("lapIn");

   getMeanGasConsumption_Arg_Name_competitorIdIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("competitorIdIn");

   getMeanGasConsumption_Arg_Name_sectorIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("sectorIn");

   getMeanGasConsumption_Arg_Name_lapIn_Ü : constant CORBA.Identifier :=
     CORBA.To_CORBA_String
        ("lapIn");

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
            = "getClassific")
         then
            declare
               Argument_idComp_In_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_idComp_In_Ü);
               Arg_CC_idComp_In_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_idComp_In_Ü'Unrestricted_Access);
               Arg_Any_idComp_In_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_idComp_In_Ü'Unchecked_Access);
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
                  getClassific_Arg_Name_idComp_In_Ü,
                  Arg_Any_idComp_In_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getClassific
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_idComp_In_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getInfo")
         then
            declare
               Argument_lap_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_lap_Ü);
               Arg_CC_lap_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_lap_Ü'Unrestricted_Access);
               Arg_Any_lap_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_lap_Ü'Unchecked_Access);
               Argument_sector_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_sector_Ü);
               Arg_CC_sector_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_sector_Ü'Unrestricted_Access);
               Arg_Any_sector_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_sector_Ü'Unchecked_Access);
               Argument_id_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_id_Ü);
               Arg_CC_id_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_id_Ü'Unrestricted_Access);
               Arg_Any_id_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_id_Ü'Unchecked_Access);
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
                  getInfo_Arg_Name_lap_Ü,
                  Arg_Any_lap_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getInfo_Arg_Name_sector_Ü,
                  Arg_Any_sector_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getInfo_Arg_Name_id_Ü,
                  Arg_Any_id_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getInfo
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_lap_Ü,
                     Argument_sector_Ü,
                     Argument_id_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getBestLap")
         then
            declare
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
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getBestLap
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getBestSector")
         then
            declare
               Argument_index_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_index_Ü);
               Arg_CC_index_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_index_Ü'Unrestricted_Access);
               Arg_Any_index_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_index_Ü'Unchecked_Access);
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
                  getBestSector_Arg_Name_index_Ü,
                  Arg_Any_index_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getBestSector
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_index_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getCondCar")
         then
            declare
               Argument_competitorIdIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_competitorIdIn_Ü);
               Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_competitorIdIn_Ü'Unrestricted_Access);
               Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_competitorIdIn_Ü'Unchecked_Access);
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
                  getCondCar_Arg_Name_competitorIdIn_Ü,
                  Arg_Any_competitorIdIn_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getCondCar
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_competitorIdIn_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getCompetitor")
         then
            declare
               Argument_competitorIdIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_competitorIdIn_Ü);
               Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_competitorIdIn_Ü'Unrestricted_Access);
               Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_competitorIdIn_Ü'Unchecked_Access);
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
                  getCompetitor_Arg_Name_competitorIdIn_Ü,
                  Arg_Any_competitorIdIn_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getCompetitor
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_competitorIdIn_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getCompetitorTimeSector")
         then
            declare
               Argument_competitorIdIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_competitorIdIn_Ü);
               Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_competitorIdIn_Ü'Unrestricted_Access);
               Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_competitorIdIn_Ü'Unchecked_Access);
               Argument_sectorIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_sectorIn_Ü);
               Arg_CC_sectorIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_sectorIn_Ü'Unrestricted_Access);
               Arg_Any_sectorIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_sectorIn_Ü'Unchecked_Access);
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
                  getCompetitorTimeSector_Arg_Name_competitorIdIn_Ü,
                  Arg_Any_competitorIdIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getCompetitorTimeSector_Arg_Name_sectorIn_Ü,
                  Arg_Any_sectorIn_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getCompetitorTimeSector
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_competitorIdIn_Ü,
                     Argument_sectorIn_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getCompetitorTimeLap")
         then
            declare
               Argument_competitorIdIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_competitorIdIn_Ü);
               Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_competitorIdIn_Ü'Unrestricted_Access);
               Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_competitorIdIn_Ü'Unchecked_Access);
               Argument_lapIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_lapIn_Ü);
               Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_lapIn_Ü'Unrestricted_Access);
               Arg_Any_lapIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_lapIn_Ü'Unchecked_Access);
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
                  getCompetitorTimeLap_Arg_Name_competitorIdIn_Ü,
                  Arg_Any_competitorIdIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getCompetitorTimeLap_Arg_Name_lapIn_Ü,
                  Arg_Any_lapIn_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getCompetitorTimeLap
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_competitorIdIn_Ü,
                     Argument_lapIn_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getCompetitorTimeCheck")
         then
            declare
               Argument_competitorIdIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_competitorIdIn_Ü);
               Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_competitorIdIn_Ü'Unrestricted_Access);
               Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_competitorIdIn_Ü'Unchecked_Access);
               Argument_checkpointIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_checkpointIn_Ü);
               Arg_CC_checkpointIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_checkpointIn_Ü'Unrestricted_Access);
               Arg_Any_checkpointIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_checkpointIn_Ü'Unchecked_Access);
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
                  getCompetitorTimeCheck_Arg_Name_competitorIdIn_Ü,
                  Arg_Any_competitorIdIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getCompetitorTimeCheck_Arg_Name_checkpointIn_Ü,
                  Arg_Any_checkpointIn_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getCompetitorTimeCheck
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_competitorIdIn_Ü,
                     Argument_checkpointIn_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getGas")
         then
            declare
               Argument_competitorIdIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_competitorIdIn_Ü);
               Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_competitorIdIn_Ü'Unrestricted_Access);
               Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_competitorIdIn_Ü'Unchecked_Access);
               Argument_Sector_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_Sector_Ü);
               Arg_CC_Sector_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_Sector_Ü'Unrestricted_Access);
               Arg_Any_Sector_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_Sector_Ü'Unchecked_Access);
               Argument_lapIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_lapIn_Ü);
               Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_lapIn_Ü'Unrestricted_Access);
               Arg_Any_lapIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_lapIn_Ü'Unchecked_Access);
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
                  getGas_Arg_Name_competitorIdIn_Ü,
                  Arg_Any_competitorIdIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getGas_Arg_Name_Sector_Ü,
                  Arg_Any_Sector_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getGas_Arg_Name_lapIn_Ü,
                  Arg_Any_lapIn_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getGas
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_competitorIdIn_Ü,
                     Argument_Sector_Ü,
                     Argument_lapIn_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getTyreUsury")
         then
            declare
               Argument_competitorIdIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_competitorIdIn_Ü);
               Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_competitorIdIn_Ü'Unrestricted_Access);
               Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_competitorIdIn_Ü'Unchecked_Access);
               Argument_sectorIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_sectorIn_Ü);
               Arg_CC_sectorIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_sectorIn_Ü'Unrestricted_Access);
               Arg_Any_sectorIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_sectorIn_Ü'Unchecked_Access);
               Argument_lapIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_lapIn_Ü);
               Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_lapIn_Ü'Unrestricted_Access);
               Arg_Any_lapIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_lapIn_Ü'Unchecked_Access);
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
                  getTyreUsury_Arg_Name_competitorIdIn_Ü,
                  Arg_Any_competitorIdIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getTyreUsury_Arg_Name_sectorIn_Ü,
                  Arg_Any_sectorIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getTyreUsury_Arg_Name_lapIn_Ü,
                  Arg_Any_lapIn_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getTyreUsury
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_competitorIdIn_Ü,
                     Argument_sectorIn_Ü,
                     Argument_lapIn_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getMeanSpeed")
         then
            declare
               Argument_competitorIdIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_competitorIdIn_Ü);
               Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_competitorIdIn_Ü'Unrestricted_Access);
               Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_competitorIdIn_Ü'Unchecked_Access);
               Argument_sectorIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_sectorIn_Ü);
               Arg_CC_sectorIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_sectorIn_Ü'Unrestricted_Access);
               Arg_Any_sectorIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_sectorIn_Ü'Unchecked_Access);
               Argument_lapIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_lapIn_Ü);
               Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_lapIn_Ü'Unrestricted_Access);
               Arg_Any_lapIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_lapIn_Ü'Unchecked_Access);
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
                  getMeanSpeed_Arg_Name_competitorIdIn_Ü,
                  Arg_Any_competitorIdIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getMeanSpeed_Arg_Name_sectorIn_Ü,
                  Arg_Any_sectorIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getMeanSpeed_Arg_Name_lapIn_Ü,
                  Arg_Any_lapIn_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getMeanSpeed
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_competitorIdIn_Ü,
                     Argument_sectorIn_Ü,
                     Argument_lapIn_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getTime")
         then
            declare
               Argument_competitorIdIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_competitorIdIn_Ü);
               Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_competitorIdIn_Ü'Unrestricted_Access);
               Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_competitorIdIn_Ü'Unchecked_Access);
               Argument_sectorIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_sectorIn_Ü);
               Arg_CC_sectorIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_sectorIn_Ü'Unrestricted_Access);
               Arg_Any_sectorIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_sectorIn_Ü'Unchecked_Access);
               Argument_lapIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_lapIn_Ü);
               Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_lapIn_Ü'Unrestricted_Access);
               Arg_Any_lapIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_lapIn_Ü'Unchecked_Access);
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
                  getTime_Arg_Name_competitorIdIn_Ü,
                  Arg_Any_competitorIdIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getTime_Arg_Name_sectorIn_Ü,
                  Arg_Any_sectorIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getTime_Arg_Name_lapIn_Ü,
                  Arg_Any_lapIn_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getTime
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_competitorIdIn_Ü,
                     Argument_sectorIn_Ü,
                     Argument_lapIn_Ü);
               --  Setting the result
               CORBA.ServerRequest.Set_Result
                 (Request,
                  Arg_Any_Result_Ü_Ü);
               CORBA.NVList.Internals.Clone_Out_Args
                 (Argument_List_Ü);
            end;
         elsif (Operation_Ü
            = "getMeanGasConsumption")
         then
            declare
               Argument_competitorIdIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_competitorIdIn_Ü);
               Arg_CC_competitorIdIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_competitorIdIn_Ü'Unrestricted_Access);
               Arg_Any_competitorIdIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_competitorIdIn_Ü'Unchecked_Access);
               Argument_sectorIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_sectorIn_Ü);
               Arg_CC_sectorIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_sectorIn_Ü'Unrestricted_Access);
               Arg_Any_sectorIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_sectorIn_Ü'Unchecked_Access);
               Argument_lapIn_Ü : CORBA.Short;
               pragma Warnings (Off, Argument_lapIn_Ü);
               Arg_CC_lapIn_Ü : aliased PolyORB.Any.Content'Class :=
                 CORBA.Wrap
                    (Argument_lapIn_Ü'Unrestricted_Access);
               Arg_Any_lapIn_Ü : constant CORBA.Any :=
                 CORBA.Internals.Get_Wrapper_Any
                    (CORBA.TC_Short,
                     Arg_CC_lapIn_Ü'Unchecked_Access);
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
                  getMeanGasConsumption_Arg_Name_competitorIdIn_Ü,
                  Arg_Any_competitorIdIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getMeanGasConsumption_Arg_Name_sectorIn_Ü,
                  Arg_Any_sectorIn_Ü,
                  CORBA.ARG_IN);
               CORBA.NVList.Add_Item
                 (Argument_List_Ü,
                  getMeanGasConsumption_Arg_Name_lapIn_Ü,
                  Arg_Any_lapIn_Ü,
                  CORBA.ARG_IN);
               --  Processing request
               CORBA.ServerRequest.Arguments
                 (Request,
                  Argument_List_Ü);
               --  Call Implementation
               Result_Ü :=
                 Competition_Monitor.Impl.getMeanGasConsumption
                    (Competition_Monitor.Impl.Object'Class
                       (Self.all)'Access,
                     Argument_competitorIdIn_Ü,
                     Argument_sectorIn_Ü,
                     Argument_lapIn_Ü);
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
         in Competition_Monitor.Impl.Object'Class);
   end Servant_Is_A;

   -----------------------------
   -- Deferred_Initialization --
   -----------------------------

   procedure Deferred_Initialization is
   begin
      PortableServer.Internals.Register_Skeleton
        (Competition_Monitor.Repository_Id,
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
           (Name => +"Competition_Monitor.Skel",
            Conflicts => PolyORB.Utils.Strings.Lists.Empty,
            Depends => PolyORB.Utils.Strings.Lists.Empty,
            Provides => PolyORB.Utils.Strings.Lists.Empty,
            Implicit => False,
            Init => Deferred_Initialization'Access,
            Shutdown => null));
   end;
end Competition_Monitor.Skel;
