with Box_Monitor_Radio.Skel;
pragma Warnings (Off, Box_Monitor_Radio.Skel);

with Box;

package body Box_Monitor_Radio.impl is

   Buffer : access Box.SYNCH_COMPETITION_UPDATES;

   procedure Init( CompetitionUpdates_Buffer : access Box.SYNCH_COMPETITION_UPDATES ) is
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

      NewInfo : access Box.COMPETITION_UPDATE;
   begin
      -- Add the new strategy somewhere

      -- The NewInfo is initialised to 1 for construction constraints.
      --+ The get update method will "update" the variable to the right value.
      NewInfo := new Box.COMPETITION_UPDATE;
      Buffer.Get_Update(NewInfo.all,INTEGER(num));
      Returns := CORBA.To_CORBA_String(Box.CompetitionUpdateToXML(NewInfo.all));
      time := Corba.FLOAT(NewInfo.Time);
   end GetUpdate;

end Box_Monitor_Radio.impl;
