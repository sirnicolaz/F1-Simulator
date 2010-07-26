with Ada.Text_IO;

with Box;
with BoxRadio.impl;

with Ada.Strings.Unbounded;
procedure Main_Box is

   package Unbounded_String renames Ada.Strings.Unbounded;
   use type Unbounded_String.Unbounded_String;
   -- Declare:
   --+ -the box registration handler
   --+ -the local box package:
   --+      - the synch_strategy_history
   --+      - the tasks strategy_updater and monitor
   --+      - the updates buffer
   --+
   --+ -the monitor ought to remotely communicate with the competition
   --+ -the box radio
   --+
   --+ Task Initialiser
--   task Initialiser is
--      entry Submit_Configuration( Configuration : STRING );
--      entry
begin

   Ada.Text_IO.Put_Line("End");
   --Declare the BoxRadio remote object
   declare

      Update_Buffer : access Box.SYNCH_COMPETITION_UPDATES;
      History : access Box.SYNCH_STRATEGY_HISTORY;
      Updater : access Box.STRATEGY_UPDATER;
      Mon : access Box.MONITOR;
      Laps : INTEGER;
      Radio_CorbaLOC : Unbounded_String.Unbounded_String := Unbounded_String.Null_Unbounded_String;
      Corbaloc_Storage : BoxRadio.impl.SYNCH_CORBALOC_POINT := new BoxRadio.impl.SYNCH_CORBALOC;
      Start_Radio : access BoxRadio.impl.Starter := new BoxRadio.impl.Starter(Corbaloc_Storage);
   begin
      Ada.Text_IO.Put_Line("Gettin corbaloc...");
      Corbaloc_Storage.Get_CorbaLOC(Radio_CorbaLOC);

      Ada.Text_IO.Put_Line("Corba LOC : " & Unbounded_String.To_String(Radio_CorbaLOC));
      declare
         begin

         -- Init BoxRadio corba
         -- Take the corba loc
         -- Wait (through an accept) for the competitor information and the competition server
         -- CORBA loc
         -- Initialize the corba object for communicating with the server
         -- Invoke the RegisterNewCompetitor with all the required information
         -- Use the information obtained to initialize all the buffers needed and
         -- to initialize the monitor connection with the server (using the corbaloc
         -- of the competition monitor)

         History := new Box.SYNCH_STRATEGY_HISTORY;
         History.Init(Laps);
         Updater := new Box.STRATEGY_UPDATER(Update_Buffer);
         Mon := new Box.MONITOR(Update_Buffer);
      end;
   end;
end Main_Box;
