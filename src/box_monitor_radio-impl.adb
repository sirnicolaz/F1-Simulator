with Box_Monitor_Radio.Skel;
pragma Warnings (Off, Box_Monitor_Radio.Skel);

with Box;
with Box_Data;

with Ada.Strings.Unbounded;

package body Box_Monitor_Radio.impl is

   Buffer : Box_Data.SYNCH_ALL_INFO_BUFFER_POINT;

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;

   procedure Init( CompetitionUpdates_Buffer : Box_Data.SYNCH_ALL_INFO_BUFFER_POINT ) is
   begin
      Buffer := CompetitionUpdates_Buffer;
   end Init;

   procedure GetUpdate(Self : access Object;
                       num : in CORBA.Short;
                       time : out CORBA.Float;
                       Returns : out CORBA.String)
   is
      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);

      NewInfo : Box_Data.ALL_INFO;
      Temp_String : Unbounded_String.Unbounded_String;
   begin
      -- Add the new strategy somewhere

      -- The NewInfo is initialised to 1 for construction constraints.
      --+ The get update method will "update" the variable to the right value.
      Buffer.Get_Info(Num  => INTEGER(num),
                      Info => NewInfo);
      Temp_String :=
        Unbounded_String.To_Unbounded_String("<update>") &
      Box_Data.Get_UpdateXML(NewInfo) & Box_Data.Get_StrategyXML(NewInfo) &
      Unbounded_String.To_Unbounded_String("</update>");

      Returns := CORBA.To_CORBA_String(Unbounded_String.To_String(Temp_String));
      time := Corba.FLOAT(Box_Data.Get_Time(NewInfo));
   end GetUpdate;

end Box_Monitor_Radio.impl;
