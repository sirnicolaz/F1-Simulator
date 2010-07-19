with Monitor.Skel;
pragma Warnings (Off, Monitor.Skel);

with Box;

package body Monitor.impl is

   Buffer : access Box.SYNCH_COMPETITION_UPDATES;

   procedure Init( CompetitionUpdates_Buffer : access Box.SYNCH_COMPETITION_UPDATES ) is
   begin
      Buffer := CompetitionUpdates_Buffer;
   end Init;

   function GetUpdate
     (Self : access Object;
      num : in CORBA.Short)
     return CORBA.STRING
   is
      pragma Warnings (Off);
      pragma Unreferenced (Self);
      pragma Warnings (On);

      NewInfo : access Box.COMPETITION_UPDATE;
   begin
      -- Add the new strategy somewhere

      -- The NewInfo is initialised to 1 for construction constraints.
      --+ The get update method will "update" the variable to the right value.
      NewInfo := new Box.COMPETITION_UPDATE(1);
      Buffer.Get_Update(NewInfo.all,INTEGER(num));
      return CORBA.To_CORBA_String(Box.CompetitionUpdateToXML(NewInfo.all));
   end GetUpdate;

end Monitor.impl;
