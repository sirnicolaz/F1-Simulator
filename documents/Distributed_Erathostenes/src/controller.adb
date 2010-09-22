package body Controller is
   use Common;

   --  We insert each distributed object in a group.
   --  When all distributed objects have been inserted
   --  we can tell each distributed object which is its logical neighbor.
   --  Until then, function Next is a blocking operation.
   --  This is done using a protected object.

   type Pool_Info is record
      Pool : Pool_Access;
      PID  : Common.Partition_ID;
   end record;

   type Pool_Info_Table is array (1 .. Common.Partitions) of Pool_Info;

   protected Group is
      procedure Add  (Pool : in  Pool_Access; PID : Common.Partition_ID);
      entry     Next (Pool : out Pool_Access; PID : Common.Partition_ID);
   private
      Table      : Pool_Info_Table;
      Registered : Natural := 0;
      Full       : Boolean := False;
   end Group;

   protected body Group is
      procedure Add  (Pool : in  Pool_Access; PID : Common.Partition_ID) is
      begin
         Registered := Registered + 1;
         Table (Registered) := (Pool, PID);
         Full := (Registered = Common.Partitions);
      end Add;
      --+-----
      entry Next (Pool : out Pool_Access;
		  PID  : Common.Partition_ID) when Full is
      begin
         for Index in 1 .. Common.Partitions loop
            if Table (Index).PID = PID then
               if Index = Common.Partitions then
                  --  we assume partitions to be in a ring
                  --+ so that the neighbour of 4 is 1
                  Pool := Table (1).Pool;
               else
                  Pool := Table (Index + 1).Pool;
               end if;
               exit;
            end if;
         end loop;
      end Next;
   end Group;

   --+--------------

   function Register
     (Pool : Pool_Access; PID : Common.Partition_ID)
      return Boolean is
   begin
      Group.Add (Pool, PID);
      return True;
   end Register;

   function  Next
     (PID : Partition_ID)
      return Pool_Access is
      Pool : Pool_Access;
   begin
      Group.Next (Pool, PID);
      return Pool;
   end Next;

end Controller;
