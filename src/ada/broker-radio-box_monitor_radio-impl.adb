with Broker.Radio.Box_Monitor_Radio.Skel;
pragma Warnings (Off, Broker.Radio.Box_Monitor_Radio.Skel);

use Broker.Radio.Box_Monitor_Radio;

with Box_Monitor;

with Ada.Strings.Unbounded;

package body Broker.Radio.Box_Monitor_Radio.impl is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   procedure GetUpdate(Self : access Object;
                       num : in CORBA.Short;
                       time : out CORBA.Float;
                       metres : out CORBA.Float;
                       Returns : out CORBA.String)
   is
      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);

      Temp_String : Unbounded_String.Unbounded_String;
   begin
      -- Add the new strategy somewhere

      -- The NewInfo is initialised to 1 for construction constraints.
      --+ The get update method will "update" the variable to the right value.
      Box_Monitor.GetUpdate(INTEGER(Num) , Standard.FLOAT(Time), Standard.FLOAT(Metres), Temp_String);

      Returns := CORBA.To_CORBA_String(Unbounded_String.To_String(Temp_String));
      time := Corba.FLOAT(Time);
      metres := Corba.FLOAT(Metres);
   end GetUpdate;

end Broker.Radio.Box_Monitor_Radio.impl;
