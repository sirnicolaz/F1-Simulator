with Box_Monitor_Radio.Skel;
pragma Warnings (Off, Box_Monitor_Radio.Skel);

with Box_Monitor;

with Ada.Strings.Unbounded;

package body Box_Monitor_Radio.impl is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   procedure GetUpdate(Self : access Object;
                       num : in CORBA.Short;
                       time : out CORBA.Float;
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
      Box_Monitor.GetUpdate(INTEGER(Num) , FLOAT(Time), Temp_String);

      Returns := CORBA.To_CORBA_String(Unbounded_String.To_String(Temp_String));
      time := Corba.FLOAT(Time);
   end GetUpdate;

end Box_Monitor_Radio.impl;
