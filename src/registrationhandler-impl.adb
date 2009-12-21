with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Command_Line;

with RegistrationHandler.Skel;
pragma Warnings (Off, RegistrationHandler.Skel);

package body RegistrationHandler.Impl is



   procedure Remote_Join (
                   Self : access Object;
                   CompetitorDescriptor_In  : CORBA.String;
                   Address_In : CORBA.String;
                   RadioAddress_out : out CORBA.String;
                   CompId_out : CORBA.Short;
                   MonitorSystemAddress : out CORBA.String) is
      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);
   begin
      null;
   end Remote_Join;

   function Remote_Ready (
                   Self : access Object;
                   CompetitorId_In: CORBA.Short ) return CORBA.Boolean is
      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);
   begin
      return false;
   end Remote_Ready;

   procedure Join(
                  CompetitorDescriptor_In  : STRING;
                  Address_In : STRING;
                  RadioAddress_out : out STRING;
                  CompId_out : INTEGER;
                  MonitorSystemAddress : out STRING) is
   begin
      Put_Line("LAPS" & POSITIVE'IMAGE(Competition.Laps_Qty));
      Competition.Configure_Ride(LapsQty_In                 => 5,
                                 CompetitorsQty_In          => 2,
                                 StatisticsRefreshFrequency => 100.0);
      --Competition.Join(CompetitorFileDescriptor_In => CompetitorDescriptor_In);
      Put_Line("LAPS" & POSITIVE'IMAGE(Competition.Laps_Qty));
   end Join;


   function Ready (
                   CompetitorId_In: INTEGER ) return BOOLEAN is
   begin
      return false;
   end Ready;

end RegistrationHandler.impl;
