with Ada.Text_IO; --  to get visibility of Put_Line
with Controller;
with Results;
with Common;

--  the Main unit is the only thread of control in the whole system
procedure Main is
   use Ada.Text_IO,
       Common;
   Divider : Natural;
   Where   : Common.Partition_ID;
   Starter : Controller.Pool_Access;
begin
   Starter := Controller.Next (Main'Partition_ID);
   for Number in Common.Search_Range loop
      --  RPC directed to the partition designated by the controlling parameter
      Common.Sieve (Starter, Number);
      --  blocking call to a protected entry that yields the divider of Number
      --+ and the partition on which that resides
      Results.Load (Divider, Where);
      delay 2.0; -- slow-down factor
      if Divider = Number then
         Put_Line (">>>>>> " &
                   Natural'Image (Number) &
                   " (prime located by partition " &
                   Partition_ID'Image (Where) &
                   ")");
      else
         Put_Line (Natural'Image (Number) &
                   "             (divided by" &
                   Natural'Image (Divider) &
                   " on partition " &
                   Partition_ID'Image (Where) &
                   ")");
      end if;
   end loop;
   Put_Line ("Finished calculating. Main ends.");
end Main;
